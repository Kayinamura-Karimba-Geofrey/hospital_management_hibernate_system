package com.example.Hospital_Management_System.servlet;

import com.example.Hospital_Management_System.dao.*;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.hibernate.Session;

import java.io.IOException;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private PatientsDAO patientsDAO;

    @Override
    public void init() {
        patientsDAO = new PatientsDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        long patientCount = patientsDAO.getAllPatients().size();
        long doctorCount = 0, nurseCount = 0, appointmentCount = 0;

        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            doctorCount = (Long) session.createQuery("select count(*) from Doctors").uniqueResult();
            nurseCount = (Long) session.createQuery("select count(*) from Nurses").uniqueResult();
            appointmentCount = (Long) session.createQuery("select count(*) from Appointments").uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("totalPatients", patientCount);
        request.setAttribute("totalDoctors", doctorCount);
        request.setAttribute("totalNurses", nurseCount);
        request.setAttribute("totalAppointments", appointmentCount);
        request.setAttribute("activeStaff", doctorCount + nurseCount);

        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}
