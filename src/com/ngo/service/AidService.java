package com.ngo.service;

import com.ngo.dao.AidDAO;

public class AidService {

    private AidDAO dao = new AidDAO();

    // ✅ Officer sends request (PENDING)
    public void createAidRequest(int beneficiaryId, String aidType, double amount, String requestedBy) {
        dao.insertAidRequest(beneficiaryId, aidType, amount, requestedBy);
    }

    // ✅ Manager approves request
    public void approveRequest(int requestId) {
        dao.approveAidRequest(requestId);
    }

    // ✅ Manager rejects request
    public void rejectRequest(int requestId) {
        dao.rejectAidRequest(requestId);
    }
}
