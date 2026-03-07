package com.example.Hospital_Management_System.servlet;

import com.example.Hospital_Management_System.dao.UserDAO;
import com.example.Hospital_Management_System.dao.DepartmentDAO;
import com.example.Hospital_Management_System.entity.*;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import com.example.Hospital_Management_System.service.AuditService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;

@WebServlet("/register")
public class RegistrationServlet extends HttpServlet {

    private UserDAO userDAO;
    private DepartmentDAO departmentDAO;

    public void init() {
        userDAO = new UserDAO();
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

        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
        User user = new User(username, hashedPassword, email, fullName, role);
        
        // Check if username already exists
        if (userDAO.existsByUsername(username)) {
            request.setAttribute("error", "Username already exists. Please choose another.");
            request.setAttribute("departments", departmentDAO.getAllDepartments());
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Check if email already exists
        if (userDAO.existsByEmail(email)) {
            request.setAttribute("error", "Email already exists. Please use another.");
            request.setAttribute("departments", departmentDAO.getAllDepartments());
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        Transaction tx = null;
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            tx = session.beginTransaction();
            
            System.out.println("Processing registration for: " + username + " with role: " + role);
            session.persist(user);

            if ("DOCTOR".equalsIgnoreCase(role)) {
                String deptIdStr = request.getParameter("departmentId");
                if (deptIdStr != null) {
                    int deptId = Integer.parseInt(deptIdStr);
                    Department dept = session.get(Department.class, deptId);
                    Doctors doctor = new Doctors(fullName, "General");
                    doctor.setDepartment(dept);
                    doctor.setEmail(email);
                    session.persist(doctor);
                }
            } else if ("NURSE".equalsIgnoreCase(role)) {
                String deptIdStr = request.getParameter("departmentId");
                if (deptIdStr != null) {
                    int deptId = Integer.parseInt(deptIdStr);
                    Department dept = session.get(Department.class, deptId);
                    Nurses nurse = new Nurses(fullName, dept);
                    session.persist(nurse);
                }
            } else if ("PATIENT".equalsIgnoreCase(role)) {
                Patients patient = new Patients(fullName, "Consultation", email);
                session.persist(patient);
                System.out.println("Patient persisted: " + fullName);
            }

            tx.commit();
            System.out.println("Registration transaction committed successfully.");
            AuditService.log(request.getSession(), "REGISTER", "User", username, "New " + role + " registration: " + fullName);
            response.sendRedirect(request.getContextPath() + "/registration-success.jsp");
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            e.printStackTrace();
            request.setAttribute("error", "An error occurred during registration: " + e.getMessage());
            request.setAttribute("departments", departmentDAO.getAllDepartments());
            request.getRequestDispatcher("register.jsp").forward(request, response);
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("departments", departmentDAO.getAllDepartments());
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }
}
