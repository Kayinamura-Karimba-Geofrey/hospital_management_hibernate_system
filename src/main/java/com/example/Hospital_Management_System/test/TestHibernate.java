package com.example.Hospital_Management_System.test;

import com.example.Hospital_Management_System.dao.AppointmentDAO;
import com.example.Hospital_Management_System.entity.Appointments;
import com.example.Hospital_Management_System.entity.Patients;
import com.example.Hospital_Management_System.dao.PatientsDAO;
import java.time.LocalDate;
import java.time.LocalTime;

public class TestHibernate {
    public static void main(String[] args) {
        System.out.println("Starting test...");
        
        try {
            AppointmentDAO dao = new AppointmentDAO();
            Appointments app = new Appointments(LocalDate.now(), LocalTime.now());
            app.setStatus("REQUESTED");
            
            // Note: we leave doctor and patient as null to see what happens
            System.out.println("Attempting to save appointment...");
            dao.saveAppointment(app);
            System.out.println("Saved successfully without error!");
        } catch (Exception e) {
            e.printStackTrace();
        }
        System.exit(0);
    }
}
