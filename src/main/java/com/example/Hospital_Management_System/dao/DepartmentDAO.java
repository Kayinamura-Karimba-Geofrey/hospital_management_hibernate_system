package com.example.Hospital_Management_System.dao;

import com.example.Hospital_Management_System.entity.Department;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

/**
 * DAO class for managing Department entities.
 * Handles departments within the hospital, including medical and administrative units.
 */
public class DepartmentDAO {

    /**
     * Saves a new department to the database.
     * @param department The department entity to save.
     */
    public void saveDepartment(Department department) {
        Transaction transaction = null;
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();
            session.persist(department);
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
     * Updates an existing department record.
     * @param department The department entity to update.
     */
    public void updateDepartment(Department department) {
        Transaction transaction = null;
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();
            session.merge(department);
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
     * Deletes a department from the database by its ID.
     * @param id The ID of the department to delete.
     */
    public void deleteDepartment(int id) {
        Transaction transaction = null;
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();
            Department dept = session.get(Department.class, id);
            if (dept != null) {
                session.remove(dept);
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
     * Retrieves all departments from the database.
     * @return A list of all Department entities.
     */
    public List<Department> getAllDepartments() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from Department", Department.class).list();
        }
    }

    /**
     * Retrieves a department by its ID.
     * @param id The ID of the department.
     * @return The Department entity, or null if not found.
     */
    public Department getDepartmentById(int id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Department.class, id);
        }
    }
}
