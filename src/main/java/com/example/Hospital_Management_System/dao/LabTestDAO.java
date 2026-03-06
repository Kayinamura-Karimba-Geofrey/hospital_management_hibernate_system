package com.example.Hospital_Management_System.dao;

import com.example.Hospital_Management_System.entity.LabTest;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

public class LabTestDAO {

    public void saveOrUpdate(LabTest labTest) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.merge(labTest);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    public List<LabTest> getByPatientId(int patientId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM LabTest WHERE patient.id = :patientId ORDER BY requestedDate DESC", LabTest.class)
                    .setParameter("patientId", patientId)
                    .list();
        }
    }

    public LabTest getById(int id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(LabTest.class, id);
        }
    }
}
