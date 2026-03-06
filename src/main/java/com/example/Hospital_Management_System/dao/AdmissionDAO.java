package com.example.Hospital_Management_System.dao;

import com.example.Hospital_Management_System.entity.Admission;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.time.LocalDateTime;
import java.util.List;

public class AdmissionDAO {
    public void save(Admission admission) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.save(admission);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    public void discharge(Long admissionId) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            Admission admission = session.get(Admission.class, admissionId);
            if (admission != null) {
                admission.setDischargeDate(LocalDateTime.now());
                admission.getBed().setStatus("CLEANING");
                session.update(admission);
                session.update(admission.getBed());
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    public List<Admission> getActiveAdmissions() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from Admission where dischargeDate is null", Admission.class).list();
        }
    }
}
