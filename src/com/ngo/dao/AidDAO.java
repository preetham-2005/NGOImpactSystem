package com.ngo.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.ngo.model.AidRequest;
import com.ngo.util.DBConnection;

public class AidDAO {

    // ✅ Insert Aid Request (PENDING)
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

    // ✅ Get all PENDING requests for manager
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

    // ✅ Approve request
    public void approveAidRequest(int requestId) {

        String sql = "UPDATE aid_requests SET status='APPROVED' WHERE request_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, requestId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ✅ Reject request
    public void rejectAidRequest(int requestId) {

        String sql = "UPDATE aid_requests SET status='REJECTED' WHERE request_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, requestId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
