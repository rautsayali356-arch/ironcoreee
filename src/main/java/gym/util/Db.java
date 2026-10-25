package gym.util;

import java.sql.*;
import java.util.*;

/** Small JDBC helper. Every query uses PreparedStatement (safe from SQL injection). */
public class Db {

    private static volatile boolean schemaInitialized = false;

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL driver jar missing in WEB-INF/lib", e);
        }
    }

    public static String getDbUrl() {
        String dbUrl = System.getenv("DB_URL");
        if (dbUrl != null && !dbUrl.trim().isEmpty()) {
            return dbUrl.trim();
        }
        // Cloud environment auto-detection (e.g. Railway MySQL)
        String host = firstEnv("MYSQLHOST", "MYSQL_HOST");
        if (host != null && !host.trim().isEmpty()) {
            String port = firstEnv("MYSQLPORT", "MYSQL_PORT");
            if (port == null || port.trim().isEmpty()) port = "3306";
            String db = firstEnv("MYSQLDATABASE", "MYSQL_DATABASE");
            if (db == null || db.trim().isEmpty()) db = "railway";
            return "jdbc:mysql://" + host.trim() + ":" + port.trim() + "/" + db.trim()
                    + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Kolkata";
        }
        return "jdbc:mysql://localhost:3306/gym_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Kolkata";
    }

    public static String getDbUser() {
        String user = firstEnv("DB_USER", "MYSQLUSER", "MYSQL_USER");
        return (user != null && !user.trim().isEmpty()) ? user.trim() : "root";
    }

    public static String getDbPass() {
        String pass = firstEnv("DB_PASS", "MYSQLPASSWORD", "MYSQL_PASSWORD");
        return (pass != null) ? pass : "root";
    }

    private static String firstEnv(String... keys) {
        for (String k : keys) {
            String v = System.getenv(k);
            if (v != null && !v.trim().isEmpty()) return v;
        }
        return null;
    }

    public static Connection getConnection() throws SQLException {
        Connection c = DriverManager.getConnection(getDbUrl(), getDbUser(), getDbPass());
        if (!schemaInitialized) {
            synchronized (Db.class) {
                if (!schemaInitialized) {
                    initSchemaIfNeeded(c);
                    schemaInitialized = true;
                }
            }
        }
        return c;
    }

    private static void initSchemaIfNeeded(Connection c) {
        try (Statement s = c.createStatement()) {
            try (ResultSet rs = s.executeQuery("SELECT 1 FROM plans LIMIT 1")) {
                // Tables already exist
                return;
            } catch (SQLException ignored) {
                // Table does not exist yet; initialize database
            }

            s.execute("CREATE TABLE IF NOT EXISTS admins ("
                    + "admin_id INT AUTO_INCREMENT PRIMARY KEY, full_name VARCHAR(100) NOT NULL, "
                    + "username VARCHAR(50) NOT NULL UNIQUE, email VARCHAR(100), "
                    + "password_hash VARCHAR(200) NOT NULL, role VARCHAR(30) DEFAULT 'Administrator')");

            s.execute("CREATE TABLE IF NOT EXISTS plans ("
                    + "plan_id INT AUTO_INCREMENT PRIMARY KEY, plan_name VARCHAR(60) NOT NULL, "
                    + "duration_months INT NOT NULL, fee DECIMAL(10,2) NOT NULL, description VARCHAR(255), "
                    + "tag VARCHAR(30) NULL)");

            s.execute("CREATE TABLE IF NOT EXISTS members ("
                    + "member_id INT AUTO_INCREMENT PRIMARY KEY, full_name VARCHAR(100) NOT NULL, phone VARCHAR(15) NOT NULL, "
                    + "email VARCHAR(100) NOT NULL UNIQUE, gender VARCHAR(10), address VARCHAR(255), joining_date DATE NOT NULL, "
                    + "password_hash VARCHAR(200), plan_id INT NULL, expiry_date DATE NULL, "
                    + "FOREIGN KEY (plan_id) REFERENCES plans(plan_id) ON DELETE SET NULL)");

            s.execute("CREATE TABLE IF NOT EXISTS payments ("
                    + "payment_id INT AUTO_INCREMENT PRIMARY KEY, member_id INT NOT NULL, plan_id INT NOT NULL, "
                    + "amount DECIMAL(10,2) NOT NULL, payment_date DATE NOT NULL, payment_method VARCHAR(20) NOT NULL, "
                    + "payment_status VARCHAR(10) NOT NULL DEFAULT 'Pending', "
                    + "FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE, "
                    + "FOREIGN KEY (plan_id) REFERENCES plans(plan_id))");

            s.execute("CREATE TABLE IF NOT EXISTS trainers ("
                    + "trainer_id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(80) NOT NULL, speciality VARCHAR(100), "
                    + "instagram VARCHAR(50), bio VARCHAR(255))");

            s.execute("CREATE TABLE IF NOT EXISTS classes ("
                    + "class_id INT AUTO_INCREMENT PRIMARY KEY, class_name VARCHAR(60) NOT NULL, day_of_week VARCHAR(3) NOT NULL, "
                    + "start_time TIME NOT NULL, trainer_id INT NULL, "
                    + "FOREIGN KEY (trainer_id) REFERENCES trainers(trainer_id) ON DELETE SET NULL)");

            s.execute("CREATE TABLE IF NOT EXISTS enquiries ("
                    + "enquiry_id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(100) NOT NULL, phone VARCHAR(15) NOT NULL, "
                    + "interest VARCHAR(40), message VARCHAR(500), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");

            try {
                s.execute("DROP TRIGGER IF EXISTS trg_payment_insert");
                s.execute("CREATE TRIGGER trg_payment_insert AFTER INSERT ON payments FOR EACH ROW "
                        + "BEGIN "
                        + "  DECLARE m INT; "
                        + "  IF NEW.payment_status = 'Paid' THEN "
                        + "    SELECT duration_months INTO m FROM plans WHERE plan_id = NEW.plan_id; "
                        + "    UPDATE members SET plan_id = NEW.plan_id, "
                        + "      expiry_date = DATE_ADD(GREATEST(IFNULL(expiry_date, CURDATE()), CURDATE()), INTERVAL m MONTH) "
                        + "    WHERE member_id = NEW.member_id; "
                        + "  END IF; "
                        + "END");

                s.execute("DROP TRIGGER IF EXISTS trg_payment_update");
                s.execute("CREATE TRIGGER trg_payment_update AFTER UPDATE ON payments FOR EACH ROW "
                        + "BEGIN "
                        + "  DECLARE m INT; "
                        + "  IF NEW.payment_status = 'Paid' AND OLD.payment_status <> 'Paid' THEN "
                        + "    SELECT duration_months INTO m FROM plans WHERE plan_id = NEW.plan_id; "
                        + "    UPDATE members SET plan_id = NEW.plan_id, "
                        + "      expiry_date = DATE_ADD(GREATEST(IFNULL(expiry_date, CURDATE()), CURDATE()), INTERVAL m MONTH) "
                        + "    WHERE member_id = NEW.member_id; "
                        + "  END IF; "
                        + "END");
            } catch (Exception triggerEx) {
                System.err.println("Notice: Could not register MySQL triggers: " + triggerEx.getMessage());
            }

            s.execute("INSERT INTO plans (plan_name, duration_months, fee, description, tag) VALUES "
                    + "('Monthly', 1, 1500, 'Full gym access. No lock-in.', NULL), "
                    + "('Student Monthly', 1, 999, 'Show a valid college ID at the front desk.', 'Student'), "
                    + "('Quarterly', 3, 3900, 'Full access plus a starter session with a trainer.', 'Most popular'), "
                    + "('Annual', 12, 12000, 'Our lowest cost per month.', NULL), "
                    + "('Buddy Monthly (2 people)', 1, 2400, 'Join with a friend and pay less each.', 'Buddy'), "
                    + "('Off-peak Monthly', 1, 999, 'Valid 10 AM to 4 PM on weekdays.', 'Off-peak')");

            s.execute("INSERT INTO trainers (name, speciality, instagram, bio) VALUES "
                    + "('Aarav Sharma', 'Strength and powerlifting', 'aarav.lifts', 'Helps beginners learn the big lifts safely.'), "
                    + "('Meera Nair', 'Yoga and mobility', 'meera.moves', 'Classes for flexibility, recovery and stress.'), "
                    + "('Rohan Das', 'HIIT and Zumba', 'rohan.fit', 'High-energy group sessions, all levels welcome.')");

            s.execute("INSERT INTO classes (class_name, day_of_week, start_time, trainer_id) VALUES "
                    + "('HIIT','Mon','06:30',3),('Strength basics','Tue','18:00',1),('Yoga flow','Wed','07:00',2),('Zumba','Thu','19:00',3), "
                    + "('HIIT','Fri','06:30',3),('Strength basics','Sat','09:00',1),('Yoga flow','Sun','08:00',2)");

            s.execute("INSERT INTO admins (full_name, username, email, password_hash, role) VALUES "
                    + "('Gym Administrator', 'admin', 'admin@ironcoregym.example', '9ODqjVjCVeyw3r49SdoQmA==:ML3amGiAifWjUvytd3FsTEAlDwMxd1uydjU5oLUZAZg=', 'Administrator')");

            s.execute("INSERT INTO members (full_name, phone, email, gender, joining_date) VALUES "
                    + "('Rohit Patil', '9876543210', 'rohit.patil@example.com', 'Male', CURDATE() - INTERVAL 40 DAY), "
                    + "('Sneha Joshi', '9822012345', 'sneha.joshi@example.com', 'Female', CURDATE() - INTERVAL 25 DAY), "
                    + "('Aman Khan', '9890011223', 'aman.khan@example.com', 'Male', CURDATE() - INTERVAL 10 DAY), "
                    + "('Priya Nair', '9765432109', 'priya.nair@example.com', 'Female', CURDATE() - INTERVAL 90 DAY), "
                    + "('Kunal Mehta', '9811122334', 'kunal.mehta@example.com', 'Male', CURDATE() - INTERVAL 2 DAY)");

            s.execute("INSERT INTO payments (member_id, plan_id, amount, payment_date, payment_method, payment_status) VALUES "
                    + "(1, 3, 3900, CURDATE() - INTERVAL 40 DAY, 'UPI', 'Paid'), "
                    + "(2, 1, 1500, CURDATE() - INTERVAL 25 DAY, 'Cash', 'Paid'), "
                    + "(4, 2, 999, CURDATE() - INTERVAL 90 DAY, 'Card', 'Paid'), "
                    + "(3, 6, 999, CURDATE() - INTERVAL 10 DAY, 'UPI', 'Pending'), "
                    + "(5, 4, 12000, CURDATE() - INTERVAL 2 DAY, 'UPI', 'Pending')");

            s.execute("UPDATE members SET expiry_date = CURDATE() - INTERVAL 20 DAY WHERE member_id = 4");

            System.out.println("IronCore database initialized with schema and seed data.");
        } catch (Exception e) {
            System.err.println("Database auto-init notice: " + e.getMessage());
        }
    }

    private static void bind(PreparedStatement ps, Object[] p) throws SQLException {
        for (int i = 0; i < p.length; i++) ps.setObject(i + 1, p[i]);
    }

    /** SELECT -> list of rows. Column labels (use SQL \"AS\") become the keys, e.g. ${p.planName} in JSP. */
    public static List<Map<String, Object>> query(String sql, Object... p) throws SQLException {
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            bind(ps, p);
            try (ResultSet rs = ps.executeQuery()) {
                ResultSetMetaData md = rs.getMetaData();
                List<Map<String, Object>> out = new ArrayList<>();
                while (rs.next()) {
                    Map<String, Object> row = new LinkedHashMap<>();
                    for (int i = 1; i <= md.getColumnCount(); i++) row.put(md.getColumnLabel(i), rs.getObject(i));
                    out.add(row);
                }
                return out;
            }
        }
    }

    public static Map<String, Object> one(String sql, Object... p) throws SQLException {
        List<Map<String, Object>> rows = query(sql, p);
        return rows.isEmpty() ? null : rows.get(0);
    }

    public static int update(String sql, Object... p) throws SQLException {
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            bind(ps, p);
            return ps.executeUpdate();
        }
    }

    /** INSERT -> returns the new auto-increment id. */
    public static long insert(String sql, Object... p) throws SQLException {
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            bind(ps, p);
            ps.executeUpdate();
            try (ResultSet k = ps.getGeneratedKeys()) { return k.next() ? k.getLong(1) : -1; }
        }
    }

    /** Trimmed request parameter, never null. */
    public static String param(javax.servlet.http.HttpServletRequest r, String name) {
        String v = r.getParameter(name);
        return v == null ? "" : v.trim();
    }
}
