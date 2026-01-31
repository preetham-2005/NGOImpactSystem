package com.ngo.dao;

import java.sql.*;
import java.util.*;
import com.ngo.model.AidRequest;
import com.ngo.util.DBConnection;

public class AidDAO {

    // ===============================
    // Officer creates aid request
    // ===============================
    public void insertAidRequest(int beneficiaryId, String aidType, double amount, String requestedBy) {

        String sql = "INSERT INTO aid_requests (beneficiary_id, aid_type, amount, request_date, requested_by, status) "
                   + "VALUES (?,?,?,CURDATE(),?, 'PENDING')";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, beneficiaryId);
            ps.setString(2, aidType);
            ps.setDouble(3, amount);
            ps.setString(4, requestedBy);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ===============================
    // 🔥 APPROVE REQUEST + PUSH TO ANALYTICS
    // ===============================
    public boolean approveAidRequest(int requestId) {

        Connection con = null;

        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false); // Transaction start

            // 1️⃣ Update request status
            String updateSql = "UPDATE aid_requests SET status='APPROVED' WHERE request_id=?";
            PreparedStatement ps1 = con.prepareStatement(updateSql);
            ps1.setInt(1, requestId);
            int updated = ps1.executeUpdate();

            if (updated == 0) {
                con.rollback();
                return false;
            }

            // 2️⃣ Fetch beneficiary + aid details
            String fetchSql =
                "SELECT b.beneficiary_id, b.name, ar.aid_type, ar.amount " +
                "FROM aid_requests ar " +
                "JOIN beneficiaries b ON ar.beneficiary_id = b.beneficiary_id " +
                "WHERE ar.request_id=?";

            PreparedStatement ps2 = con.prepareStatement(fetchSql);
            ps2.setInt(1, requestId);
            ResultSet rs = ps2.executeQuery();

            if (rs.next()) {

                int beneficiaryId = rs.getInt("beneficiary_id");
                String name = rs.getString("name");
                String aidType = rs.getString("aid_type");
                double amount = rs.getDouble("amount");

                // 3️⃣ Insert into analytics_data
                String insertSql =
                    "INSERT INTO analytics_data (beneficiary_id, name, aid_type, amount, income_after, employed) " +
                    "VALUES (?, ?, ?, ?, 0, 'NO')";

                PreparedStatement ps3 = con.prepareStatement(insertSql);
                ps3.setInt(1, beneficiaryId);
                ps3.setString(2, name);
                ps3.setString(3, aidType);
                ps3.setDouble(4, amount);
                ps3.executeUpdate();
            }

            con.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            try { if (con != null) con.rollback(); } catch (Exception ex) {}
        }
        return false;
    }

    // ===============================
    // Reject request
    // ===============================
    public boolean rejectAidRequest(int requestId) {

        String sql = "UPDATE aid_requests SET status='REJECTED' WHERE request_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, requestId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ===============================
    // Email helpers
    // ===============================
    public int getBeneficiaryIdByRequest(int requestId) {

        String sql = "SELECT beneficiary_id FROM aid_requests WHERE request_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, requestId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public double getAmountByRequest(int requestId) {

        String sql = "SELECT amount FROM aid_requests WHERE request_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, requestId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ===============================
    // Manager views
    // ===============================
    public List<AidRequest> getPendingRequests() {

        List<AidRequest> list = new ArrayList<>();
        String sql = "SELECT * FROM aid_requests WHERE status='PENDING' ORDER BY request_id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                AidRequest ar = new AidRequest();
                ar.setRequestId(rs.getInt("request_id"));
                ar.setBeneficiaryId(rs.getInt("beneficiary_id"));
                ar.setAidType(rs.getString("aid_type"));
                ar.setAmount(rs.getDouble("amount"));
                ar.setRequestDate(rs.getDate("request_date"));
                ar.setRequestedBy(rs.getString("requested_by"));
                ar.setStatus(rs.getString("status"));
                list.add(ar);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<AidRequest> getApprovedRequests() {

        List<AidRequest> list = new ArrayList<>();
        String sql = "SELECT * FROM aid_requests WHERE status='APPROVED' ORDER BY request_id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                AidRequest ar = new AidRequest();
                ar.setRequestId(rs.getInt("request_id"));
                ar.setBeneficiaryId(rs.getInt("beneficiary_id"));
                ar.setAidType(rs.getString("aid_type"));
                ar.setAmount(rs.getDouble("amount"));
                ar.setRequestDate(rs.getDate("request_date"));
                ar.setRequestedBy(rs.getString("requested_by"));
                ar.setStatus(rs.getString("status"));
                list.add(ar);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
