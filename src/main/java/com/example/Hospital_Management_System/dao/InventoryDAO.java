package com.example.Hospital_Management_System.dao;

import com.example.Hospital_Management_System.entity.InventoryItem;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

/**
 * DAO class for managing InventoryItem entities.
 * Handles hospital stock, supplies, and low-level alerts.
 */
public class InventoryDAO {

    /**
     * Saves or updates an inventory item.
     * @param item The inventory item to save or update.
     */
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

    /**
     * Retrieves all inventory items in stock.
     * @return A list of all InventoryItem entities.
     */
    public List<InventoryItem> getAllItems() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM InventoryItem", InventoryItem.class).list();
        }
    }

    /**
     * Retrieves a specific inventory item by ID.
     * @param id The ID of the item.
     * @return The InventoryItem entity, or null if not found.
     */
    public InventoryItem getById(int id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(InventoryItem.class, id);
        }
    }

    /**
     * Retrieves items that are currently below their minimum threshold.
     * @return A list of low-stock InventoryItem entities.
     */
    public List<InventoryItem> getLowStockItems() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM InventoryItem WHERE quantity <= minThreshold", InventoryItem.class).list();
        }
    }

    /**
     * Deletes an inventory item by ID.
     * @param id The ID of the item to delete.
     */
    public void deleteItem(int id) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            InventoryItem item = session.get(InventoryItem.class, id);
            if (item != null) {
                session.remove(item);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }
}
