package com.example.Hospital_Management_System.servlet;

import com.example.Hospital_Management_System.dao.DepartmentDAO;
import com.example.Hospital_Management_System.entity.Doctors;
import com.example.Hospital_Management_System.entity.Department;
import com.example.Hospital_Management_System.service.AuditService;
import com.example.Hospital_Management_System.service.DoctorService;
import com.example.Hospital_Management_System.service.ValidationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/doctors")
public class DoctorServlet extends HttpServlet {
    private DoctorService doctorsService;
    private DepartmentDAO departmentDAO;

    public void init() {
        doctorsService = new DoctorService();
        departmentDAO = new DepartmentDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            doctorsService.deleteDoctor(id);
            AuditService.log(request.getSession(), "DELETE", "Doctor", String.valueOf(id), "Deleted doctor with ID: " + id);
            response.sendRedirect(request.getContextPath() + "/doctors");
            return;
        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Doctors doctor = doctorsService.getDoctorById(id);
            request.setAttribute("editableDoc", doctor);
        }

        List<Doctors> doctors = doctorsService.getAllDoctors();
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
        String phone = request.getParameter("phone");
        String deptIdParam = request.getParameter("departmentId");

        if (deptIdParam == null || deptIdParam.isEmpty()) {
            request.setAttribute("error", "Department is required.");
            doGet(request, response);
            return;
        }
        int departmentId = Integer.parseInt(deptIdParam);

        // Validation
        if (!ValidationService.isValidEmail(email)) {
            request.setAttribute("error", "Invalid email format.");
            doGet(request, response);
            return;
        }
        if (!ValidationService.isValidPhone(phone)) {
            request.setAttribute("error", "Invalid phone number format.");
            doGet(request, response);
            return;
        }

        Department dept = departmentDAO.getDepartmentById(departmentId);
        Doctors doctor = new Doctors(name, specialisation);
        doctor.setDepartment(dept);
        doctor.setEmail(email);
        doctor.setPhone(phone);
        
        if (idStr != null && !idStr.isEmpty()) {
            // Update
            int id = Integer.parseInt(idStr);
            Doctors oldDoc = doctorsService.getDoctorById(id);
            String oldEmail = (oldDoc != null) ? oldDoc.getEmail() : null;
            
            doctor.setId(id);
            doctorsService.updateDoctor(doctor, oldEmail);
            AuditService.log(request.getSession(), "UPDATE", "Doctor", idStr, "Updated doctor: " + name + " (" + email + ")");
        } else {
            // Save
            doctorsService.saveDoctor(doctor);
            AuditService.log(request.getSession(), "CREATE", "Doctor", String.valueOf(doctor.getId()), "Created new doctor: " + name + " (" + email + ")");
        }

        response.sendRedirect(request.getContextPath() + "/doctors");
    }
}
