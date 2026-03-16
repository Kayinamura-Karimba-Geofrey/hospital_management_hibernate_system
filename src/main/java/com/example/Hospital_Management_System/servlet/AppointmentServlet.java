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
        String action = request.getParameter("action");

        if ("request".equals(action)) {
            // Patient requesting an appointment
            String dateStr = request.getParameter("appointmentDate");
            String timeStr = request.getParameter("appointmentTime");
            com.example.Hospital_Management_System.entity.User user = (com.example.Hospital_Management_System.entity.User) request.getSession().getAttribute("user");
            
            String patientIdStr = request.getParameter("patientId");
            
            Patients patient = null;
            com.example.Hospital_Management_System.service.PatientService ps = new com.example.Hospital_Management_System.service.PatientService();
            
            if (patientIdStr != null && !patientIdStr.isEmpty()) {
                patient = ps.getPatientById(Integer.parseInt(patientIdStr));
                System.out.println("DEBUG: Patient retrieved via ID: " + (patient != null ? patient.getName() : "null"));
            } else if (user != null) {
                System.out.println("DEBUG: User found in session. Email: " + user.getEmail());
                patient = ps.getPatientByEmail(user.getEmail());
                System.out.println("DEBUG: Patient retrieved via Email: " + (patient != null ? patient.getName() : "null"));
            } else {
                System.out.println("DEBUG: User NOT found in session and no patientId provided!");
            }

            if (patient != null) {
                System.out.println("DEBUG: Patient found. Saving requested appointment...");
                LocalDate date = LocalDate.parse(dateStr);
                LocalTime time = LocalTime.parse(timeStr);
                Appointments appointment = new Appointments(date, time);
                appointment.setPatient(patient);
                
                String doctorIdStr = request.getParameter("doctorId");
                if (doctorIdStr != null && !doctorIdStr.isEmpty()) {
                    com.example.Hospital_Management_System.service.DoctorService ds = new com.example.Hospital_Management_System.service.DoctorService();
                    com.example.Hospital_Management_System.entity.Doctors doctor = ds.getDoctorById(Integer.parseInt(doctorIdStr));
                    appointment.setDoctor(doctor);
                }
                
                appointment.setStatus("REQUESTED");
                appointmentService.saveAppointment(appointment);
                AuditService.log(request.getSession(), "CREATE", "Appointment", String.valueOf(appointment.getId()), "Patient requested new appointment");
            } else {
                System.out.println("DEBUG: Patient NOT FOUND for request processing.");
            }
            response.sendRedirect(request.getContextPath() + "/dashboard?msg=request_sent");
            return;
        } else if ("approve".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Appointments appointment = appointmentService.getAppointmentById(id);
            if (appointment != null) {
                appointment.setStatus("CONFIRMED");
                appointmentService.updateAppointment(appointment);
                AuditService.log(request.getSession(), "UPDATE", "Appointment", String.valueOf(id), "Approved appointment request");
            }
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        } else if ("reject".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String rejectionReason = request.getParameter("rejectionReason");
            Appointments appointment = appointmentService.getAppointmentById(id);
            if (appointment != null) {
                appointment.setStatus("REJECTED");
                if (rejectionReason != null && !rejectionReason.trim().isEmpty()) {
                    appointment.setRejectionReason(rejectionReason.trim());
                }
                appointmentService.updateAppointment(appointment);
                AuditService.log(request.getSession(), "UPDATE", "Appointment", String.valueOf(id), "Rejected appointment request");
            }
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        String idStr = request.getParameter("id");
        int patientId = Integer.parseInt(request.getParameter("patientId"));
        String dateStr = request.getParameter("appointmentDate");
        String timeStr = request.getParameter("appointmentTime");

        Patients patient = patientsDAO.getPatientById(patientId);
        LocalDate date = LocalDate.parse(dateStr);
        LocalTime time = LocalTime.parse(timeStr);

        Appointments appointment = new Appointments(date, time);
        appointment.setPatient(patient);
        appointment.setStatus("CONFIRMED");

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
