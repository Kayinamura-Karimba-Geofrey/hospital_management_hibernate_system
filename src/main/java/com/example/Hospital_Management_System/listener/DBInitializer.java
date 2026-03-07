package com.example.Hospital_Management_System.listener;

import com.example.Hospital_Management_System.dao.DepartmentDAO;
import com.example.Hospital_Management_System.entity.Department;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.util.List;

@WebListener
public class DBInitializer implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        DepartmentDAO departmentDAO = new DepartmentDAO();
        List<Department> existing = departmentDAO.getAllDepartments();

        if (existing == null || existing.isEmpty()) {
            System.out.println("Seeding default departments...");
            departmentDAO.saveDepartment(new Department("Cardiology", "Block A, Floor 1"));
            departmentDAO.saveDepartment(new Department("Pediatrics", "Block B, Floor 2"));
            departmentDAO.saveDepartment(new Department("Neurology", "Block A, Floor 3"));
            departmentDAO.saveDepartment(new Department("Emergency", "Ground Floor, Entrance"));
            departmentDAO.saveDepartment(new Department("Radiology", "Basement 1"));
            departmentDAO.saveDepartment(new Department("General Medicine", "Block C, Floor 1"));
            System.out.println("Seeding complete.");
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Cleanup if needed
    }
}
