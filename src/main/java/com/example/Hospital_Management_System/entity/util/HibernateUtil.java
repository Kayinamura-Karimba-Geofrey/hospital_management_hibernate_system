package com.example.Hospital_Management_System.entity.util;



import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

/**
 * Utility class for managing Hibernate SessionFactory.
 * Configures the database connection using hibernate.cfg.xml and environment variables.
 */
public class HibernateUtil {
    private static final SessionFactory sessionFactory;

    static {
        try {
            Configuration cfg = new Configuration().configure();

            String url = System.getenv("DB_URL");
            if (url == null || url.isBlank()) {
                url = System.getenv("DATABASE_URL");
            }
            String user = System.getenv("DB_USER");
            String pass = System.getenv("DB_PASSWORD");

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
                
                cfg.setProperty("hibernate.connection.url", url);
                System.out.println("Hibernate: Using cleaned DB_URL: " + url);
            }
            if (user != null && !user.isBlank()) {
                cfg.setProperty("hibernate.connection.username", user);
            }
            if (pass != null && !pass.isBlank()) {
                cfg.setProperty("hibernate.connection.password", pass);
            }

            sessionFactory = cfg.buildSessionFactory();
            System.out.println("Hibernate: SessionFactory initialized successfully.");
        } catch (Throwable ex) {
            throw new ExceptionInInitializerError(ex);
        }
    }

    /**
     * Provides the singleton SessionFactory instance.
     * @return The configured SessionFactory.
     */
    public static SessionFactory getSessionFactory() {
        return sessionFactory;
    }

    public static void shutdown() {
        if (sessionFactory != null) {
            sessionFactory.close();
        }
    }
}
