package com.example.Hospital_Management_System.servlet;

import com.example.Hospital_Management_System.dao.NurseDAO;
import com.example.Hospital_Management_System.dao.DepartmentDAO;
import com.example.Hospital_Management_System.entity.Nurses;
import com.example.Hospital_Management_System.entity.Department;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/nurses")
public class NurseServlet extends HttpServlet {
    private NurseDAO nurseDAO;
    private DepartmentDAO departmentDAO;

    public void init() {
        nurseDAO = new NurseDAO();
        departmentDAO = new DepartmentDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Nurses> nurses = nurseDAO.getAllNurses();
        List<Department> departments = departmentDAO.getAllDepartments();
        request.setAttribute("nurses", nurses);
        request.setAttribute("departments", departments);
        request.getRequestDispatcher("nurses.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        int departmentId = Integer.parseInt(request.getParameter("departmentId"));

        Department dept = departmentDAO.getDepartmentById(departmentId);
        Nurses nurse = new Nurses(name, dept);
        
        nurseDAO.saveNurse(nurse);

        response.sendRedirect(request.getContextPath() + "/nurses");
    }
}
