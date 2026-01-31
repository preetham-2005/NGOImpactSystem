package com.ngo.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

import com.ngo.service.AidService;
import com.ngo.service.BeneficiaryService;
import com.ngo.util.EmailUtil;
import com.ngo.util.RedirectUtil;
@WebServlet("/DistributeAidServlet")
public class DistributeAidServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("role") == null) {
            RedirectUtil.redirect(req, res, "/login.html");
            return;
        }

        String requestedBy = (String) session.getAttribute("username");
        if (requestedBy == null) requestedBy = "officer1";

        int beneficiaryId = Integer.parseInt(req.getParameter("beneficiary_id"));
        String aidType = req.getParameter("aid_type");
        double amount = Double.parseDouble(req.getParameter("amount"));

        new AidService().createAidRequest(beneficiaryId, aidType, amount, requestedBy);

        BeneficiaryService bs = new BeneficiaryService();
        String email = bs.getBeneficiaryEmail(beneficiaryId);

        if (email != null && !email.trim().isEmpty()) {
            String msg = "Hello,\n\n" +
                    "A new aid request has been submitted and is pending approval.\n\n" +
                    "Aid Type: " + aidType +
                    "\nAmount: " + amount +
                    "\nStatus: PENDING\n\n" +
                    "Thank you.\nNGO Impact System";

            EmailUtil.sendEmail(email, "Aid Request Submitted", msg);
        }

        RedirectUtil.redirect(req, res,
                "/pages/officers/officer_dashboard.jsp?msg=aid_requested");
    }
}
