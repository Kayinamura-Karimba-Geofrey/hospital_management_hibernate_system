package com.example.Hospital_Management_System.service;

import com.example.Hospital_Management_System.dao.PatientsDAO;
import com.example.Hospital_Management_System.dao.UserDAO;
import com.example.Hospital_Management_System.entity.Doctors;
import com.example.Hospital_Management_System.entity.Nurses;
import com.example.Hospital_Management_System.entity.Patients;
import com.example.Hospital_Management_System.entity.User;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

public class PatientService {
    private final PatientsDAO patientsDAO;
    private final UserDAO userDAO;
    private final UserService userService;

    public PatientService() {
        this.patientsDAO = new PatientsDAO();
        this.userDAO = new UserDAO();
        this.userService = new UserService();
    }

    public void savePatient(Patients patient, int doctorId, int nurseId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction tx = session.beginTransaction();
            
            Doctors doctor = session.get(Doctors.class, doctorId);
            Nurses nurse = session.get(Nurses.class, nurseId);
            
            patient.setDoctor(doctor);
            patient.setNurse(nurse);
            
            session.persist(patient);
            tx.commit();
            
            syncUser(patient, null);
        }
    }

    public void updatePatient(Patients patient, int doctorId, int nurseId, String oldEmail) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction tx = session.beginTransaction();
            
            Doctors doctor = session.get(Doctors.class, doctorId);
            Nurses nurse = session.get(Nurses.class, nurseId);
            
            patient.setDoctor(doctor);
            patient.setNurse(nurse);
            
            session.merge(patient);
            tx.commit();
            
            syncUser(patient, oldEmail);
        }
    }

    private void syncUser(Patients patient, String oldEmail) {
        String emailToFind = (oldEmail != null) ? oldEmail : patient.getEmail();
        User user = userDAO.getUserByEmail(emailToFind);

        if (user == null) {
            // Create new user if it doesn't exist
            if (patient.getEmail() != null && !userDAO.existsByEmail(patient.getEmail())) {
                String hashedPassword = userService.hashPassword(patient.getName());
                user = new User(patient.getEmail(), hashedPassword, patient.getEmail(), patient.getName(), "PATIENT");
                userDAO.saveUser(user);
            }
        } else {
            // Update existing user
            user.setEmail(patient.getEmail());
            user.setFullName(patient.getName());
            user.setUsername(patient.getEmail());
            user.setPassword(userService.hashPassword(patient.getName()));
            userDAO.updateUser(user);
        }
    }

    public void deletePatient(int id) {
        Patients patient = patientsDAO.getPatientById(id);
        if (patient != null) {
            String email = patient.getEmail();
            patientsDAO.deletePatient(id);
            User user = userDAO.getUserByEmail(email);
            if (user != null) {
                userDAO.deleteUser(user.getId());
            }
        }
    }

    public Patients getPatientById(int id) {
        return patientsDAO.getPatientById(id);
    }

    public List<Patients> getAllPatients() {
        return patientsDAO.getAllPatients();
    }

    public Patients getPatientByEmail(String email) {
        return patientsDAO.getPatientByEmail(email);
    }
}
