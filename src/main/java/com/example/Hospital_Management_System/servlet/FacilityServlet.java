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

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        
        if (path.equals("/facility")) {
            List<Ward> wards = facilityService.getAllWards();
            List<Patients> patients = patientService.getAllPatients();
            request.setAttribute("wards", wards);
            request.setAttribute("patients", patients);
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
                
            } else if ("scheduleSurgery".equals(action)) {
                Surgery surgery = new Surgery();
                surgery.setPatient(patientService.getPatientById(Integer.parseInt(request.getParameter("patientId"))));
                surgery.setSurgeon(doctorService.getDoctorById(Integer.parseInt(request.getParameter("surgeonId"))));
                
                String anesthetistId = request.getParameter("anesthetistId");
                if (anesthetistId != null && !anesthetistId.isEmpty()) {
                    surgery.setAnesthetist(doctorService.getDoctorById(Integer.parseInt(anesthetistId)));
                }
                
                surgery.setOtRoomName(request.getParameter("otRoomName"));
                surgery.setSurgeryDateTime(LocalDateTime.parse(request.getParameter("dateTime")));
                surgery.setDurationMinutes(Integer.parseInt(request.getParameter("duration")));
                surgery.setEquipment(request.getParameter("equipment"));
                
                facilityService.scheduleSurgery(surgery);
                response.sendRedirect("surgery");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
