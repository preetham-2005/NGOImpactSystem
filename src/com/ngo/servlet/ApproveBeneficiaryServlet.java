package com.ngo.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.ngo.util.DBConnection;
import com.ngo.util.RedirectUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/ApproveBeneficiaryServlet")
public class ApproveBeneficiaryServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("role") == null ||
            !"MANAGER".equalsIgnoreCase((String) session.getAttribute("role"))) {
            RedirectUtil.redirect(req, res, "/login.html");
            return;
        }

        int beneficiaryId = Integer.parseInt(req.getParameter("beneficiary_id"));
        String action = req.getParameter("action");
        String newStatus = "APPROVE".equalsIgnoreCase(action) ? "APPROVED" : "REJECTED";

        String sql = "UPDATE beneficiaries SET status = ? WHERE beneficiary_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, newStatus);
            ps.setInt(2, beneficiaryId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        RedirectUtil.redirect(req, res, "/pages/manager/approve_aid.jsp?msg=beneficiary_updated");
    }
}
