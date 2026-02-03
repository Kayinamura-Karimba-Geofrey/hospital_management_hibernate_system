package com.example.Hospital_Management_System.servlet;

import com.example.Hospital_Management_System.dao.UserDAO;
import com.example.Hospital_Management_System.dao.DepartmentDAO;
import com.example.Hospital_Management_System.entity.*;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.hibernate.Session;
import org.hibernate.Transaction;

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

        User user = new User(username, password, email, fullName, role);
        
        // Handle specific role logic
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction tx = session.beginTransaction();
            session.persist(user);

            if ("DOCTOR".equalsIgnoreCase(role)) {
                int deptId = Integer.parseInt(request.getParameter("departmentId"));
                Department dept = session.get(Department.class, deptId);
                Doctors doctor = new Doctors(fullName, "General");
                doctor.setDepartment(dept);
                session.persist(doctor);
            } else if ("NURSE".equalsIgnoreCase(role)) {
                int deptId = Integer.parseInt(request.getParameter("departmentId"));
                Department dept = session.get(Department.class, deptId);
                Nurses nurse = new Nurses(fullName, dept);
                session.persist(nurse);
            } else if ("PATIENT".equalsIgnoreCase(role)) {
                Patients patient = new Patients(fullName, "Consultation");
                session.persist(patient);
            }

            tx.commit();
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/registration-success.jsp");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("departments", departmentDAO.getAllDepartments());
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }
}
