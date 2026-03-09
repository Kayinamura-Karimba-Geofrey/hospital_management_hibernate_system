package com.example.Hospital_Management_System.entity;

import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Entity representing a member of the nursing staff.
 * Contains contact info and associations with departments, patients, and appointments.
 */
@Entity
public class Nurses {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String name;
    private String email;

    @ManyToOne
    @JoinColumn(name = "department_id")
    private Department department;


    @OneToMany(mappedBy = "nurse", cascade = CascadeType.ALL)
    private List<Patients> patients = new ArrayList<>();


    @OneToMany(mappedBy = "nurse", cascade = CascadeType.ALL)
    private List<Appointments> appointments = new ArrayList<>();


    /** Default constructor for JPA. */
    public Nurses() {}

    /**
     * Constructs a new Nurse entry.
     * @param name The full name of the nurse.
     * @param department The department the nurse is assigned to.
     */
    public Nurses(String name, Department department) {
        this.name = name;
        this.department = department;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Department getDepartment() {
        return department;
    }

    public void setDepartment(Department department) {
        this.department = department;
    }

    public List<Patients> getPatients() {
        return patients;
    }

    public void setPatients(List<Patients> patients) {
        this.patients = patients;
    }

    public List<Appointments> getAppointments() {
        return appointments;
    }

    public void setAppointments(List<Appointments> appointments) {
        this.appointments = appointments;
    }

    @Override
    public String toString() {
        return "Nurses{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", department='" + department + '\'' +
                '}';
    }
}
