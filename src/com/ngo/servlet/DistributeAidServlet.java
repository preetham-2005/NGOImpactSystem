package com.ngo.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import com.ngo.service.AidService;
import com.ngo.service.BeneficiaryService;
import com.ngo.util.EmailUtil;
import com.ngo.util.RedirectUtil;

public class DistributeAidServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("role") == null) {
            RedirectUtil.redirect(req, res, "/login.html");
            return;
        }

        int beneficiaryId = Integer.parseInt(req.getParameter("beneficiary_id"));
        String aidType = req.getParameter("aid_type");
        double amount = Double.parseDouble(req.getParameter("amount"));
        String date = req.getParameter("date");

        // ✅ Save distribution in DB
        new AidService().distribute(beneficiaryId, aidType, amount, date);

        // ✅ Fetch beneficiary email from DB (CORRECT WAY)
        BeneficiaryService bs = new BeneficiaryService();
        String email = bs.getBeneficiaryEmail(beneficiaryId);

        // ✅ Send email only if email exists
        if (email != null && !email.trim().isEmpty()) {
            String msg = "Hello,\n\nYour aid has been distributed successfully.\n\n" +
                    "Aid Type: " + aidType +
                    "\nAmount: " + amount +
                    "\nDate: " + date +
                    "\n\nThank you.\nNGO Impact System";

            EmailUtil.sendEmail(email, "Aid Distributed Successfully", msg);
        }

        RedirectUtil.redirect(req, res, "/pages/officers/officer_dashboard.html");
    }
}
