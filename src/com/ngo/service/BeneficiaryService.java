package com.ngo.service;

import com.ngo.dao.BeneficiaryDAO;
import com.ngo.model.Beneficiary;

public class BeneficiaryService {

    private BeneficiaryDAO dao = new BeneficiaryDAO();

    public void registerBeneficiary(String name, int regionId,
            int programId, double income, String email) {
        Beneficiary b = new Beneficiary();
        b.setName(name);
        b.setRegionId(regionId);
        b.setProgramId(programId);
        b.setIncomeBefore(income);
        b.setEmail(email);
        dao.addBeneficiary(b);
    }

    // ✅ get email by id
    public String getBeneficiaryEmail(int beneficiaryId) {
        return dao.getBeneficiaryEmailById(beneficiaryId);
    }
}
