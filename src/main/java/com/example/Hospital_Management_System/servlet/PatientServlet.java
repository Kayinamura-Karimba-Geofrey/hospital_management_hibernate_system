package com.example.Hospital_Management_System.servlet;

import com.example.Hospital_Management_System.dao.PatientsDAO;
import com.example.Hospital_Management_System.dao.DoctorDAO;
import com.example.Hospital_Management_System.dao.NurseDAO;
import com.example.Hospital_Management_System.entity.Patients;
import com.example.Hospital_Management_System.entity.Doctors;
import com.example.Hospital_Management_System.entity.Nurses;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.io.IOException;
import java.util.List;

@WebServlet("/patients")
public class PatientServlet extends HttpServlet {
    private PatientsDAO patientsDAO;
    private DoctorDAO doctorDAO;
    private NurseDAO nurseDAO;

    public void init() {
        patientsDAO = new PatientsDAO();
        doctorDAO = new DoctorDAO();
        nurseDAO = new NurseDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Patients> patients = patientsDAO.getAllPatients();
        List<Doctors> doctors = doctorDAO.getAllDoctors();
        List<Nurses> nurses = nurseDAO.getAllNurses();
        request.setAttribute("patients", patients);
        request.setAttribute("doctors", doctors);
        request.setAttribute("nurses", nurses);
        request.getRequestDispatcher("patients.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String disease = request.getParameter("disease");
        int doctorId = Integer.parseInt(request.getParameter("doctorId"));
        int nurseId = Integer.parseInt(request.getParameter("nurseId"));

        Patients patient = new Patients(name, disease);
        
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Transaction tx = session.beginTransaction();
            Doctors doctor = session.get(Doctors.class, doctorId);
            Nurses nurse = session.get(Nurses.class, nurseId);
            patient.setDoctor(doctor);
            patient.setNurse(nurse);
            session.persist(patient);
            tx.commit();
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/patients");
    }
}
