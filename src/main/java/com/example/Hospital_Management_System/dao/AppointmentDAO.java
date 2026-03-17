package com.example.Hospital_Management_System.dao;

import com.example.Hospital_Management_System.entity.Appointments;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import java.util.List;
import java.util.ArrayList;

/**
 * DAO class for managing Appointments entities.
 */
public class AppointmentDAO {

    public void saveAppointment(Appointments appointment) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.persist(appointment);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) transaction.rollback();
            e.printStackTrace();
        }
    }

    public void updateAppointment(Appointments appointment) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            session.merge(appointment);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) transaction.rollback();
            e.printStackTrace();
        }
    }

    public void deleteAppointment(int id) {
        Transaction transaction = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            transaction = session.beginTransaction();
            Appointments app = session.get(Appointments.class, id);
            if (app != null) session.remove(app);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null && transaction.isActive()) transaction.rollback();
            e.printStackTrace();
        }
    }

    public List<Appointments> getAllAppointments() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from Appointments", Appointments.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public Appointments getAppointmentById(int id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(Appointments.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Appointments> getAppointmentsByDoctorId(int doctorId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from Appointments a where a.doctor.id = :doctorId", Appointments.class)
                    .setParameter("doctorId", doctorId)
                    .list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public List<Appointments> getAppointmentsByPatientId(int patientId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from Appointments a left join fetch a.doctor where a.patient.id = :patientId", Appointments.class)
                    .setParameter("patientId", patientId)
                    .list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public List<Appointments> getAppointmentsByNurseId(int nurseId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from Appointments a where a.nurse.id = :nurseId", Appointments.class)
                    .setParameter("nurseId", nurseId)
                    .list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public List<Appointments> getRequestedAppointments() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Appointments> query = session.createQuery(
                "from Appointments a left join fetch a.patient " +
                "where upper(a.status) like :status " +
                "order by a.appointmentDate desc", Appointments.class);
            query.setParameter("status", "%REQUESTED%");
            List<Appointments> results = query.list();
            System.out.println("DEBUG: [AppointmentDAO] Found " + (results != null ? results.size() : 0) + " matches for %REQUESTED%");
            return results != null ? results : new ArrayList<>();
        } catch (Exception e) {
            System.err.println("DEBUG: [AppointmentDAO] Error: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
}
