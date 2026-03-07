package com.example.Hospital_Management_System.service;

import com.example.Hospital_Management_System.dao.*;
import com.example.Hospital_Management_System.entity.*;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.time.LocalDateTime;
import java.util.List;

public class FacilityService {
    private final WardDAO wardDAO;
    private final BedDAO bedDAO;
    private final AdmissionDAO admissionDAO;
    private final SurgeryDAO surgeryDAO;

    public FacilityService() {
        this.wardDAO = new WardDAO();
        this.bedDAO = new BedDAO();
        this.admissionDAO = new AdmissionDAO();
        this.surgeryDAO = new SurgeryDAO();
    }

    // Ward & Bed Management
    public List<Ward> getAllWards() {
        return wardDAO.getAllWards();
    }

    public Bed getBedById(Long id) {
        return bedDAO.getBedById(id);
    }

    // Admission Management
    public void admitPatient(Patients patient, Bed bed) {
        if (patient != null && bed != null && "AVAILABLE".equals(bed.getStatus())) {
            Admission admission = new Admission(patient, bed, LocalDateTime.now());
            admissionDAO.save(admission);
            bedDAO.updateBedStatus(bed.getId(), "OCCUPIED");
        }
    }

    public void dischargePatient(Long admissionId) {
        Admission admission = admissionDAO.getById(admissionId);
        if (admission != null) {
            Long bedId = admission.getBed().getId();
            admissionDAO.discharge(admissionId);
            bedDAO.updateBedStatus(bedId, "AVAILABLE");
        }
    }

    // Surgery Management
    public List<Surgery> getAllSurgeries() {
        return surgeryDAO.getAllSurgeries();
    }

    public void scheduleSurgery(Surgery surgery) {
        surgeryDAO.saveOrUpdate(surgery);
    }

    public List<Admission> getAllAdmissions() {
        return admissionDAO.getAllAdmissions();
    }
}
