package com.example.Hospital_Management_System;

import com.example.Hospital_Management_System.entity.Appointments;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

public class FixAppointmentStatus {
    public static void main(String[] args) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction tx = session.beginTransaction();
            
            List<Appointments> apps = session.createQuery("from Appointments", Appointments.class).list();
            int count = 0;
            for (Appointments a : apps) {
                if (a.getStatus() == null || a.getStatus().trim().isEmpty()) {
                    System.out.println("Updating Appointment ID: " + a.getId() + " status to 'REQUESTED'");
                    a.setStatus("REQUESTED");
                    session.merge(a);
                    count++;
                }
            }
            
            tx.commit();
            System.out.println("Finished updating " + count + " appointments.");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            HibernateUtil.shutdown();
        }
    }
}
