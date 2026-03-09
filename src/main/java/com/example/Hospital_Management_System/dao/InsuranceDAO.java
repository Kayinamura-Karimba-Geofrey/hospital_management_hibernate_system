package com.example.Hospital_Management_System.dao;

import com.example.Hospital_Management_System.entity.Insurance;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 * DAO class for managing Insurance entities.
 * Handles patient insurance coverage details and providers.
 */
public class InsuranceDAO {

    /**
     * Saves or updates an insurance policy for a patient.
     * @param insurance The insurance entity to save or update.
     */
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

    /**
     * Retrieves insurance details for a specific patient.
     * @param patientId The ID of the patient.
     * @return The Insurance entity, or null if not found.
     */
    public Insurance getByPatientId(int patientId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Insurance WHERE patient.id = :patientId", Insurance.class)
                    .setParameter("patientId", patientId)
                    .uniqueResult();
        }
    }
}
