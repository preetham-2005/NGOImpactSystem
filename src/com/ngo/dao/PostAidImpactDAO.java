package com.ngo.dao;

import java.sql.*;
import com.ngo.util.DBConnection;

public class PostAidImpactDAO {

    public void updateImpact(int beneficiaryId, double incomeAfter,
                             String employed, String struggling) {

        try (Connection con = DBConnection.getConnection()) {
            String sql =
                "INSERT INTO post_aid_impact(beneficiary_id,income_after,employed,struggling) " +
                "VALUES(?,?,?,?)";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, beneficiaryId);
            ps.setDouble(2, incomeAfter);
            ps.setString(3, employed);
            ps.setString(4, struggling);

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
