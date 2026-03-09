package com.example.Hospital_Management_System.entity;

import jakarta.persistence.*;

/**
 * Entity representing a hospital bed.
 * Managed within a specific ward and tracks its current status (e.g., AVAILABLE).
 */
@Entity
@Table(name = "beds")
public class Bed {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String bedNumber;

    @Column(nullable = false)
    private String status; // AVAILABLE, OCCUPIED, CLEANING

    @ManyToOne
    @JoinColumn(name = "ward_id")
    private Ward ward;

    /** Default constructor for JPA. */
    public Bed() {}

    /**
     * Constructs a new Bed entry.
     * @param bedNumber The unique identifier for the bed in the ward.
     * @param status The current availability status.
     * @param ward The ward this bed belongs to.
     */
    public Bed(String bedNumber, String status, Ward ward) {
        this.bedNumber = bedNumber;
        this.status = status;
        this.ward = ward;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getBedNumber() { return bedNumber; }
    public void setBedNumber(String bedNumber) { this.bedNumber = bedNumber; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Ward getWard() { return ward; }
    public void setWard(Ward ward) { this.ward = ward; }
}
