package com.ngo.model;

import java.sql.Date;

public class AidRequest {
    private int requestId;
    private int beneficiaryId;
    private String aidType;
    private double amount;
    private Date requestDate;
    private String requestedBy;
    private String status;

    public int getRequestId() {
        return requestId;
    }
    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }

    public int getBeneficiaryId() {
        return beneficiaryId;
    }
    public void setBeneficiaryId(int beneficiaryId) {
        this.beneficiaryId = beneficiaryId;
    }

    public String getAidType() {
        return aidType;
    }
    public void setAidType(String aidType) {
        this.aidType = aidType;
    }

    public double getAmount() {
        return amount;
    }
    public void setAmount(double amount) {
        this.amount = amount;
    }

    public Date getRequestDate() {
        return requestDate;
    }
    public void setRequestDate(Date requestDate) {
        this.requestDate = requestDate;
    }

    public String getRequestedBy() {
        return requestedBy;
    }
    public void setRequestedBy(String requestedBy) {
        this.requestedBy = requestedBy;
    }

    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }
}
