package com.ngo.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

import com.ngo.service.ImpactService;
import com.ngo.service.BeneficiaryService;
import com.ngo.util.EmailUtil;
import com.ngo.util.RedirectUtil;

public class PostAidImpactServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("role") == null) {
            RedirectUtil.redirect(req, res, "/login.html");
            return;
        }

        int beneficiaryId = Integer.parseInt(req.getParameter("beneficiary_id"));
        double incomeAfter = Double.parseDouble(req.getParameter("income_after"));
        String employed = req.getParameter("employed");
        String struggling = req.getParameter("struggling");

        // ✅ Save impact in DB
        new ImpactService().updateImpact(beneficiaryId, incomeAfter, employed, struggling);

        // ✅ Fetch email from DB
        String email = new BeneficiaryService().getBeneficiaryEmail(beneficiaryId);

        // ✅ Send email only if email exists
        if (email != null && !email.trim().isEmpty()) {

            String message =
                    "Hello,\n\nYour post-aid impact has been updated successfully.\n\n" +
                    "Income After Aid: " + incomeAfter +
                    "\nEmployment Improved: " + employed +
                    "\nStill Struggling: " + struggling +
                    "\n\nThank you.\nNGO Impact System";

            EmailUtil.sendEmail(email, "Impact Updated", message);
        }

        RedirectUtil.redirect(req, res, "/pages/officers/officer_dashboard.html");
    }
}
