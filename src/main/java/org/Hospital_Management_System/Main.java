package org.Hospital_Management_System;

import com.example.Hospital_Management_System.entity.*;
import com.example.Hospital_Management_System.service.*;
import java.time.LocalDate;
import java.time.LocalTime;

public class Main {
    public static void main(String[] args) {

        DoctorsService doctorsService = new DoctorsService();
        PatientsService patientsService = new PatientsService();
        NursesServices nursesServices = new NursesServices();
        AppointmentsService appointmentsService = new AppointmentsService();

        // Create a default department
        Department generalDept = new Department("General", "Wing A");

        Doctors d1 = new Doctors("Mr. John", "Cardiologist");
        d1.setDepartment(generalDept);
        doctorsService.saveDoctors(d1);


        Patients p1 = new Patients("James", "Malaria");
        p1.setDoctor(d1);
        patientsService.createPatient(p1);


        Nurses n1 = new Nurses("Jane", generalDept);
        nursesServices.createNurses(n1);


        Appointments a1 = new Appointments(LocalDate.of(2025, 10, 11), LocalTime.of(10, 37));
        appointmentsService.createAppointments(a1);


        Doctors fetched = doctorsService.getDoctors(d1.getId());
        System.out.println("Fetched Doctor: " + fetched.getName() + " (" + fetched.getSpecialisation() + ")");


        fetched.setName("Alice N.");
        doctorsService.updateDoctor(fetched);

        System.out.println(" All operations completed successfully!");
    }
}
