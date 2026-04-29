-- Smart City Service Portal - Database Schema
-- Run this file in MySQL to set up the database

CREATE DATABASE IF NOT EXISTS smartcity_db;
USE smartcity_db;

-- ============================================================
-- TABLE: users
-- ============================================================
CREATE TABLE IF NOT EXISTS users (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    email      VARCHAR(100) NOT NULL UNIQUE,
    password   VARCHAR(255) NOT NULL,
    phone      VARCHAR(15),
    address    VARCHAR(255),
    role       ENUM('ADMIN','CITIZEN') DEFAULT 'CITIZEN',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- TABLE: complaints
-- ============================================================
CREATE TABLE IF NOT EXISTS complaints (
    complaint_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id      INT NOT NULL,
    category     ENUM('Road','Water','Electricity','Garbage','Other') NOT NULL,
    description  TEXT NOT NULL,
    location     VARCHAR(255) NOT NULL,
    status       ENUM('Pending','In Progress','Resolved') DEFAULT 'Pending',
    date         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    latitude   DOUBLE DEFAULT NULL,
    longitude  DOUBLE DEFAULT NULL,
    image_path VARCHAR(500) DEFAULT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ============================================================
-- TABLE: appointments
-- ============================================================
CREATE TABLE IF NOT EXISTS appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id        INT NOT NULL,
    doctor_name    VARCHAR(100) NOT NULL,
    specialization VARCHAR(100),
    date           DATE NOT NULL,
    time           TIME NOT NULL,
    status         ENUM('Pending','Confirmed','Cancelled') DEFAULT 'Pending',
    notes          TEXT,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ============================================================
-- TABLE: bills
-- ============================================================
CREATE TABLE IF NOT EXISTS bills (
    bill_id    INT AUTO_INCREMENT PRIMARY KEY,
    user_id    INT NOT NULL,
    type       ENUM('Electricity','Water','Property Tax','Sewage') NOT NULL,
    amount     DECIMAL(10,2) NOT NULL,
    due_date   DATE NOT NULL,
    status     ENUM('Unpaid','Paid') DEFAULT 'Unpaid',
    issued_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ============================================================
-- TABLE: announcements
-- ============================================================
CREATE TABLE IF NOT EXISTS announcements (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    title       VARCHAR(200) NOT NULL,
    content     TEXT NOT NULL,
    category    ENUM('General','Alert','Event','Maintenance') DEFAULT 'General',
    posted_by   INT,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (posted_by) REFERENCES users(id) ON DELETE SET NULL
);

-- ============================================================
-- SAMPLE DATA
-- ============================================================

-- Admin user (password: admin123)
INSERT INTO users (name, email, password, phone, address, role) VALUES
('Admin User', 'admin@smartcity.com', 'admin123', '9000000000', 'City Hall, Smart City', 'ADMIN');

-- Citizen users (password: pass123)
INSERT INTO users (name, email, password, phone, address, role) VALUES
('Ravi Sharma',  'ravi@email.com',   'pass123', '9111111111', '12 MG Road, Block A', 'CITIZEN'),
('Priya Patel',  'priya@email.com',  'pass123', '9222222222', '45 Park Street, Block B', 'CITIZEN'),
('Amit Kumar',   'amit@email.com',   'pass123', '9333333333', '78 Lake View, Block C', 'CITIZEN');

-- Sample complaints
INSERT INTO complaints (user_id, category, description, location, status, latitude, longitude) VALUES
(2, 'Road',        'Large pothole on main road causing accidents', 'MG Road Near School', 'In Progress', 28.6139, 77.2090),
(3, 'Water',       'No water supply since 3 days', '45 Park Street', 'Pending', 28.6229, 77.2195),
(4, 'Electricity', 'Frequent power cuts in our area', 'Block C, Sector 5', 'Pending', 28.6304, 77.2177),
(2, 'Garbage',     'Garbage not collected for a week', 'MG Road Colony', 'Resolved', 28.6100, 77.2300);

-- Sample appointments
INSERT INTO appointments (user_id, doctor_name, specialization, date, time, status) VALUES
(2, 'Dr. Sunita Mehta', 'General Physician', '2026-04-01', '10:30:00', 'Confirmed'),
(3, 'Dr. Rakesh Iyer',  'Cardiologist',      '2026-04-02', '11:00:00', 'Pending'),
(4, 'Dr. Anjali Rao',   'Dermatologist',     '2026-04-03', '14:00:00', 'Pending');

-- Sample bills
INSERT INTO bills (user_id, type, amount, due_date, status) VALUES
(2, 'Electricity',   850.00,  '2026-04-10', 'Unpaid'),
(2, 'Water',         320.00,  '2026-04-15', 'Paid'),
(3, 'Property Tax', 4500.00,  '2026-04-30', 'Unpaid'),
(3, 'Electricity',   670.00,  '2026-04-10', 'Unpaid'),
(4, 'Water',         290.00,  '2026-04-15', 'Unpaid'),
(4, 'Sewage',        150.00,  '2026-04-20', 'Paid');

-- Sample announcements
INSERT INTO announcements (title, content, category, posted_by) VALUES
('Water Supply Disruption', 'Water supply will be disrupted on 28 March 2026 from 9 AM to 2 PM for maintenance work.', 'Maintenance', 1),
('Smart City Marathon 2026', 'Annual Smart City Marathon will be held on 5 April 2026. Register at the municipal office.', 'Event', 1),
('Property Tax Last Date', 'Last date to pay property tax without penalty is 30 April 2026.', 'Alert', 1),
('New Park Opening', 'The new Riverside Park in Block D will be inaugurated on 1 April 2026.', 'General', 1);
