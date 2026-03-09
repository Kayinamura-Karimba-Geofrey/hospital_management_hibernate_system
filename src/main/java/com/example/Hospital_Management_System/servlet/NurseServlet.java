package com.example.Hospital_Management_System.servlet;

import com.example.Hospital_Management_System.dao.DepartmentDAO;
import com.example.Hospital_Management_System.entity.Nurses;
import com.example.Hospital_Management_System.entity.Department;
import com.example.Hospital_Management_System.service.NurseService;
import com.example.Hospital_Management_System.service.AuditService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Servlet for managing nursing staff profiles.
 * Handles registration, profile updates, and nurse deletions.
 */
@WebServlet("/nurses")
public class NurseServlet extends HttpServlet {
    private NurseService nurseService;
    private DepartmentDAO departmentDAO;

    public void init() {
        nurseService = new NurseService();
        departmentDAO = new DepartmentDAO();
    }

    /**
     * Handles GET requests to list nurses and departments.
     * Prepares data for the nurse management interface.
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            nurseService.deleteNurse(id);
            AuditService.log(request.getSession(), "DELETE", "Nurse", String.valueOf(id), "Deleted nurse with ID: " + id);
            response.sendRedirect(request.getContextPath() + "/nurses");
            return;
        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Nurses nurse = nurseService.getNurseById(id);
            request.setAttribute("editableNurse", nurse);
        }

        List<Nurses> nurses = nurseService.getAllNurses();
        List<Department> departments = departmentDAO.getAllDepartments();
        request.setAttribute("nurses", nurses);
        request.setAttribute("departments", departments);
        request.getRequestDispatcher("nurses.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        int departmentId = Integer.parseInt(request.getParameter("departmentId"));

        Department dept = departmentDAO.getDepartmentById(departmentId);
        Nurses nurse = new Nurses(name, dept);
        nurse.setEmail(email);
        
        if (idStr != null && !idStr.isEmpty()) {
            // Update
            int id = Integer.parseInt(idStr);
            Nurses oldNurse = nurseService.getNurseById(id);
            String oldEmail = (oldNurse != null) ? oldNurse.getEmail() : null;
            
            nurse.setId(id);
            nurseService.updateNurse(nurse, oldEmail);
            AuditService.log(request.getSession(), "UPDATE", "Nurse", idStr, "Updated nurse: " + name + " (" + email + ")");
        } else {
            // Save
            nurseService.saveNurse(nurse);
            AuditService.log(request.getSession(), "CREATE", "Nurse", String.valueOf(nurse.getId()), "Created new nurse: " + name + " (" + email + ")");
        }

        response.sendRedirect(request.getContextPath() + "/nurses");
    }
}
