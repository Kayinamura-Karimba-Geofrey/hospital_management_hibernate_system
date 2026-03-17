package com.example.Hospital_Management_System.entity;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalTime;

/**
 * Entity representing a medical appointment.
 * Links patients with doctors and optional nursing staff for scheduled visits.
 */
@Entity
public class Appointments {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "appointmentdate")
    private LocalDate appointmentDate;

    @Column(name = "appointmenttime")
    private LocalTime appointmentTime;

    @Column(name = "status", length = 50)
    private String status = "REQUESTED"; // Default to REQUESTED for new requests
    
    @Column(name = "rejection_reason", length = 500)
    private String rejectionReason;



    @ManyToOne
    @JoinColumn(name = "patient_id")
    private Patients patient;


    @ManyToOne
    @JoinColumn(name = "doctor_id")
    private Doctors doctor;

    @ManyToOne
    @JoinColumn(name = "nurse_id")
    private Nurses nurse;


    /** Default constructor for JPA. */
    public Appointments() {}

    /**
     * Constructs a new Appointment with specified timing.
     * @param appointmentDate The scheduled date.
     * @param appointmentTime The scheduled time.
     */
    public Appointments(LocalDate appointmentDate, LocalTime appointmentTime) {
        this.appointmentDate = appointmentDate;
        this.appointmentTime = appointmentTime;
    }

    
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Nurses getNurse() {
        return nurse;
    }

    public void setNurse(Nurses nurse) {
        this.nurse = nurse;
    }


    public LocalDate getAppointmentDate() { return appointmentDate; }
    public void setAppointmentDate(LocalDate appointmentDate) { this.appointmentDate = appointmentDate; }

    public LocalTime getAppointmentTime() { return appointmentTime; }
    public void setAppointmentTime(LocalTime appointmentTime) { this.appointmentTime = appointmentTime; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getRejectionReason() { return rejectionReason; }
    public void setRejectionReason(String rejectionReason) { this.rejectionReason = rejectionReason; }

    public Patients getPatient() { return patient; }
    public void setPatient(Patients patient) { this.patient = patient; }

    public Doctors getDoctor() { return doctor; }
    public void setDoctor(Doctors doctor) { this.doctor = doctor; }

    @Override
    public String toString() {
        return "Appointments{" +
                "id=" + id +
                ", appointmentDate=" + appointmentDate +
                ", appointmentTime=" + appointmentTime +
                '}';
    }
}
