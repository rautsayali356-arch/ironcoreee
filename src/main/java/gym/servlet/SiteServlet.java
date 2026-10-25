package gym.servlet;

import gym.util.Db;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

/** Public pages: loads data from MySQL, then forwards to the matching JSP. */
@WebServlet({"/site/home", "/site/plans", "/site/classes", "/site/contact"})
public class SiteServlet extends HttpServlet {

    static final String PLANS = "SELECT plan_id AS planId, plan_name AS planName, duration_months AS durationMonths, "
            + "fee, description, tag FROM plans ORDER BY duration_months, fee";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        try {
            if (path.equals("/site/home") || path.equals("/site/plans")) {
                req.setAttribute("plans", Db.query(PLANS));
            } else if (path.equals("/site/classes")) {
                req.setAttribute("trainers", Db.query("SELECT trainer_id AS trainerId, name, speciality, instagram, bio FROM trainers"));
                req.setAttribute("timetable", Db.query(
                    "SELECT c.class_name AS className, c.day_of_week AS dayOfWeek, c.start_time AS startTime, t.name AS trainerName "
                    + "FROM classes c LEFT JOIN trainers t ON t.trainer_id = c.trainer_id "
                    + "ORDER BY FIELD(c.day_of_week,'Mon','Tue','Wed','Thu','Fri','Sat','Sun'), c.start_time"));
            }
        } catch (SQLException e) {
            log("Database error on " + path, e);
            req.setAttribute("error", "We could not load this page's data. Please try again in a moment.");
        }
        req.getRequestDispatcher(path + ".jsp").forward(req, resp);
    }

    /** Enquiry form on the contact page. */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = Db.param(req, "name"), phone = Db.param(req, "phone");
        String interest = Db.param(req, "interest"), message = Db.param(req, "message");
        HttpSession session = req.getSession();
        if (name.length() < 3 || !phone.matches("[6-9]\\d{9}")) {
            session.setAttribute("error", "Please enter your name and a valid 10-digit phone number.");
        } else {
            try {
                Db.update("INSERT INTO enquiries(name, phone, interest, message) VALUES (?,?,?,?)",
                        name, phone, interest, message.length() > 500 ? message.substring(0, 500) : message);
                session.setAttribute("success", "Thanks " + name + "! We will contact you soon.");
            } catch (SQLException e) {
                log("Enquiry insert failed", e);
                session.setAttribute("error", "Could not send your enquiry. Please try WhatsApp instead.");
            }
        }
        resp.sendRedirect(req.getContextPath() + "/site/contact");
    }
}
