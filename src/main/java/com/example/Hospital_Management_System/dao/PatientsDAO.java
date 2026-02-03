package com.example.Hospital_Management_System.dao;

import com.example.Hospital_Management_System.entity.Patients;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

public class PatientsDAO {

    public List<Patients> getAllPatients() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from Patients", Patients.class).list();
        }
    }

    public Patients getPatientById(int id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Patients.class, id);
        }
    }
}
