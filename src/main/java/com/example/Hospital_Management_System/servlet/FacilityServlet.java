package com.example.Hospital_Management_System.servlet;

import com.example.Hospital_Management_System.dao.*;
import com.example.Hospital_Management_System.entity.*;
import com.example.Hospital_Management_System.service.PatientsService;
import com.example.Hospital_Management_System.service.DoctorsService;

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
    private WardDAO wardDAO = new WardDAO();
    private BedDAO bedDAO = new BedDAO();
    private AdmissionDAO admissionDAO = new AdmissionDAO();
    private SurgeryDAO surgeryDAO = new SurgeryDAO();
    private PatientsService patientsService = new PatientsService();
    private DoctorsService doctorsService = new DoctorsService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        
        if (path.equals("/facility")) {
            List<Ward> wards = wardDAO.getAllWards();
            List<Patients> patients = patientsService.getAllPatients();
            request.setAttribute("wards", wards);
            request.setAttribute("patients", patients);
            request.getRequestDispatcher("facility.jsp").forward(request, response);
        } else if (path.equals("/surgery")) {
            List<Surgery> surgeries = surgeryDAO.getAllSurgeries();
            List<Patients> patients = patientsService.getAllPatients();
            List<Doctors> doctors = doctorsService.getAllDoctors();
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
                
                Patients patient = patientsService.getPatientById(patientId);
                Bed bed = bedDAO.getBedById(bedId);
                
                if (patient != null && bed != null && "AVAILABLE".equals(bed.getStatus())) {
                    Admission admission = new Admission(patient, bed, LocalDateTime.now());
                    admissionDAO.save(admission);
                    bedDAO.updateBedStatus(bedId, "OCCUPIED");
                }
                response.sendRedirect("facility");
                
            } else if ("discharge".equals(action)) {
                Long admissionId = Long.parseLong(request.getParameter("admissionId"));
                admissionDAO.discharge(admissionId);
                response.sendRedirect("facility");
                
            } else if ("scheduleSurgery".equals(action)) {
                Surgery surgery = new Surgery();
                surgery.setPatient(patientsService.getPatientById(Integer.parseInt(request.getParameter("patientId"))));
                surgery.setSurgeon(doctorsService.getDoctorById(Integer.parseInt(request.getParameter("surgeonId"))));
                
                String anesthetistId = request.getParameter("anesthetistId");
                if (anesthetistId != null && !anesthetistId.isEmpty()) {
                    surgery.setAnesthetist(doctorsService.getDoctorById(Integer.parseInt(anesthetistId)));
                }
                
                surgery.setOtRoomName(request.getParameter("otRoomName"));
                surgery.setSurgeryDateTime(LocalDateTime.parse(request.getParameter("dateTime")));
                surgery.setDurationMinutes(Integer.parseInt(request.getParameter("duration")));
                surgery.setEquipment(request.getParameter("equipment"));
                
                surgeryDAO.saveOrUpdate(surgery);
                response.sendRedirect("surgery");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
