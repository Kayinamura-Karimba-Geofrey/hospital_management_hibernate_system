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

    public void init() {
        appointmentService = new AppointmentService();
        patientsDAO = new PatientsDAO();
    }

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

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("request".equals(action)) {
            String dateStr = request.getParameter("appointmentDate");
            String timeStr = request.getParameter("appointmentTime");
            String patientIdStr = request.getParameter("patientId");
            User user = (User) request.getSession().getAttribute("user");
            
            PatientService ps = new PatientService();
            Patients patient = null;

            if (patientIdStr != null && !patientIdStr.isEmpty()) {
                patient = ps.getPatientById(Integer.parseInt(patientIdStr));
            } else if (user != null) {
                patient = ps.getPatientByEmail(user.getEmail());
            }

            if (patient != null) {
                System.out.println("DEBUG: Saving appointment for patient: " + patient.getName());
                LocalDate date = LocalDate.parse(dateStr);
                LocalTime time = LocalTime.parse(timeStr);
                Appointments appointment = new Appointments(date, time);
                appointment.setPatient(patient);
                
                String doctorIdStr = request.getParameter("doctorId");
                if (doctorIdStr != null && !doctorIdStr.isEmpty()) {
                    DoctorService ds = new DoctorService();
                    Doctors doctor = ds.getDoctorById(Integer.parseInt(doctorIdStr));
                    if (doctor != null) {
                        appointment.setDoctor(doctor);
                    }
                }
                
                appointment.setStatus("REQUESTED");
                System.out.println("DEBUG: Saving appointment - Status: " + appointment.getStatus() + ", Patient: " + (appointment.getPatient() != null ? appointment.getPatient().getName() : "NULL"));
                appointmentService.saveAppointment(appointment);
                System.out.println("DEBUG: Appointment saved. ID assigned: " + appointment.getId());
                response.sendRedirect(request.getContextPath() + "/dashboard?msg=request_sent");
            } else {
                System.out.println("DEBUG: Patient not found for email: " + (user != null ? user.getEmail() : "null"));
                response.sendRedirect(request.getContextPath() + "/dashboard?msg=error_patient_not_found");
            }
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

        // Default appointment creation (Admin/Staff)
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
            AuditService.log(request.getSession(), "UPDATE", "Appointment", idStr, "Updated appointment");
        } else {
            appointmentService.saveAppointment(appointment);
            AuditService.log(request.getSession(), "CREATE", "Appointment", String.valueOf(appointment.getId()), "Created appointment");
        }

        response.sendRedirect(request.getContextPath() + "/appointments");
    }
}
