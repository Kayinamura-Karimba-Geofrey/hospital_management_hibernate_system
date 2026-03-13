package com.example.Hospital_Management_System.servlet;

import com.example.Hospital_Management_System.entity.*;
import com.example.Hospital_Management_System.service.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Servlet for redirecting users to their role-specific dashboards.
 * Fetches relevant statistics and profiles for Admins, Doctors, Nurses, and Patients.
 */
@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private PatientService patientService;
    private DoctorService doctorService;
    private NurseService nurseService;
    private AppointmentService appointmentService;
    private FinancialService financialService;
    private ClinicalService clinicalService;

    @Override
    public void init() {
        patientService = new PatientService();
        doctorService = new DoctorService();
        nurseService = new NurseService();
        appointmentService = new AppointmentService();
        financialService = new FinancialService();
        clinicalService = new ClinicalService();
    }

    /**
     * Handles GET requests to identify user role and display the correct dashboard.
     * Redirects to login if the session is invalid.
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String role = (String) session.getAttribute("role");

        if (user == null || role == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String email = user.getEmail();

        String jspPage = null;

        if ("ADMIN".equals(role)) {
            fetchAdminStats(request);
            jspPage = "admin_dashboard.jsp";
        } else if ("DOCTOR".equals(role)) {
            fetchDoctorStats(request, email);
            jspPage = "doctor_dashboard.jsp";
        } else if ("NURSE".equals(role)) {
            fetchNurseStats(request, email);
            jspPage = "nurse_dashboard.jsp";
        } else if ("PATIENT".equals(role)) {
            fetchPatientStats(request, email);
            jspPage = "patient_dashboard.jsp";
        }

        if (jspPage != null) {
            request.getRequestDispatcher(jspPage).forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }

    private void fetchAdminStats(HttpServletRequest request) {
        long patientCount = patientService.getAllPatients().size();
        long doctorCount = doctorService.getAllDoctors().size();
        long nurseCount = nurseService.getAllNurses().size();
        long appointmentCount = appointmentService.getAllAppointments().size();

        request.setAttribute("totalPatients", patientCount);
        request.setAttribute("totalDoctors", doctorCount);
        request.setAttribute("totalNurses", nurseCount);
        request.setAttribute("totalAppointments", appointmentCount);
        request.setAttribute("activeStaff", doctorCount + nurseCount);

        Map<String, Long> stats = new HashMap<>();
        stats.put("Patients", patientCount);
        stats.put("Doctors", doctorCount);
        stats.put("Nurses", nurseCount);
        stats.put("Appointments", appointmentCount);
        request.setAttribute("stats", stats);
    }

    private void fetchDoctorStats(HttpServletRequest request, String email) {
        Doctors doctor = doctorService.getDoctorByEmail(email);
        if (doctor != null) {
            request.setAttribute("doctor", doctor);
            request.setAttribute("myPatientsCount", doctorService.getPatientsCount(doctor.getId()));
            request.setAttribute("myAppointments", appointmentService.getAppointmentsByDoctorId(doctor.getId()));
        }
    }

    private void fetchNurseStats(HttpServletRequest request, String email) {
        Nurses nurse = nurseService.getNurseByEmail(email);
        if (nurse != null) {
            request.setAttribute("nurse", nurse);
            request.setAttribute("myPatientsCount", nurseService.getPatientsCount(nurse.getId()));
            request.setAttribute("wardPatients", nurse.getPatients()); // Fetch list for the table
            request.setAttribute("deptAppointments", appointmentService.getAppointmentsByNurseId(nurse.getId()));
        }
    }

    private void fetchPatientStats(HttpServletRequest request, String email) {
        Patients patient = patientService.getPatientByEmail(email);
        if (patient != null) {
            request.setAttribute("patient", patient);
            request.setAttribute("myAppointments", appointmentService.getAppointmentsByPatientId(patient.getId()));
            request.setAttribute("myInvoices", financialService.getInvoicesByPatientId(patient.getId()));
            request.setAttribute("medicalRecord", clinicalService.getRecordByPatientId(patient.getId()));
        }
    }
}
