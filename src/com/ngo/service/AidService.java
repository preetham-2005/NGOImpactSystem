package com.ngo.service;

import com.ngo.dao.AidDAO;
import com.ngo.util.EmailUtil;

public class AidService {

    private AidDAO dao = new AidDAO();
    private BeneficiaryService beneficiaryService = new BeneficiaryService();

    // ===============================
    // Officer sends request (PENDING)
    // ===============================
    public void createAidRequest(int beneficiaryId, String aidType, double amount, String requestedBy) {
        dao.insertAidRequest(beneficiaryId, aidType, amount, requestedBy);
    }

    // ===============================
    // 🔥 Manager approves request
    // ALSO updates analytics_data (handled in DAO)
    // ALSO sends email
    // ===============================
    public void approveRequest(int requestId) {

        boolean updated = dao.approveAidRequest(requestId); // updates + analytics insert

        if (updated) {

            int beneficiaryId = dao.getBeneficiaryIdByRequest(requestId);
            double amount = dao.getAmountByRequest(requestId);

            String email = beneficiaryService.getBeneficiaryEmail(beneficiaryId);

            if (email != null && !email.trim().isEmpty()) {

                String subject = "Aid Distributed Successfully";

                String body = "Hello,\n\n"
                        + "Your aid request has been APPROVED and the aid has been distributed.\n\n"
                        + "Amount: ₹" + amount + "\n"
                        + "Status: APPROVED\n\n"
                        + "Thank you.\nNGO Impact System";

                EmailUtil.sendEmail(email, subject, body);
            }
        }
    }

    // ===============================
    // Manager rejects request
    // ===============================
    public void rejectRequest(int requestId) {
        dao.rejectAidRequest(requestId);
    }

    // ===============================
    // Helper methods
    // ===============================
    public int getBeneficiaryIdByRequest(int requestId) {
        return dao.getBeneficiaryIdByRequest(requestId);
    }

    public double getAmountByRequest(int requestId) {
        return dao.getAmountByRequest(requestId);
    }
}
