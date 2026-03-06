package com.example.Hospital_Management_System.dao;

import com.example.Hospital_Management_System.entity.Notification;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

public class NotificationDAO {

    public void save(Notification notification) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(notification);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    public List<Notification> getUnreadByUserId(Long userId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Notification WHERE user.id = :userId AND isRead = false ORDER BY createdAt DESC", Notification.class)
                    .setParameter("userId", userId)
                    .list();
        }
    }

    public void markAsRead(Long notificationId) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            Notification notification = session.get(Notification.class, notificationId);
            if (notification != null) {
                notification.setRead(true);
                session.merge(notification);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }
}
