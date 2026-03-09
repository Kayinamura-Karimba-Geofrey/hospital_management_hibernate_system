package com.example.Hospital_Management_System.service;

import com.example.Hospital_Management_System.entity.*;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 * Service class for handling multi-role user registration.
 * Manages the atomic creation of Users and their corresponding staff (Doctor/Nurse) or Patient entities.
 */
public class RegistrationService {
    private final UserService userService;

    public RegistrationService() {
        this.userService = new UserService();
    }

    public RegistrationService(UserService userService) {
        this.userService = userService;
    }

    /**
     * Registers a new user and their associated profile (Doctor, Nurse, or Patient).
     * @param user The core user account details.
     * @param role The role to assign (e.g., DOCTOR, PATIENT).
     * @param departmentId The ID of the department (for staff).
     * @param fullName The display name.
     * @param email The contact email.
     * @throws Exception If registration fails or email/username already exists.
     */
    public void registerUser(User user, String role, Integer departmentId, String fullName, String email) throws Exception {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            
            session.persist(user);

            if ("DOCTOR".equalsIgnoreCase(role)) {
                if (departmentId != null) {
                    Department dept = session.get(Department.class, departmentId);
                    Doctors doctor = new Doctors(fullName, "General");
                    doctor.setDepartment(dept);
                    doctor.setEmail(email);
                    session.persist(doctor);
                }
            } else if ("NURSE".equalsIgnoreCase(role)) {
                if (departmentId != null) {
                    Department dept = session.get(Department.class, departmentId);
                    Nurses nurse = new Nurses(fullName, dept);
                    nurse.setEmail(email);
                    session.persist(nurse);
                }
            } else if ("PATIENT".equalsIgnoreCase(role)) {
                Patients patient = new Patients(fullName, "Consultation", email);
                session.persist(patient);
            }

            tx.commit();
        } catch (Exception e) {
            if (tx != null && tx.isActive()) tx.rollback();
            throw e;
        }
    }
}
