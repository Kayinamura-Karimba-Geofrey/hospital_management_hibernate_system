package com.example.Hospital_Management_System.dao;

import com.example.Hospital_Management_System.entity.Appointments;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

/**
 * DAO class for managing Appointments entities.
 * Handles CRUD operations and specialized queries for appointments.
 */
public class AppointmentDAO {

    /**
     * Saves a new appointment to the database.
     * @param appointment The appointment record to save.
     */
    public void saveAppointment(Appointments appointment) {
        Transaction transaction = null;
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();
            session.persist(appointment);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            throw new RuntimeException("Failed to save appointment: " + e.getMessage(), e);
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }

    /**
     * Updates an existing appointment in the database.
     * @param appointment The appointment record to update.
     */
    public void updateAppointment(Appointments appointment) {
        Transaction transaction = null;
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();
            session.merge(appointment);
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
     * Deletes an appointment from the database by its ID.
     * @param id The ID of the appointment to delete.
     */
    public void deleteAppointment(int id) {
        Transaction transaction = null;
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();
            Appointments appointment = session.get(Appointments.class, id);
            if (appointment != null) {
                session.remove(appointment);
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
     * Retrieves all appointments from the database.
     * @return A list of all Appointments entities.
     */
    public List<Appointments> getAllAppointments() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from Appointments", Appointments.class).list();
        }
    }

    /**
     * Retrieves an appointment by its ID.
     * @param id The ID of the appointment.
     * @return The Appointments entity, or null if not found.
     */
    public Appointments getAppointmentById(int id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Appointments.class, id);
        }
    }

    /**
     * Retrieves all appointments for a specific patient.
     * @param patientId The ID of the patient.
     * @return A list of appointments associated with the patient.
     */
    public List<Appointments> getAppointmentsByPatientId(int patientId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from Appointments where patient.id = :patientId", Appointments.class)
                    .setParameter("patientId", patientId)
                    .list();
        }
    }

    /**
     * Retrieves all appointments for a specific doctor.
     * @param doctorId The ID of the doctor.
     * @return A list of appointments associated with the doctor.
     */
    public List<Appointments> getAppointmentsByDoctorId(int doctorId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from Appointments where doctor.id = :doctorId", Appointments.class)
                    .setParameter("doctorId", doctorId)
                    .list();
        }
    }

    /**
     * Retrieves all appointments for a specific nurse.
     * @param nurseId The ID of the nurse.
     * @return A list of appointments associated with the nurse.
     */
    public List<Appointments> getAppointmentsByNurseId(int nurseId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from Appointments where nurse.id = :nurseId", Appointments.class)
                    .setParameter("nurseId", nurseId)
                    .list();
        }
    }

    /**
     * Retrieves all requested appointments from the database.
     * @return A list of all Appointments entities with status 'REQUESTED'.
     */
    public List<Appointments> getRequestedAppointments() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from Appointments where status = 'REQUESTED'", Appointments.class).list();
        }
    }
}
