package com.ngo.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import com.ngo.model.ImpactReport;
import com.ngo.util.DBConnection;

public class ImpactDAO {

    public ArrayList<ImpactReport> getAllImpactReports() {

        ArrayList<ImpactReport> list = new ArrayList<>();

        String sql = "SELECT p.impact_id, b.name, a.aid_type, a.amount, b.income_before, " +
                     "p.income_after, p.employment_status, p.remarks, p.updated_by, p.impact_date " +
                     "FROM post_aid_impact p " +
                     "JOIN beneficiaries b ON p.beneficiary_id = b.beneficiary_id " +
                     "LEFT JOIN aid_distribution a ON a.beneficiary_id = b.beneficiary_id " +
                     "ORDER BY p.impact_date DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ImpactReport r = new ImpactReport();

                r.setImpactId(rs.getInt("impact_id"));
                r.setBeneficiaryName(rs.getString("name"));
                r.setAidType(rs.getString("aid_type"));
                r.setAmount(rs.getDouble("amount"));
                r.setIncomeBefore(rs.getDouble("income_before"));
                r.setIncomeAfter(rs.getDouble("income_after"));
                r.setEmploymentStatus(rs.getString("employment_status"));
                r.setRemarks(rs.getString("remarks"));
                r.setUpdatedBy(rs.getString("updated_by"));
                r.setImpactDate(rs.getString("impact_date"));

                list.add(r);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
