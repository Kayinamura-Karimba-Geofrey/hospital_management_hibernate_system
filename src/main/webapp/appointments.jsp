<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Appointments - Hospital Management System</title>
            <style>
                :root {
                    --primary: #4a148c;
                    --secondary: #6a1b9a;
                    --white: #ffffff;
                    --gray: #f8f9fa;
                }

                body {
                    font-family: 'Segoe UI', sans-serif;
                    margin: 0;
                    background: var(--gray);
                    display: flex;
                }

                .sidebar {
                    width: 250px;
                    background: var(--primary);
                    color: var(--white);
                    min-height: 100vh;
                    padding: 20px 0;
                    flex-shrink: 0;
                }

                .sidebar-header {
                    padding: 0 20px 20px;
                    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
                    font-size: 1.5rem;
                    font-weight: bold;
                    text-align: center;
                }

                .sidebar-nav a {
                    display: block;
                    padding: 15px 25px;
                    color: rgba(255, 255, 255, 0.8);
                    text-decoration: none;
                    transition: all 0.3s;
                }

                .sidebar-nav a:hover {
                    background: rgba(255, 255, 255, 0.1);
                    color: var(--white);
                    padding-left: 35px;
                }

                .main-content {
                    flex-grow: 1;
                    padding: 40px;
                }

                .card {
                    background: var(--white);
                    padding: 25px;
                    border-radius: 12px;
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
                    margin-bottom: 30px;
                }

                h2 {
                    color: var(--primary);
                    margin-top: 0;
                }

                .form-group {
                    margin-bottom: 1rem;
                }

                label {
                    display: block;
                    margin-bottom: 0.5rem;
                    font-weight: bold;
                }

                input,
                select {
                    width: 100%;
                    padding: 0.8rem;
                    border: 1px solid #ddd;
                    border-radius: 5px;
                    box-sizing: border-box;
                }

                .btn {
                    padding: 10px 20px;
                    border-radius: 5px;
                    cursor: pointer;
                    border: none;
                    font-weight: bold;
                    text-decoration: none;
                    display: inline-block;
                }

                .btn-primary {
                    background: var(--primary);
                    color: white;
                }

                table {
                    width: 100%;
                    border-collapse: collapse;
                    margin-top: 20px;
                }

                th,
                td {
                    padding: 12px;
                    text-align: left;
                    border-bottom: 1px solid #eee;
                }

                th {
                    background: #fdfafd;
                    color: var(--primary);
                }
            </style>
        </head>

        <body>
            <div class="sidebar">
                <div class="sidebar-header">HMS Admin</div>
                <div class="sidebar-nav">
                    <a href="${pageContext.request.contextPath}/index.jsp">🏠 Dashboard</a>
                    <a href="${pageContext.request.contextPath}/departments">🏥 Departments</a>
                    <a href="${pageContext.request.contextPath}/doctors">👨‍⚕️ Doctors</a>
                    <a href="${pageContext.request.contextPath}/nurses">👩‍⚕️ Nurses</a>
                    <a href="${pageContext.request.contextPath}/patients">🚑 Patients</a>
                    <a href="${pageContext.request.contextPath}/appointments">📅 Appointments</a>
                </div>
            </div>
            <div class="main-content">
                <h2>Appointment Scheduling</h2>

                <div class="card">
                    <h3>Schedule New Appointment</h3>
                    <form action="appointments" method="post"
                        style="display: grid; grid-template-columns: 1fr 1fr 1fr auto; gap: 15px; align-items: end;">
                        <div class="form-group">
                            <label>Select Patient</label>
                            <select name="patientId" required>
                                <option value="" disabled selected>Select Patient</option>
                                <c:forEach var="p" items="${patients}">
                                    <option value="${p.id}">${p.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Date</label>
                            <input type="date" name="appointmentDate" required>
                        </div>
                        <div class="form-group">
                            <label>Time</label>
                            <input type="time" name="appointmentTime" required>
                        </div>
                        <button type="submit" class="btn btn-primary" style="height: 45px;">Book Appointment</button>
                    </form>
                </div>

                <div class="card">
                    <h3>Upcoming Appointments</h3>
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Patient</th>
                                <th>Doctor</th>
                                <th>Date</th>
                                <th>Time</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="app" items="${appointments}">
                                <tr>
                                    <td>${app.id}</td>
                                    <td>${app.patient.name}</td>
                                    <td>${app.patient.doctor.name}</td>
                                    <td>${app.appointmentDate}</td>
                                    <td>${app.appointmentTime}</td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty appointments}">
                                <tr>
                                    <td colspan="5" style="text-align: center; color: #999;">No appointments scheduled.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </body>

        </html>