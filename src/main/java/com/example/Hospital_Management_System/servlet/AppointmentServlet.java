package com.example.Hospital_Management_System.servlet;

import com.example.Hospital_Management_System.dao.AppointmentDAO;
import com.example.Hospital_Management_System.dao.PatientsDAO;
import com.example.Hospital_Management_System.entity.Appointments;
import com.example.Hospital_Management_System.entity.Patients;
import com.example.Hospital_Management_System.entity.User;
import com.example.Hospital_Management_System.entity.Notification;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@WebServlet("/appointments")
public class AppointmentServlet extends HttpServlet {
    private AppointmentDAO appointmentDAO;
    private PatientsDAO patientsDAO;

    public void init() {
        appointmentDAO = new AppointmentDAO();
        patientsDAO = new PatientsDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            appointmentDAO.deleteAppointment(id);
            response.sendRedirect(request.getContextPath() + "/appointments");
            return;
        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Appointments appointment = appointmentDAO.getAppointmentById(id);
            request.setAttribute("editableApp", appointment);
        }

        List<Appointments> appointments = appointmentDAO.getAllAppointments();
        List<Patients> patients = patientsDAO.getAllPatients();
        request.setAttribute("appointments", appointments);
        request.setAttribute("patients", patients);
        request.getRequestDispatcher("appointments.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        int patientId = Integer.parseInt(request.getParameter("patientId"));
        String dateStr = request.getParameter("appointmentDate");
        String timeStr = request.getParameter("appointmentTime");

        Patients patient = patientsDAO.getPatientById(patientId);
        LocalDate date = LocalDate.parse(dateStr);
        LocalTime time = LocalTime.parse(timeStr);

        Appointments appointment = new Appointments(date, time);
        appointment.setPatient(patient);

        if (idStr != null && !idStr.isEmpty()) {
            appointment.setId(Integer.parseInt(idStr));
            appointmentDAO.updateAppointment(appointment);
        } else {
            appointmentDAO.saveAppointment(appointment);
            
            // Trigger Notification
            if (patient != null && patient.getEmail() != null) {
                com.example.Hospital_Management_System.dao.UserDAO userDAO = new com.example.Hospital_Management_System.dao.UserDAO();
                User user = userDAO.getUserByEmail(patient.getEmail());
                if (user != null) {
                    Notification notification = new Notification(user, 
                        "New appointment scheduled for " + dateStr + " at " + timeStr, "APPOINTMENT");
                    new com.example.Hospital_Management_System.dao.NotificationDAO().save(notification);
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/appointments");
    }
}
