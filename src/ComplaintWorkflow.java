package src;

import java.sql.*;

public class ComplaintWorkflow {

    // Pseudo-implementation to demonstrate State Machine validation in Backend
    public static boolean updateComplaintStatus(Connection conn, int complaintId, int userId, String userRole, int newStatusId, String comments) throws SQLException {
        
        // 1. Get Current Status of the Complaint
        String getStatusSql = "SELECT status_id FROM Complaints WHERE complaint_id = ?";
        PreparedStatement getStatusStmt = conn.prepareStatement(getStatusSql);
        getStatusStmt.setInt(1, complaintId);
        ResultSet rs = getStatusStmt.executeQuery();
        
        if (!rs.next()) return false; // Complaint not found
        int currentStatusId = rs.getInt("status_id");

        // 2. Validate State Transition based on FSM rules
        String validateSql = "SELECT 1 FROM State_Transitions WHERE from_status_id = ? AND to_status_id = ? AND allowed_role = ?";
        PreparedStatement validateStmt = conn.prepareStatement(validateSql);
        validateStmt.setInt(1, currentStatusId);
        validateStmt.setInt(2, newStatusId);
        validateStmt.setString(3, userRole);
        ResultSet validateRs = validateStmt.executeQuery();

        if (!validateRs.next()) {
            System.out.println("❌ Invalid State Transition! User role '" + userRole + "' cannot move status from " + currentStatusId + " to " + newStatusId);
            return false;
        }

        // 3. Perform Update and Log (Inside a Transaction)
        conn.setAutoCommit(false);
        try {
            // Update Complaint
            String updateSql = "UPDATE Complaints SET status_id = ?, updated_at = CURRENT_TIMESTAMP WHERE complaint_id = ?";
            PreparedStatement updateStmt = conn.prepareStatement(updateSql);
            updateStmt.setInt(1, newStatusId);
            updateStmt.setInt(2, complaintId);
            updateStmt.executeUpdate();

            // Insert Audit Log
            String logSql = "INSERT INTO Complaint_History (complaint_id, changed_by, old_status_id, new_status_id, comments) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement logStmt = conn.prepareStatement(logSql);
            logStmt.setInt(1, complaintId);
            logStmt.setInt(2, userId);
            logStmt.setInt(3, currentStatusId);
            logStmt.setInt(4, newStatusId);
            logStmt.setString(5, comments);
            logStmt.executeUpdate();

            conn.commit();
            System.out.println("✅ Status updated successfully!");
            return true;
            
        } catch (SQLException e) {
            conn.rollback();
            throw e;
        } finally {
            conn.setAutoCommit(true);
        }
    }
}
