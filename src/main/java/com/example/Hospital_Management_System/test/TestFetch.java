package com.example.Hospital_Management_System.test;

import com.example.Hospital_Management_System.dao.AppointmentDAO;
import com.example.Hospital_Management_System.entity.Appointments;
import java.util.List;

public class TestFetch {
    public static void main(String[] args) {
        try {
            AppointmentDAO dao = new AppointmentDAO();
            List<Appointments> list = dao.getRequestedAppointments();
            System.out.println("Requested Appointments Count: " + list.size());
            for (Appointments app : list) {
                System.out.println("ID: " + app.getId() + ", Status: " + app.getStatus());
                if (app.getPatient() != null) {
                    System.out.println("Patient: " + app.getPatient().getName());
                } else {
                    System.out.println("Patient is NULL");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        System.exit(0);
    }
}
