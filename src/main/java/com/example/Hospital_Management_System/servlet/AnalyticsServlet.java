package com.example.Hospital_Management_System.servlet;

import com.example.Hospital_Management_System.dao.*;
import com.example.Hospital_Management_System.entity.*;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import com.example.Hospital_Management_System.service.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.hibernate.Session;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

/**
 * Servlet for displaying hospital analytics and statistics.
 * Aggregates data from audit logs, finance, and staffing for the dashboard.
 */
@WebServlet("/analytics")
public class AnalyticsServlet extends HttpServlet {

    private AuditLogDAO auditLogDAO;
    private FinancialService financialService;
    private PatientService patientService;
    private DoctorService doctorService;
    private NurseService nurseService;

    @Override
    public void init() {
        auditLogDAO = new AuditLogDAO();
        financialService = new FinancialService();
        patientService = new PatientService();
        doctorService = new DoctorService();
        nurseService = new NurseService();
    }

    /**
     * Handles GET requests to display the analytics dashboard.
     * Fetches audit logs, patient inflow, revenue, and staff statistics.
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Audit Logs
        List<AuditLog> recentLogs = auditLogDAO.getAllLogs();
        request.setAttribute("auditLogs", recentLogs);

        // 2. Patient Inflow (using generic HQL/SQL)
        Map<String, Long> inflowData = new TreeMap<>();
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            // Use native query or more portable HQL for patient inflow
            List<Object[]> results = session.createNativeQuery(
                "SELECT TO_CHAR(created_at, 'Month'), COUNT(*) FROM patients GROUP BY TO_CHAR(created_at, 'Month')", Object[].class).list();
            for (Object[] res : results) {
                inflowData.put((String) res[0], (Long) res[1]);
            }
        } catch (Exception e) {
            inflowData.put("Current Month", (long) patientService.getAllPatients().size());
        }
        request.setAttribute("inflowData", inflowData);

        // 3. Revenue Data
        Map<String, Double> revenueData = new HashMap<>();
        List<Invoice> invoices = financialService.getAllInvoices();
        double paid = 0, pending = 0;
        for (Invoice inv : invoices) {
            if ("PAID".equalsIgnoreCase(inv.getStatus())) paid += inv.getAmount();
            else pending += inv.getAmount();
        }
        revenueData.put("Paid", paid);
        revenueData.put("Pending", pending);
        request.setAttribute("revenueData", revenueData);

        // 4. Bed Occupancy
        Map<String, Long> bedData = new HashMap<>();
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
             List<Object[]> bedRes = session.createQuery(
                "SELECT b.status, count(b) FROM Bed b GROUP BY b.status", Object[].class).list();
            for (Object[] res : bedRes) {
                bedData.put((String) res[0], (Long) res[1]);
            }
        } catch (Exception e) {
            bedData.put("No Data", 0L);
        }
        request.setAttribute("bedData", bedData);

        // Staff stats
        long doctorCount = doctorService.getAllDoctors().size();
        long nurseCount = nurseService.getAllNurses().size();

        request.setAttribute("totalPatients", patientService.getAllPatients().size());
        request.setAttribute("totalInvoices", invoices.size());
        request.setAttribute("totalDoctors", doctorCount);
        request.setAttribute("totalNurses", nurseCount);
        request.setAttribute("activeStaff", doctorCount + nurseCount);

        request.getRequestDispatcher("analytics.jsp").forward(request, response);
    }
}
