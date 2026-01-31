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

        String content = "<h2>NGO Impact Summary</h2>" +
                "<p>Total Beneficiaries: " + request.getParameter("totalBeneficiaries") + "</p>" +
                "<p>Beneficiaries Aided: " + request.getParameter("totalAided") + "</p>" +
                "<p>Improved After Aid: " + request.getParameter("improved") + "</p>" +
                "<p>Impact Percentage: " + request.getParameter("impact") + "%</p>";

        try {
            EmailUtil.sendReport(email, content);
            response.sendRedirect("pages/admin/reports.jsp?mail=success");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("pages/admin/reports.jsp?mail=error");
        }
    }
}
