package com.example.Hospital_Management_System.service;

import com.example.Hospital_Management_System.dao.InsuranceDAO;
import com.example.Hospital_Management_System.dao.InvoiceDAO;
import com.example.Hospital_Management_System.dao.PatientsDAO;
import com.example.Hospital_Management_System.entity.Insurance;
import com.example.Hospital_Management_System.entity.Invoice;
import com.example.Hospital_Management_System.entity.Patients;
import java.util.List;

public class FinancialService {
    private final InvoiceDAO invoiceDAO;
    private final InsuranceDAO insuranceDAO;
    private final PatientsDAO patientsDAO;

    public FinancialService() {
        this.invoiceDAO = new InvoiceDAO();
        this.insuranceDAO = new InsuranceDAO();
        this.patientsDAO = new PatientsDAO();
    }

    public List<Invoice> getAllInvoices() {
        return invoiceDAO.getAllInvoices();
    }

    public List<Invoice> getInvoicesByPatientId(int patientId) {
        return invoiceDAO.getByPatientId(patientId);
    }

    public Invoice getInvoiceById(int id) {
        return invoiceDAO.getById(id);
    }

    public void saveInvoice(Invoice invoice) {
        invoiceDAO.save(invoice);
    }

    public void updateInvoice(Invoice invoice) {
        invoiceDAO.update(invoice);
    }

    public Insurance getInsuranceByPatientId(int patientId) {
        return insuranceDAO.getByPatientId(patientId);
    }

    public void saveOrUpdateInsurance(Insurance insurance) {
        insuranceDAO.saveOrUpdate(insurance);
    }

    public void generateInvoice(int patientId, double amount, String description) {
        Patients patient = patientsDAO.getPatientById(patientId);
        if (patient != null) {
            Invoice invoice = new Invoice();
            invoice.setPatient(patient);
            invoice.setAmount(amount);
            invoice.setDescription(description);
            invoiceDAO.save(invoice);
        }
    }

    public void updatePaymentStatus(int invoiceId, String status) {
        Invoice invoice = invoiceDAO.getById(invoiceId);
        if (invoice != null) {
            invoice.setStatus(status);
            invoiceDAO.update(invoice);
        }
    }
}
