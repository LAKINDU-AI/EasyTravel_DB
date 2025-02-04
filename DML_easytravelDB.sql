-- DML File for EasyTravel Database (easytravel_dml.sql)
-- Insert sample data into the database

-- Insert Roles (for RBAC)
INSERT INTO roles (role_name) VALUES ('customer'), ('travel_agent'), ('admin');

-- Insert Users
INSERT INTO users (name, email, password, role) VALUES
('John Doe', 'johndoe@example.com', 'hashed_password', 'customer'),
('Jane Smith', 'janesmith@example.com', 'hashed_password', 'travel_agent'),
('Admin User', 'admin@example.com', 'hashed_password', 'admin');

-- Insert Flights
INSERT INTO flights (airline, origin, destination, departure_time, arrival_time, seat_class, price, seats_available) VALUES
('Airways A', 'New York', 'London', '2025-03-10 08:00:00', '2025-03-10 20:00:00', 'economy', 500.00, 100),
('Airways B', 'Paris', 'Tokyo', '2025-04-15 10:00:00', '2025-04-16 05:00:00', 'business', 1200.00, 50);

-- Insert Accommodations
INSERT INTO accommodations (name, location, room_type, amenities, price_per_night, seasonal_demand) VALUES
('Grand Hotel', 'London', 'Deluxe Suite', 'WiFi, Pool, Gym', 200.00, TRUE),
('Mountain Resort', 'Tokyo', 'Cabin', 'Hot Springs, Hiking', 150.00, FALSE);

-- Insert Bookings
INSERT INTO bookings (user_id, booking_date, total_price, payment_status) VALUES
(1, '2025-02-20', 700.00, 'confirmed'),
(2, '2025-02-25', 1350.00, 'pending');

-- Insert Booking Details
INSERT INTO booking_details (booking_id, flight_id, accommodation_id, extra_services) VALUES
(1, 1, 1, 'Extra baggage, Breakfast'),
(2, 2, 2, 'Guided tour');

-- Insert Payments
INSERT INTO payments (booking_id, payment_method, amount, transaction_date) VALUES
(1, 'credit_card', 700.00, '2025-02-21'),
(2, 'bank_transfer', 1350.00, '2025-02-26');

-- Insert Taxi Transfers
INSERT INTO taxi_transfers (booking_id, transfer_type, special_requests) VALUES
(1, 'private', 'Child seat'),
(2, 'shared', 'Wheelchair accessible');

-- Insert Loyalty Program Data
INSERT INTO loyalty_programs (user_id, points_balance) VALUES
(1, 1000),
(2, 500);

-- Insert Feedback
INSERT INTO feedback (user_id, booking_id, rating, comments, feedback_date) VALUES
(1, 1, 5, 'Amazing experience!', '2025-03-15'),
(2, 2, 4, 'Great service, but flight was delayed.', '2025-04-18');

-- Insert Promotions
INSERT INTO promotions (name, discount_percentage, start_date, end_date, applicable_to) VALUES
('Spring Discount', 10.00, '2025-03-01', '2025-03-31', 'flights'),
('Summer Special', 15.00, '2025-06-01', '2025-06-30', 'accommodations');

-- Completed DML File
-- Next Steps: Implement Data Control Language (DCL) and Transaction Control (TCL) operations
