package gym.servlet;

import gym.util.Db;
import gym.util.Pw;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

/** Admin profile page and change-password. */
@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Map<?, ?> admin = (Map<?, ?>) req.getSession().getAttribute("admin");
        String current = req.getParameter("currentPassword") == null ? "" : req.getParameter("currentPassword");
        String next = req.getParameter("newPassword") == null ? "" : req.getParameter("newPassword");
        try {
            Map<String, Object> row = Db.one("SELECT password_hash AS pw FROM admins WHERE admin_id = ?", admin.get("adminId"));
            if (row == null || !Pw.check(current, (String) row.get("pw"))) {
                req.setAttribute("error", "Your current password is incorrect.");
            } else if (next.length() < 6) {
                req.setAttribute("error", "The new password must be at least 6 characters.");
            } else {
                Db.update("UPDATE admins SET password_hash = ? WHERE admin_id = ?", Pw.hash(next), admin.get("adminId"));
                MemberAdminServlet.flash(req, "success", "Password updated.");
                resp.sendRedirect(req.getContextPath() + "/profile");
                return;
            }
        } catch (SQLException e) {
            log("Password change failed", e);
            req.setAttribute("error", "Could not update the password. Please try again.");
        }
        req.getRequestDispatcher("/profile.jsp").forward(req, resp);
    }
}
