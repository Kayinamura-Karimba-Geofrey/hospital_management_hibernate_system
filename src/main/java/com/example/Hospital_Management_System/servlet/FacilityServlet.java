package com.example.Hospital_Management_System.servlet;

import com.example.Hospital_Management_System.entity.*;
import com.example.Hospital_Management_System.service.PatientService;
import com.example.Hospital_Management_System.service.DoctorService;
import com.example.Hospital_Management_System.service.FacilityService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Servlet for managing hospital facilities and surgeries.
 * Maps to multiple endpoints: /facility for ward/bed management and /surgery for scheduling.
 */
@WebServlet(name = "FacilityServlet", urlPatterns = {"/facility", "/surgery"})
public class FacilityServlet extends HttpServlet {
    private FacilityService facilityService;
    private PatientService patientService;
    private DoctorService doctorService;

    public void init() {
        facilityService = new FacilityService();
        patientService = new PatientService();
        doctorService = new DoctorService();
    }

    /**
     * Handles GET requests for facility or surgery views based on the servlet path.
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        
        if (path.equals("/facility")) {
            List<Ward> wards = facilityService.getAllWards();
            List<Patients> patients = patientService.getAllPatients();
            List<Admission> activeAdmissions = facilityService.getActiveAdmissions();
            request.setAttribute("wards", wards);
            request.setAttribute("patients", patients);
            request.setAttribute("activeAdmissions", activeAdmissions);
            request.getRequestDispatcher("facility.jsp").forward(request, response);
        } else if (path.equals("/surgery")) {
            List<Surgery> surgeries = facilityService.getAllSurgeries();
            List<Patients> patients = patientService.getAllPatients();
            List<Doctors> doctors = doctorService.getAllDoctors();
            request.setAttribute("surgeries", surgeries);
            request.setAttribute("patients", patients);
            request.setAttribute("doctors", doctors);
            request.getRequestDispatcher("surgery-schedule.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("admit".equals(action)) {
                int patientId = Integer.parseInt(request.getParameter("patientId"));
                Long bedId = Long.parseLong(request.getParameter("bedId"));
                
                Patients patient = patientService.getPatientById(patientId);
                Bed bed = facilityService.getBedById(bedId);
                
                facilityService.admitPatient(patient, bed);
                response.sendRedirect("facility");
                
            } else if ("discharge".equals(action)) {
                Long admissionId = Long.parseLong(request.getParameter("admissionId"));
                facilityService.dischargePatient(admissionId);
                response.sendRedirect("facility");
                
            } else if ("markReady".equals(action)) {
                Long bedId = Long.parseLong(request.getParameter("bedId"));
                com.example.Hospital_Management_System.dao.BedDAO bedDAO = new com.example.Hospital_Management_System.dao.BedDAO();
                bedDAO.updateBedStatus(bedId, "AVAILABLE");
                response.sendRedirect("facility");

            } else if ("scheduleSurgery".equals(action)) {
                saveOrUpdateSurgery(request);
                response.sendRedirect("surgery");

            } else if ("deleteSurgery".equals(action)) {
                Long surgeryId = Long.parseLong(request.getParameter("surgeryId"));
                facilityService.deleteSurgery(surgeryId);
                response.sendRedirect("surgery");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    private void saveOrUpdateSurgery(HttpServletRequest request) {
        String idStr = request.getParameter("surgeryId");
        Surgery surgery = null;
        
        if (idStr != null && !idStr.isEmpty()) {
            surgery = new com.example.Hospital_Management_System.dao.SurgeryDAO().getById(Integer.parseInt(idStr));
        }
        
        if (surgery == null) {
            surgery = new Surgery();
        }

        surgery.setPatient(patientService.getPatientById(Integer.parseInt(request.getParameter("patientId"))));
        surgery.setSurgeon(doctorService.getDoctorById(Integer.parseInt(request.getParameter("surgeonId"))));
        
        String anesthetistId = request.getParameter("anesthetistId");
        if (anesthetistId != null && !anesthetistId.isEmpty()) {
            surgery.setAnesthetist(doctorService.getDoctorById(Integer.parseInt(anesthetistId)));
        } else {
            surgery.setAnesthetist(null);
        }
        
        surgery.setOtRoomName(request.getParameter("otRoomName"));
        surgery.setSurgeryDateTime(LocalDateTime.parse(request.getParameter("dateTime")));
        surgery.setDurationMinutes(Integer.parseInt(request.getParameter("duration")));
        surgery.setEquipment(request.getParameter("equipment"));
        
        facilityService.scheduleSurgery(surgery);
    }
}
