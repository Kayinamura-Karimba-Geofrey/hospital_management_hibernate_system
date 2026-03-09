package com.example.Hospital_Management_System.dao;

import com.example.Hospital_Management_System.entity.Admission;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.time.LocalDateTime;
import java.util.List;

/**
 * DAO class for managing Admission entities.
 * Handles database operations for patient admissions and discharges.
 */
public class AdmissionDAO {
    /**
     * Saves a new admission record to the database.
     * @param admission The admission record to save.
     */
    public void save(Admission admission) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.save(admission);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    /**
     * Discharges a patient by updating the admission record and freeing the associated bed.
     * @param admissionId The ID of the admission record.
     */
    public void discharge(Long admissionId) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            Admission admission = session.get(Admission.class, admissionId);
            if (admission != null) {
                admission.setDischargeDate(LocalDateTime.now());
                admission.getBed().setStatus("CLEANING");
                session.update(admission);
                session.update(admission.getBed());
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    /**
     * Retrieves an admission record by its ID.
     * @param id The ID of the admission.
     * @return The Admission entity, or null if not found.
     */
    public Admission getById(Long id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Admission.class, id);
        }
    }

    /**
     * Retrieves all admission records from the database.
     * @return A list of all Admission entities.
     */
    public List<Admission> getAllAdmissions() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from Admission", Admission.class).list();
        }
    }

    /**
     * Retrieves all active admissions (where discharge date is null).
     * @return A list of active Admission entities.
     */
    public List<Admission> getActiveAdmissions() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from Admission where dischargeDate is null", Admission.class).list();
        }
    }
}
