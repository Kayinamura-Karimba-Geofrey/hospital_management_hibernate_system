<%@ page import="com.example.Hospital_Management_System.entity.*" %>
<%@ page import="com.example.Hospital_Management_System.entity.util.HibernateUtil" %>
<%@ page import="org.hibernate.Session" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<body>
<h2>System Data Debug</h2>
<h3>Patients</h3>
<table border="1">
    <tr><th>ID</th><th>Name</th><th>Email</th></tr>
    <%
    try (Session s = HibernateUtil.getSessionFactory().openSession()) {
        List<Patients> patients = s.createQuery("from Patients", Patients.class).list();
        for (Patients p : patients) {
            out.println("<tr><td>" + p.getId() + "</td><td>" + p.getName() + "</td><td>" + p.getEmail() + "</td></tr>");
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
    %>
</table>

<h3>Appointments</h3>
<table border="1">
    <tr><th>ID</th><th>Patient</th><th>Status</th><th>Date</th></tr>
    <%
    try (Session s = HibernateUtil.getSessionFactory().openSession()) {
        List<Appointments> apps = s.createQuery("from Appointments", Appointments.class).list();
        for (Appointments a : apps) {
            String pName = (a.getPatient() != null) ? a.getPatient().getName() : "NULL";
            out.println("<tr><td>" + a.getId() + "</td><td>" + pName + "</td><td>" + a.getStatus() + "</td><td>" + a.getAppointmentDate() + "</td></tr>");
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
    %>
</table>
</body>
</html>
