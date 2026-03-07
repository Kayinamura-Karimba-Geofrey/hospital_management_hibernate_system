package com.example.Hospital_Management_System.servlet;

import com.example.Hospital_Management_System.entity.*;
import com.example.Hospital_Management_System.service.AuditService;
import com.example.Hospital_Management_System.service.ClinicalService;
import com.example.Hospital_Management_System.service.DoctorService;
import com.example.Hospital_Management_System.service.PatientService;
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
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2,
                 maxFileSize = 1024 * 1024 * 10,
                 maxRequestSize = 1024 * 1024 * 50)
public class ClinicalServlet extends HttpServlet {
    private ClinicalService clinicalService;
    private PatientService patientService;
    private DoctorService doctorService;

    public void init() {
        clinicalService = new ClinicalService();
        patientService = new PatientService();
        doctorService = new DoctorService();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");

        if (idStr != null && !idStr.isEmpty()) {
            int patientId = Integer.parseInt(idStr);
            Patients patient = patientService.getPatientById(patientId);
            PatientRecord record = clinicalService.getRecordByPatientId(patientId);
            if (record == null) {
                record = new PatientRecord(patient);
            }
            List<Prescription> prescriptions = clinicalService.getPrescriptionsByPatientId(patientId);
            List<LabTest> labTests = clinicalService.getLabTestsByPatientId(patientId);

            request.setAttribute("patient", patient);
            request.setAttribute("record", record);
            request.setAttribute("prescriptions", prescriptions);
            request.setAttribute("labTests", labTests);
            request.getRequestDispatcher("patient-file.jsp").forward(request, response);
        } else if ("download".equals(request.getParameter("action"))) {
            downloadFile(request, response);
        } else {
            List<Patients> patients = patientService.getAllPatients();
            request.setAttribute("patients", patients);
            request.getRequestDispatcher("clinical-records.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String patientIdStr = request.getParameter("patientId");
        if (patientIdStr == null) {
             response.sendRedirect(request.getContextPath() + "/clinical");
             return;
        }
        int patientId = Integer.parseInt(patientIdStr);
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
            uploadLabResult(request);
        }

        response.sendRedirect(request.getContextPath() + "/clinical?id=" + patientId);
    }

    private void updateEHR(HttpServletRequest request, int patientId) {
        PatientRecord record = clinicalService.getRecordByPatientId(patientId);
        if (record == null) {
            record = new PatientRecord(patientService.getPatientById(patientId));
        }
        record.setMedicalHistory(request.getParameter("medicalHistory"));
        record.setAllergies(request.getParameter("allergies"));
        record.setBloodPressure(request.getParameter("bloodPressure"));
        
        String hrStr = request.getParameter("heartRate");
        if (hrStr != null && !hrStr.isEmpty()) record.setHeartRate(Integer.parseInt(hrStr));
        
        String tempStr = request.getParameter("temperature");
        if (tempStr != null && !tempStr.isEmpty()) record.setTemperature(Double.parseDouble(tempStr));
        
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

        clinicalService.saveOrUpdateRecord(record);
        AuditService.log(request.getSession(), "UPDATE", "PatientRecord", String.valueOf(patientId), "Updated EHR data");
    }

    private void addPrescription(HttpServletRequest request, int patientId) {
        List<Doctors> doctors = doctorService.getAllDoctors();
        if (doctors.isEmpty()) return;
        
        Doctors doctor = doctors.get(0); 
        Prescription p = new Prescription();
        p.setPatient(patientService.getPatientById(patientId));
        p.setDoctor(doctor);
        p.setMedicationName(request.getParameter("medicationName"));
        p.setDosage(request.getParameter("dosage"));
        p.setFrequency(request.getParameter("frequency"));
        p.setInstructions(request.getParameter("instructions"));
        clinicalService.savePrescription(p);
        AuditService.log(request.getSession(), "CREATE", "Prescription", String.valueOf(p.getId()), "Added prescription: " + p.getMedicationName());
    }

    private void requestLab(HttpServletRequest request, int patientId) {
        List<Doctors> doctors = doctorService.getAllDoctors();
        if (doctors.isEmpty()) return;
        
        Doctors doctor = doctors.get(0);
        LabTest lt = new LabTest();
        lt.setPatient(patientService.getPatientById(patientId));
        lt.setDoctor(doctor);
        lt.setTestName(request.getParameter("testName"));
        clinicalService.saveOrUpdateLabTest(lt);
        AuditService.log(request.getSession(), "CREATE", "LabTest", String.valueOf(lt.getId()), "Requested lab test: " + lt.getTestName());
    }

    private void uploadLabResult(HttpServletRequest request) throws IOException, ServletException {
        String testIdStr = request.getParameter("testId");
        if (testIdStr == null || testIdStr.isEmpty()) return;
        
        int testId = Integer.parseInt(testIdStr);
        LabTest lt = clinicalService.getLabTestById(testId);
        if (lt == null) return;
        
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
            clinicalService.saveOrUpdateLabTest(lt);
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
