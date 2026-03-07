package com.example.Hospital_Management_System.service;

import com.example.Hospital_Management_System.dao.DoctorDAO;
import com.example.Hospital_Management_System.dao.UserDAO;
import com.example.Hospital_Management_System.entity.Doctors;
import com.example.Hospital_Management_System.entity.User;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

public class DoctorService {
    private final DoctorDAO doctorDAO;
    private final UserDAO userDAO;
    private final UserService userService;

    public DoctorService() {
        this.doctorDAO = new DoctorDAO();
        this.userDAO = new UserDAO();
        this.userService = new UserService();
    }

    public void saveDoctor(Doctors doctor) {
        doctorDAO.saveDoctor(doctor);
        syncUser(doctor, null);
    }

    public void updateDoctor(Doctors doctor, String oldEmail) {
        doctorDAO.updateDoctor(doctor);
        syncUser(doctor, oldEmail);
    }

    private void syncUser(Doctors doctor, String oldEmail) {
        String emailToFind = (oldEmail != null) ? oldEmail : doctor.getEmail();
        User user = userDAO.getUserByEmail(emailToFind);

        if (user == null) {
            // Create new user if it doesn't exist
            if (!userDAO.existsByEmail(doctor.getEmail())) {
                String hashedPassword = userService.hashPassword(doctor.getName());
                user = new User(doctor.getEmail(), hashedPassword, doctor.getEmail(), doctor.getName(), "DOCTOR");
                userDAO.saveUser(user);
            }
        } else {
            // Update existing user
            user.setEmail(doctor.getEmail());
            user.setFullName(doctor.getName());
            user.setUsername(doctor.getEmail());
            user.setPassword(userService.hashPassword(doctor.getName()));
            userDAO.updateUser(user);
        }
    }

    public void deleteDoctor(int id) {
        Doctors doctor = doctorDAO.getDoctorById(id);
        if (doctor != null) {
            String email = doctor.getEmail();
            doctorDAO.deleteDoctor(id);
            User user = userDAO.getUserByEmail(email);
            if (user != null) {
                userDAO.deleteUser(user.getId());
            }
        }
    }

    public Doctors getDoctorById(int id) {
        return doctorDAO.getDoctorById(id);
    }

    public List<Doctors> getAllDoctors() {
        return doctorDAO.getAllDoctors();
    }

    public Doctors getDoctorByEmail(String email) {
        return doctorDAO.getDoctorByEmail(email);
    }
}
