package gym.servlet;

import gym.util.Db;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

/** Admin: payment history, record a payment, mark a pending payment as paid, delete. */
@WebServlet({"/payments", "/payment"})
public class PaymentAdminServlet extends HttpServlet {

    private static final List<String> METHODS = Arrays.asList("Cash", "UPI", "Card", "Net Banking");
    private static final List<String> STATUSES = Arrays.asList("Paid", "Pending", "Failed");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            if (req.getServletPath().equals("/payments")) {
                String mid = req.getParameter("memberId");
                String sql = "SELECT p.payment_id AS paymentId, m.full_name AS memberName, pl.plan_name AS planName, p.amount, "
                        + "p.payment_date AS paymentDate, p.payment_method AS paymentMethod, p.payment_status AS paymentStatus "
                        + "FROM payments p JOIN members m ON m.member_id = p.member_id JOIN plans pl ON pl.plan_id = p.plan_id "
                        + (mid != null && !mid.isEmpty() ? "WHERE p.member_id = ? " : "") + "ORDER BY p.payment_id DESC";
                req.setAttribute("payments", mid != null && !mid.isEmpty() ? Db.query(sql, MemberAdminServlet.parseId(mid)) : Db.query(sql));
                req.getRequestDispatcher("/payments.jsp").forward(req, resp);
                return;
            }
            loadFormLists(req);
            req.getRequestDispatcher("/addPayment.jsp").forward(req, resp);
        } catch (SQLException e) {
            log("Payment query failed", e);
            req.setAttribute("error", "Database error. Please try again.");
            req.getRequestDispatcher("/payments.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = Db.param(req, "action"), ctx = req.getContextPath();
        try {
            if (action.equals("delete")) {
                Db.update("DELETE FROM payments WHERE payment_id = ?", MemberAdminServlet.parseId(req.getParameter("id")));
                MemberAdminServlet.flash(req, "success", "Payment deleted.");
            } else if (action.equals("markPaid")) {
                int paymentId = MemberAdminServlet.parseId(req.getParameter("id"));
                int n = Db.update("UPDATE payments SET payment_status = 'Paid', payment_date = CURDATE() WHERE payment_id = ? AND payment_status <> 'Paid'",
                        paymentId);
                if (n > 0) {
                    try {
                        Map<String, Object> p = Db.one("SELECT member_id, plan_id FROM payments WHERE payment_id = ?", paymentId);
                        if (p != null) {
                            Map<String, Object> pl = Db.one("SELECT duration_months FROM plans WHERE plan_id = ?", p.get("plan_id"));
                            if (pl != null) {
                                int m = ((Number) pl.get("duration_months")).intValue();
                                Db.update("UPDATE members SET plan_id = ?, expiry_date = DATE_ADD(GREATEST(IFNULL(expiry_date, CURDATE()), CURDATE()), INTERVAL ? MONTH) WHERE member_id = ?",
                                        p.get("plan_id"), m, p.get("member_id"));
                            }
                        }
                    } catch (Exception ignored) {}
                }
                MemberAdminServlet.flash(req, n > 0 ? "success" : "error", n > 0 ? "Payment marked as paid. Membership updated." : "Payment not found or already paid.");
            } else {
                int memberId = MemberAdminServlet.parseId(req.getParameter("memberId")), planId = MemberAdminServlet.parseId(req.getParameter("planId"));
                BigDecimal amount = PlanAdminServlet.parseMoney(req.getParameter("amount"));
                String date = Db.param(req, "paymentDate"), method = Db.param(req, "paymentMethod"), status = Db.param(req, "paymentStatus");
                String err = null;
                if (Db.one("SELECT member_id FROM members WHERE member_id = ?", memberId) == null) err = "Please select a member.";
                else if (Db.one("SELECT plan_id FROM plans WHERE plan_id = ?", planId) == null) err = "Please select a plan.";
                else if (amount == null || amount.signum() <= 0) err = "Enter an amount greater than 0.";
                else if (!MemberAdminServlet.validDate(date)) err = "Choose a valid payment date.";
                else if (!METHODS.contains(method)) err = "Choose a payment method.";
                else if (!STATUSES.contains(status)) err = "Choose a payment status.";
                if (err != null) {
                    loadFormLists(req);
                    req.setAttribute("error", err);
                    req.getRequestDispatcher("/addPayment.jsp").forward(req, resp);
                    return;
                }
                Db.update("INSERT INTO payments(member_id, plan_id, amount, payment_date, payment_method, payment_status) VALUES (?,?,?,?,?,?)",
                        memberId, planId, amount, java.sql.Date.valueOf(date), method, status);
                if ("Paid".equals(status)) {
                    try {
                        Map<String, Object> pl = Db.one("SELECT duration_months FROM plans WHERE plan_id = ?", planId);
                        if (pl != null) {
                            int m = ((Number) pl.get("duration_months")).intValue();
                            Db.update("UPDATE members SET plan_id = ?, expiry_date = DATE_ADD(GREATEST(IFNULL(expiry_date, CURDATE()), CURDATE()), INTERVAL ? MONTH) WHERE member_id = ?",
                                    planId, m, memberId);
                        }
                    } catch (Exception ignored) {}
                }
                MemberAdminServlet.flash(req, "success", "Payment recorded successfully.");
            }
            resp.sendRedirect(ctx + "/payments");
        } catch (SQLException e) {
            log("Payment save failed", e);
            MemberAdminServlet.flash(req, "error", "Could not save the payment. Please try again.");
            resp.sendRedirect(ctx + "/payments");
        }
    }

    private void loadFormLists(HttpServletRequest req) throws SQLException {
        req.setAttribute("members", Db.query("SELECT member_id AS memberId, full_name AS fullName FROM members ORDER BY full_name"));
        req.setAttribute("plans", Db.query("SELECT plan_id AS planId, plan_name AS planName, fee, duration_months AS durationMonths FROM plans ORDER BY duration_months, fee"));
    }
}
