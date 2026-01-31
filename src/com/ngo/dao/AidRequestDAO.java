package com.ngo.dao;

import java.sql.*;
import java.util.*;
import com.ngo.model.AidRequest;
import com.ngo.util.DBConnection;

public class AidRequestDAO {

    public List<AidRequest> getPendingRequests() {
        List<AidRequest> list = new ArrayList<>();
        String sql = "SELECT * FROM aid_requests WHERE status='PENDING'";

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

    public boolean updateStatus(int requestId, String status) {
        String sql = "UPDATE aid_requests SET status=? WHERE request_id=?";

        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, requestId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}
