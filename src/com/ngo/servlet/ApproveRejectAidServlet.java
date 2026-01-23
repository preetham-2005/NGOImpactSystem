package com.ngo.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.ngo.util.DBConnection;

@WebServlet("/ApproveRejectAidServlet")
public class ApproveRejectAidServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        int requestId = Integer.parseInt(req.getParameter("request_id"));
        String action = req.getParameter("action"); // APPROVED or REJECTED

        String sql = "UPDATE aid_requests SET status=? WHERE request_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, action);
            ps.setInt(2, requestId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        res.sendRedirect(req.getContextPath() + "/pages/manager/manager_dashboard.html");
    }
}
