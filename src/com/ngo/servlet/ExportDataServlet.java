package com.ngo.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

import com.ngo.dao.ExportDAO;
import com.ngo.model.User;
import com.ngo.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ExportDataServlet")
public class ExportDataServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String exportType = request.getParameter("type");
        if (exportType == null) {
            exportType = "beneficiaries";
        }
        export(response, exportType);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String exportType = request.getParameter("type");
        if (exportType == null) {
            exportType = "beneficiaries";
        }
        export(response, exportType);
    }

    private void export(HttpServletResponse response, String exportType) throws IOException {
        response.setContentType("text/csv;charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=NGO_Export.csv");

        PrintWriter out = response.getWriter();

        try {
            if ("beneficiaries".equals(exportType)) {
                exportBeneficiaries(out);
            } else if ("aid_requests".equals(exportType)) {
                exportAidRequests(out);
            } else if ("impact_reports".equals(exportType)) {
                exportImpactReports(out);
            } else if ("analytics".equals(exportType)) {
                exportAnalytics(out);
            } else {
                exportAll(out);
            }
        } catch (Exception e) {
            out.println("ERROR: " + e.getMessage());
            e.printStackTrace();
        }

        out.flush();
        out.close();
    }

    private void exportBeneficiaries(PrintWriter out) throws Exception {
        out.println("Beneficiary ID,Name,Region ID,Program ID,Income Before,Email");

        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT beneficiary_id, name, region_id, program_id, income_before, email FROM beneficiaries";
            try (PreparedStatement ps = con.prepareStatement(sql);
                    ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    out.println(rs.getInt("beneficiary_id") + "," +
                            rs.getString("name") + "," +
                            rs.getInt("region_id") + "," +
                            rs.getInt("program_id") + "," +
                            rs.getDouble("income_before") + "," +
                            rs.getString("email"));
                }
            }
        }
    }

    private void exportAidRequests(PrintWriter out) throws Exception {
        out.println("Aid ID,Beneficiary ID,Aid Type,Amount,Status,Request Date,Approval Date");

        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT aid_id, beneficiary_id, aid_type, amount, status, request_date, approval_date FROM aid_requests";
            try (PreparedStatement ps = con.prepareStatement(sql);
                    ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    out.println(rs.getInt("aid_id") + "," +
                            rs.getInt("beneficiary_id") + "," +
                            rs.getString("aid_type") + "," +
                            rs.getDouble("amount") + "," +
                            rs.getString("status") + "," +
                            rs.getString("request_date") + "," +
                            rs.getString("approval_date"));
                }
            }
        }
    }

    private void exportImpactReports(PrintWriter out) throws Exception {
        out.println("Report ID,Beneficiary ID,Income After,Employment Status,Education Level,Report Date");

        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT report_id, beneficiary_id, income_after, employed, education, report_date FROM impact_reports";
            try (PreparedStatement ps = con.prepareStatement(sql);
                    ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    out.println(rs.getInt("report_id") + "," +
                            rs.getInt("beneficiary_id") + "," +
                            rs.getDouble("income_after") + "," +
                            rs.getString("employed") + "," +
                            rs.getString("education") + "," +
                            rs.getString("report_date"));
                }
            }
        }
    }

    private void exportAnalytics(PrintWriter out) throws Exception {
        out.println("Beneficiary ID,Name,Aid Type,Amount,Income After,Employment");

        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT beneficiary_id, name, aid_type, amount, income_after, employed FROM analytics_data";
            try (PreparedStatement ps = con.prepareStatement(sql);
                    ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    out.println(rs.getInt("beneficiary_id") + "," +
                            rs.getString("name") + "," +
                            rs.getString("aid_type") + "," +
                            rs.getDouble("amount") + "," +
                            rs.getDouble("income_after") + "," +
                            rs.getString("employed"));
                }
            }
        }
    }

    private void exportAll(PrintWriter out) throws Exception {
        // Export all data sections
        out.println("=== BENEFICIARIES ===");
        exportBeneficiaries(out);

        out.println();
        out.println("=== AID REQUESTS ===");
        exportAidRequests(out);

        out.println();
        out.println("=== IMPACT REPORTS ===");
        exportImpactReports(out);

        out.println();
        out.println("=== ANALYTICS ===");
        exportAnalytics(out);
    }
}
