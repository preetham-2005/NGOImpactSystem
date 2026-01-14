package com.ngo.dao;

import java.sql.*;
import com.ngo.util.DBConnection;

public class AidDistributionDAO {

    public void distributeAid(int beneficiaryId, String aidType,
            double amount, String date) {

        try (Connection con = DBConnection.getConnection()) {
            String sql = "INSERT INTO aid_distribution(beneficiary_id,aid_type,amount,date) VALUES(?,?,?,?)";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, beneficiaryId);
            ps.setString(2, aidType);
            ps.setDouble(3, amount);
            ps.setString(4, date);

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
