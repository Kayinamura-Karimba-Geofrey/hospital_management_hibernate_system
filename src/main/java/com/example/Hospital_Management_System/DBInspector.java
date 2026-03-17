package com.example.Hospital_Management_System;

import com.example.Hospital_Management_System.entity.Appointments;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import java.util.List;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;

public class DBInspector {
    public static void main(String[] args) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            System.out.println("--- DB INSPECTION START ---");
            
            List<Appointments> allApps = session.createQuery("from Appointments", Appointments.class).list();
            System.out.println("Total Appointments in DB: " + allApps.size());
            for (Appointments a : allApps) {
                System.out.println(String.format("ID: %d | Date: %s | Time: %s | Status: [%s] | Patient: %s | Doctor: %s",
                    a.getId(), a.getAppointmentDate(), a.getAppointmentTime(),
                    a.getStatus(),
                    (a.getPatient() != null ? a.getPatient().getName() : "NULL"),
                    (a.getDoctor() != null ? a.getDoctor().getName() : "NULL")
                ));
            }
            
            String targetStatus = "REQUESTED";
            List<Appointments> requested = session.createQuery(
                "from Appointments a where upper(trim(a.status)) = :status", Appointments.class)
                .setParameter("status", targetStatus)
                .list();
            System.out.println("\nMatches for Status '" + targetStatus + "': " + requested.size());
            
            System.out.println("--- DB INSPECTION END ---");
        } catch (Exception e) {
            System.err.println("CRITICAL ERROR: " + e.getMessage());
            e.printStackTrace();
        } finally {
            HibernateUtil.shutdown();
        }
    }
}
