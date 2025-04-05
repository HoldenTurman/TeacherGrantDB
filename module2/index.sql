-- 1. Create the database
CREATE DATABASE TeacherGrantsDB;
USE TeacherGrantsDB;

-- 2. Table for storing teacher details
CREATE TABLE Teachers (
    teacher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(100),
    email VARCHAR(100) UNIQUE NOT NULL,
    hire_date DATE DEFAULT CURRENT_DATE
);

-- 3. Table for storing grant details
CREATE TABLE Grants (
    grant_id INT AUTO_INCREMENT PRIMARY KEY,
    grant_name VARCHAR(255) NOT NULL,
    funding_amount DECIMAL(10,2) NOT NULL CHECK (funding_amount > 0),
    approval_date DATE,
    funding_source VARCHAR(100)
);

-- 4. Table for tracking the status of grant applications
CREATE TABLE ApplicationStatus (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name ENUM('Pending', 'Approved', 'Rejected', 'Under Review') NOT NULL UNIQUE
);

-- 5. Insert predefined statuses
INSERT INTO ApplicationStatus (status_name) VALUES 
    ('Pending'), ('Approved'), ('Rejected'), ('Under Review');

-- 6. Table for tracking teacher grant applications
CREATE TABLE GrantApplications (
    application_id INT AUTO_INCREMENT PRIMARY KEY,
    teacher_id INT NOT NULL,
    grant_id INT NOT NULL,
    status_id INT DEFAULT 1,  -- Default is 'Pending'
    application_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (teacher_id) REFERENCES Teachers(teacher_id) ON DELETE CASCADE,
    FOREIGN KEY (grant_id) REFERENCES Grants(grant_id) ON DELETE CASCADE,
    FOREIGN KEY (status_id) REFERENCES ApplicationStatus(status_id),
    INDEX idx_teacher (teacher_id),
    INDEX idx_grant (grant_id)
);

-- 7. Table for tracking approvals and rejections
CREATE TABLE Approvals (
    approval_id INT AUTO_INCREMENT PRIMARY KEY,
    application_id INT NOT NULL,
    approved_by VARCHAR(100) NOT NULL,
    decision ENUM('Approved', 'Rejected') NOT NULL,
    decision_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    comments TEXT,
    FOREIGN KEY (application_id) REFERENCES GrantApplications(application_id) ON DELETE CASCADE
);

-- 8. Insert sample teachers
INSERT INTO Teachers (name, department, email, hire_date) VALUES
    ('Alice Johnson', 'Science', 'alice.johnson@example.com', '2018-09-01'),
    ('Bob Williams', 'Mathematics', 'bob.williams@example.com', '2015-08-15'),
    ('Catherine Lee', 'English', 'catherine.lee@example.com', '2020-01-10'),
    ('Daniel Smith', 'History', 'daniel.smith@example.com', '2012-07-20');

-- 9. Insert sample grants
INSERT INTO Grants (grant_name, funding_amount, approval_date, funding_source) VALUES
    ('STEM Research Grant', 10000.00, '2025-02-15', 'National Science Foundation'),
    ('Math Excellence Grant', 5000.00, '2025-03-10', 'Private Donation'),
    ('Literature & Arts Grant', 7500.00, '2025-04-05', 'State Education Fund');

-- 10. Insert sample applications
INSERT INTO GrantApplications (teacher_id, grant_id, status_id) VALUES 
    (1, 1, 1),  -- Alice applies for STEM grant
    (2, 2, 4),  -- Bob applies for Math grant (Under Review)
    (3, 3, 1),  -- Catherine applies for Literature grant
    (4, 1, 3);  -- Daniel's STEM grant got rejected

-- 11. Insert sample approvals
INSERT INTO Approvals (application_id, approved_by, decision, comments) VALUES 
    (1, 'Dr. Smith', 'Approved', 'Great proposal, funding approved.'),
    (4, 'Dr. Brown', 'Rejected', 'Did not meet the research criteria.');

-- 12. View all applications and their status
SELECT t.name AS Teacher, g.grant_name AS Grant, a.application_date, s.status_name
FROM GrantApplications a
JOIN Teachers t ON a.teacher_id = t.teacher_id
JOIN Grants g ON a.grant_id = g.grant_id
JOIN ApplicationStatus s ON a.status_id = s.status_id;

-- 13. View approved applications with details
SELECT t.name AS Teacher, g.grant_name AS Grant, ap.approved_by, ap.decision_date, ap.comments
FROM Approvals ap
JOIN GrantApplications a ON ap.application_id = a.application_id
JOIN Teachers t ON a.teacher_id = t.teacher_id
JOIN Grants g ON a.grant_id = g.grant_id
WHERE ap.decision = 'Approved';

-- 14. Count grant applications per teacher
SELECT t.name, COUNT(a.application_id) AS TotalApplications
FROM Teachers t
LEFT JOIN GrantApplications a ON t.teacher_id = a.teacher_id
GROUP BY t.name;

-- 15. Create a View for Active Grant Applications
CREATE VIEW ActiveGrantApplications AS
SELECT t.name AS Teacher, g.grant_name AS Grant, s.status_name, a.application_date
FROM GrantApplications a
JOIN Teachers t ON a.teacher_id = t.teacher_id
JOIN Grants g ON a.grant_id = g.grant_id
JOIN ApplicationStatus s ON a.status_id = s.status_id
WHERE s.status_name IN ('Pending', 'Under Review');

-- 16. Retrieve all active grant applications from the view
SELECT * FROM ActiveGrantApplications;

-- 17. Retrieve all grants with funding amount over $5000
SELECT * FROM Grants WHERE funding_amount > 5000.00;

-- 18. Count how many teachers applied for at least one grant
SELECT COUNT(DISTINCT teacher_id) AS TeachersWithApplications FROM GrantApplications;

-- 19. Count applications by status
SELECT s.status_name, COUNT(a.application_id) AS TotalApplications
FROM GrantApplications a
JOIN ApplicationStatus s ON a.status_id = s.status_id
GROUP BY s.status_name;

-- 20. Find teachers who have not applied for any grants
SELECT t.name FROM Teachers t
LEFT JOIN GrantApplications a ON t.teacher_id = a.teacher_id
WHERE a.application_id IS NULL;
