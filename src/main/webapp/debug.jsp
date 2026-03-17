<%@ page import="com.example.Hospital_Management_System.entity.*" %>
<%@ page import="com.example.Hospital_Management_System.entity.util.HibernateUtil" %>
<%@ page import="org.hibernate.Session" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<body>
<h2>System Data Debug</h2>
<p>Current Time: <%= new java.util.Date() %></p>

<h3>Patients</h3>
<table border="1">
    <tr><th>ID</th><th>Name</th><th>Email</th></tr>
    <%
    try (Session s = HibernateUtil.getSessionFactory().openSession()) {
        List<Patients> patients = s.createQuery("from Patients", Patients.class).list();
        if (patients.isEmpty()) {
            out.println("<tr><td colspan='3'>No patients found</td></tr>");
        }
        for (Patients p : patients) {
            out.println("<tr><td>" + p.getId() + "</td><td>" + p.getName() + "</td><td>" + p.getEmail() + "</td></tr>");
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
        e.printStackTrace(new java.io.PrintWriter(out));
    }
    %>
</table>

<h3>Appointments (ALL)</h3>
<table border="1">
    <tr><th>ID</th><th>Patient</th><th>Status</th><th>Date</th></tr>
    <%
    try (Session s = HibernateUtil.getSessionFactory().openSession()) {
        List<Appointments> apps = s.createQuery("from Appointments", Appointments.class).list();
        if (apps.isEmpty()) {
            out.println("<tr><td colspan='4'>No appointments found</td></tr>");
        }
        for (Appointments a : apps) {
            String pName = (a.getPatient() != null) ? a.getPatient().getName() : "NULL";
            String status = a.getStatus();
            String hexStatus = "";
            if (status != null) {
                for (byte b : status.getBytes()) {
                    hexStatus += String.format("%02X ", b);
                }
            }
            out.println("<tr><td>" + a.getId() + "</td><td>" + pName + "</td><td>[" + status + "] (Hex: " + hexStatus + ")</td><td>" + a.getAppointmentDate() + "</td></tr>");
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
        e.printStackTrace(new java.io.PrintWriter(out));
    }
    %>
</table>

<h3>Requested Appointments (Filter Check)</h3>
<%
    try (Session s = HibernateUtil.getSessionFactory().openSession()) {
        List<Appointments> reqs = s.createQuery("from Appointments a where upper(trim(a.status)) = 'REQUESTED'", Appointments.class).list();
        out.println("<p>Found " + reqs.size() + " matches with filter.</p>");
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
</body>
</html>
