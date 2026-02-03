package com.example.Hospital_Management_System.servlet;

import com.example.Hospital_Management_System.dao.DepartmentDAO;
import com.example.Hospital_Management_System.entity.Department;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/departments")
public class DepartmentServlet extends HttpServlet {
    private DepartmentDAO departmentDAO;

    public void init() {
        departmentDAO = new DepartmentDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            departmentDAO.deleteDepartment(id);
            response.sendRedirect(request.getContextPath() + "/departments");
            return;
        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Department dept = departmentDAO.getDepartmentById(id);
            request.setAttribute("editableDept", dept);
        }

        List<Department> departments = departmentDAO.getAllDepartments();
        request.setAttribute("departments", departments);
        request.getRequestDispatcher("departments.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        String name = request.getParameter("name");
        String location = request.getParameter("location");

        if (idStr != null && !idStr.isEmpty()) {
            // Update existing
            int id = Integer.parseInt(idStr);
            Department department = new Department(name, location);
            department.setId(id);
            departmentDAO.updateDepartment(department);
        } else {
            // Save new
            Department department = new Department(name, location);
            departmentDAO.saveDepartment(department);
        }

        response.sendRedirect(request.getContextPath() + "/departments");
    }
}
