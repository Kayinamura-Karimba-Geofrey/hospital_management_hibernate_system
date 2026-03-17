package com.example.Hospital_Management_System.dao;

import com.example.Hospital_Management_System.entity.Patients;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

/**
 * DAO class for managing Patients entities.
 * Handles database operations for patient demographic and contact information.
 */
public class PatientsDAO {

    /**
     * Saves a new patient record to the database.
     * @param patient The patient entity to save.
     */
    public void savePatient(Patients patient) {
        Transaction transaction = null;
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();
            session.persist(patient);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }

    /**
     * Updates an existing patient's details.
     * @param patient The patient entity to update.
     */
    public void updatePatient(Patients patient) {
        Transaction transaction = null;
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();
            session.merge(patient);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }

    /**
     * Deletes a patient record from the database by ID.
     * @param id The ID of the patient to delete.
     */
    public void deletePatient(int id) {
        Transaction transaction = null;
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();
            Patients patient = session.get(Patients.class, id);
            if (patient != null) {
                session.remove(patient);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }

    /**
     * Retrieves all registered patients.
     * @return A list of all Patients entities.
     */
    public List<Patients> getAllPatients() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from Patients", Patients.class).list();
        }
    }

    /**
     * Retrieves a patient by their ID.
     * @param id The ID of the patient.
     * @return The Patients entity, or null if not found.
     */
    public Patients getPatientById(int id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Patients.class, id);
        }
    }

    /**
     * Retrieves a patient record by their email address.
     * @param email The email of the patient.
     * @return The Patients entity, or null if not found.
     */
    public Patients getPatientByEmail(String email) {
        if (email == null) return null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from Patients where lower(trim(email)) = lower(trim(:email))", Patients.class)
                    .setParameter("email", email)
                    .uniqueResult();
        }
    }
}
