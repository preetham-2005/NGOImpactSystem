package com.ngo.service;

import com.ngo.dao.PostAidImpactDAO;

public class ImpactService {

    private PostAidImpactDAO dao = new PostAidImpactDAO();

    public boolean updateImpact(int beneficiaryId, double incomeAfter,
                                String employed, String struggling) {

        return dao.updateImpact(beneficiaryId, incomeAfter, employed, struggling);
    }
}