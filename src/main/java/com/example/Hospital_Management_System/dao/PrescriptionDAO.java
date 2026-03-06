package com.example.Hospital_Management_System.dao;

import com.example.Hospital_Management_System.entity.Prescription;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

public class PrescriptionDAO {

    public void save(Prescription prescription) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(prescription);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    public List<Prescription> getByPatientId(int patientId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Prescription WHERE patient.id = :patientId ORDER BY prescribedDate DESC", Prescription.class)
                    .setParameter("patientId", patientId)
                    .list();
        }
    }
}
