<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.Hospital_Management_System.entity.Appointments" %>
<%@ page import="com.example.Hospital_Management_System.entity.util.HibernateUtil" %>
<%@ page import="org.hibernate.Session" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head><title>Debug Appointments</title></head>
<body>
    <h1>Raw Appointments Table</h1>
    <table border="1">
        <tr>
            <th>ID</th>
            <th>Date</th>
            <th>Time</th>
            <th>Status</th>
            <th>Patient</th>
            <th>Doctor</th>
        </tr>
        <%
            try (Session s = HibernateUtil.getSessionFactory().openSession()) {
                List<Appointments> apps = s.createQuery("from Appointments", Appointments.class).list();
                for (Appointments a : apps) {
        %>
        <tr>
            <td><%= a.getId() %></td>
            <td><%= a.getAppointmentDate() %></td>
            <td><%= a.getAppointmentTime() %></td>
            <td><%= a.getStatus() %></td>
            <td><%= a.getPatient() != null ? a.getPatient().getName() : "NULL" %></td>
            <td><%= a.getDoctor() != null ? a.getDoctor().getName() : "NULL" %></td>
        </tr>
        <%
                }
            } catch (Exception e) {
                out.println("Error: " + e.getMessage());
                e.printStackTrace(new java.io.PrintWriter(out));
            }
        %>
    </table>
</body>
</html>
