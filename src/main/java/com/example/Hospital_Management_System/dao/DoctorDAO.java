package com.example.Hospital_Management_System.dao;

import com.example.Hospital_Management_System.entity.Doctors;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

/**
 * DAO class for managing Doctors entities.
 * Handles database operations for medical staff (doctors).
 */
public class DoctorDAO {

    /**
     * Saves a new doctor record to the database.
     * @param doctor The doctor entity to save.
     */
    public void saveDoctor(Doctors doctor) {
        Transaction transaction = null;
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();
            session.persist(doctor);
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
     * Updates an existing doctor's profile.
     * @param doctor The doctor entity to update.
     */
    public void updateDoctor(Doctors doctor) {
        Transaction transaction = null;
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();
            session.merge(doctor);
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
     * Deletes a doctor record from the database by ID.
     * @param id The ID of the doctor to delete.
     */
    public void deleteDoctor(int id) {
        Transaction transaction = null;
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();
            Doctors doctor = session.get(Doctors.class, id);
            if (doctor != null) {
                session.remove(doctor);
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
     * Retrieves all doctors from the database.
     * @return A list of all Doctors entities.
     */
    public List<Doctors> getAllDoctors() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from Doctors", Doctors.class).list();
        }
    }

    /**
     * Retrieves a doctor by their ID.
     * @param id The ID of the doctor.
     * @return The Doctors entity, or null if not found.
     */
    public Doctors getDoctorById(int id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Doctors.class, id);
        }
    }

    /**
     * Retrieves a doctor record based on their email address.
     * @param email The email of the doctor.
     * @return The Doctors entity, or null if not found.
     */
    public Doctors getDoctorByEmail(String email) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from Doctors where email = :email", Doctors.class)
                    .setParameter("email", email)
                    .uniqueResult();
        }
    }

    /**
     * Counts the number of patients assigned to a specific doctor.
     * @param doctorId The ID of the doctor.
     * @return The count of patients.
     */
    public long getPatientsCount(int doctorId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("SELECT count(p) FROM Patients p WHERE p.doctor.id = :id", Long.class)
                    .setParameter("id", doctorId)
                    .uniqueResult();
        }
    }
}
