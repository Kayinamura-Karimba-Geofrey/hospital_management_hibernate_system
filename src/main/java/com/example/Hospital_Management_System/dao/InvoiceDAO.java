package com.example.Hospital_Management_System.dao;

import com.example.Hospital_Management_System.entity.Invoice;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

/**
 * DAO class for managing Invoice entities.
 * Handles hospital billing, patient invoicing, and payment tracking.
 */
public class InvoiceDAO {

    /**
     * Persists a new invoice to the database.
     * @param invoice The invoice entity to save.
     */
    public void save(Invoice invoice) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(invoice);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    /**
     * Updates an existing invoice record (e.g., marking as PAID).
     * @param invoice The invoice entity to update.
     */
    public void update(Invoice invoice) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.merge(invoice);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    /**
     * Retrieves all invoices, sorted by date.
     * @return A list of all Invoice entities.
     */
    public List<Invoice> getAllInvoices() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Invoice ORDER BY invoiceDate DESC", Invoice.class).list();
        }
    }

    /**
     * Retrieves all invoices associated with a specific patient.
     * @param patientId The ID of the patient.
     * @return A list of matching Invoice entities.
     */
    public List<Invoice> getByPatientId(int patientId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Invoice WHERE patient.id = :patientId ORDER BY invoiceDate DESC", Invoice.class)
                    .setParameter("patientId", patientId)
                    .list();
        }
    }

    /**
     * Retrieves an invoice by its ID.
     * @param id The ID of the invoice.
     * @return The Invoice entity, or null if not found.
     */
    public Invoice getById(int id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Invoice.class, id);
        }
    }

    /**
     * Deletes an invoice from the database.
     * @param id The ID of the invoice to delete.
     */
    public void delete(int id) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            Invoice invoice = session.get(Invoice.class, id);
            if (invoice != null) {
                session.remove(invoice);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }
}
