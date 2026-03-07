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
import java.util.List;

@WebServlet("/patient-portal")
public class PatientPortalServlet extends HttpServlet {

    private PatientService patientService;
    private AppointmentService appointmentService;
    private FinancialService financialService;
    private ClinicalService clinicalService;

    @Override
    public void init() {
        patientService = new PatientService();
        appointmentService = new AppointmentService();
        financialService = new FinancialService();
        clinicalService = new ClinicalService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"PATIENT".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Link User to Patient by Email
        Patients patient = patientService.getPatientByEmail(user.getEmail());

        if (patient != null) {
            request.setAttribute("patient", patient);
            
            // Get Appointments for this patient
            List<Appointments> appointments = appointmentService.getAppointmentsByPatientId(patient.getId());
            request.setAttribute("appointments", appointments);
            
            // Get Invoices for this patient
            List<Invoice> invoices = financialService.getInvoicesByPatientId(patient.getId());
            request.setAttribute("invoices", invoices);
            
            // Get Medical Record
            PatientRecord record = clinicalService.getRecordByPatientId(patient.getId());
            request.setAttribute("record", record);
        }

        request.getRequestDispatcher("patient-portal.jsp").forward(request, response);
    }
}
