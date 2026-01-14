package com.ngo.model;

public class PostAidImpact {

    private int beneficiaryId;
    private double incomeAfter;
    private String employed;
    private String struggling;

    // ✅ Default Constructor
    public PostAidImpact() {}

    // ✅ Parameterized Constructor
    public PostAidImpact(int beneficiaryId, double incomeAfter, String employed, String struggling) {
        this.beneficiaryId = beneficiaryId;
        this.incomeAfter = incomeAfter;
        this.employed = employed;
        this.struggling = struggling;
    }

    // ✅ Getters and Setters
    public int getBeneficiaryId() {
        return beneficiaryId;
    }

    public void setBeneficiaryId(int beneficiaryId) {
        this.beneficiaryId = beneficiaryId;
    }

    public double getIncomeAfter() {
        return incomeAfter;
    }

    public void setIncomeAfter(double incomeAfter) {
        this.incomeAfter = incomeAfter;
    }

    public String getEmployed() {
        return employed;
    }

    public void setEmployed(String employed) {
        this.employed = employed;
    }

    public String getStruggling() {
        return struggling;
    }

    public void setStruggling(String struggling) {
        this.struggling = struggling;
    }

    // ✅ Optional toString()
    @Override
    public String toString() {
        return "PostAidImpact{" +
                "beneficiaryId=" + beneficiaryId +
                ", incomeAfter=" + incomeAfter +
                ", employed='" + employed + '\'' +
                ", struggling='" + struggling + '\'' +
                '}';
    }
}
