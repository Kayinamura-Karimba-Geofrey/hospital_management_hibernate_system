package com.example.Hospital_Management_System.service;

import com.example.Hospital_Management_System.dao.UserDAO;
import com.example.Hospital_Management_System.entity.User;
import org.mindrot.jbcrypt.BCrypt;

/**
 * Service class for management of system users.
 * Handles password hashing, credential verification, and account existence checks.
 */
public class UserService {
    private final UserDAO userDAO;

    public UserService() {
        this.userDAO = new UserDAO();
    }

    public UserService(UserDAO userDAO) {
        this.userDAO = userDAO;
    }

    /**
     * Hashes a raw password using BCrypt.
     * @param password The raw password string.
     * @return The resulting hashed password.
     */
    public String hashPassword(String password) {
        return BCrypt.hashpw(password, BCrypt.gensalt());
    }

    public boolean checkPassword(String password, String hashedPassword) {
        return BCrypt.checkpw(password, hashedPassword);
    }

    public boolean existsByUsername(String username) {
        return userDAO.existsByUsername(username);
    }

    public boolean existsByEmail(String email) {
        return userDAO.existsByEmail(email);
    }

    public void save(User user) {
        userDAO.saveUser(user);
    }
}
