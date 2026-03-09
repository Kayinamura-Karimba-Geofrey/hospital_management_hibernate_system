package com.example.Hospital_Management_System.dao;

import com.example.Hospital_Management_System.entity.PatientRecord;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 * DAO class for managing PatientRecord entities.
 * Handles extensive medical histories, diagnoses, and treatments for patients.
 */
public class PatientRecordDAO {

    /**
     * Saves or updates a patient's medical record.
     * @param record The patient record entity to save or update.
     */
    public void saveOrUpdate(PatientRecord record) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.merge(record);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    /**
     * Retrieves the medical record for a specific patient.
     * @param patientId The ID of the patient.
     * @return The PatientRecord entity, or null if not found.
     */
    public PatientRecord getByPatientId(int patientId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM PatientRecord WHERE patient.id = :patientId", PatientRecord.class)
                    .setParameter("patientId", patientId)
                    .uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
