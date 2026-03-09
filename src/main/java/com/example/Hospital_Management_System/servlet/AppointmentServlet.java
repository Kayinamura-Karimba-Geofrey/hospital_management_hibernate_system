package com.example.Hospital_Management_System.servlet;

import com.example.Hospital_Management_System.dao.PatientsDAO;
import com.example.Hospital_Management_System.entity.Appointments;
import com.example.Hospital_Management_System.entity.Patients;
import com.example.Hospital_Management_System.service.AppointmentService;
import com.example.Hospital_Management_System.service.AuditService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

/**
 * Servlet for managing patient appointments.
 * Handles listing, editing, deleting, and creating new appointments.
 */
@WebServlet("/appointments")
public class AppointmentServlet extends HttpServlet {
    private AppointmentService appointmentService;
    private PatientsDAO patientsDAO;

    public void init() {
        appointmentService = new AppointmentService();
        patientsDAO = new PatientsDAO();
    }

    /**
     * Handles GET requests for listing and managing appointments.
     * Supports "edit" and "delete" actions via query parameters.
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            appointmentService.deleteAppointment(id);
            AuditService.log(request.getSession(), "DELETE", "Appointment", String.valueOf(id), "Deleted appointment record");
            response.sendRedirect(request.getContextPath() + "/appointments");
            return;
        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Appointments appointment = appointmentService.getAppointmentById(id);
            request.setAttribute("editableApp", appointment);
        }

        List<Appointments> appointments = appointmentService.getAllAppointments();
        List<Patients> patients = patientsDAO.getAllPatients();
        request.setAttribute("appointments", appointments);
        request.setAttribute("patients", patients);
        request.getRequestDispatcher("appointments.jsp").forward(request, response);
    }

    /**
     * Handles POST requests for saving or updating appointments.
     * Redirects back to the appointments list upon success.
     */
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
            appointmentService.updateAppointment(appointment);
            AuditService.log(request.getSession(), "UPDATE", "Appointment", idStr, "Updated appointment for patient: " + (patient != null ? patient.getName() : "Unknown"));
        } else {
            appointmentService.saveAppointment(appointment);
            AuditService.log(request.getSession(), "CREATE", "Appointment", String.valueOf(appointment.getId()), "Created new appointment for patient: " + (patient != null ? patient.getName() : "Unknown"));
        }

        response.sendRedirect(request.getContextPath() + "/appointments");
    }
}
