package com.example.Hospital_Management_System.servlet;

import com.example.Hospital_Management_System.dao.*;
import com.example.Hospital_Management_System.entity.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/financial")
public class FinancialServlet extends HttpServlet {

    private InvoiceDAO invoiceDAO;
    private InsuranceDAO insuranceDAO;
    private PatientsDAO patientsDAO;

    public void init() {
        invoiceDAO = new InvoiceDAO();
        insuranceDAO = new InsuranceDAO();
        patientsDAO = new PatientsDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String patientIdStr = request.getParameter("patientId");
        
        if (patientIdStr != null) {
            int patientId = Integer.parseInt(patientIdStr);
            Patients patient = patientsDAO.getPatientById(patientId);
            List<Invoice> patientInvoices = invoiceDAO.getByPatientId(patientId);
            Insurance insurance = insuranceDAO.getByPatientId(patientId);
            
            request.setAttribute("selectedPatient", patient);
            request.setAttribute("patientInvoices", patientInvoices);
            request.setAttribute("insurance", insurance);
        }

        List<Invoice> allInvoices = invoiceDAO.getAllInvoices();
        List<Patients> allPatients = patientsDAO.getAllPatients();
        
        request.setAttribute("allInvoices", allInvoices);
        request.setAttribute("allPatients", allPatients);
        request.getRequestDispatcher("billing.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("generateInvoice".equals(action)) {
            generateInvoice(request);
        } else if ("updatePaymentStatus".equals(action)) {
            updatePaymentStatus(request);
        } else if ("updateInsurance".equals(action)) {
            updateInsurance(request);
        }

        response.sendRedirect(request.getContextPath() + "/financial");
    }

    private void generateInvoice(HttpServletRequest request) {
        int patientId = Integer.parseInt(request.getParameter("patientId"));
        double amount = Double.parseDouble(request.getParameter("amount"));
        String description = request.getParameter("description");

        Invoice invoice = new Invoice();
        invoice.setPatient(patientsDAO.getPatientById(patientId));
        invoice.setAmount(amount);
        invoice.setDescription(description);
        invoiceDAO.save(invoice);
    }

    private void updatePaymentStatus(HttpServletRequest request) {
        int invoiceId = Integer.parseInt(request.getParameter("invoiceId"));
        String status = request.getParameter("status");
        
        Invoice invoice = invoiceDAO.getById(invoiceId);
        if (invoice != null) {
            invoice.setStatus(status);
            invoiceDAO.update(invoice);
        }
    }

    private void updateInsurance(HttpServletRequest request) {
        int patientId = Integer.parseInt(request.getParameter("patientId"));
        String provider = request.getParameter("provider");
        String policyNumber = request.getParameter("policyNumber");
        double coverage = Double.parseDouble(request.getParameter("coveragePercentage"));

        Insurance insurance = insuranceDAO.getByPatientId(patientId);
        if (insurance == null) {
            insurance = new Insurance();
            insurance.setPatient(patientsDAO.getPatientById(patientId));
        }
        insurance.setProvider(provider);
        insurance.setPolicyNumber(policyNumber);
        insurance.setCoveragePercentage(coverage);
        insuranceDAO.saveOrUpdate(insurance);
    }
}
