CREATE DATABASE IF NOT EXISTS ngo_impact_db;
USE ngo_impact_db;

-- USERS TABLE
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL,
    email VARCHAR(100)
);

-- PROGRAM MASTER
CREATE TABLE programs (
    program_id INT PRIMARY KEY,
    program_name VARCHAR(100) NOT NULL,
    category VARCHAR(50)
);

INSERT INTO programs VALUES
(1,'Education Sponsorship','Education'),
(2,'Medical Aid','Health'),
(3,'Food Distribution','Relief'),
(4,'Skill Training','Employment');

-- REGION MASTER
CREATE TABLE regions (
    region_id INT PRIMARY KEY,
    region_name VARCHAR(50) NOT NULL
);

INSERT INTO regions VALUES
(1,'Region A'),
(2,'Region B'),
(3,'Region C');

-- BENEFICIARIES
CREATE TABLE beneficiaries (
    beneficiary_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    region_id INT NOT NULL,
    program_id INT NOT NULL,
    income_before DECIMAL(10,2),
    email VARCHAR(100),
    status VARCHAR(20) DEFAULT 'PENDING',
    FOREIGN KEY (region_id) REFERENCES regions(region_id),
    FOREIGN KEY (program_id) REFERENCES programs(program_id)
);

-- AID DISTRIBUTION
CREATE TABLE aid_distribution (
    aid_id INT AUTO_INCREMENT PRIMARY KEY,
    beneficiary_id INT NOT NULL,
    aid_type VARCHAR(50),
    amount DECIMAL(10,2),
    distributed_on DATE,
    FOREIGN KEY (beneficiary_id) REFERENCES beneficiaries(beneficiary_id)
        ON DELETE CASCADE
);

-- POST AID IMPACT
CREATE TABLE post_aid_impact (
    impact_id INT AUTO_INCREMENT PRIMARY KEY,
    beneficiary_id INT NOT NULL,
    income_after DECIMAL(10,2),
    employed VARCHAR(10),
    struggling VARCHAR(10),
    updated_by VARCHAR(50),
    date DATE,
    FOREIGN KEY (beneficiary_id) REFERENCES beneficiaries(beneficiary_id)
        ON DELETE CASCADE
);

-- AID REQUESTS
CREATE TABLE aid_requests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    beneficiary_id INT NOT NULL,
    aid_type VARCHAR(50) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    request_date DATE,
    approval_date DATE,
    requested_by VARCHAR(50),
    status VARCHAR(20) DEFAULT 'PENDING',
    FOREIGN KEY (beneficiary_id) REFERENCES beneficiaries(beneficiary_id) ON DELETE CASCADE
);

-- ANALYTICS DATA
CREATE TABLE analytics_data (
    analytics_id INT AUTO_INCREMENT PRIMARY KEY,
    beneficiary_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    aid_type VARCHAR(50) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    income_after DECIMAL(10,2) DEFAULT 0,
    employed VARCHAR(10) DEFAULT 'NO',
    FOREIGN KEY (beneficiary_id) REFERENCES beneficiaries(beneficiary_id) ON DELETE CASCADE
);

-- IMPACT REPORTS
CREATE TABLE impact_reports (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    beneficiary_id INT NOT NULL,
    income_after DECIMAL(10,2),
    employed VARCHAR(20),
    education VARCHAR(50),
    report_date DATE,
    FOREIGN KEY (beneficiary_id) REFERENCES beneficiaries(beneficiary_id) ON DELETE CASCADE
);

-- AUDIT LOGS
CREATE TABLE audit_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    action VARCHAR(255),
    action_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- SAMPLE USERS
INSERT INTO users (username, password, role, email) VALUES
('admin', 'admin123', 'ADMIN', 'admin@ngo.org'),
('officer1', 'officer123', 'OFFICER', 'officer@ngo.org'),
('manager1', 'manager123', 'MANAGER', 'manager@ngo.org');
