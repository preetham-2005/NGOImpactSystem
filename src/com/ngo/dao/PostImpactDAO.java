package com.ngo.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;

import com.ngo.util.DBConnection;

public class PostImpactDAO {

    public void insertImpact(int beneficiaryId, double incomeAfter, String employed,
                             String struggling, String updatedBy) {

        String sql = "INSERT INTO post_aid_impact (beneficiary_id, income_after, employed, struggling, updated_by, date) "
                   + "VALUES (?, ?, ?, ?, ?, CURDATE())";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, beneficiaryId);
            ps.setDouble(2, incomeAfter);
            ps.setString(3, employed);
            ps.setString(4, struggling);
            ps.setString(5, updatedBy);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
