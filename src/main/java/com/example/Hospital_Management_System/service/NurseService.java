package com.example.Hospital_Management_System.service;

import com.example.Hospital_Management_System.dao.NurseDAO;
import com.example.Hospital_Management_System.dao.UserDAO;
import com.example.Hospital_Management_System.entity.Nurses;
import com.example.Hospital_Management_System.entity.User;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

/**
 * Service class for managing nursing staff and their associated user accounts.
 * Handles synchronization between nurse profiles and application users.
 */
public class NurseService {
    private final NurseDAO nurseDAO;
    private final UserDAO userDAO;
    private final UserService userService;

    public NurseService() {
        this.nurseDAO = new NurseDAO();
        this.userDAO = new UserDAO();
        this.userService = new UserService();
    }

    public void saveNurse(Nurses nurse) {
        nurseDAO.saveNurse(nurse);
        syncUser(nurse, null);
    }

    /**
     * Updates nurse information and synchronizes the associated user account.
     * @param nurse The nurse entity with updated info.
     * @param oldEmail The nurse's previous email (if it changed).
     */
    public void updateNurse(Nurses nurse, String oldEmail) {
        nurseDAO.updateNurse(nurse);
        syncUser(nurse, oldEmail);
    }

    /**
     * Synchronizes a nurse's profile with their system user account.
     * Creates a new user if none exists, or updates the existing one.
     */
    private void syncUser(Nurses nurse, String oldEmail) {
        String emailToFind = (oldEmail != null) ? oldEmail : nurse.getEmail();
        User user = userDAO.getUserByEmail(emailToFind);

        if (user == null) {
            // Create new user if it doesn't exist
            if (nurse.getEmail() != null && !userDAO.existsByEmail(nurse.getEmail())) {
                String hashedPassword = userService.hashPassword(nurse.getName());
                user = new User(nurse.getEmail(), hashedPassword, nurse.getEmail(), nurse.getName(), "NURSE");
                userDAO.saveUser(user);
            }
        } else {
            // Update existing user
            user.setEmail(nurse.getEmail());
            user.setFullName(nurse.getName());
            user.setUsername(nurse.getEmail());
            user.setPassword(userService.hashPassword(nurse.getName()));
            userDAO.updateUser(user);
        }
    }

    public void deleteNurse(int id) {
        Nurses nurse = nurseDAO.getNurseById(id);
        if (nurse != null) {
            String email = nurse.getEmail();
            nurseDAO.deleteNurse(id);
            User user = userDAO.getUserByEmail(email);
            if (user != null) {
                userDAO.deleteUser(user.getId());
            }
        }
    }

    public Nurses getNurseById(int id) {
        return nurseDAO.getNurseById(id);
    }

    public List<Nurses> getAllNurses() {
        return nurseDAO.getAllNurses();
    }

    public Nurses getNurseByEmail(String email) {
        return nurseDAO.getNurseByEmail(email);
    }
}
