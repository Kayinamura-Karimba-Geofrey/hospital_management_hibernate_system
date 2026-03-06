package com.example.Hospital_Management_System.servlet;

import com.example.Hospital_Management_System.dao.*;
import com.example.Hospital_Management_System.entity.*;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
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

@WebServlet("/analytics")
public class AnalyticsServlet extends HttpServlet {

    private AuditLogDAO auditLogDAO;
    private InvoiceDAO invoiceDAO;
    private PatientsDAO patientsDAO;

    @Override
    public void init() {
        auditLogDAO = new AuditLogDAO();
        invoiceDAO = new InvoiceDAO();
        patientsDAO = new PatientsDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Audit Logs (Recent)
        List<AuditLog> recentLogs = auditLogDAO.getAllLogs();
        request.setAttribute("auditLogs", recentLogs);

        // 2. Patient Inflow (Monthly)
        // Grouping logic (simplified for the demonstration/chart)
        Map<String, Long> inflowData = new TreeMap<>();
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            List<Object[]> results = session.createQuery(
                "SELECT function('monthname', p.createdAt), count(p) FROM Patients p GROUP BY function('monthname', p.createdAt)", Object[].class).list();
            for (Object[] res : results) {
                inflowData.put((String) res[0], (Long) res[1]);
            }
        } catch (Exception e) {
            // Fallback if monthname function isn't available in the specific SQL dialect
            inflowData.put("March", (long) patientsDAO.getAllPatients().size());
        }
        request.setAttribute("inflowData", inflowData);

        // 3. Revenue by Status
        Map<String, Double> revenueData = new HashMap<>();
        List<Invoice> invoices = invoiceDAO.getAllInvoices();
        double paid = 0, pending = 0;
        for (Invoice inv : invoices) {
            if ("PAID".equals(inv.getStatus())) paid += inv.getTotalAmount();
            else pending += inv.getTotalAmount();
        }
        revenueData.put("Paid", paid);
        revenueData.put("Pending", pending);
        request.setAttribute("revenueData", revenueData);

        // 4. Counts
        request.setAttribute("totalPatients", patientsDAO.getAllPatients().size());
        request.setAttribute("totalInvoices", invoices.size());

        request.getRequestDispatcher("analytics.jsp").forward(request, response);
    }
}
