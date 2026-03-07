package com.example.Hospital_Management_System.servlet;

import com.example.Hospital_Management_System.dao.DoctorDAO;
import com.example.Hospital_Management_System.dao.NurseDAO;
import com.example.Hospital_Management_System.entity.Patients;
import com.example.Hospital_Management_System.entity.Doctors;
import com.example.Hospital_Management_System.entity.Nurses;
import com.example.Hospital_Management_System.service.AuditService;
import com.example.Hospital_Management_System.service.PatientService;
import com.example.Hospital_Management_System.service.ValidationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/patients")
public class PatientServlet extends HttpServlet {
    private PatientService patientService;
    private DoctorDAO doctorDAO;
    private NurseDAO nurseDAO;

    public void init() {
        patientService = new PatientService();
        doctorDAO = new DoctorDAO();
        nurseDAO = new NurseDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            patientService.deletePatient(id);
            AuditService.log(request.getSession(), "DELETE", "Patients", String.valueOf(id), "Deleted patient record");
            response.sendRedirect(request.getContextPath() + "/patients");
            return;
        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Patients patient = patientService.getPatientById(id);
            request.setAttribute("editablePatient", patient);
        }

        List<Patients> patients = patientService.getAllPatients();
        List<Doctors> doctors = doctorDAO.getAllDoctors();
        List<Nurses> nurses = nurseDAO.getAllNurses();
        request.setAttribute("patients", patients);
        request.setAttribute("doctors", doctors);
        request.setAttribute("nurses", nurses);
        request.getRequestDispatcher("patients.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        String name = request.getParameter("name");
        String disease = request.getParameter("disease");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        int doctorId = Integer.parseInt(request.getParameter("doctorId"));
        int nurseId = Integer.parseInt(request.getParameter("nurseId"));

        // Validation
        if (!ValidationService.isValidEmail(email)) {
             request.setAttribute("error", "Invalid email format.");
             doGet(request, response);
             return;
        }
        if (!ValidationService.isValidPhone(phone)) {
             request.setAttribute("error", "Invalid phone number format.");
             doGet(request, response);
             return;
        }

        Patients patient = new Patients(name, disease, email);
        patient.setPhone(phone);
        
        if (idStr != null && !idStr.isEmpty()) {
            // Update
            int id = Integer.parseInt(idStr);
            Patients oldPatient = patientService.getPatientById(id);
            String oldEmail = (oldPatient != null) ? oldPatient.getEmail() : null;
            
            patient.setId(id);
            patientService.updatePatient(patient, doctorId, nurseId, oldEmail);
            AuditService.log(request.getSession(), "UPDATE", "Patients", idStr, "Updated patient details: " + name);
        } else {
            // Save
            patientService.savePatient(patient, doctorId, nurseId);
            AuditService.log(request.getSession(), "CREATE", "Patients", String.valueOf(patient.getId()), "Created new patient: " + name);
        }

        response.sendRedirect(request.getContextPath() + "/patients");
    }
}
