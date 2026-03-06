package com.example.Hospital_Management_System.dao;

import com.example.Hospital_Management_System.entity.PatientRecord;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

public class PatientRecordDAO {

    public void saveOrUpdate(PatientRecord record) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.merge(record);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    public PatientRecord getByPatientId(int patientId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM PatientRecord WHERE patient.id = :patientId", PatientRecord.class)
                    .setParameter("patientId", patientId)
                    .uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
