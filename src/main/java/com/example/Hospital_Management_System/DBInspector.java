package com.example.Hospital_Management_System;

import com.example.Hospital_Management_System.entity.Appointments;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import java.util.List;

public class DBInspector {
    public static void main(String[] args) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            List<Appointments> apps = session.createQuery("from Appointments", Appointments.class).list();
            System.out.println("Total Appointments: " + apps.size());
            for (Appointments a : apps) {
                System.out.println("ID: " + a.getId() + " | Status: [" + a.getStatus() + "] | Patient: " + (a.getPatient() != null ? a.getPatient().getName() : "NULL"));
            }
            
            List<Appointments> requested = session.createQuery("from Appointments a where upper(trim(a.status)) = 'REQUESTED'", Appointments.class).list();
            System.out.println("\nRequested Appointments: " + requested.size());
            for (Appointments a : requested) {
                System.out.println("ID: " + a.getId() + " | Patient: " + (a.getPatient() != null ? a.getPatient().getName() : "NULL"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            HibernateUtil.shutdown();
        }
    }
}
