package com.ngo.servlet;

import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import com.ngo.util.EmailUtil;

@WebServlet("/SendReportServlet")
public class SendReportServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");

        // Validate email parameter
        if (email == null || email.trim().isEmpty()) {
            response.sendRedirect("pages/admin/reports.jsp?mail=error&reason=no_email");
            return;
        }

        String totalBeneficiaries = request.getParameter("totalBeneficiaries");
        String totalAided = request.getParameter("totalAided");
        String improved = request.getParameter("improved");
        String impact = request.getParameter("impact");

        // Validate report parameters
        if (totalBeneficiaries == null || totalAided == null || improved == null || impact == null) {
            response.sendRedirect("pages/admin/reports.jsp?mail=error&reason=missing_data");
            return;
        }

        String content = "<h2>NGO Impact Summary</h2>" +
                "<p>Total Beneficiaries: " + totalBeneficiaries + "</p>" +
                "<p>Beneficiaries Aided: " + totalAided + "</p>" +
                "<p>Improved After Aid: " + improved + "</p>" +
                "<p>Impact Percentage: " + impact + "%</p>";

        try {
            EmailUtil.sendReport(email, content);
            response.sendRedirect("pages/admin/reports.jsp?mail=success");
        } catch (Exception e) {
            System.err.println("[ERROR] Failed to send report email to " + email + ": " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("pages/admin/reports.jsp?mail=error&reason=send_failed");
        }
    }
}
