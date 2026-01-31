package com.ngo.servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.ngo.service.ImpactService;
import com.ngo.service.BeneficiaryService;
import com.ngo.util.EmailUtil;
import com.ngo.util.RedirectUtil;

@WebServlet("/PostAidImpactServlet")
public class PostAidImpactServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("role") == null) {
            RedirectUtil.redirect(req, res, "/login.html");
            return;
        }

        try {
            int beneficiaryId = Integer.parseInt(req.getParameter("beneficiary_id"));
            double incomeAfter = Double.parseDouble(req.getParameter("income_after"));
            String employed = req.getParameter("employed");
            String struggling = req.getParameter("struggling");

            // ✅ Save to DB
            boolean status = new ImpactService()
                    .updateImpact(beneficiaryId, incomeAfter, employed, struggling);

            if (status) {

                String email = new BeneficiaryService().getBeneficiaryEmail(beneficiaryId);

                if (email != null && !email.trim().isEmpty()) {
                    String message =
                            "Hello,\n\nYour post-aid impact has been updated successfully.\n\n" +
                            "Income After Aid: " + incomeAfter +
                            "\nEmployment Improved: " + employed +
                            "\nStill Struggling: " + struggling +
                            "\n\nThank you.\nNGO Impact System";

                    EmailUtil.sendEmail(email, "Impact Updated", message);
                }

                RedirectUtil.redirect(req, res,
                        "/pages/officers/officer_dashboard.jsp?msg=impact_success");

            } else {
                RedirectUtil.redirect(req, res,
                        "/pages/officers/post_impact.jsp?msg=fail");
            }

        } catch (Exception e) {
            e.printStackTrace();
            RedirectUtil.redirect(req, res,
                    "/pages/officers/post_impact.jsp?msg=fail");
        }
    }
}
