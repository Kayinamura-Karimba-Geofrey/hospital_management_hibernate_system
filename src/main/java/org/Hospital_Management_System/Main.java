package org.Hospital_Management_System;

import com.example.Hospital_Management_System.entity.*;
import com.example.Hospital_Management_System.service.*;
import java.time.LocalDate;
import java.time.LocalTime;

public class Main {
    public static void main(String[] args) {

        DoctorService doctorService = new DoctorService();
        PatientService patientService = new PatientService();
        NurseService nurseService = new NurseService();
        AppointmentService appointmentService = new AppointmentService();

        // Create a default department
        Department generalDept = new Department("General", "Wing A");

        Doctors d1 = new Doctors("Mr. John", "Cardiologist");
        d1.setDepartment(generalDept);
        doctorService.saveDoctor(d1);


        Patients p1 = new Patients("James", "Malaria", "james@example.com");
        p1.setDoctor(d1);
        patientService.savePatient(p1, d1.getId(), 0);


        Nurses n1 = new Nurses("Jane", generalDept);
        nurseService.saveNurse(n1);


        Appointments a1 = new Appointments(LocalDate.of(2025, 10, 11), LocalTime.of(10, 37));
        appointmentService.saveAppointment(a1);


        Doctors fetched = doctorService.getDoctorById(d1.getId());
        System.out.println("Fetched Doctor: " + fetched.getName() + " (" + fetched.getSpecialisation() + ")");


        fetched.setName("Alice N.");
        doctorService.updateDoctor(fetched, fetched.getEmail());

        System.out.println(" All operations completed successfully!");
    }
}
