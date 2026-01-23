package com.ngo.model;

public class Beneficiary {

    private int beneficiaryId;
    private String name;
    private int regionId;
    private int programId;
    private double incomeBefore;
    private String email;

    public int getBeneficiaryId() { return beneficiaryId; }
    public void setBeneficiaryId(int beneficiaryId) { this.beneficiaryId = beneficiaryId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public int getRegionId() { return regionId; }
    public void setRegionId(int regionId) { this.regionId = regionId; }

    public int getProgramId() { return programId; }
    public void setProgramId(int programId) { this.programId = programId; }

    public double getIncomeBefore() { return incomeBefore; }
    public void setIncomeBefore(double incomeBefore) { this.incomeBefore = incomeBefore; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
}
