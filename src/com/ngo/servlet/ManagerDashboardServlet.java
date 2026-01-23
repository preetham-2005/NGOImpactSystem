package com.ngo.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.ngo.util.DBConnection;

@WebServlet("/ManagerDashboardServlet")
public class ManagerDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        res.setContentType("application/json");
        PrintWriter out = res.getWriter();

        StringBuilder json = new StringBuilder();
        json.append("{\"requests\":[");

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "SELECT request_id, beneficiary_id, aid_type, amount, request_date, requested_by, status " +
                     "FROM aid_requests ORDER BY request_date DESC");
             ResultSet rs = ps.executeQuery()) {

            boolean first = true;
            while (rs.next()) {
                if (!first) json.append(",");
                first = false;

                json.append("{");
                json.append("\"request_id\":").append(rs.getInt("request_id")).append(",");
                json.append("\"beneficiary_id\":").append(rs.getInt("beneficiary_id")).append(",");
                json.append("\"aid_type\":\"").append(rs.getString("aid_type")).append("\",");
                json.append("\"amount\":").append(rs.getDouble("amount")).append(",");
                json.append("\"request_date\":\"").append(rs.getString("request_date")).append("\",");
                json.append("\"requested_by\":\"").append(rs.getString("requested_by")).append("\",");
                json.append("\"status\":\"").append(rs.getString("status")).append("\"");
                json.append("}");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        json.append("]}");
        out.print(json.toString());
        out.flush();
    }
}
