package com.example.Hospital_Management_System.entity;

import jakarta.persistence.*;
import java.util.List;

/**
 * Entity representing a hospital ward.
 * Grouping of beds for specific medical purposes (e.g., ICU, Pediatric).
 */
@Entity
@Table(name = "wards")
public class Ward {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private String type; // ICU, General, Pediatric, etc.

    @OneToMany(mappedBy = "ward", cascade = CascadeType.ALL)
    private List<Bed> beds;

    /** Default constructor for JPA. */
    public Ward() {}

    /**
     * Constructs a new Ward.
     * @param name The name of the ward.
     * @param type The functional type of the ward.
     */
    public Ward(String name, String type) {
        this.name = name;
        this.type = type;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public List<Bed> getBeds() { return beds; }
    public void setBeds(List<Bed> beds) { this.beds = beds; }
}
