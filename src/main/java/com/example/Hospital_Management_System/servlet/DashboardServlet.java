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
import java.util.ArrayList;
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
    private UserService userService;

    public DashboardServlet() {
        this.patientService = new PatientService();
        this.doctorService = new DoctorService();
        this.nurseService = new NurseService();
        this.appointmentService = new AppointmentService();
        this.financialService = new FinancialService();
        this.clinicalService = new ClinicalService();
        this.userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String role = (String) session.getAttribute("role");
        User user = (User) session.getAttribute("user");
        String email = user.getEmail();

        String jspPage = "index.jsp";
        String action = request.getParameter("action");

        if ("ADMIN".equalsIgnoreCase(role)) {
            fetchAdminStats(request);
            jspPage = "admin_dashboard.jsp";
        } else if ("DOCTOR".equalsIgnoreCase(role)) {
            fetchDoctorStats(request, email);
            jspPage = "doctor_dashboard.jsp";
        } else if ("NURSE".equalsIgnoreCase(role)) {
            fetchNurseStats(request, email);
            jspPage = "nurse_dashboard.jsp";
        } else if ("PATIENT".equalsIgnoreCase(role)) {
            fetchPatientStats(request, email);
            jspPage = "patient_dashboard.jsp";
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.getRequestDispatcher(jspPage).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private void fetchAdminStats(HttpServletRequest request) {
        List<Patients> patients = patientService.getAllPatients();
        List<Doctors> doctors = doctorService.getAllDoctors();
        List<Nurses> nurses = nurseService.getAllNurses();
        List<Appointments> appointments = appointmentService.getAllAppointments();

        request.setAttribute("totalPatients", patients.size());
        request.setAttribute("totalDoctors", doctors.size());
        request.setAttribute("totalNurses", nurses.size());
        request.setAttribute("totalAppointments", appointments.size());
        request.setAttribute("activeStaff", doctors.size() + nurses.size());

        Map<String, Long> stats = new HashMap<>();
        stats.put("Patients", (long)patients.size());
        stats.put("Doctors", (long)doctors.size());
        stats.put("Nurses", (long)nurses.size());
        stats.put("Appointments", (long)appointments.size());
        request.setAttribute("stats", stats);

        System.out.println("DEBUG: [DashboardServlet] Admin - TOTAL Appointments in DB: " + appointments.size());
        
        List<Appointments> requestedApps = appointmentService.getRequestedAppointments();
        if (requestedApps == null) requestedApps = new ArrayList<>();
        System.out.println("DEBUG: [DashboardServlet] Admin - Requested App Count: " + requestedApps.size());
        
        request.setAttribute("requestedAppointments", requestedApps);
        // Expose appointment service for JSP debug loop if needed
        request.setAttribute("appointmentService", appointmentService);
    }

    private void fetchDoctorStats(HttpServletRequest request, String email) {
        Doctors doctor = doctorService.getDoctorByEmail(email);
        if (doctor != null) {
            request.setAttribute("doctor", doctor);
            List<Appointments> myApps = appointmentService.getAppointmentsByDoctorId(doctor.getId());
            request.setAttribute("myAppointments", myApps != null ? myApps : new ArrayList<>());
            request.setAttribute("myPatientsCount", doctor.getPatients() != null ? doctor.getPatients().size() : 0);
        }
    }

    private void fetchNurseStats(HttpServletRequest request, String email) {
        Nurses nurse = nurseService.getNurseByEmail(email);
        if (nurse != null) {
            request.setAttribute("nurse", nurse);
            List<Patients> patients = nurse.getPatients();
            request.setAttribute("wardPatients", patients != null ? patients : new ArrayList<>());
            request.setAttribute("myPatientsCount", patients != null ? patients.size() : 0);
        }
    }

    private void fetchPatientStats(HttpServletRequest request, String email) {
        Patients patient = patientService.getPatientByEmail(email);
        if (patient != null) {
            request.setAttribute("patient", patient);
            List<Appointments> myApps = appointmentService.getAppointmentsByPatientId(patient.getId());
            request.setAttribute("myAppointments", myApps != null ? myApps : new ArrayList<>());
            
            // Add doctors for the request appointment dropdown
            List<Doctors> allDoctors = doctorService.getAllDoctors();
            request.setAttribute("allDoctors", allDoctors != null ? allDoctors : new ArrayList<>());
        }
    }
}
