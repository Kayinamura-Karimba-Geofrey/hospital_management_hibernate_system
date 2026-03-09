package com.example.Hospital_Management_System.entity.util;



import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

public class HibernateUtil {
    private static final SessionFactory sessionFactory;

    static {
        try {
            Configuration cfg = new Configuration().configure();

    
            String url = System.getenv("DB_URL");
            String user = System.getenv("DB_USER");
            String pass = System.getenv("DB_PASSWORD");

            if (url != null && !url.isBlank()) {
                cfg.setProperty("hibernate.connection.url", url);
            }
            if (user != null && !user.isBlank()) {
                cfg.setProperty("hibernate.connection.username", user);
            }
            if (pass != null && !pass.isBlank()) {
                cfg.setProperty("hibernate.connection.password", pass);
            }

            sessionFactory = cfg.buildSessionFactory();
        } catch (Throwable ex) {
            throw new ExceptionInInitializerError(ex);
        }
    }

    public static SessionFactory getSessionFactory() {
        return sessionFactory;
    }
}
