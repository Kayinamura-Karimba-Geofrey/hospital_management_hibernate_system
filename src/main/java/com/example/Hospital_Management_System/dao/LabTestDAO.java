package com.example.Hospital_Management_System.dao;

import com.example.Hospital_Management_System.entity.LabTest;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

/**
 * DAO class for managing LabTest entities.
 * Handles laboratory orders, test results, and patient lab history.
 */
public class LabTestDAO {

    /**
     * Saves or updates a lab test record.
     * @param labTest The lab test entity to save or update.
     */
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

    /**
     * Retrieves all lab tests for a specific patient.
     * @param patientId The ID of the patient.
     * @return A list of LabTest entities.
     */
    public List<LabTest> getByPatientId(int patientId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM LabTest WHERE patient.id = :patientId ORDER BY requestedDate DESC", LabTest.class)
                    .setParameter("patientId", patientId)
                    .list();
        }
    }

    /**
     * Retrieves a specific lab test by its ID.
     * @param id The ID of the lab test.
     * @return The LabTest entity, or null if not found.
     */
    public LabTest getById(int id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(LabTest.class, id);
        }
    }
}
