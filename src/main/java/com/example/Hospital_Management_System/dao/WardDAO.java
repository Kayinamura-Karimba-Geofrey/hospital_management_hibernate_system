package com.example.Hospital_Management_System.dao;

import com.example.Hospital_Management_System.entity.Ward;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

public class WardDAO {
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

    public List<Ward> getAllWards() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from Ward", Ward.class).list();
        }
    }

    public Ward getWardById(Long id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Ward.class, id);
        }
    }
}
