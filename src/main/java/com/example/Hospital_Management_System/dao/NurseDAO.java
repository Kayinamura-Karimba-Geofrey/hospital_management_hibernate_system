package com.example.Hospital_Management_System.dao;

import com.example.Hospital_Management_System.entity.Nurses;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

/**
 * DAO class for managing Nurses entities.
 * Handles database operations for nursing staff.
 */
public class NurseDAO {

    /**
     * Saves a new nurse record to the database.
     * @param nurse The nurse entity to save.
     */
    public void saveNurse(Nurses nurse) {
        Transaction transaction = null;
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();
            session.persist(nurse);
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
     * Updates an existing nurse's details.
     * @param nurse The nurse entity to update.
     */
    public void updateNurse(Nurses nurse) {
        Transaction transaction = null;
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();
            session.merge(nurse);
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
     * Deletes a nurse record by ID.
     * @param id The ID of the nurse to delete.
     */
    public void deleteNurse(int id) {
        Transaction transaction = null;
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();
            Nurses nurse = session.get(Nurses.class, id);
            if (nurse != null) {
                session.remove(nurse);
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
     * Retrieves all nurses from the database.
     * @return A list of all Nurses entities.
     */
    public List<Nurses> getAllNurses() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from Nurses", Nurses.class).list();
        }
    }

    /**
     * Retrieves a nurse by their ID.
     * @param id The ID of the nurse.
     * @return The Nurses entity, or null if not found.
     */
    public Nurses getNurseById(int id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Nurses.class, id);
        }
    }

    /**
     * Retrieves a nurse by their email address.
     * @param email The email of the nurse.
     * @return The Nurses entity, or null if not found.
     */
    public Nurses getNurseByEmail(String email) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from Nurses where email = :email", Nurses.class)
                    .setParameter("email", email)
                    .uniqueResult();
        }
    }
}
