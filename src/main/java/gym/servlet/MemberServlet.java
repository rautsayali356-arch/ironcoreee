package gym.servlet;

import gym.util.Db;
import gym.util.Pw;
import java.io.IOException;
import java.sql.SQLException;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

/** Member sign-up, login, logout and the "My account" dashboard. */
@WebServlet({"/site/register", "/site/login", "/site/logout", "/site/dashboard", "/site/renew"})
public class MemberServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath(), ctx = req.getContextPath();
        try {
            switch (path) {
                case "/site/register": showRegister(req, resp); return;
                case "/site/logout":
                    HttpSession s = req.getSession(false);
                    if (s != null) s.invalidate();
                    resp.sendRedirect(ctx + "/site/login?out=1"); return;
                case "/site/dashboard": {
                    HttpSession ses = req.getSession(false);
                    Map<?, ?> me = ses == null ? null : (Map<?, ?>) ses.getAttribute("member");
                    if (me == null) { resp.sendRedirect(ctx + "/site/login"); return; }
                    req.setAttribute("m", Db.one(
                        "SELECT m.member_id AS memberId, m.full_name AS fullName, m.email, m.phone, m.joining_date AS joiningDate, "
                        + "m.expiry_date AS expiryDate, p.plan_name AS planName, DATEDIFF(m.expiry_date, CURDATE()) AS daysLeft "
                        + "FROM members m LEFT JOIN plans p ON p.plan_id = m.plan_id WHERE m.member_id = ?", me.get("memberId")));
                    req.setAttribute("payments", Db.query(
                        "SELECT p.payment_id AS paymentId, pl.plan_name AS planName, p.amount, p.payment_date AS paymentDate, "
                        + "p.payment_method AS paymentMethod, p.payment_status AS paymentStatus "
                        + "FROM payments p JOIN plans pl ON pl.plan_id = p.plan_id WHERE p.member_id = ? ORDER BY p.payment_id DESC", me.get("memberId")));
                    break;
                }
                default: break; // /site/login
            }
        } catch (SQLException e) {
            log("DB error", e);
            req.setAttribute("error", "Something went wrong loading your account. Please try again.");
        }
        req.getRequestDispatcher(path + ".jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            switch (req.getServletPath()) {
                case "/site/register": register(req, resp); break;
                case "/site/renew": renew(req, resp); break;
                default: login(req, resp);
            }
        } catch (SQLException e) {
            log("DB error", e);
            if (req.getServletPath().equals("/site/renew")) {
                req.getSession().setAttribute("error", "Could not save your plan choice. Please try again.");
                resp.sendRedirect(req.getContextPath() + "/site/dashboard");
                return;
            }
            req.setAttribute("error", "Something went wrong on our side. Please try again.");
            req.getRequestDispatcher(req.getServletPath() + ".jsp").forward(req, resp);
        }
    }

    private void showRegister(HttpServletRequest req, HttpServletResponse resp) throws SQLException, ServletException, IOException {
        req.setAttribute("plans", Db.query(SiteServlet.PLANS));
        req.getRequestDispatcher("/site/register.jsp").forward(req, resp);
    }

    private void register(HttpServletRequest req, HttpServletResponse resp) throws SQLException, ServletException, IOException {
        String name = Db.param(req, "fullName"), phone = Db.param(req, "phone");
        String email = Db.param(req, "email").toLowerCase(), gender = Db.param(req, "gender");
        String password = req.getParameter("password") == null ? "" : req.getParameter("password");
        int planId = 0;
        try { planId = Integer.parseInt(Db.param(req, "planId")); } catch (NumberFormatException ignored) { }

        String err = null;
        Map<String, Object> plan = planId > 0 ? Db.one("SELECT plan_id, fee FROM plans WHERE plan_id = ?", planId) : null;
        if (name.length() < 3) err = "Please enter your full name.";
        else if (!phone.matches("[6-9]\\d{9}")) err = "Enter a valid 10-digit phone number.";
        else if (!email.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")) err = "Enter a valid email address.";
        else if (password.length() < 6) err = "Password must be at least 6 characters.";
        else if (plan == null) err = "Please choose a plan.";
        else if (Db.one("SELECT member_id FROM members WHERE email = ?", email) != null) err = "This email is already registered. Please log in.";

        if (err != null) { req.setAttribute("error", err); showRegister(req, resp); return; }

        long id = Db.insert("INSERT INTO members(full_name, phone, email, gender, joining_date, password_hash, plan_id) VALUES (?,?,?,?,CURDATE(),?,?)",
                name, phone, email, gender.isEmpty() ? null : gender, Pw.hash(password), planId);
        // Membership turns Active when the admin marks this payment "Paid" (a database trigger sets the expiry date).
        Db.update("INSERT INTO payments(member_id, plan_id, amount, payment_date, payment_method, payment_status) VALUES (?,?,?,CURDATE(),'UPI','Pending')",
                id, planId, plan.get("fee"));
        startSession(req, id, name, email);
        req.getSession().setAttribute("success", "Welcome to the crew, " + name + "! Pay at the front desk or by UPI to activate your plan.");
        resp.sendRedirect(req.getContextPath() + "/site/dashboard");
    }

    private void login(HttpServletRequest req, HttpServletResponse resp) throws SQLException, ServletException, IOException {
        String email = Db.param(req, "email").toLowerCase();
        String password = req.getParameter("password") == null ? "" : req.getParameter("password");
        Map<String, Object> row = Db.one("SELECT member_id AS memberId, full_name AS fullName, email, password_hash AS pw FROM members WHERE email = ?", email);
        if (row == null || !Pw.check(password, (String) row.get("pw"))) {
            req.setAttribute("error", "Wrong email or password. Please try again.");
            req.getRequestDispatcher("/site/login.jsp").forward(req, resp);
            return;
        }
        startSession(req, ((Number) row.get("memberId")).longValue(), (String) row.get("fullName"), email);
        resp.sendRedirect(req.getContextPath() + "/site/dashboard");
    }

    /** A logged-in member picks a plan to renew or change; the desk confirms payment later. */
    private void renew(HttpServletRequest req, HttpServletResponse resp) throws SQLException, IOException {
        HttpSession ses = req.getSession(false);
        Map<?, ?> me = ses == null ? null : (Map<?, ?>) ses.getAttribute("member");
        if (me == null) { resp.sendRedirect(req.getContextPath() + "/site/login"); return; }
        int planId = 0;
        try { planId = Integer.parseInt(Db.param(req, "planId")); } catch (NumberFormatException ignored) { }
        Map<String, Object> plan = planId > 0 ? Db.one("SELECT plan_id, plan_name, fee FROM plans WHERE plan_id = ?", planId) : null;
        if (plan == null) {
            ses.setAttribute("error", "Please choose a valid plan.");
        } else {
            Db.update("INSERT INTO payments(member_id, plan_id, amount, payment_date, payment_method, payment_status) VALUES (?,?,?,CURDATE(),'UPI','Pending')",
                    me.get("memberId"), planId, plan.get("fee"));
            ses.setAttribute("success", plan.get("plan_name") + " selected. Pay by UPI or at the front desk to activate it.");
        }
        resp.sendRedirect(req.getContextPath() + "/site/dashboard");
    }

    private void startSession(HttpServletRequest req, long id, String name, String email) {
        HttpSession s = req.getSession();
        req.changeSessionId(); // protects against session fixation
        Map<String, Object> me = new HashMap<>();
        me.put("memberId", id); me.put("fullName", name); me.put("email", email);
        s.setAttribute("member", me);
    }
}
