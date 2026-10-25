package gym.servlet;

import gym.util.Db;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

/** Admin: list, add, edit and delete membership plans. */
@WebServlet({"/plans", "/plan"})
public class PlanAdminServlet extends HttpServlet {

    private static final String LIST = "SELECT plan_id AS planId, plan_name AS planName, duration_months AS durationMonths, fee, "
            + "description, tag FROM plans ORDER BY duration_months, fee";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            if (req.getServletPath().equals("/plans")) {
                req.setAttribute("plans", Db.query(LIST));
                req.getRequestDispatcher("/plans.jsp").forward(req, resp);
                return;
            }
            if ("edit".equals(req.getParameter("action"))) {
                Map<String, Object> p = Db.one("SELECT plan_id AS planId, plan_name AS planName, duration_months AS durationMonths, fee, "
                        + "description, tag FROM plans WHERE plan_id = ?", MemberAdminServlet.parseId(req.getParameter("id")));
                if (p == null) { MemberAdminServlet.flash(req, "error", "Plan not found."); resp.sendRedirect(req.getContextPath() + "/plans"); return; }
                req.setAttribute("plan", p);
            }
            req.getRequestDispatcher("/addPlan.jsp").forward(req, resp);
        } catch (SQLException e) {
            log("Plan query failed", e);
            req.setAttribute("error", "Database error. Please try again.");
            req.getRequestDispatcher("/plans.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = Db.param(req, "action"), ctx = req.getContextPath();
        try {
            if (action.equals("delete")) {
                try {
                    Db.update("DELETE FROM plans WHERE plan_id = ?", MemberAdminServlet.parseId(req.getParameter("id")));
                    MemberAdminServlet.flash(req, "success", "Plan deleted.");
                } catch (SQLException e) {
                    if (e.getErrorCode() != 1451) throw e;   // 1451 = plan is used by payments
                    MemberAdminServlet.flash(req, "error", "This plan has payment records, so it cannot be deleted.");
                }
                resp.sendRedirect(ctx + "/plans");
                return;
            }
            String name = Db.param(req, "planName"), desc = Db.param(req, "description"), tag = Db.param(req, "tag");
            int months = MemberAdminServlet.parseId(req.getParameter("durationMonths"));
            BigDecimal fee = parseMoney(req.getParameter("fee"));
            String err = null;
            if (name.length() < 3) err = "Enter a plan name (at least 3 characters).";
            else if (months < 1 || months > 36) err = "Duration must be between 1 and 36 months.";
            else if (fee == null || fee.signum() <= 0) err = "Enter a fee greater than 0.";
            if (err != null) {
                if (action.equals("update")) {
                    Map<String, Object> p = new HashMap<>();
                    p.put("planId", req.getParameter("planId")); p.put("planName", name); p.put("durationMonths", req.getParameter("durationMonths"));
                    p.put("fee", req.getParameter("fee")); p.put("description", desc); p.put("tag", tag);
                    req.setAttribute("plan", p);
                }
                req.setAttribute("error", err);
                req.getRequestDispatcher("/addPlan.jsp").forward(req, resp);
                return;
            }
            Object tagValue = tag.isEmpty() ? null : tag, descValue = desc.isEmpty() ? null : desc;
            if (action.equals("update")) {
                Db.update("UPDATE plans SET plan_name=?, duration_months=?, fee=?, description=?, tag=? WHERE plan_id=?",
                        name, months, fee, descValue, tagValue, MemberAdminServlet.parseId(req.getParameter("planId")));
                MemberAdminServlet.flash(req, "success", "Plan updated.");
            } else {
                Db.update("INSERT INTO plans(plan_name, duration_months, fee, description, tag) VALUES (?,?,?,?,?)", name, months, fee, descValue, tagValue);
                MemberAdminServlet.flash(req, "success", "Plan added successfully.");
            }
            resp.sendRedirect(ctx + "/plans");
        } catch (SQLException e) {
            log("Plan save failed", e);
            MemberAdminServlet.flash(req, "error", "Could not save the plan. Please try again.");
            resp.sendRedirect(ctx + "/plans");
        }
    }

    static BigDecimal parseMoney(String s) { try { return new BigDecimal(s == null ? "" : s.trim()); } catch (NumberFormatException e) { return null; } }
}
