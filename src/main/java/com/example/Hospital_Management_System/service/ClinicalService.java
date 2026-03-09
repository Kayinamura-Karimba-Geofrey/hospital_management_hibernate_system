package com.example.Hospital_Management_System.service;

import com.example.Hospital_Management_System.dao.LabTestDAO;
import com.example.Hospital_Management_System.dao.PatientRecordDAO;
import com.example.Hospital_Management_System.dao.PrescriptionDAO;
import com.example.Hospital_Management_System.entity.LabTest;
import com.example.Hospital_Management_System.entity.PatientRecord;
import com.example.Hospital_Management_System.entity.Prescription;
import java.util.List;

/**
 * Service class for clinical operations.
 * Manages patient records, prescriptions, and lab test results.
 */
public class ClinicalService {
    private final PatientRecordDAO recordDAO;
    private final PrescriptionDAO prescriptionDAO;
    private final LabTestDAO labTestDAO;

    public ClinicalService() {
        this.recordDAO = new PatientRecordDAO();
        this.prescriptionDAO = new PrescriptionDAO();
        this.labTestDAO = new LabTestDAO();
    }

    public PatientRecord getRecordByPatientId(int patientId) {
        return recordDAO.getByPatientId(patientId);
    }

    /**
     * Saves or updates a patient's medical record.
     * @param record The PatientRecord entity to persist.
     */
    public void saveOrUpdateRecord(PatientRecord record) {
        recordDAO.saveOrUpdate(record);
    }

    public List<Prescription> getPrescriptionsByPatientId(int patientId) {
        return prescriptionDAO.getByPatientId(patientId);
    }

    public void savePrescription(Prescription prescription) {
        prescriptionDAO.save(prescription);
    }

    public List<LabTest> getLabTestsByPatientId(int patientId) {
        return labTestDAO.getByPatientId(patientId);
    }

    public LabTest getLabTestById(int id) {
        return labTestDAO.getById(id);
    }

    public void saveOrUpdateLabTest(LabTest labTest) {
        labTestDAO.saveOrUpdate(labTest);
    }
}
