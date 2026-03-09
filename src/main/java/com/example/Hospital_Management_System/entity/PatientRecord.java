package com.example.Hospital_Management_System.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

/**
 * Entity representing a patient's comprehensive medical record.
 * Stores history, allergies, vitals (blood pressure, temperature), and immunizations.
 */
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

    @Column(name = "file_path")
    private String filePath;

    private LocalDateTime lastUpdated;

    /** Default constructor for JPA. */
    public PatientRecord() {}

    /**
     * Constructs a new PatientRecord for a specific patient.
     * @param patient The patient this record belongs to.
     */
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

    public String getFilePath() { return filePath; }
    public void setFilePath(String filePath) { this.filePath = filePath; }

    public LocalDateTime getLastUpdated() { return lastUpdated; }
    public void setLastUpdated(LocalDateTime lastUpdated) { this.lastUpdated = lastUpdated; }
}
