package com.ngo.model;

public class AidDistribution {

    private int beneficiaryId;
    private String aidType;
    private double amount;
    private String date;

    // ✅ Default Constructor
    public AidDistribution() {}

    // ✅ Parameterized Constructor
    public AidDistribution(int beneficiaryId, String aidType, double amount, String date) {
        this.beneficiaryId = beneficiaryId;
        this.aidType = aidType;
        this.amount = amount;
        this.date = date;
    }

    // ✅ Getters and Setters
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

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    // ✅ Optional toString
    @Override
    public String toString() {
        return "AidDistribution{" +
                "beneficiaryId=" + beneficiaryId +
                ", aidType='" + aidType + '\'' +
                ", amount=" + amount +
                ", date='" + date + '\'' +
                '}';
    }
}
