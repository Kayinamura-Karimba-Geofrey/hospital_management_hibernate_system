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
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            nurseDAO.deleteNurse(id);
            response.sendRedirect(request.getContextPath() + "/nurses");
            return;
        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Nurses nurse = nurseDAO.getNurseById(id);
            request.setAttribute("editableNurse", nurse);
        }

        List<Nurses> nurses = nurseDAO.getAllNurses();
        List<Department> departments = departmentDAO.getAllDepartments();
        request.setAttribute("nurses", nurses);
        request.setAttribute("departments", departments);
        request.getRequestDispatcher("nurses.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        String name = request.getParameter("name");
        int departmentId = Integer.parseInt(request.getParameter("departmentId"));

        Department dept = departmentDAO.getDepartmentById(departmentId);
        
        if (idStr != null && !idStr.isEmpty()) {
            // Update
            int id = Integer.parseInt(idStr);
            Nurses nurse = new Nurses(name, dept);
            nurse.setId(id);
            nurseDAO.updateNurse(nurse);
        } else {
            // Save
            Nurses nurse = new Nurses(name, dept);
            nurseDAO.saveNurse(nurse);
        }

        response.sendRedirect(request.getContextPath() + "/nurses");
    }
}
