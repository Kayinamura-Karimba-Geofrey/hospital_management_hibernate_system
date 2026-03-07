package com.example.Hospital_Management_System.servlet;

import com.example.Hospital_Management_System.dao.*;
import com.example.Hospital_Management_System.entity.*;
import com.example.Hospital_Management_System.service.AuditService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/clinical")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class ClinicalServlet extends HttpServlet {
    private PatientsDAO patientsDAO;
    private PatientRecordDAO recordDAO;
    private PrescriptionDAO prescriptionDAO;

    private LabTestDAO labTestDAO;

    public void init() {
        patientsDAO = new PatientsDAO();
        recordDAO = new PatientRecordDAO();
        prescriptionDAO = new PrescriptionDAO();
        labTestDAO = new LabTestDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");

        if (idStr != null && !idStr.isEmpty()) {
            int patientId = Integer.parseInt(idStr);
            Patients patient = patientsDAO.getPatientById(patientId);
            PatientRecord record = recordDAO.getByPatientId(patientId);
            if (record == null) {
                record = new PatientRecord(patient);
            }
            List<Prescription> prescriptions = prescriptionDAO.getByPatientId(patientId);
            List<LabTest> labTests = labTestDAO.getByPatientId(patientId);

            request.setAttribute("patient", patient);
            request.setAttribute("record", record);
            request.setAttribute("prescriptions", prescriptions);
            request.setAttribute("labTests", labTests);
            request.getRequestDispatcher("patient-file.jsp").forward(request, response);
        } else if ("download".equals(request.getParameter("action"))) {
            downloadFile(request, response);
        } else {
            List<Patients> patients = patientsDAO.getAllPatients();
            request.setAttribute("patients", patients);
            request.getRequestDispatcher("clinical-records.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        int patientId = Integer.parseInt(request.getParameter("patientId"));

        String userRole = (String) request.getSession().getAttribute("role");

        if ("updateEHR".equals(action)) {
            updateEHR(request, patientId);
        } else if ("addPrescription".equals(action)) {
            if ("DOCTOR".equals(userRole) || "ADMIN".equals(userRole)) {
                addPrescription(request, patientId);
            }
        } else if ("requestLab".equals(action)) {
            if ("DOCTOR".equals(userRole) || "ADMIN".equals(userRole)) {
                requestLab(request, patientId);
            }
        } else if ("uploadLabResult".equals(action)) {
            // Lab results can be uploaded by staff (Nurses included)
            uploadLabResult(request);
        }

        response.sendRedirect(request.getContextPath() + "/clinical?id=" + patientId);
    }

    private void updateEHR(HttpServletRequest request, int patientId) {
        PatientRecord record = recordDAO.getByPatientId(patientId);
        if (record == null) {
            record = new PatientRecord(patientsDAO.getPatientById(patientId));
        }
        record.setMedicalHistory(request.getParameter("medicalHistory"));
        record.setAllergies(request.getParameter("allergies"));
        record.setBloodPressure(request.getParameter("bloodPressure"));
        record.setHeartRate(Integer.parseInt(request.getParameter("heartRate")));
        record.setTemperature(Double.parseDouble(request.getParameter("temperature")));
        record.setImmunizations(request.getParameter("immunizations"));
        
        try {
            Part filePart = request.getPart("recordFile");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = "Patient_" + patientId + "_" + System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();
                filePart.write(uploadPath + File.separator + fileName);
                record.setFilePath("uploads/" + fileName);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        recordDAO.saveOrUpdate(record);
        AuditService.log(request.getSession(), "UPDATE", "PatientRecord", String.valueOf(patientId), "Updated EHR data");
    }

    private void addPrescription(HttpServletRequest request, int patientId) {
        User user = (User) request.getSession().getAttribute("user");
        // We need a way to get the Doctor entity associated with this user
        // For now, let's assume the first doctor for simplicity if we can't find a better way
        // In a real app, User would have a link to Doctor/Nurse
        DoctorDAO doctorDAO = new DoctorDAO();
        Doctors doctor = doctorDAO.getAllDoctors().get(0); 

        Prescription p = new Prescription();
        p.setPatient(patientsDAO.getPatientById(patientId));
        p.setDoctor(doctor);
        p.setMedicationName(request.getParameter("medicationName"));
        p.setDosage(request.getParameter("dosage"));
        p.setFrequency(request.getParameter("frequency"));
        p.setInstructions(request.getParameter("instructions"));
        prescriptionDAO.save(p);
        AuditService.log(request.getSession(), "CREATE", "Prescription", String.valueOf(p.getId()), "Added prescription: " + p.getMedicationName());
    }

    private void requestLab(HttpServletRequest request, int patientId) {
        DoctorDAO doctorDAO = new DoctorDAO();
        Doctors doctor = doctorDAO.getAllDoctors().get(0);

        LabTest lt = new LabTest();
        lt.setPatient(patientsDAO.getPatientById(patientId));
        lt.setDoctor(doctor);
        lt.setTestName(request.getParameter("testName"));
        labTestDAO.saveOrUpdate(lt);
        AuditService.log(request.getSession(), "CREATE", "LabTest", String.valueOf(lt.getId()), "Requested lab test: " + lt.getTestName());
    }

    private void uploadLabResult(HttpServletRequest request) throws IOException, ServletException {
        int testId = Integer.parseInt(request.getParameter("testId"));
        LabTest lt = labTestDAO.getById(testId);
        
        Part filePart = request.getPart("resultFile");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();
            
            filePart.write(uploadPath + File.separator + fileName);
            lt.setResultFileUrl("uploads/" + fileName);
            lt.setStatus("COMPLETED");
            lt.setCompletedDate(LocalDateTime.now());
            lt.setObservations(request.getParameter("observations"));
            labTestDAO.saveOrUpdate(lt);
        }
    }

    private void downloadFile(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String filePath = request.getParameter("path");
        if (filePath == null || filePath.isEmpty()) return;

        String fullPath = getServletContext().getRealPath("") + File.separator + filePath;
        File file = new File(fullPath);
        if (!file.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        response.setContentType(getServletContext().getMimeType(fullPath));
        response.setHeader("Content-Disposition", "attachment; filename=\"" + file.getName() + "\"");
        java.nio.file.Files.copy(file.toPath(), response.getOutputStream());
    }
}
