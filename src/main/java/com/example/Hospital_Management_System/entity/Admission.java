package com.example.Hospital_Management_System.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

/**
 * Entity representing a patient's admission to the hospital.
 * Records the patient, their assigned bed, and timing of admission/discharge.
 */
@Entity
@Table(name = "admissions")
public class Admission {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "patient_id", nullable = false)
    private Patients patient;

    @ManyToOne
    @JoinColumn(name = "bed_id", nullable = false)
    private Bed bed;

    @Column(nullable = false)
    private LocalDateTime admissionDate;

    private LocalDateTime dischargeDate;

    /** Default constructor for JPA. */
    public Admission() {}

    /**
     * Constructs a new Admission record.
     * @param patient The patient being admitted.
     * @param bed The bed assigned to the patient.
     * @param admissionDate The date and time of admission.
     */
    public Admission(Patients patient, Bed bed, LocalDateTime admissionDate) {
        this.patient = patient;
        this.bed = bed;
        this.admissionDate = admissionDate;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Patients getPatient() { return patient; }
    public void setPatient(Patients patient) { this.patient = patient; }
    public Bed getBed() { return bed; }
    public void setBed(Bed bed) { this.bed = bed; }
    public LocalDateTime getAdmissionDate() { return admissionDate; }
    public void setAdmissionDate(LocalDateTime admissionDate) { this.admissionDate = admissionDate; }
    public LocalDateTime getDischargeDate() { return dischargeDate; }
    public void setDischargeDate(LocalDateTime dischargeDate) { this.dischargeDate = dischargeDate; }
}
