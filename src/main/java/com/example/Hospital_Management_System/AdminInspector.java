package com.example.Hospital_Management_System;

import com.example.Hospital_Management_System.entity.User;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import java.util.List;

public class AdminInspector {
    public static void main(String[] args) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            List<User> admins = session.createQuery("from User where role = 'ADMIN'", User.class).list();
            System.out.println("--- ADMIN USERS IN DB ---");
            for (User u : admins) {
                System.out.println("ID: " + u.getId() + 
                                   " | Email: " + u.getEmail() + 
                                   " | 2FA Enabled: " + u.isTwoFactorEnabled() + 
                                   " | 2FA Secret: " + (u.getTwoFactorSecret() != null ? "exists" : "null"));
            }
            System.out.println("--------------------------");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            HibernateUtil.shutdown();
        }
    }
}
