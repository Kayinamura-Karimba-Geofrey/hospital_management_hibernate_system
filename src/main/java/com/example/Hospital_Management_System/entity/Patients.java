package com.example.Hospital_Management_System.entity;

import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
public class Patients {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String name;
    private String disease;


    @ManyToOne
    @JoinColumn(name = "doctor_id")
    private Doctors doctor;

    @ManyToOne
    @JoinColumn(name = "nurse_id")
    private Nurses nurse;



    @OneToMany(mappedBy = "patient", cascade = CascadeType.ALL)
    private List<Appointments> appointments = new ArrayList<>();

    public Patients() {}

    public Patients(String name, String disease) {
        this.name = name;
        this.disease = disease;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Nurses getNurse() {
        return nurse;
    }

    public void setNurse(Nurses nurse) {
        this.nurse = nurse;
    }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDisease() { return disease; }
    public void setDisease(String disease) { this.disease = disease; }

    public Doctors getDoctor() { return doctor; }
    public void setDoctor(Doctors doctor) { this.doctor = doctor; }

    public List<Appointments> getAppointments() { return appointments; }
    public void setAppointments(List<Appointments> appointments) { this.appointments = appointments; }

    @Override
    public String toString() {
        return "Patients{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", disease='" + disease + '\'' +
                '}';
    }
}
