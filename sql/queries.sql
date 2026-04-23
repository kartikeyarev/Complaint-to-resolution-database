USE complaint_workflow;

-- ---------------------------------------------------------
-- 1. FETCH ALL COMPLAINTS (Basic Join)
-- ---------------------------------------------------------
SELECT c.complaint_id, u.full_name AS complainant, c.title, s.status_name, c.created_at
FROM Complaints c
JOIN Users u ON c.user_id = u.user_id
JOIN Status s ON c.status_id = s.status_id
ORDER BY c.created_at DESC;

-- ---------------------------------------------------------
-- 2. FETCH COMPLAINTS BY SPECIFIC STATUS
-- ---------------------------------------------------------
SELECT c.complaint_id, c.title, u.full_name AS assigned_resolver
FROM Complaints c
JOIN Status s ON c.status_id = s.status_id
LEFT JOIN Users u ON c.assigned_to = u.user_id
WHERE s.status_name = 'In Progress';

-- ---------------------------------------------------------
-- 3. CHECK VALID STATE TRANSITION (Simulating Backend Logic)
-- Can a Resolver move Complaint #2 from 'In Progress'(3) to 'Pending Review'(4)?
-- ---------------------------------------------------------
SELECT EXISTS (
    SELECT 1 FROM State_Transitions 
    WHERE from_status_id = (SELECT status_id FROM Complaints WHERE complaint_id = 2)
    AND to_status_id = 4 
    AND allowed_role = 'resolver'
) AS is_valid_transition;

-- ---------------------------------------------------------
-- 4. UPDATE COMPLAINT STATUS
-- ---------------------------------------------------------
UPDATE Complaints 
SET status_id = 4, 
    updated_at = CURRENT_TIMESTAMP
WHERE complaint_id = 2;

-- ---------------------------------------------------------
-- 5. INSERT AUDIT LOG FOR THE UPDATE
-- ---------------------------------------------------------
INSERT INTO Complaint_History (complaint_id, changed_by, old_status_id, new_status_id, comments)
VALUES (2, 4, 3, 4, 'Checked library logs, fine was an error. Sent for admin review.');

-- ---------------------------------------------------------
-- 6. DELETE A REJECTED/SPAM COMPLAINT
-- ---------------------------------------------------------
DELETE FROM Complaints WHERE complaint_id = 5;

-- ---------------------------------------------------------
-- 7. AGGREGATION: COUNT COMPLAINTS PER STATUS
-- ---------------------------------------------------------
SELECT s.status_name, COUNT(c.complaint_id) AS total_complaints
FROM Status s
LEFT JOIN Complaints c ON s.status_id = c.status_id
GROUP BY s.status_name
ORDER BY total_complaints DESC;

-- ---------------------------------------------------------
-- 8. JOIN & FILTER: FULL HISTORY OF A SPECIFIC COMPLAINT
-- ---------------------------------------------------------
SELECT h.log_id, u.full_name AS action_by, s1.status_name AS old_status, s2.status_name AS new_status, h.changed_at, h.comments
FROM Complaint_History h
JOIN Users u ON h.changed_by = u.user_id
LEFT JOIN Status s1 ON h.old_status_id = s1.status_id
JOIN Status s2 ON h.new_status_id = s2.status_id
WHERE h.complaint_id = 3
ORDER BY h.changed_at ASC;
