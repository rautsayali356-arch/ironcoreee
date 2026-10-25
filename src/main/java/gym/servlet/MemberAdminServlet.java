package gym.servlet;

import gym.util.Db;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

/** Admin: list, add, edit and delete members. */
@WebServlet({"/members", "/member"})
public class MemberAdminServlet extends HttpServlet {

    private static final String LIST = "SELECT member_id AS memberId, full_name AS fullName, phone, email, gender, "
            + "joining_date AS joiningDate, CASE WHEN expiry_date IS NULL THEN 'Pending' WHEN expiry_date >= CURDATE() THEN 'Active' "
            + "ELSE 'Expired' END AS status FROM members ORDER BY member_id DESC";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            if (req.getServletPath().equals("/members")) {
                req.setAttribute("members", Db.query(LIST));
                req.getRequestDispatcher("/members.jsp").forward(req, resp);
                return;
            }
            if ("edit".equals(req.getParameter("action"))) {
                Map<String, Object> m = Db.one("SELECT member_id AS memberId, full_name AS fullName, phone, email, gender, address, "
                        + "joining_date AS joiningDate FROM members WHERE member_id = ?", parseId(req.getParameter("id")));
                if (m == null) { flash(req, "error", "Member not found."); resp.sendRedirect(req.getContextPath() + "/members"); return; }
                req.setAttribute("member", m);
            }
            req.getRequestDispatcher("/addMember.jsp").forward(req, resp);
        } catch (SQLException e) {
            log("Member query failed", e);
            req.setAttribute("error", "Database error. Please try again.");
            req.getRequestDispatcher("/members.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = Db.param(req, "action"), ctx = req.getContextPath();
        try {
            if (action.equals("delete")) {
                Db.update("DELETE FROM members WHERE member_id = ?", parseId(req.getParameter("id")));
                flash(req, "success", "Member deleted.");
                resp.sendRedirect(ctx + "/members");
                return;
            }
            String name = Db.param(req, "fullName"), phone = Db.param(req, "phone"), email = Db.param(req, "email").toLowerCase();
            String gender = Db.param(req, "gender"), address = Db.param(req, "address"), date = Db.param(req, "joiningDate");
            String err = null;
            if (name.length() < 3) err = "Enter the member's full name.";
            else if (!phone.matches("[6-9]\\d{9}")) err = "Enter a valid 10-digit phone number.";
            else if (!email.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")) err = "Enter a valid email address.";
            else if (!validDate(date)) err = "Choose a valid joining date.";
            if (err != null) { showForm(req, resp, action, err); return; }

            Object genderValue = gender.isEmpty() ? null : gender, addressValue = address.isEmpty() ? null : address;
            if (action.equals("update")) {
                Db.update("UPDATE members SET full_name=?, phone=?, email=?, gender=?, address=?, joining_date=? WHERE member_id=?",
                        name, phone, email, genderValue, addressValue, java.sql.Date.valueOf(date), parseId(req.getParameter("memberId")));
                flash(req, "success", "Member updated.");
            } else {
                Db.update("INSERT INTO members(full_name, phone, email, gender, address, joining_date) VALUES (?,?,?,?,?,?)",
                        name, phone, email, genderValue, addressValue, java.sql.Date.valueOf(date));
                flash(req, "success", "Member added successfully.");
            }
            resp.sendRedirect(ctx + "/members");
        } catch (SQLException e) {
            if (e.getErrorCode() == 1062) { try { showForm(req, resp, action, "This email is already registered."); return; } catch (Exception ignored) { } }
            log("Member save failed", e);
            flash(req, "error", "Could not save the member. Please try again.");
            resp.sendRedirect(ctx + "/members");
        }
    }

    /** Re-show the form with an error and the values the admin typed. */
    private void showForm(HttpServletRequest req, HttpServletResponse resp, String action, String error) throws ServletException, IOException {
        if (action.equals("update")) {
            Map<String, Object> m = new HashMap<>();
            m.put("memberId", req.getParameter("memberId")); m.put("fullName", Db.param(req, "fullName")); m.put("phone", Db.param(req, "phone"));
            m.put("email", Db.param(req, "email")); m.put("gender", Db.param(req, "gender")); m.put("address", Db.param(req, "address"));
            m.put("joiningDate", Db.param(req, "joiningDate"));
            req.setAttribute("member", m);
        }
        req.setAttribute("error", error);
        req.getRequestDispatcher("/addMember.jsp").forward(req, resp);
    }

    static boolean validDate(String s) { try { LocalDate.parse(s); return true; } catch (DateTimeParseException e) { return false; } }
    static int parseId(String s) { try { return Integer.parseInt(s == null ? "" : s.trim()); } catch (NumberFormatException e) { return -1; } }
    static void flash(HttpServletRequest req, String key, String msg) { req.getSession().setAttribute(key, msg); }
}
