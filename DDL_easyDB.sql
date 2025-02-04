-- DDL File for EasyTravel Database
-- Database: easytravel_db

-- Drop tables if they exist (to avoid conflicts during re-creation)
DROP TABLE IF EXISTS users, roles, flights, accommodations, bookings, payments, taxi_transfers, loyalty_programs, feedback, promotions, booking_details CASCADE;

-- Create Users Table
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(50) CHECK (role IN ('customer', 'travel_agent', 'admin')) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Roles Table for RBAC (Role-Based Access Control)
CREATE TABLE roles (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE NOT NULL
);

-- Create Flights Table
CREATE TABLE flights (
    flight_id SERIAL PRIMARY KEY,
    airline VARCHAR(100) NOT NULL,
    origin VARCHAR(50) NOT NULL,
    destination VARCHAR(50) NOT NULL,
    departure_time TIMESTAMP NOT NULL,
    arrival_time TIMESTAMP NOT NULL,
    seat_class VARCHAR(20) CHECK (seat_class IN ('economy', 'business', 'first')) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    seats_available INT CHECK (seats_available >= 0) NOT NULL
);

-- Create Accommodations Table
CREATE TABLE accommodations (
    accommodation_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    location VARCHAR(100) NOT NULL,
    room_type VARCHAR(50) NOT NULL,
    amenities TEXT,
    price_per_night DECIMAL(10,2) NOT NULL,
    seasonal_demand BOOLEAN DEFAULT FALSE
);

-- Create Bookings Table
CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_price DECIMAL(10,2) NOT NULL,
    payment_status VARCHAR(20) CHECK (payment_status IN ('pending', 'confirmed', 'cancelled')) NOT NULL
);

-- Create Booking Details Table (to store flight & accommodation references in a booking)
CREATE TABLE booking_details (
    booking_detail_id SERIAL PRIMARY KEY,
    booking_id INT REFERENCES bookings(booking_id) ON DELETE CASCADE,
    flight_id INT REFERENCES flights(flight_id) ON DELETE SET NULL,
    accommodation_id INT REFERENCES accommodations(accommodation_id) ON DELETE SET NULL,
    extra_services TEXT
);

-- Create Payments Table
CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    booking_id INT REFERENCES bookings(booking_id) ON DELETE CASCADE,
    payment_method VARCHAR(50) CHECK (payment_method IN ('credit_card', 'bank_transfer', 'loyalty_points')) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Taxi Transfers Table
CREATE TABLE taxi_transfers (
    transfer_id SERIAL PRIMARY KEY,
    booking_id INT REFERENCES bookings(booking_id) ON DELETE CASCADE,
    transfer_type VARCHAR(50) CHECK (transfer_type IN ('shared', 'private')) NOT NULL,
    special_requests TEXT
);

-- Create Loyalty Programs Table
CREATE TABLE loyalty_programs (
    loyalty_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    points_balance INT DEFAULT 0 CHECK (points_balance >= 0)
);

-- Create Feedback Table
CREATE TABLE feedback (
    feedback_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    booking_id INT REFERENCES bookings(booking_id) ON DELETE CASCADE,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comments TEXT,
    feedback_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Promotions Table
CREATE TABLE promotions (
    promotion_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    discount_percentage DECIMAL(5,2) CHECK (discount_percentage BETWEEN 0 AND 100) NOT NULL,
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP NOT NULL,
    applicable_to VARCHAR(50) CHECK (applicable_to IN ('flights', 'accommodations', 'all')) NOT NULL
);

-- Create Indexes for Faster Queries
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_flights_origin ON flights(origin);
CREATE INDEX idx_flights_destination ON flights(destination);
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_payments_booking_id ON payments(booking_id);

-- Enforce Foreign Key Constraints
ALTER TABLE bookings ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE;
ALTER TABLE booking_details ADD CONSTRAINT fk_booking FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE;
ALTER TABLE booking_details ADD CONSTRAINT fk_flight FOREIGN KEY (flight_id) REFERENCES flights(flight_id) ON DELETE SET NULL;
ALTER TABLE booking_details ADD CONSTRAINT fk_accommodation FOREIGN KEY (accommodation_id) REFERENCES accommodations(accommodation_id) ON DELETE SET NULL;
ALTER TABLE payments ADD CONSTRAINT fk_payment FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE;
ALTER TABLE loyalty_programs ADD CONSTRAINT fk_loyalty FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE;
ALTER TABLE feedback ADD CONSTRAINT fk_feedback FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE;
ALTER TABLE feedback ADD CONSTRAINT fk_feedback_booking FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE;

-- Completed DDL File
-- Next Steps: Insert sample data using DML file
