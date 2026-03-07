package com.example.Hospital_Management_System.dao;

import com.example.Hospital_Management_System.entity.Surgery;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.time.LocalDateTime;
import java.util.List;

public class SurgeryDAO {
    public void saveOrUpdate(Surgery surgery) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.merge(surgery);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    public List<Surgery> getAllSurgeries() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from Surgery order by surgeryDateTime asc", Surgery.class).list();
        }
    }

    public List<Surgery> getSurgeriesByRoomAndDate(String room, LocalDateTime start, LocalDateTime end) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from Surgery where otRoomName = :room and surgeryDateTime between :start and :end", Surgery.class)
                    .setParameter("room", room)
                    .setParameter("start", start)
                    .setParameter("end", end)
                    .list();
        }
    }
}
