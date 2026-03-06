package com.example.Hospital_Management_System.dao;

import com.example.Hospital_Management_System.entity.AuditLog;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

public class AuditLogDAO {

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

    public List<AuditLog> getAllLogs() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM AuditLog ORDER BY timestamp DESC", AuditLog.class)
                    .setMaxResults(100)
                    .list();
        }
    }

    public List<AuditLog> getLogsByEntity(String entityName, String entityId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM AuditLog WHERE entityName = :entityName AND entityId = :entityId ORDER BY timestamp DESC", AuditLog.class)
                    .setParameter("entityName", entityName)
                    .setParameter("entityId", entityId)
                    .list();
        }
    }
}
