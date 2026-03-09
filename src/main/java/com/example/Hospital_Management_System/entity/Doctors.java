package com.example.Hospital_Management_System.entity;

import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Entity representing a medical doctor.
 * Contains professional details, contact info, and associations with departments and patients.
 */
@Entity
public class Doctors {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String name;
    private String specialisation;
    private String email;
    private String phone;

    @ManyToOne
    @JoinColumn(name = "department_id")
    private Department department;


    @OneToMany(mappedBy = "doctor", cascade = CascadeType.ALL)
    private List<Patients> patients = new ArrayList<>();


    @OneToMany(mappedBy = "doctor", cascade = CascadeType.ALL)
    private List<Appointments> appointments = new ArrayList<>();

    /** Default constructor for JPA. */
    public Doctors() {}

    /**
     * Constructs a new Doctor entry.
     * @param name The full name of the doctor.
     * @param specialisation The doctor's area of medical expertise.
     */
    public Doctors(String name, String specialisation) {
        this.name = name;
        this.specialisation = specialisation;
    }


    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getSpecialisation() { return specialisation; }
    public void setSpecialisation(String specialisation) { this.specialisation = specialisation; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public Department getDepartment() { return department; }
    public void setDepartment(Department department) { this.department = department; }

    public List<Patients> getPatients() { return patients; }
    public void setPatients(List<Patients> patients) { this.patients = patients; }

    public List<Appointments> getAppointments() { return appointments; }
    public void setAppointments(List<Appointments> appointments) { this.appointments = appointments; }

    @Override
    public String toString() {
        return "Doctors{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", specialisation='" + specialisation + '\'' +
                ", email='" + email + '\'' +
                '}';
    }
}
