package com.example.Hospital_Management_System.dao;

import com.example.Hospital_Management_System.entity.Insurance;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

public class InsuranceDAO {

    public void saveOrUpdate(Insurance insurance) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.merge(insurance);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    public Insurance getByPatientId(int patientId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Insurance WHERE patient.id = :patientId", Insurance.class)
                    .setParameter("patientId", patientId)
                    .uniqueResult();
        }
    }
}
