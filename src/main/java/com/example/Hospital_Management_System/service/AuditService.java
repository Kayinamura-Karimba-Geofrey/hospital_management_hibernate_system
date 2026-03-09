package com.example.Hospital_Management_System.service;

import com.example.Hospital_Management_System.dao.AuditLogDAO;
import com.example.Hospital_Management_System.entity.AuditLog;
import com.example.Hospital_Management_System.entity.User;
import jakarta.servlet.http.HttpSession;

/**
 * Service class for handling system audit logging.
 * Provides static methods to log user actions across the application.
 */
public class AuditService {
    private static final AuditLogDAO auditLogDAO = new AuditLogDAO();

    /**
     * Logs a user action to the audit database.
     * @param session The current HTTP session to identify the logged-in user.
     * @param action The type of action performed (e.g., CREATE, UPDATE).
     * @param entityName The name of the affected entity.
     * @param entityId The ID of the affected entity.
     * @param details Additional descriptive details about the action.
     */
    public static void log(HttpSession session, String action, String entityName, String entityId, String details) {
        User user = (User) session.getAttribute("user");
        if (user != null) {
            AuditLog log = new AuditLog(user, action, entityName, entityId, details);
            auditLogDAO.save(log);
        }
    }
}
