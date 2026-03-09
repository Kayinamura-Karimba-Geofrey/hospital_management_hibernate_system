package com.example.Hospital_Management_System.servlet;

import com.example.Hospital_Management_System.dao.DepartmentDAO;
import com.example.Hospital_Management_System.entity.*;
import com.example.Hospital_Management_System.service.AuditService;
import com.example.Hospital_Management_System.service.RegistrationService;
import com.example.Hospital_Management_System.service.UserService;
import com.example.Hospital_Management_System.service.ValidationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/register")
public class RegistrationServlet extends HttpServlet {

    private UserService userService;
    private RegistrationService registrationService;
    private DepartmentDAO departmentDAO;

    public void init() {
        userService = new UserService();
        registrationService = new RegistrationService(userService);
        departmentDAO = new DepartmentDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String role = request.getParameter("role");
        User currentUser = (User) request.getSession().getAttribute("user");
        String currentRole = (String) request.getSession().getAttribute("role");

        // RBAC: Only ADMIN can register STAFF (Doctor, Nurse, Accountant)
        if (!"PATIENT".equalsIgnoreCase(role)) {
            if (currentUser == null || !"ADMIN".equalsIgnoreCase(currentRole)) {
                request.setAttribute("error", "Unauthorized: Only Administrators can register staff members.");
                request.setAttribute("departments", departmentDAO.getAllDepartments());
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
        }

        // Server-side validation
        if (!ValidationService.isValidEmail(email)) {
            request.setAttribute("error", "Invalid email format.");
            request.setAttribute("departments", departmentDAO.getAllDepartments());
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (!ValidationService.isStrongPassword(password)) {
            request.setAttribute("error", ValidationService.getPasswordStrengthRequirement());
            request.setAttribute("departments", departmentDAO.getAllDepartments());
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Advanced reCAPTCHA v3 Validation
        String recaptchaToken = request.getParameter("g-recaptcha-response");
        boolean isHuman = com.example.Hospital_Management_System.service.ReCaptchaService.verify(recaptchaToken);
        if (!isHuman) {
            request.setAttribute("error", "Security check failed. Our systems flagged this registration attempt as automated bot activity. If you're a human, please try again.");
            request.setAttribute("departments", departmentDAO.getAllDepartments());
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Check if username already exists
        if (userService.existsByUsername(username)) {
            request.setAttribute("error", "Username already exists. Please choose another.");
            request.setAttribute("departments", departmentDAO.getAllDepartments());
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Check if email already exists
        if (userService.existsByEmail(email)) {
            request.setAttribute("error", "Email already exists. Please use another.");
            request.setAttribute("departments", departmentDAO.getAllDepartments());
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        try {
            String hashedPassword = userService.hashPassword(password);
            User user = new User(username, hashedPassword, email, fullName, role);
            
            Integer departmentId = null;
            String deptIdStr = request.getParameter("departmentId");
            if (deptIdStr != null && !deptIdStr.isEmpty()) {
                departmentId = Integer.parseInt(deptIdStr);
            }

            registrationService.registerUser(user, role, departmentId, fullName, email);
            
            AuditService.log(request.getSession(), "REGISTER", "User", username, "New " + role + " registration: " + fullName);
            response.sendRedirect(request.getContextPath() + "/registration-success.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred during registration: " + e.getMessage());
            request.setAttribute("departments", departmentDAO.getAllDepartments());
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("departments", departmentDAO.getAllDepartments());
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }
}
