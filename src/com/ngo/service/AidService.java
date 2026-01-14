package com.ngo.service;

import com.ngo.dao.AidDistributionDAO;

public class AidService {

    public void distribute(int beneficiaryId, String type,
                           double amount, String date) {

        new AidDistributionDAO().distributeAid(beneficiaryId, type, amount, date);
    }
}
