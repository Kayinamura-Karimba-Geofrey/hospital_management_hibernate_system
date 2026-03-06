package com.example.Hospital_Management_System.dao;

import com.example.Hospital_Management_System.entity.InventoryItem;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

public class InventoryDAO {

    public void saveOrUpdate(InventoryItem item) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.merge(item);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    public List<InventoryItem> getAllItems() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM InventoryItem", InventoryItem.class).list();
        }
    }

    public InventoryItem getById(int id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(InventoryItem.class, id);
        }
    }

    public List<InventoryItem> getLowStockItems() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM InventoryItem WHERE quantity <= minThreshold", InventoryItem.class).list();
        }
    }
}
