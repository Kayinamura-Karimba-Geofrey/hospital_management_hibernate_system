package com.example.Hospital_Management_System.dao;

import com.example.Hospital_Management_System.entity.Ward;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

/**
 * DAO class for managing Ward entities.
 * Handles hospital wards, wings, and room groupings.
 */
public class WardDAO {
    /**
     * Saves or updates a ward record.
     * @param ward The ward entity to save or update.
     */
    public void saveOrUpdate(Ward ward) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.saveOrUpdate(ward);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    /**
     * Retrieves all hospital wards.
     * @return A list of all Ward entities.
     */
    public List<Ward> getAllWards() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from Ward", Ward.class).list();
        }
    }

    /**
     * Retrieves a specific ward by its ID.
     * @param id The ID of the ward.
     * @return The Ward entity, or null if not found.
     */
    public Ward getWardById(Long id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Ward.class, id);
        }
    }
}
