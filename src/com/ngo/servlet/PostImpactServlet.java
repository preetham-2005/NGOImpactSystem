package com.ngo.servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.ngo.dao.PostImpactDAO;

@WebServlet("/PostImpactServlet")
public class PostImpactServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("role") == null) {
            res.sendRedirect(req.getContextPath() + "/login.html");
            return;
        }

        try {
            int beneficiaryId = Integer.parseInt(req.getParameter("beneficiary_id"));
            double incomeAfter = Double.parseDouble(req.getParameter("income_after"));
            String employed = req.getParameter("employed");
            String struggling = req.getParameter("struggling");

            String updatedBy = session.getAttribute("role").toString(); // officer role / username

            PostImpactDAO dao = new PostImpactDAO();
            dao.insertImpact(beneficiaryId, incomeAfter, employed, struggling, updatedBy);

            res.sendRedirect(req.getContextPath() + "/pages/officers/officer_dashboard.html");

        } catch (Exception e) {
            e.printStackTrace();
            res.getWriter().println("❌ Error: " + e.getMessage());
        }
    }
}
