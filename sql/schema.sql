-- Create Database
CREATE DATABASE IF NOT EXISTS complaint_workflow;
USE complaint_workflow;

-- 1. Users Table (Complainants, Admins, Resolvers)
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role ENUM('complainant', 'admin', 'resolver') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Status Table (Defines the states in the State Machine)
CREATE TABLE Status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50) UNIQUE NOT NULL,
    is_final BOOLEAN DEFAULT FALSE
);

-- 3. State Transitions (Defines valid state machine transitions)
CREATE TABLE State_Transitions (
    transition_id INT AUTO_INCREMENT PRIMARY KEY,
    from_status_id INT,
    to_status_id INT NOT NULL,
    allowed_role ENUM('complainant', 'admin', 'resolver', 'system') NOT NULL,
    FOREIGN KEY (from_status_id) REFERENCES Status(status_id) ON DELETE CASCADE,
    FOREIGN KEY (to_status_id) REFERENCES Status(status_id) ON DELETE CASCADE
);

-- 4. Complaints Table
CREATE TABLE Complaints (
    complaint_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    status_id INT NOT NULL DEFAULT 1,
    assigned_to INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (status_id) REFERENCES Status(status_id),
    FOREIGN KEY (assigned_to) REFERENCES Users(user_id) ON DELETE SET NULL
);

-- 5. Complaint History (Audit log for state transitions)
CREATE TABLE Complaint_History (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    complaint_id INT NOT NULL,
    changed_by INT NOT NULL,
    old_status_id INT,
    new_status_id INT NOT NULL,
    comments TEXT,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (complaint_id) REFERENCES Complaints(complaint_id) ON DELETE CASCADE,
    FOREIGN KEY (changed_by) REFERENCES Users(user_id),
    FOREIGN KEY (old_status_id) REFERENCES Status(status_id),
    FOREIGN KEY (new_status_id) REFERENCES Status(status_id)
);
