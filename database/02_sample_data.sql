-- OPTIONAL demo data so the dashboard is not empty. Skip this file for a clean install.
-- USE gym_db;
INSERT INTO members (full_name, phone, email, gender, joining_date) VALUES
 ('Rohit Patil', '9876543210', 'rohit.patil@example.com', 'Male', CURDATE() - INTERVAL 40 DAY),
 ('Sneha Joshi', '9822012345', 'sneha.joshi@example.com', 'Female', CURDATE() - INTERVAL 25 DAY),
 ('Aman Khan', '9890011223', 'aman.khan@example.com', 'Male', CURDATE() - INTERVAL 10 DAY),
 ('Priya Nair', '9765432109', 'priya.nair@example.com', 'Female', CURDATE() - INTERVAL 90 DAY),
 ('Kunal Mehta', '9811122334', 'kunal.mehta@example.com', 'Male', CURDATE() - INTERVAL 2 DAY);
-- Paid payments activate memberships through the trigger; Pending ones wait for the admin.
INSERT INTO payments (member_id, plan_id, amount, payment_date, payment_method, payment_status) VALUES
 (1, 3, 3900, CURDATE() - INTERVAL 40 DAY, 'UPI', 'Paid'),
 (2, 1, 1500, CURDATE() - INTERVAL 25 DAY, 'Cash', 'Paid'),
 (4, 2, 999, CURDATE() - INTERVAL 90 DAY, 'Card', 'Paid'),
 (3, 6, 999, CURDATE() - INTERVAL 10 DAY, 'UPI', 'Pending'),
 (5, 4, 12000, CURDATE() - INTERVAL 2 DAY, 'UPI', 'Pending');
-- Make member 4's membership expired so the Expired count is not zero.
UPDATE members SET expiry_date = CURDATE() - INTERVAL 20 DAY WHERE member_id = 4;
