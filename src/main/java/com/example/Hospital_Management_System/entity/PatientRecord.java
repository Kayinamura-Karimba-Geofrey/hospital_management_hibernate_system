package com.example.Hospital_Management_System.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "patient_records")
public class PatientRecord {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @OneToOne
    @JoinColumn(name = "patient_id")
    private Patients patient;

    @Column(columnDefinition = "TEXT")
    private String medicalHistory;

    @Column(columnDefinition = "TEXT")
    private String allergies;

    private String bloodPressure;
    private int heartRate;
    private double temperature;

    @Column(columnDefinition = "TEXT")
    private String immunizations;

    private LocalDateTime lastUpdated;

    public PatientRecord() {}

    public PatientRecord(Patients patient) {
        this.patient = patient;
        this.lastUpdated = LocalDateTime.now();
    }

    @PreUpdate
    @PrePersist
    public void onUpdate() {
        this.lastUpdated = LocalDateTime.now();
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Patients getPatient() { return patient; }
    public void setPatient(Patients patient) { this.patient = patient; }

    public String getMedicalHistory() { return medicalHistory; }
    public void setMedicalHistory(String medicalHistory) { this.medicalHistory = medicalHistory; }

    public String getAllergies() { return allergies; }
    public void setAllergies(String allergies) { this.allergies = allergies; }

    public String getBloodPressure() { return bloodPressure; }
    public void setBloodPressure(String bloodPressure) { this.bloodPressure = bloodPressure; }

    public int getHeartRate() { return heartRate; }
    public void setHeartRate(int heartRate) { this.heartRate = heartRate; }

    public double getTemperature() { return temperature; }
    public void setTemperature(double temperature) { this.temperature = temperature; }

    public String getImmunizations() { return immunizations; }
    public void setImmunizations(String immunizations) { this.immunizations = immunizations; }

    public LocalDateTime getLastUpdated() { return lastUpdated; }
    public void setLastUpdated(LocalDateTime lastUpdated) { this.lastUpdated = lastUpdated; }
}
