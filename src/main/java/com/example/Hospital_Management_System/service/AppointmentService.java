package com.example.Hospital_Management_System.service;

import com.example.Hospital_Management_System.dao.AppointmentDAO;
import com.example.Hospital_Management_System.entity.Appointments;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

public class AppointmentService {
    private final AppointmentDAO appointmentDAO;

    public AppointmentService() {
        this.appointmentDAO = new AppointmentDAO();
    }

    public void saveAppointment(Appointments appointment) {
        appointmentDAO.saveAppointment(appointment);
    }

    public Appointments getAppointmentById(int id) {
        return appointmentDAO.getAppointmentById(id);
    }

    public List<Appointments> getAllAppointments() {
        return appointmentDAO.getAllAppointments();
    }

    public void updateAppointment(Appointments appointment) {
        appointmentDAO.updateAppointment(appointment);
    }

    public void deleteAppointment(int id) {
        appointmentDAO.deleteAppointment(id);
    }

    public List<Appointments> getAppointmentsByDoctorId(int doctorId) {
        return appointmentDAO.getAppointmentsByDoctorId(doctorId);
    }

    public List<Appointments> getAppointmentsByPatientId(int patientId) {
        return appointmentDAO.getAppointmentsByPatientId(patientId);
    }
}
