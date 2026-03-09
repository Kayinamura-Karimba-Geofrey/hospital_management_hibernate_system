package com.example.Hospital_Management_System.entity;

import jakarta.persistence.*;

/**
 * Entity representing patient insurance details.
 * Links a patient to their insurance provider and policy specifics.
 */
@Entity
@Table(name = "insurance_details")
public class Insurance {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @OneToOne
    @JoinColumn(name = "patient_id")
    private Patients patient;

    private String provider;
    private String policyNumber;
    private double coveragePercentage;

    public Insurance() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Patients getPatient() { return patient; }
    public void setPatient(Patients patient) { this.patient = patient; }

    public String getProvider() { return provider; }
    public void setProvider(String provider) { this.provider = provider; }

    public String getPolicyNumber() { return policyNumber; }
    public void setPolicyNumber(String policyNumber) { this.policyNumber = policyNumber; }

    public double getCoveragePercentage() { return coveragePercentage; }
    public void setCoveragePercentage(double coveragePercentage) { this.coveragePercentage = coveragePercentage; }
}
