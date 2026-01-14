package com.ngo.service;

import com.ngo.dao.BeneficiaryDAO;

public class BeneficiaryService {

    private BeneficiaryDAO dao = new BeneficiaryDAO();

    public void registerBeneficiary(String name, int regionId,
                                    int programId, double income, String email) {
        dao.addBeneficiary(name, regionId, programId, income, email);
    }

    // ✅ get email by id
    public String getBeneficiaryEmail(int beneficiaryId) {
        return dao.getBeneficiaryEmailById(beneficiaryId);
    }
}
