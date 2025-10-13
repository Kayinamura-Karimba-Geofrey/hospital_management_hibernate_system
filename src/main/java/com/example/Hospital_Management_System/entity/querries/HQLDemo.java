package com.example.Hospital_Management_System.entity.querries;

import com.example.Hospital_Management_System.entity.Doctors;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.query.Query;

import java.util.List;

public class HQLDemo {
    public static void main(String[] args) {
        Session session = HibernateUtil.getSessionFactory().openSession();

        // Fetch all doctors
        Query<Doctors> query = session.createQuery("FROM Doctors", Doctors.class);
        query.setCacheable(true);

        List<Doctors> doctorsList = query.list();

        for (Doctors d : doctorsList) {
            System.out.println(d);
        }

        session.close();
    }
}
