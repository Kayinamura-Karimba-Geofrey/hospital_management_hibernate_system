package com.example.Hospital_Management_System.service;

import com.example.Hospital_Management_System.dao.AuditLogDAO;
import com.example.Hospital_Management_System.entity.AuditLog;
import com.example.Hospital_Management_System.entity.User;
import jakarta.servlet.http.HttpSession;

public class AuditService {
    private static final AuditLogDAO auditLogDAO = new AuditLogDAO();

    public static void log(HttpSession session, String action, String entityName, String entityId, String details) {
        User user = (User) session.getAttribute("user");
        if (user != null) {
            AuditLog log = new AuditLog(user, action, entityName, entityId, details);
            auditLogDAO.save(log);
        }
    }
}
