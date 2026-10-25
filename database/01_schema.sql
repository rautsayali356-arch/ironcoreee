-- Run this whole file once in MySQL Workbench, Railway MySQL, or: mysql -u root -p < schema.sql
-- (Uncomment the next two lines if running locally on a brand new MySQL server)
-- CREATE DATABASE IF NOT EXISTS gym_db;
-- USE gym_db;

CREATE TABLE IF NOT EXISTS admins (
  admin_id INT AUTO_INCREMENT PRIMARY KEY, full_name VARCHAR(100) NOT NULL,
  username VARCHAR(50) NOT NULL UNIQUE, email VARCHAR(100), password_hash VARCHAR(200) NOT NULL, role VARCHAR(30) DEFAULT 'Administrator');

CREATE TABLE IF NOT EXISTS plans (
  plan_id INT AUTO_INCREMENT PRIMARY KEY, plan_name VARCHAR(60) NOT NULL,
  duration_months INT NOT NULL, fee DECIMAL(10,2) NOT NULL, description VARCHAR(255),
  tag VARCHAR(30) NULL COMMENT 'Optional label: Most popular, Student, Buddy, Off-peak');

CREATE TABLE IF NOT EXISTS members (
  member_id INT AUTO_INCREMENT PRIMARY KEY, full_name VARCHAR(100) NOT NULL, phone VARCHAR(15) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE, gender VARCHAR(10), address VARCHAR(255), joining_date DATE NOT NULL,
  password_hash VARCHAR(200), plan_id INT NULL, expiry_date DATE NULL,
  FOREIGN KEY (plan_id) REFERENCES plans(plan_id) ON DELETE SET NULL);

CREATE TABLE IF NOT EXISTS payments (
  payment_id INT AUTO_INCREMENT PRIMARY KEY, member_id INT NOT NULL, plan_id INT NOT NULL,
  amount DECIMAL(10,2) NOT NULL, payment_date DATE NOT NULL, payment_method VARCHAR(20) NOT NULL,
  payment_status VARCHAR(10) NOT NULL DEFAULT 'Pending',
  FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
  FOREIGN KEY (plan_id) REFERENCES plans(plan_id));

CREATE TABLE IF NOT EXISTS trainers (
  trainer_id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(80) NOT NULL, speciality VARCHAR(100), instagram VARCHAR(50), bio VARCHAR(255));

CREATE TABLE IF NOT EXISTS classes (
  class_id INT AUTO_INCREMENT PRIMARY KEY, class_name VARCHAR(60) NOT NULL, day_of_week VARCHAR(3) NOT NULL,
  start_time TIME NOT NULL, trainer_id INT NULL, FOREIGN KEY (trainer_id) REFERENCES trainers(trainer_id) ON DELETE SET NULL);

CREATE TABLE IF NOT EXISTS enquiries (
  enquiry_id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(100) NOT NULL, phone VARCHAR(15) NOT NULL,
  interest VARCHAR(40), message VARCHAR(500), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);

-- When a payment becomes 'Paid', activate/extend the member's membership automatically.
DROP TRIGGER IF EXISTS trg_payment_insert; DROP TRIGGER IF EXISTS trg_payment_update;
DELIMITER //
CREATE TRIGGER trg_payment_insert AFTER INSERT ON payments FOR EACH ROW
BEGIN
  DECLARE m INT;
  IF NEW.payment_status = 'Paid' THEN
    SELECT duration_months INTO m FROM plans WHERE plan_id = NEW.plan_id;
    UPDATE members SET plan_id = NEW.plan_id,
      expiry_date = DATE_ADD(GREATEST(IFNULL(expiry_date, CURDATE()), CURDATE()), INTERVAL m MONTH)
    WHERE member_id = NEW.member_id;
  END IF;
END//
CREATE TRIGGER trg_payment_update AFTER UPDATE ON payments FOR EACH ROW
BEGIN
  DECLARE m INT;
  IF NEW.payment_status = 'Paid' AND OLD.payment_status <> 'Paid' THEN
    SELECT duration_months INTO m FROM plans WHERE plan_id = NEW.plan_id;
    UPDATE members SET plan_id = NEW.plan_id,
      expiry_date = DATE_ADD(GREATEST(IFNULL(expiry_date, CURDATE()), CURDATE()), INTERVAL m MONTH)
    WHERE member_id = NEW.member_id;
  END IF;
END//
DELIMITER ;

-- SAMPLE data so the website is not empty. Change the prices/names to your real ones.
INSERT INTO plans (plan_name, duration_months, fee, description, tag) VALUES
 ('Monthly', 1, 1500, 'Full gym access. No lock-in.', NULL),
 ('Student Monthly', 1, 999, 'Show a valid college ID at the front desk.', 'Student'),
 ('Quarterly', 3, 3900, 'Full access plus a starter session with a trainer.', 'Most popular'),
 ('Annual', 12, 12000, 'Our lowest cost per month.', NULL),
 ('Buddy Monthly (2 people)', 1, 2400, 'Join with a friend and pay less each.', 'Buddy'),
 ('Off-peak Monthly', 1, 999, 'Valid 10 AM to 4 PM on weekdays.', 'Off-peak');
INSERT INTO trainers (name, speciality, instagram, bio) VALUES
 ('Aarav Sharma', 'Strength and powerlifting', 'aarav.lifts', 'Helps beginners learn the big lifts safely.'),
 ('Meera Nair', 'Yoga and mobility', 'meera.moves', 'Classes for flexibility, recovery and stress.'),
 ('Rohan Das', 'HIIT and Zumba', 'rohan.fit', 'High-energy group sessions, all levels welcome.');
INSERT INTO classes (class_name, day_of_week, start_time, trainer_id) VALUES
 ('HIIT','Mon','06:30',3),('Strength basics','Tue','18:00',1),('Yoga flow','Wed','07:00',2),('Zumba','Thu','19:00',3),
 ('HIIT','Fri','06:30',3),('Strength basics','Sat','09:00',1),('Yoga flow','Sun','08:00',2);

-- Default administrator. Username: admin   Password: Admin@123   (change it on the Profile page after first login)
INSERT INTO admins (full_name, username, email, password_hash, role) VALUES
 ('Gym Administrator', 'admin', 'admin@ironcoregym.example', '9ODqjVjCVeyw3r49SdoQmA==:ML3amGiAifWjUvytd3FsTEAlDwMxd1uydjU5oLUZAZg=', 'Administrator');
