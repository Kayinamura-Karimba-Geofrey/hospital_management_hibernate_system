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
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            patientsDAO.deletePatient(id);
            response.sendRedirect(request.getContextPath() + "/patients");
            return;
        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Patients patient = patientsDAO.getPatientById(id);
            request.setAttribute("editablePatient", patient);
        }

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
        String idStr = request.getParameter("id");
        String name = request.getParameter("name");
        String disease = request.getParameter("disease");
        int doctorId = Integer.parseInt(request.getParameter("doctorId"));
        int nurseId = Integer.parseInt(request.getParameter("nurseId"));

        Patients patient = new Patients(name, disease);
        
        // Use a manual session here to fetch relations and save/update
        // Alternatively, update DAO to handle relations, but this is simpler for now
        Transaction tx = null;
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            tx = session.beginTransaction();
            
            Doctors doctor = session.get(Doctors.class, doctorId);
            Nurses nurse = session.get(Nurses.class, nurseId);
            
            patient.setDoctor(doctor);
            patient.setNurse(nurse);

            if (idStr != null && !idStr.isEmpty()) {
                patient.setId(Integer.parseInt(idStr));
                session.merge(patient);
            } else {
                session.persist(patient);
            }
            
            tx.commit();
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            e.printStackTrace();
        } finally {
            if (session != null) {
                session.close();
            }
        }

        response.sendRedirect(request.getContextPath() + "/patients");
    }
}
