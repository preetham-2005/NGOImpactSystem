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
                
                // Synchronize denormalized analytics_data table with latest impact details
                String updateAnalyticsSql = "UPDATE analytics_data SET income_after = ?, employed = ? WHERE beneficiary_id = ?";
                try (PreparedStatement ps2 = con.prepareStatement(updateAnalyticsSql)) {
                    ps2.setDouble(1, incomeAfter);
                    ps2.setString(2, employed);
                    ps2.setInt(3, beneficiaryId);
                    ps2.executeUpdate();
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }
}
