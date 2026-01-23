package com.ngo.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.ngo.util.DBConnection;

public class ExportService {

    public String exportAllDataCSV() {

        StringBuilder csv = new StringBuilder();

        try (Connection con = DBConnection.getConnection()) {

            // ✅ Section 1: Beneficiaries
            csv.append("=== BENEFICIARIES DATA ===\n");
            csv.append("Beneficiary ID,Name,Region ID,Program ID,Income Before,Email\n");

            String bSql = "SELECT beneficiary_id, name, region_id, program_id, income_before, email FROM beneficiaries";
            try (PreparedStatement ps = con.prepareStatement(bSql);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    csv.append(rs.getInt("beneficiary_id")).append(",")
                       .append(rs.getString("name")).append(",")
                       .append(rs.getInt("region_id")).append(",")
                       .append(rs.getInt("program_id")).append(",")
                       .append(rs.getDouble("income_before")).append(",")
                       .append(rs.getString("email")).append("\n");
                }
            }

            csv.append("\n");

            // ✅ Section 2: Analytics / Aid + Impact (analytics_data)
            csv.append("=== AID + IMPACT ANALYTICS DATA ===\n");
            csv.append("Beneficiary ID,Name,Aid Type,Amount,Income After,Employment\n");

            String aSql = "SELECT beneficiary_id, name, aid_type, amount, income_after, employed FROM analytics_data";
            try (PreparedStatement ps = con.prepareStatement(aSql);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    csv.append(rs.getInt("beneficiary_id")).append(",")
                       .append(rs.getString("name")).append(",")
                       .append(rs.getString("aid_type")).append(",")
                       .append(rs.getInt("amount")).append(",")
                       .append(rs.getInt("income_after")).append(",")
                       .append(rs.getString("employed")).append("\n");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            csv.append("ERROR: ").append(e.getMessage());
        }

        return csv.toString();
    }
}
