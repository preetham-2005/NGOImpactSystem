package com.ngo.servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.ngo.dao.BeneficiaryDAO;
import com.ngo.model.Beneficiary;

@WebServlet("/AddBeneficiaryServlet")
public class AddBeneficiaryServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        try {

            String name = req.getParameter("name");
            int regionId = Integer.parseInt(req.getParameter("region_id"));
            int programId = Integer.parseInt(req.getParameter("program_id"));
            double incomeBefore = Double.parseDouble(req.getParameter("income_before"));
            String email = req.getParameter("email");

            // ✅ Create Beneficiary object
            Beneficiary b = new Beneficiary();
            b.setName(name);
            b.setRegionId(regionId);
            b.setProgramId(programId);
            b.setIncomeBefore(incomeBefore);
            b.setEmail(email);

            // ✅ call DAO method
            boolean status = new BeneficiaryDAO().addBeneficiary(b);

            if (status) {
                res.sendRedirect(req.getContextPath() + "/pages/officers/officer_dashboard.html");
            } else {
                res.getWriter().println("❌ Beneficiary insert failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            res.getWriter().println("❌ Error: " + e.getMessage());
        }
    }
}
