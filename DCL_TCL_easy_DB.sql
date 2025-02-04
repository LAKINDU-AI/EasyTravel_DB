-- DCL & TCL File for EasyTravel Database (easytravel_dcl_tcl.sql)
-- This file manages user permissions and transaction control

-- Step 1: Create Users with Specific Roles
CREATE ROLE customer_user LOGIN PASSWORD 'customer_pass';
CREATE ROLE travel_agent_user LOGIN PASSWORD 'agent_pass';
CREATE ROLE admin_user LOGIN PASSWORD 'admin_pass';

-- Step 2: Assign Privileges Based on Roles
GRANT SELECT, INSERT, UPDATE ON bookings, payments, feedback TO customer_user;
GRANT SELECT, INSERT, UPDATE ON bookings, payments, feedback TO travel_agent_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO admin_user;

-- Restrict certain tables from being accessed by non-admin users
REVOKE ALL ON users, roles FROM customer_user;
REVOKE ALL ON users, roles FROM travel_agent_user;

-- Step 3: Implement Transaction Control
-- Example Transaction: Booking Confirmation
BEGIN;
  UPDATE bookings SET payment_status = 'confirmed' WHERE booking_id = 1;
  INSERT INTO payments (booking_id, payment_method, amount, transaction_date)
  VALUES (1, 'credit_card', 700.00, NOW());
COMMIT;

-- Example Transaction: Refund Process (With Rollback if Condition Fails)
BEGIN;
  UPDATE bookings SET payment_status = 'refunded' WHERE booking_id = 2;
  DELETE FROM payments WHERE booking_id = 2;
  -- Simulate a condition where rollback is required (e.g., invalid refund policy)
  -- ROLLBACK;
COMMIT;

-- Step 4: Create Views for Admin Reporting
CREATE VIEW revenue_report AS
SELECT b.booking_date, SUM(p.amount) AS total_revenue
FROM bookings b
JOIN payments p ON b.booking_id = p.booking_id
GROUP BY b.booking_date;

-- Completed DCL & TCL File
