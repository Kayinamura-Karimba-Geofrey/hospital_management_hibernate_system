package com.example.Hospital_Management_System.listener;

import com.example.Hospital_Management_System.dao.DepartmentDAO;
import com.example.Hospital_Management_System.dao.UserDAO;
import com.example.Hospital_Management_System.entity.Department;
import com.example.Hospital_Management_System.entity.User;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.util.List;
import org.mindrot.jbcrypt.BCrypt;

/**
 * Servlet Context Listener for database initialization and data seeding.
 * Executes Flyway migrations and seeds default admin and departments on application startup.
 */
@WebListener
public class DBInitializer implements ServletContextListener {

    /**
     * Called when the servlet context is initialized.
     * Triggers database migrations and default data setup.
     */
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("Initializing Database and running migrations...");
        
        // 1. Run Flyway Migrations
        try {
            String url = System.getenv("DB_URL");
            if (url == null || url.isBlank()) {
                url = System.getenv("DATABASE_URL");
            }

            if (url != null && !url.isBlank()) {
                url = url.trim();
                
                // Remove 'psql ' prefix if present
                if (url.toLowerCase().startsWith("psql ")) {
                    url = url.substring(5).trim();
                }
                
                // Remove surrounding quotes if present
                if ((url.startsWith("'") && url.endsWith("'")) || (url.startsWith("\"") && url.endsWith("\""))) {
                    url = url.substring(1, url.length() - 1).trim();
                }

                // Standardize as JDBC URL
                if (url.startsWith("postgres://")) {
                    url = url.replaceFirst("postgres://", "jdbc:postgresql://");
                } else if (url.startsWith("postgresql://")) {
                    url = url.replaceFirst("postgresql://", "jdbc:postgresql://");
                }
            }
            
            String user = System.getenv("DB_USER");
            String pass = System.getenv("DB_PASSWORD");

            // Fallback for local development if env vars are missing
            if (url == null || url.isBlank()) url = "jdbc:postgresql://localhost:5432/hospital_db";
            if (user == null) user = "postgres";
            if (pass == null) pass = "123";

            System.out.println("Running Flyway migrations with URL: " + url);
            org.flywaydb.core.Flyway flyway = org.flywaydb.core.Flyway.configure()
                .dataSource(url, user, pass)
                .baselineOnMigrate(true)
                .load();
            flyway.migrate();
            System.out.println("Flyway migrations applied successfully.");
        } catch (Exception e) {
            System.err.println("Flyway migration failed: " + e.getMessage());
            e.printStackTrace();
        }

        // 2. Initialize Default Data (Wrapped in try-catch to prevent context failure)
        try {
            initializeDefaultAdmin();
            System.out.println("DBInitializer: Default admin check complete.");
            initializeDefaultDepartments();
            System.out.println("DBInitializer: Default departments check complete.");
        } catch (Exception e) {
            System.err.println("DBInitializer: Default data seeding failed: " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("DBInitializer: initialization complete.");
    }

    private void initializeDefaultAdmin() {
        UserDAO userDAO = new UserDAO();
        User admin = userDAO.getUserByEmail("geofreykayin@gmail.com");
        if (admin == null) {
            System.out.println("Seeding admin user...");
            String hashedPass = BCrypt.hashpw("geo654", BCrypt.gensalt());
            admin = new User("geofrey", hashedPass, "geofreykayin@gmail.com", "Geofrey", "ADMIN");
            userDAO.saveUser(admin);
            System.out.println("Admin user seeded.");
        } else if ("geo654".equals(admin.getPassword())) {
            System.out.println("Migrating plain-text admin password...");
            admin.setPassword(BCrypt.hashpw("geo654", BCrypt.gensalt()));
            userDAO.updateUser(admin);
            System.out.println("Admin password migrated.");
        }
    }

    private void initializeDefaultDepartments() {
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
        
    }
}
