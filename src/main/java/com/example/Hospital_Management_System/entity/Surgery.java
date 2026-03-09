package com.example.Hospital_Management_System.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

/**
 * Entity representing a surgical procedure.
 * Schedules surgery in an operating theater with a surgeon and anesthetist.
 */
@Entity
@Table(name = "surgeries")
public class Surgery {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "patient_id", nullable = false)
    private Patients patient;

    @ManyToOne
    @JoinColumn(name = "surgeon_id", nullable = false)
    private Doctors surgeon;

    @ManyToOne
    @JoinColumn(name = "anesthetist_id")
    private Doctors anesthetist;

    @Column(nullable = false)
    private String otRoomName;

    @Column(nullable = false)
    private LocalDateTime surgeryDateTime;

    @Column(nullable = false)
    private Integer durationMinutes;

    private String equipment;

    /** Default constructor for JPA. */
    public Surgery() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Patients getPatient() { return patient; }
    public void setPatient(Patients patient) { this.patient = patient; }
    public Doctors getSurgeon() { return surgeon; }
    public void setSurgeon(Doctors surgeon) { this.surgeon = surgeon; }
    public Doctors getAnesthetist() { return anesthetist; }
    public void setAnesthetist(Doctors anesthetist) { this.anesthetist = anesthetist; }
    public String getOtRoomName() { return otRoomName; }
    public void setOtRoomName(String otRoomName) { this.otRoomName = otRoomName; }
    public LocalDateTime getSurgeryDateTime() { return surgeryDateTime; }
    public void setSurgeryDateTime(LocalDateTime surgeryDateTime) { this.surgeryDateTime = surgeryDateTime; }
    public Integer getDurationMinutes() { return durationMinutes; }
    public void setDurationMinutes(Integer durationMinutes) { this.durationMinutes = durationMinutes; }
    public String getEquipment() { return equipment; }
    public void setEquipment(String equipment) { this.equipment = equipment; }
}
