package com.example.Hospital_Management_System.entity;

import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Entity representing a hospital department.
 * Departments are used to categorize doctors and organize hospital locations.
 */
@Entity
@Table(name = "departments")
public class Department {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private String location;

    @OneToMany(mappedBy = "department", cascade = CascadeType.ALL)
    private List<Doctors> doctors = new ArrayList<>();

    /** Default constructor for JPA. */
    public Department() {}

    /**
     * Constructs a new Department.
     * @param name The name of the department (e.g., Cardiology).
     * @param location The physical location or wing in the hospital.
     */
    public Department(String name, String location) {
        this.name = name;
        this.location = location;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public List<Doctors> getDoctors() { return doctors; }
    public void setDoctors(List<Doctors> doctors) { this.doctors = doctors; }
}
