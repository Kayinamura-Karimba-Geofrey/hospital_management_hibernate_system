package com.example.Hospital_Management_System.servlet;

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
import java.time.format.DateTimeParseException;
import java.util.List;

/**
 * Servlet for managing patient appointments.
 * Handles listing, editing, deleting, and creating new appointments.
 */
@WebServlet("/appointments")
public class AppointmentServlet extends HttpServlet {
    private AppointmentService appointmentService;
    private PatientService patientService;
    private DoctorService doctorService;

    @Override
    public void init() {
        appointmentService = new AppointmentService();
        patientService = new PatientService();
        doctorService = new DoctorService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.isEmpty()) {
                try {
                    int id = Integer.parseInt(idStr);
                    appointmentService.deleteAppointment(id);
                    AuditService.log(request.getSession(), "DELETE", "Appointment", idStr, "Deleted appointment record");
                } catch (NumberFormatException e) {
                    System.err.println("ERROR: Invalid ID for deletion: " + idStr);
                }
            }
            response.sendRedirect(request.getContextPath() + "/appointments");
            return;
        } else if ("edit".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.isEmpty()) {
                try {
                    int id = Integer.parseInt(idStr);
                    Appointments appointment = appointmentService.getAppointmentById(id);
                    request.setAttribute("editableApp", appointment);
                } catch (NumberFormatException e) {
                    System.err.println("ERROR: Invalid ID for edit: " + idStr);
                }
            }
        }

        List<Appointments> appointments = appointmentService.getAllAppointments();
        List<Patients> patients = patientService.getAllPatients();
        request.setAttribute("appointments", appointments);
        request.setAttribute("patients", patients);
        request.getRequestDispatcher("appointments.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        System.out.println("DEBUG: [AppointmentServlet] POST action: " + action);

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
        
        System.out.println("DEBUG: [AppointmentServlet] Request Details - Date: " + dateStr + ", Time: " + timeStr + ", PatientID: " + patientIdStr + ", DoctorID: " + doctorIdStr);

        User user = (User) request.getSession().getAttribute("user");
        Patients patient = null;

        try {
            if (patientIdStr != null && !patientIdStr.isEmpty()) {
                patient = patientService.getPatientById(Integer.parseInt(patientIdStr));
            } else if (user != null) {
                patient = patientService.getPatientByEmail(user.getEmail());
            }

            if (patient != null && dateStr != null && timeStr != null) {
                LocalDate date = LocalDate.parse(dateStr);
                LocalTime time = LocalTime.parse(timeStr);
                
                Appointments appointment = new Appointments(date, time);
                appointment.setPatient(patient);
                appointment.setStatus("REQUESTED");
                
                if (doctorIdStr != null && !doctorIdStr.isEmpty()) {
                    Doctors doctor = doctorService.getDoctorById(Integer.parseInt(doctorIdStr));
                    if (doctor != null) {
                        appointment.setDoctor(doctor);
                    }
                }
                
                appointmentService.saveAppointment(appointment);
                System.out.println("DEBUG: [AppointmentServlet] Saved request. ID: " + appointment.getId() + " for Patient: " + patient.getName());
                response.sendRedirect(request.getContextPath() + "/dashboard?msg=request_sent");
            } else {
                String error = (patient == null) ? "patient_not_found" : "missing_data";
                System.err.println("DEBUG: [AppointmentServlet] Request failed: " + error);
                response.sendRedirect(request.getContextPath() + "/dashboard?msg=error_" + error);
            }
        } catch (DateTimeParseException | NumberFormatException e) {
            System.err.println("DEBUG: [AppointmentServlet] Parsing error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/dashboard?msg=error_invalid_input");
        }
    }

    private void handleApprove(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            try {
                int id = Integer.parseInt(idStr);
                Appointments appointment = appointmentService.getAppointmentById(id);
                if (appointment != null) {
                    appointment.setStatus("CONFIRMED");
                    appointmentService.updateAppointment(appointment);
                    AuditService.log(request.getSession(), "UPDATE", "Appointment", idStr, "Approved appointment request");
                }
            } catch (NumberFormatException e) {
                System.err.println("ERROR: Invalid ID for approval: " + idStr);
            }
        }
        response.sendRedirect(request.getContextPath() + "/dashboard?msg=approved");
    }

    private void handleReject(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        String reason = request.getParameter("rejectionReason");
        if (idStr != null && !idStr.isEmpty()) {
            try {
                int id = Integer.parseInt(idStr);
                Appointments appointment = appointmentService.getAppointmentById(id);
                if (appointment != null) {
                    appointment.setStatus("REJECTED");
                    if (reason != null) appointment.setRejectionReason(reason.trim());
                    appointmentService.updateAppointment(appointment);
                    AuditService.log(request.getSession(), "UPDATE", "Appointment", idStr, "Rejected appointment request");
                }
            } catch (NumberFormatException e) {
                System.err.println("ERROR: Invalid ID for rejection: " + idStr);
            }
        }
        response.sendRedirect(request.getContextPath() + "/dashboard?msg=declined");
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

        try {
            int patientId = Integer.parseInt(patientIdStr);
            Patients patient = patientService.getPatientById(patientId);
            LocalDate date = LocalDate.parse(dateStr);
            LocalTime time = LocalTime.parse(timeStr);

            if (idStr != null && !idStr.isEmpty()) {
                int id = Integer.parseInt(idStr);
                Appointments appointment = appointmentService.getAppointmentById(id);
                if (appointment != null && patient != null) {
                    appointment.setPatient(patient);
                    appointment.setAppointmentDate(date);
                    appointment.setAppointmentTime(time);
                    appointmentService.updateAppointment(appointment);
                    AuditService.log(request.getSession(), "UPDATE", "Appointment", idStr, "Updated existing appointment");
                }
            } else if (patient != null) {
                Appointments appointment = new Appointments(date, time);
                appointment.setPatient(patient);
                appointment.setStatus("CONFIRMED");
                appointmentService.saveAppointment(appointment);
                AuditService.log(request.getSession(), "CREATE", "Appointment", String.valueOf(appointment.getId()), "Created new appointment");
            }
            response.sendRedirect(request.getContextPath() + "/appointments");
        } catch (DateTimeParseException | NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/appointments?error=invalid_input");
        }
    }
}
