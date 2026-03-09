package com.example.Hospital_Management_System.dao;

import com.example.Hospital_Management_System.entity.AuditLog;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

/**
 * DAO class for managing AuditLog entities.
 * Tracks system activities and enables activity searching.
 */
public class AuditLogDAO {

    /**
     * Saves a new audit log entry to the database.
     * @param log The audit log record to save.
     */
    public void save(AuditLog log) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(log);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    /**
     * Retrieves the most recent 100 audit log entries.
     * @return A list of recent audit logs.
     */
    public List<AuditLog> getAllLogs() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM AuditLog ORDER BY timestamp DESC", AuditLog.class)
                    .setMaxResults(100)
                    .list();
        }
    }

    /**
     * Retrieves audit logs filtered by entity name and ID.
     * @param entityName The name of the entity being audited.
     * @param entityId The ID of the specific entity.
     * @return A list of matching audit logs.
     */
    public List<AuditLog> getLogsByEntity(String entityName, String entityId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM AuditLog WHERE entityName = :entityName AND entityId = :entityId ORDER BY timestamp DESC", AuditLog.class)
                    .setParameter("entityName", entityName)
                    .setParameter("entityId", entityId)
                    .list();
        }
    }
}
