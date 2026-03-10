package com.example.Hospital_Management_System.dao;

import com.example.Hospital_Management_System.entity.Surgery;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.time.LocalDateTime;
import java.util.List;

/**
 * DAO class for managing Surgery entities.
 * Handles surgical procedures, scheduling, and operating theater allocation.
 */
public class SurgeryDAO {
    /**
     * Saves or updates a surgery record.
     * @param surgery The surgery entity to save or update.
     */
    public void saveOrUpdate(Surgery surgery) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.merge(surgery);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    public Surgery getById(int id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Surgery.class, id);
        }
    }

    public void delete(Long id) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            Surgery surgery = session.get(Surgery.class, id);
            if (surgery != null) {
                session.remove(surgery);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    /**
     * Retrieves all scheduled surgeries.
     * @return A list of all Surgery entities.
     */
    public List<Surgery> getAllSurgeries() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from Surgery order by surgeryDateTime asc", Surgery.class).list();
        }
    }

    /**
     * Checks for surgery schedule conflicts in a specific room.
     * @param room The name of the operating theater room.
     * @param start The start time of the slot.
     * @param end The end time of the slot.
     * @return A list of surgeries already scheduled in that slot.
     */
    public List<Surgery> getSurgeriesByRoomAndDate(String room, LocalDateTime start, LocalDateTime end) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from Surgery where otRoomName = :room and surgeryDateTime between :start and :end", Surgery.class)
                    .setParameter("room", room)
                    .setParameter("start", start)
                    .setParameter("end", end)
                    .list();
        }
    }
}
