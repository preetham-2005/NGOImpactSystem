package com.ngo.dao;

import java.sql.*;
import com.ngo.util.DBConnection;

public class PostAidImpactDAO {

    public boolean updateImpact(int beneficiaryId, double incomeAfter,
                                String employed, String struggling) {

        boolean status = false;

        try (Connection con = DBConnection.getConnection()) {

            String sql = "INSERT INTO post_aid_impact " +
                         "(beneficiary_id, income_after, employed, struggling) " +
                         "VALUES (?, ?, ?, ?)";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, beneficiaryId);
            ps.setDouble(2, incomeAfter);
            ps.setString(3, employed);
            ps.setString(4, struggling);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                status = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }
}
