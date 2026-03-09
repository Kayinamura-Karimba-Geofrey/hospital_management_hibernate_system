package com.example.Hospital_Management_System.dao;

import com.example.Hospital_Management_System.entity.Notification;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

import com.example.Hospital_Management_System.websocket.NotificationWebSocket;

/**
 * DAO class for managing Notification entities.
 * Handles system alerts, broadcasts them via WebSockets, and tracks read status.
 */
public class NotificationDAO {

    /**
     * Saves a notification and broadcasts it in real-time.
     * @param notification The notification entity to save.
     */
    public void save(Notification notification) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(notification);
            transaction.commit();
            
            // Broadcast via WebSocket
            NotificationWebSocket.sendNotification(notification.getUser().getId(), notification.getMessage());
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    /**
     * Retrieves all unread notifications for a specific user.
     * @param userId The ID of the user.
     * @return A list of unread Notification entities.
     */
    public List<Notification> getUnreadByUserId(Long userId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Notification WHERE user.id = :userId AND isRead = false ORDER BY createdAt DESC", Notification.class)
                    .setParameter("userId", userId)
                    .list();
        }
    }

    /**
     * Marks a specific notification as 'read'.
     * @param notificationId The ID of the notification.
     */
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
