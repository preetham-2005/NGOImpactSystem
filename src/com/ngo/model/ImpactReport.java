package com.ngo.model;

public class ImpactReport {

    private int impactId;
    private String beneficiaryName;
    private String aidType;
    private double amount;
    private double incomeBefore;
    private double incomeAfter;
    private String employmentStatus;
    private String remarks;
    private String updatedBy;
    private String impactDate;

    public int getImpactId() { return impactId; }
    public void setImpactId(int impactId) { this.impactId = impactId; }

    public String getBeneficiaryName() { return beneficiaryName; }
    public void setBeneficiaryName(String beneficiaryName) { this.beneficiaryName = beneficiaryName; }

    public String getAidType() { return aidType; }
    public void setAidType(String aidType) { this.aidType = aidType; }

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    public double getIncomeBefore() { return incomeBefore; }
    public void setIncomeBefore(double incomeBefore) { this.incomeBefore = incomeBefore; }

    public double getIncomeAfter() { return incomeAfter; }
    public void setIncomeAfter(double incomeAfter) { this.incomeAfter = incomeAfter; }

    public String getEmploymentStatus() { return employmentStatus; }
    public void setEmploymentStatus(String employmentStatus) { this.employmentStatus = employmentStatus; }

    public String getRemarks() { return remarks; }
    public void setRemarks(String remarks) { this.remarks = remarks; }

    public String getUpdatedBy() { return updatedBy; }
    public void setUpdatedBy(String updatedBy) { this.updatedBy = updatedBy; }

    public String getImpactDate() { return impactDate; }
    public void setImpactDate(String impactDate) { this.impactDate = impactDate; }
}
