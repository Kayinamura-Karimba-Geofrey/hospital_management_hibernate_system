package com.example.Hospital_Management_System.servlet;

import com.example.Hospital_Management_System.dao.DoctorDAO;
import com.example.Hospital_Management_System.dao.DepartmentDAO;
import com.example.Hospital_Management_System.entity.Doctors;
import com.example.Hospital_Management_System.entity.Department;
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

    public void init() {
        doctorDAO = new DoctorDAO();
        departmentDAO = new DepartmentDAO();
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
        int departmentId = Integer.parseInt(request.getParameter("departmentId"));

        Department dept = departmentDAO.getDepartmentById(departmentId);
        
        if (idStr != null && !idStr.isEmpty()) {
            // Update
            int id = Integer.parseInt(idStr);
            Doctors doctor = new Doctors(name, specialisation);
            doctor.setId(id);
            doctor.setDepartment(dept);
            doctorDAO.updateDoctor(doctor);
        } else {
            // Save
            Doctors doctor = new Doctors(name, specialisation);
            doctor.setDepartment(dept);
            doctorDAO.saveDoctor(doctor);
        }

        response.sendRedirect(request.getContextPath() + "/doctors");
    }
}
