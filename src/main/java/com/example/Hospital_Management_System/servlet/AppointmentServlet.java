package com.example.Hospital_Management_System.servlet;

import com.example.Hospital_Management_System.dao.PatientsDAO;
import com.example.Hospital_Management_System.entity.Appointments;
import com.example.Hospital_Management_System.entity.Patients;
import com.example.Hospital_Management_System.entity.User;
import com.example.Hospital_Management_System.entity.Doctors;
import com.example.Hospital_Management_System.service.AppointmentService;
import com.example.Hospital_Management_System.service.AuditService;
import com.example.Hospital_Management_System.service.PatientService;
import com.example.Hospital_Management_System.service.DoctorService;
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

    @Override
    public void init() {
        appointmentService = new AppointmentService();
        patientsDAO = new PatientsDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.isEmpty()) {
                int id = Integer.parseInt(idStr);
                appointmentService.deleteAppointment(id);
                AuditService.log(request.getSession(), "DELETE", "Appointment", idStr, "Deleted appointment record");
            }
            response.sendRedirect(request.getContextPath() + "/appointments");
            return;
        } else if ("edit".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.isEmpty()) {
                int id = Integer.parseInt(idStr);
                Appointments appointment = appointmentService.getAppointmentById(id);
                request.setAttribute("editableApp", appointment);
            }
        }

        List<Appointments> appointments = appointmentService.getAllAppointments();
        List<Patients> patients = patientsDAO.getAllPatients();
        request.setAttribute("appointments", appointments);
        request.setAttribute("patients", patients);
        request.getRequestDispatcher("appointments.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        System.out.println("DEBUG: AppointmentServlet POST action: " + action);

        if ("request".equals(action)) {
            handleRequest(request, response);
        } else if ("approve".equals(action)) {
            handleApprove(request, response);
        } else if ("reject".equals(action)) {
            handleReject(request, response);
        } else {
            handleDefaultPost(request, response);
        }
    }

    private void handleRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String dateStr = request.getParameter("appointmentDate");
        String timeStr = request.getParameter("appointmentTime");
        String patientIdStr = request.getParameter("patientId");
        String doctorIdStr = request.getParameter("doctorId");
        
        User user = (User) request.getSession().getAttribute("user");
        PatientService ps = new PatientService();
        Patients patient = null;

        if (patientIdStr != null && !patientIdStr.isEmpty()) {
            patient = ps.getPatientById(Integer.parseInt(patientIdStr));
        } else if (user != null) {
            patient = ps.getPatientByEmail(user.getEmail());
        }

        if (patient != null) {
            LocalDate date = LocalDate.parse(dateStr);
            LocalTime time = LocalTime.parse(timeStr);
            Appointments appointment = new Appointments(date, time);
            appointment.setPatient(patient);
            
            if (doctorIdStr != null && !doctorIdStr.isEmpty()) {
                DoctorService ds = new DoctorService();
                Doctors doctor = ds.getDoctorById(Integer.parseInt(doctorIdStr));
                if (doctor != null) {
                    appointment.setDoctor(doctor);
                }
            }
            
            appointment.setStatus("REQUESTED");
            appointmentService.saveAppointment(appointment);
            System.out.println("DEBUG: Patient request saved. ID: " + appointment.getId() + " for Patient: " + patient.getName());
            response.sendRedirect(request.getContextPath() + "/dashboard?msg=request_sent");
        } else {
            System.err.println("DEBUG: Patient lookup failed for request.");
            response.sendRedirect(request.getContextPath() + "/dashboard?msg=error_patient_not_found");
        }
    }

    private void handleApprove(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            int id = Integer.parseInt(idStr);
            Appointments appointment = appointmentService.getAppointmentById(id);
            if (appointment != null) {
                appointment.setStatus("CONFIRMED");
                appointmentService.updateAppointment(appointment);
                AuditService.log(request.getSession(), "UPDATE", "Appointment", idStr, "Approved appointment request");
            }
        }
        response.sendRedirect(request.getContextPath() + "/dashboard");
    }

    private void handleReject(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        String reason = request.getParameter("rejectionReason");
        if (idStr != null && !idStr.isEmpty()) {
            int id = Integer.parseInt(idStr);
            Appointments appointment = appointmentService.getAppointmentById(id);
            if (appointment != null) {
                appointment.setStatus("REJECTED");
                if (reason != null) appointment.setRejectionReason(reason.trim());
                appointmentService.updateAppointment(appointment);
                AuditService.log(request.getSession(), "UPDATE", "Appointment", idStr, "Rejected appointment request");
            }
        }
        response.sendRedirect(request.getContextPath() + "/dashboard");
    }

    private void handleDefaultPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        String patientIdStr = request.getParameter("patientId");
        String dateStr = request.getParameter("appointmentDate");
        String timeStr = request.getParameter("appointmentTime");

        if (patientIdStr == null || dateStr == null || timeStr == null) {
            response.sendRedirect(request.getContextPath() + "/appointments?error=missing_data");
            return;
        }

        Patients patient = patientsDAO.getPatientById(Integer.parseInt(patientIdStr));
        LocalDate date = LocalDate.parse(dateStr);
        LocalTime time = LocalTime.parse(timeStr);

        if (idStr != null && !idStr.isEmpty()) {
            Appointments appointment = appointmentService.getAppointmentById(Integer.parseInt(idStr));
            if (appointment != null) {
                appointment.setPatient(patient);
                appointment.setAppointmentDate(date);
                appointment.setAppointmentTime(time);
                appointmentService.updateAppointment(appointment);
                AuditService.log(request.getSession(), "UPDATE", "Appointment", idStr, "Updated existing appointment");
            }
        } else {
            Appointments appointment = new Appointments(date, time);
            appointment.setPatient(patient);
            appointment.setStatus("CONFIRMED");
            appointmentService.saveAppointment(appointment);
            AuditService.log(request.getSession(), "CREATE", "Appointment", String.valueOf(appointment.getId()), "Created new appointment");
        }
        response.sendRedirect(request.getContextPath() + "/appointments");
    }
}
