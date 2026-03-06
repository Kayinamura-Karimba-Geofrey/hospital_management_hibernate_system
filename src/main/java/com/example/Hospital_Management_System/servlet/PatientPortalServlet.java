package com.example.Hospital_Management_System.servlet;

import com.example.Hospital_Management_System.dao.*;
import com.example.Hospital_Management_System.entity.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/patient-portal")
public class PatientPortalServlet extends HttpServlet {

    private PatientsDAO patientsDAO;
    private AppointmentDAO appointmentDAO;
    private InvoiceDAO invoiceDAO;

    @Override
    public void init() {
        patientsDAO = new PatientsDAO();
        appointmentDAO = new AppointmentDAO();
        invoiceDAO = new InvoiceDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"PATIENT".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Link User to Patient by Email
        Patients patient = patientsDAO.getPatientByEmail(user.getEmail());

        if (patient != null) {
            request.setAttribute("patient", patient);
            
            // Get Appointments for this patient
            List<Appointments> appointments = appointmentDAO.getAppointmentsByPatientId(patient.getId());
            request.setAttribute("appointments", appointments);
            
            // Get Invoices for this patient
            List<Invoice> invoices = invoiceDAO.getByPatientId(patient.getId());
            request.setAttribute("invoices", invoices);
            
            // Note: Clinical records are usually part of the patient object or a separate DAO
            // Assuming clinical records are managed via PatientRecordDAO
            PatientRecordDAO recordDAO = new PatientRecordDAO();
            PatientRecord record = recordDAO.getByPatientId(patient.getId());
            request.setAttribute("record", record);
        }

        request.getRequestDispatcher("patient-portal.jsp").forward(request, response);
    }
}
