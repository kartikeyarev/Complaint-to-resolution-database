USE complaint_workflow;

-- Insert Statuses (The nodes of our State Machine)
INSERT INTO Status (status_name, is_final) VALUES 
('Submitted', FALSE),
('Acknowledged', FALSE),
('In Progress', FALSE),
('Pending Review', FALSE),
('Resolved', FALSE),
('Closed', TRUE),
('Rejected', TRUE);

-- Insert Users
INSERT INTO Users (full_name, email, role) VALUES 
('Alice Smith', 'alice@student.edu', 'complainant'),
('Bob Jones', 'bob@student.edu', 'complainant'),
('Admin Sharma', 'admin@college.edu', 'admin'),
('Resolver Rao', 'resolver@college.edu', 'resolver'),
('Resolver Patel', 'patel@college.edu', 'resolver');

-- Insert Valid State Transitions (The edges of our State Machine)
-- 1->2: Admin acknowledges submission
INSERT INTO State_Transitions (from_status_id, to_status_id, allowed_role) VALUES (1, 2, 'admin');
-- 2->3: Resolver starts working
INSERT INTO State_Transitions (from_status_id, to_status_id, allowed_role) VALUES (2, 3, 'resolver');
-- 3->4: Resolver submits for review
INSERT INTO State_Transitions (from_status_id, to_status_id, allowed_role) VALUES (3, 4, 'resolver');
-- 4->5: Admin approves resolution
INSERT INTO State_Transitions (from_status_id, to_status_id, allowed_role) VALUES (4, 5, 'admin');
-- 4->3: Admin rejects resolution, back to progress
INSERT INTO State_Transitions (from_status_id, to_status_id, allowed_role) VALUES (4, 3, 'admin');
-- 5->6: Complainant accepts and closes
INSERT INTO State_Transitions (from_status_id, to_status_id, allowed_role) VALUES (5, 6, 'complainant');
-- 1->7: Admin rejects spam complaint
INSERT INTO State_Transitions (from_status_id, to_status_id, allowed_role) VALUES (1, 7, 'admin');

-- Insert Complaints
INSERT INTO Complaints (user_id, title, description, status_id, assigned_to) VALUES 
(1, 'WiFi Issue in Hostel A', 'The WiFi router on the 3rd floor is not working.', 1, NULL),
(2, 'Library Fine Error', 'I was charged a fine even though I returned the book on time.', 3, 4),
(1, 'Broken Chair in Lab', 'Chair #12 in Computer Lab 2 is broken.', 6, 5),
(2, 'Payment Gateway Failed', 'Fee payment failed but money was deducted.', 2, NULL),
(1, 'Spam Report', 'Testing the system.', 7, NULL);

-- Insert History Logs to represent past actions
INSERT INTO Complaint_History (complaint_id, changed_by, old_status_id, new_status_id, comments) VALUES
(2, 3, 1, 2, 'Acknowledged and routed to library staff.'),
(2, 4, 2, 3, 'Checking library database logs.'),
(3, 3, 1, 2, 'Acknowledged.'),
(3, 5, 2, 3, 'Procuring new chair.'),
(3, 5, 3, 4, 'Chair replaced, awaiting admin review.'),
(3, 3, 4, 5, 'Approved replacement.'),
(3, 1, 5, 6, 'Thank you, issue resolved.'),
(4, 3, 1, 2, 'Acknowledged payment issue, checking with bank.'),
(5, 3, 1, 7, 'Rejected as spam test.');
