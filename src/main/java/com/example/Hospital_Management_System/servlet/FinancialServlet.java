package com.example.Hospital_Management_System.servlet;

import com.example.Hospital_Management_System.entity.*;
import com.example.Hospital_Management_System.service.FinancialService;
import com.example.Hospital_Management_System.service.PatientService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Servlet for managing hospital finances.
 * Handles invoice generation, payment status updates, and patient insurance details.
 */
@WebServlet("/financial")
public class FinancialServlet extends HttpServlet {
    private FinancialService financialService;
    private PatientService patientService;

    public void init() {
        financialService = new FinancialService();
        patientService = new PatientService();
    }

    /**
     * Handles GET requests to view billing information.
     * Can display all invoices or filter by a specific patient to show their billing history and insurance.
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String patientIdStr = request.getParameter("patientId");
        
        if (patientIdStr != null && !patientIdStr.isEmpty()) {
            int patientId = Integer.parseInt(patientIdStr);
            Patients patient = patientService.getPatientById(patientId);
            List<Invoice> patientInvoices = financialService.getInvoicesByPatientId(patientId);
            Insurance insurance = financialService.getInsuranceByPatientId(patientId);
            
            request.setAttribute("selectedPatient", patient);
            request.setAttribute("patientInvoices", patientInvoices);
            request.setAttribute("insurance", insurance);
        }

        List<Invoice> allInvoices = financialService.getAllInvoices();
        List<Patients> allPatients = patientService.getAllPatients();
        
        request.setAttribute("allInvoices", allInvoices);
        request.setAttribute("allPatients", allPatients);
        request.getRequestDispatcher("billing.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("generateInvoice".equals(action)) {
                int patientId = Integer.parseInt(request.getParameter("patientId"));
                double amount = Double.parseDouble(request.getParameter("amount"));
                String description = request.getParameter("description");
                financialService.generateInvoice(patientId, amount, description);
            } else if ("updatePaymentStatus".equals(action)) {
                int invoiceId = Integer.parseInt(request.getParameter("invoiceId"));
                String status = request.getParameter("status");
                financialService.updatePaymentStatus(invoiceId, status);
            } else if ("updateInsurance".equals(action)) {
                int patientId = Integer.parseInt(request.getParameter("patientId"));
                String provider = request.getParameter("provider");
                String policyNumber = request.getParameter("policyNumber");
                double coverage = Double.parseDouble(request.getParameter("coveragePercentage"));

                Insurance insurance = financialService.getInsuranceByPatientId(patientId);
                if (insurance == null) {
                    insurance = new Insurance();
                    insurance.setPatient(patientService.getPatientById(patientId));
                }
                insurance.setProvider(provider);
                insurance.setPolicyNumber(policyNumber);
                insurance.setCoveragePercentage(coverage);
                financialService.saveOrUpdateInsurance(insurance);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/financial");
    }
}
