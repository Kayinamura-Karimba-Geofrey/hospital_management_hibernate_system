package com.example.Hospital_Management_System.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "lab_tests")
public class LabTest {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne
    @JoinColumn(name = "patient_id")
    private Patients patient;

    @ManyToOne
    @JoinColumn(name = "doctor_id")
    private Doctors doctor;

    private String testName;
    private String status; // REQUESTED, COMPLETED
    private String resultFileUrl;
    
    @Column(columnDefinition = "TEXT")
    private String observations;
    
    private LocalDateTime requestedDate;
    private LocalDateTime completedDate;

    public LabTest() {
        this.status = "REQUESTED";
        this.requestedDate = LocalDateTime.now();
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Patients getPatient() { return patient; }
    public void setPatient(Patients patient) { this.patient = patient; }

    public Doctors getDoctor() { return doctor; }
    public void setDoctor(Doctors doctor) { this.doctor = doctor; }

    public String getTestName() { return testName; }
    public void setTestName(String testName) { this.testName = testName; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getResultFileUrl() { return resultFileUrl; }
    public void setResultFileUrl(String resultFileUrl) { this.resultFileUrl = resultFileUrl; }

    public String getObservations() { return observations; }
    public void setObservations(String observations) { this.observations = observations; }

    public LocalDateTime getRequestedDate() { return requestedDate; }
    public void setRequestedDate(LocalDateTime requestedDate) { this.requestedDate = requestedDate; }

    public LocalDateTime getCompletedDate() { return completedDate; }
    public void setCompletedDate(LocalDateTime completedDate) { this.completedDate = completedDate; }
}
