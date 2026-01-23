package com.ngo.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.ngo.util.DBConnection;

@WebServlet("/AnalyticsServlet")
public class AnalyticsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        res.setContentType("application/json");
        res.setCharacterEncoding("UTF-8");

        StringBuilder json = new StringBuilder();

        int totalBeneficiaries = 0;

        try (Connection con = DBConnection.getConnection()) {

            // ✅ 1) Get total beneficiaries count from beneficiaries table
            String countSql = "SELECT COUNT(*) AS total FROM beneficiaries";
            try (PreparedStatement cps = con.prepareStatement(countSql);
                 ResultSet crs = cps.executeQuery()) {

                if (crs.next()) {
                    totalBeneficiaries = crs.getInt("total");
                }
            }

            // ✅ 2) Get analytics data
            String sql = "SELECT beneficiary_id, name, aid_type, amount, income_after, employed FROM analytics_data";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            json.append("{");
            json.append("\"totalBeneficiaries\":").append(totalBeneficiaries).append(",");
            json.append("\"data\":[");

            boolean first = true;

            while (rs.next()) {
                if (!first) json.append(",");
                first = false;

                json.append("{")
                    .append("\"id\":").append(rs.getInt("beneficiary_id")).append(",")
                    .append("\"name\":\"").append(rs.getString("name")).append("\",")
                    .append("\"aid\":\"").append(rs.getString("aid_type")).append("\",")
                    .append("\"amount\":").append(rs.getInt("amount")).append(",")
                    .append("\"income\":").append(rs.getInt("income_after")).append(",")
                    .append("\"employment\":\"").append(rs.getString("employed")).append("\"")
                    .append("}");
            }

            json.append("]}");

        } catch (Exception e) {
            e.printStackTrace();

            // ✅ return error response
            json.setLength(0);
            json.append("{\"error\":\"").append(e.getMessage()).append("\"}");
        }

        res.getWriter().print(json.toString());
    }
}
