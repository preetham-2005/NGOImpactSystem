package com.ngo.dao;

import java.sql.*;
import com.ngo.util.DBConnection;

public class BeneficiaryDAO {

    // ✅ Add Beneficiary
    public void addBeneficiary(String name, int regionId, int programId,
                               double incomeBefore, String email) {

        try (Connection con = DBConnection.getConnection()) {

            String sql =
                "INSERT INTO beneficiaries(name,region_id,program_id,income_before,email,status) " +
                "VALUES(?,?,?,?,?,'PENDING')";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setInt(2, regionId);
            ps.setInt(3, programId);
            ps.setDouble(4, incomeBefore);
            ps.setString(5, email);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ✅ Fetch Beneficiary Email (IMPORTANT FOR REAL EMAIL NOTIFICATION)
    public String getBeneficiaryEmailById(int beneficiaryId) {

        String email = null;

        try (Connection con = DBConnection.getConnection()) {

            String sql = "SELECT email FROM beneficiaries WHERE beneficiary_id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, beneficiaryId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                email = rs.getString("email");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return email;
    }
}
