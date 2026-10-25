package gym.servlet;

import gym.util.Db;
import gym.util.Pw;
import java.io.IOException;
import java.sql.SQLException;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

/** Admin login and logout. */
@WebServlet({"/login", "/logout"})
public class AuthServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String ctx = req.getContextPath();
        if (req.getServletPath().equals("/logout")) {
            HttpSession s = req.getSession(false);
            if (s != null) s.invalidate();
            resp.sendRedirect(ctx + "/login.jsp?logout=1");
        } else {
            resp.sendRedirect(ctx + "/login.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = Db.param(req, "username");
        String password = req.getParameter("password") == null ? "" : req.getParameter("password");
        try {
            Map<String, Object> row = Db.one("SELECT admin_id AS adminId, full_name AS fullName, username, email, role, "
                    + "password_hash AS pw FROM admins WHERE username = ?", username);
            if (row == null || !Pw.check(password, (String) row.get("pw"))) {
                req.setAttribute("error", "Wrong username or password.");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
                return;
            }
            row.remove("pw");
            HttpSession old = req.getSession(false);
            if (old != null) old.invalidate();          // fresh session after login
            req.getSession(true).setAttribute("admin", row);
            resp.sendRedirect(req.getContextPath() + "/dashboard");
        } catch (SQLException e) {
            log("Login query failed", e);
            req.setAttribute("error", "Cannot reach the database. Please try again later.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }
}
