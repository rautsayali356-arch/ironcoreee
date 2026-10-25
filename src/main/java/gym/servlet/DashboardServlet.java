package gym.servlet;

import gym.util.Db;
import java.io.IOException;
import java.sql.SQLException;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

/** Loads the four dashboard numbers and the recent activity lists. */
@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            Map<String, Object> stats = new HashMap<>();
            stats.put("totalMembers", Db.one("SELECT COUNT(*) AS c FROM members").get("c"));
            stats.put("activeMemberships", Db.one("SELECT COUNT(*) AS c FROM members WHERE expiry_date >= CURDATE()").get("c"));
            stats.put("expiredMemberships", Db.one("SELECT COUNT(*) AS c FROM members WHERE expiry_date < CURDATE()").get("c"));
            stats.put("totalRevenue", Db.one("SELECT COALESCE(SUM(amount), 0) AS r FROM payments WHERE payment_status = 'Paid'").get("r"));
            req.setAttribute("stats", stats);
            req.setAttribute("recentMembers", Db.query("SELECT member_id AS memberId, full_name AS fullName, phone, joining_date AS joiningDate "
                    + "FROM members ORDER BY member_id DESC LIMIT 5"));
            req.setAttribute("recentPayments", Db.query("SELECT m.full_name AS memberName, pl.plan_name AS planName, p.amount, p.payment_status AS paymentStatus "
                    + "FROM payments p JOIN members m ON m.member_id = p.member_id JOIN plans pl ON pl.plan_id = p.plan_id "
                    + "ORDER BY p.payment_id DESC LIMIT 5"));
        } catch (SQLException e) {
            log("Dashboard query failed", e);
            req.setAttribute("error", "Could not load dashboard data.");
        }
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }
}
