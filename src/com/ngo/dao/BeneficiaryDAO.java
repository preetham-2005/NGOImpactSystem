package com.ngo.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.ngo.model.Beneficiary;
import com.ngo.util.DBConnection;

public class BeneficiaryDAO {

    // ✅ 1) Add Beneficiary
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

    // ✅ 2) Get Total Beneficiaries (IMPORTANT for Analytics Dashboard)
    public int getTotalBeneficiaries() {
        String sql = "SELECT COUNT(*) FROM beneficiaries";
        int total = 0;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                total = rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }

    // ✅ 3) Get All Beneficiaries
    public List<Beneficiary> getAllBeneficiaries() {
        List<Beneficiary> list = new ArrayList<>();
        String sql = "SELECT beneficiary_id, name, region_id, program_id, income_before, email FROM beneficiaries";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Beneficiary b = new Beneficiary();
                b.setBeneficiaryId(rs.getInt("beneficiary_id"));
                b.setName(rs.getString("name"));
                b.setRegionId(rs.getInt("region_id"));
                b.setProgramId(rs.getInt("program_id"));
                b.setIncomeBefore(rs.getDouble("income_before"));
                b.setEmail(rs.getString("email"));
                list.add(b);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ✅ 4) Get Beneficiary By ID
    public Beneficiary getBeneficiaryById(int beneficiaryId) {
        String sql = "SELECT beneficiary_id, name, region_id, program_id, income_before, email FROM beneficiaries WHERE beneficiary_id=?";
        Beneficiary b = null;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, beneficiaryId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    b = new Beneficiary();
                    b.setBeneficiaryId(rs.getInt("beneficiary_id"));
                    b.setName(rs.getString("name"));
                    b.setRegionId(rs.getInt("region_id"));
                    b.setProgramId(rs.getInt("program_id"));
                    b.setIncomeBefore(rs.getDouble("income_before"));
                    b.setEmail(rs.getString("email"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return b;
    }

    // ✅ 5) Get Beneficiary Email by ID
    public String getBeneficiaryEmailById(int beneficiaryId) {
        String sql = "SELECT email FROM beneficiaries WHERE beneficiary_id = ?";
        String email = null;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, beneficiaryId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    email = rs.getString("email");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return email;
    }

    // ✅ 6) Update Beneficiary
    public boolean updateBeneficiary(Beneficiary b) {
        String sql = "UPDATE beneficiaries SET name=?, region_id=?, program_id=?, income_before=?, email=? WHERE beneficiary_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, b.getName());
            ps.setInt(2, b.getRegionId());
            ps.setInt(3, b.getProgramId());
            ps.setDouble(4, b.getIncomeBefore());
            ps.setString(5, b.getEmail());
            ps.setInt(6, b.getBeneficiaryId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ✅ 7) Delete Beneficiary
    public boolean deleteBeneficiary(int beneficiaryId) {
        String sql = "DELETE FROM beneficiaries WHERE beneficiary_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, beneficiaryId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ✅ 8) Search Beneficiaries by Name
    public List<Beneficiary> searchBeneficiariesByName(String name) {
        List<Beneficiary> list = new ArrayList<>();
        String sql = "SELECT beneficiary_id, name, region_id, program_id, income_before, email " +
                     "FROM beneficiaries WHERE name LIKE ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, "%" + name + "%");

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Beneficiary b = new Beneficiary();
                    b.setBeneficiaryId(rs.getInt("beneficiary_id"));
                    b.setName(rs.getString("name"));
                    b.setRegionId(rs.getInt("region_id"));
                    b.setProgramId(rs.getInt("program_id"));
                    b.setIncomeBefore(rs.getDouble("income_before"));
                    b.setEmail(rs.getString("email"));
                    list.add(b);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ✅ 9) Get Beneficiaries by Region
    public List<Beneficiary> getBeneficiariesByRegion(int regionId) {
        List<Beneficiary> list = new ArrayList<>();
        String sql = "SELECT beneficiary_id, name, region_id, program_id, income_before, email " +
                     "FROM beneficiaries WHERE region_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, regionId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Beneficiary b = new Beneficiary();
                    b.setBeneficiaryId(rs.getInt("beneficiary_id"));
                    b.setName(rs.getString("name"));
                    b.setRegionId(rs.getInt("region_id"));
                    b.setProgramId(rs.getInt("program_id"));
                    b.setIncomeBefore(rs.getDouble("income_before"));
                    b.setEmail(rs.getString("email"));
                    list.add(b);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ✅ 10) Get Beneficiaries by Program
    public List<Beneficiary> getBeneficiariesByProgram(int programId) {
        List<Beneficiary> list = new ArrayList<>();
        String sql = "SELECT beneficiary_id, name, region_id, program_id, income_before, email " +
                     "FROM beneficiaries WHERE program_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, programId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Beneficiary b = new Beneficiary();
                    b.setBeneficiaryId(rs.getInt("beneficiary_id"));
                    b.setName(rs.getString("name"));
                    b.setRegionId(rs.getInt("region_id"));
                    b.setProgramId(rs.getInt("program_id"));
                    b.setIncomeBefore(rs.getDouble("income_before"));
                    b.setEmail(rs.getString("email"));
                    list.add(b);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
