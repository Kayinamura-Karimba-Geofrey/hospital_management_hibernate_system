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
        

        List<AuditLog> recentLogs = auditLogDAO.getAllLogs();
        request.setAttribute("auditLogs", recentLogs);


        Map<String, Long> inflowData = new TreeMap<>();
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            List<Object[]> results = session.createQuery(
                "SELECT function('monthname', p.createdAt), count(p) FROM Patients p GROUP BY function('monthname', p.createdAt)", Object[].class).list();
            for (Object[] res : results) {
                inflowData.put((String) res[0], (Long) res[1]);
            }
        } catch (Exception e) {

            inflowData.put("March", (long) patientsDAO.getAllPatients().size());
        }
        request.setAttribute("inflowData", inflowData);


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

        // Bed Occupancy
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
        long doctorCount = 0, nurseCount = 0;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            doctorCount = (Long) session.createQuery("select count(*) from Doctors").uniqueResult();
            nurseCount = (Long) session.createQuery("select count(*) from Nurses").uniqueResult();
        } catch (Exception e) {
             doctorCount = (long) new DoctorDAO().getAllDoctors().size();
             nurseCount = (long) new NurseDAO().getAllNurses().size();
        }

        request.setAttribute("totalPatients", patientsDAO.getAllPatients().size());
        request.setAttribute("totalInvoices", invoices.size());
        request.setAttribute("totalDoctors", doctorCount);
        request.setAttribute("totalNurses", nurseCount);
        request.setAttribute("activeStaff", doctorCount + nurseCount);

        request.getRequestDispatcher("analytics.jsp").forward(request, response);
    }
}
