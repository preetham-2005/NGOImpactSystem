package com.ngo.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;

import com.ngo.model.Beneficiary;
import com.ngo.util.DBConnection;

public class BeneficiaryDAO {

    // ================= CRUD OPERATIONS =================

    public boolean addBeneficiary(Beneficiary b) {
        String sql = "INSERT INTO beneficiaries (name, region_id, program_id, income_before, email) VALUES (?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, b.getName());
            ps.setInt(2, b.getRegionId());
            ps.setInt(3, b.getProgramId());
            ps.setDouble(4, b.getIncomeBefore());
            ps.setString(5, b.getEmail());

            return ps.executeUpdate() > 0;
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return false;
    }

    public int getTotalBeneficiaries() {
        String sql = "SELECT COUNT(*) FROM beneficiaries";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return 0;
    }

    // ================= ANALYTICS METHODS =================

    public Map<String, Integer> getBeneficiaryCountByRegion() {
        Map<String, Integer> map = new HashMap<>();
        String sql = "SELECT r.region_name, COUNT(b.beneficiary_id) " +
                     "FROM beneficiaries b JOIN regions r ON b.region_id = r.region_id " +
                     "GROUP BY r.region_name";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) map.put(rs.getString(1), rs.getInt(2));
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return map;
    }

    public Map<String, Integer> getBeneficiaryCountByProgram() {
        Map<String, Integer> map = new HashMap<>();
        String sql = "SELECT p.program_name, COUNT(b.beneficiary_id) " +
                     "FROM beneficiaries b JOIN programs p ON b.program_id = p.program_id " +
                     "GROUP BY p.program_name";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) map.put(rs.getString(1), rs.getInt(2));
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return map;
    }

    public double getTotalAidDistributed() {
        String sql = "SELECT SUM(amount) FROM aid_requests WHERE LOWER(status)='approved'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getDouble(1) : 0;
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return 0;
    }

    public Map<String, Integer> getEmploymentImpactStats() {
        Map<String, Integer> map = new HashMap<>();
        String sql = "SELECT employed, COUNT(*) FROM post_aid_impact GROUP BY employed";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) map.put(rs.getString(1), rs.getInt(2));
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return map;
    }

    public Map<String, Double> getRegionImprovementPercent() {
        Map<String, Double> map = new HashMap<>();
        String sql = "SELECT r.region_name, " +
                     "ROUND(SUM(CASE WHEN p.employed='YES' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) " +
                     "FROM post_aid_impact p " +
                     "JOIN beneficiaries b ON p.beneficiary_id=b.beneficiary_id " +
                     "JOIN regions r ON b.region_id=r.region_id " +
                     "GROUP BY r.region_name";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) map.put(rs.getString(1), rs.getDouble(2));
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return map;
    }

    // ================= 🔥 MISSING METHOD ADDED =================

    public String getBeneficiaryEmailById(int id) {
        String email = null;
        String sql = "SELECT email FROM beneficiaries WHERE beneficiary_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
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
