package com.example.Hospital_Management_System.servlet;

import com.example.Hospital_Management_System.dao.DoctorDAO;
import com.example.Hospital_Management_System.dao.DepartmentDAO;
import com.example.Hospital_Management_System.dao.UserDAO;
import com.example.Hospital_Management_System.entity.Doctors;
import com.example.Hospital_Management_System.entity.Department;
import com.example.Hospital_Management_System.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/doctors")
public class DoctorServlet extends HttpServlet {
    private DoctorDAO doctorDAO;
    private DepartmentDAO departmentDAO;
    private UserDAO userDAO;

    public void init() {
        doctorDAO = new DoctorDAO();
        departmentDAO = new DepartmentDAO();
        userDAO = new UserDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            doctorDAO.deleteDoctor(id);
            response.sendRedirect(request.getContextPath() + "/doctors");
            return;
        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Doctors doctor = doctorDAO.getDoctorById(id);
            request.setAttribute("editableDoc", doctor);
        }

        List<Doctors> doctors = doctorDAO.getAllDoctors();
        List<Department> departments = departmentDAO.getAllDepartments();
        request.setAttribute("doctors", doctors);
        request.setAttribute("departments", departments);
        request.getRequestDispatcher("doctors.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        String name = request.getParameter("name");
        String specialisation = request.getParameter("specialisation");
        String email = request.getParameter("email");
        int departmentId = Integer.parseInt(request.getParameter("departmentId"));

        Department dept = departmentDAO.getDepartmentById(departmentId);
        
        if (idStr != null && !idStr.isEmpty()) {
            // Update
            int id = Integer.parseInt(idStr);
            Doctors oldDoc = doctorDAO.getDoctorById(id);
            String oldEmail = oldDoc.getEmail();

            Doctors doctor = new Doctors(name, specialisation);
            doctor.setId(id);
            doctor.setDepartment(dept);
            doctor.setEmail(email);
            doctorDAO.updateDoctor(doctor);

            // Sync User
            User user = userDAO.getUserByEmail(oldEmail);
            if (user != null) {
                user.setEmail(email);
                user.setFullName(name);
                user.setUsername(email);
                user.setPassword(name); // Specific request: password to be name
                userDAO.updateUser(user);
            }
        } else {
            // Save
            Doctors doctor = new Doctors(name, specialisation);
            doctor.setDepartment(dept);
            doctor.setEmail(email);
            doctorDAO.saveDoctor(doctor);

            // Create User
            if (!userDAO.existsByEmail(email)) {
                User user = new User(email, name, email, name, "DOCTOR");
                userDAO.saveUser(user);
            }
        }

        response.sendRedirect(request.getContextPath() + "/doctors");
    }
}
