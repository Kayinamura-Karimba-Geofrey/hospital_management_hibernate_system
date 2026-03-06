package com.example.Hospital_Management_System.dao;

import com.example.Hospital_Management_System.entity.Bed;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

public class BedDAO {
    public void saveOrUpdate(Bed bed) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.saveOrUpdate(bed);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    public Bed getBedById(Long id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Bed.class, id);
        }
    }

    public List<Bed> getBedsByWard(Long wardId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from Bed where ward.id = :wardId", Bed.class)
                    .setParameter("wardId", wardId)
                    .list();
        }
    }

    public void updateBedStatus(Long bedId, String status) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            Bed bed = session.get(Bed.class, bedId);
            if (bed != null) {
                bed.setStatus(status);
                session.update(bed);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }
}
