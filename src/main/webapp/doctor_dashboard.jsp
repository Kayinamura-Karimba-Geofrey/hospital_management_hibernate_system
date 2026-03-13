<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Portal | MediFlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="dashboard-body">
    <jsp:include page="includes/sidebar.jsp" />

    <main class="main-content">
        <header class="dashboard-header">
            <div>
                <span class="role-badge DOCTOR-badge">PHYSICIAN</span>
                <h1>Welcome, Dr. ${sessionScope.user.fullName}</h1>
                <p>You have ${fn:length(myAppointments)} appointments scheduled for today.</p>
            </div>
            <div style="display: flex; gap: 12px;">
                <a href="${pageContext.request.contextPath}/appointments" class="btn btn-primary">View Full Schedule</a>
            </div>
        </header>

        <section class="stats-grid">
            <div class="stat-card">
                <div class="stat-header">
                    <span class="stat-icon" style="background: rgba(59, 130, 246, 0.1); color: var(--primary);">👥</span>
                    <span class="stat-label">Active Patients</span>
                </div>
                <div class="stat-value">${not empty myPatientsCount ? myPatientsCount : 0}</div>
                <p style="font-size: 0.8rem; color: var(--text-muted); margin-top: 8px;">Directly assigned to you</p>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <span class="stat-icon" style="background: rgba(16, 185, 129, 0.1); color: var(--success);">📅</span>
                    <span class="stat-label">Today's Load</span>
                </div>
                <div class="stat-value">${fn:length(myAppointments)}</div>
                <p style="font-size: 0.8rem; color: var(--text-muted); margin-top: 8px;">Appointments remaining: 4</p>
            </div>

            <div class="stat-card" style="grid-column: span 1.5;">
                <div class="stat-header">
                    <span class="stat-icon" style="background: rgba(139, 92, 246, 0.1); color: #8b5cf6;">📈</span>
                    <span class="stat-label">Weekly Activity</span>
                </div>
                <div style="height: 120px; margin-top: 12px;">
                    <canvas id="doctorChart"></canvas>
                </div>
            </div>
        </section>

        <section class="dashboard-grid" style="margin-top: 32px;">
            <div class="card" style="grid-column: span 2;">
                <div class="card-header">
                    <h3>Upcoming Appointments</h3>
                </div>
                <div class="table-container" style="margin-top: 16px;">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Patient Name</th>
                                <th>Time</th>
                                <th>Reason / Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="app" items="${myAppointments}" end="5">
                                <tr>
                                    <td style="font-weight: 500;">${app.patient.name}</td>
                                    <td>${app.appointmentTime}</td>
                                    <td>
                                        <span class="status-pill status-active">Consultation</span>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/patient-file?id=${app.patient.id}" class="btn btn-secondary" style="padding: 6px 12px; font-size: 0.8rem;">Open File</a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty myAppointments}">
                                <tr>
                                    <td colspan="4" style="text-align: center; color: var(--text-muted); padding: 40px;">No appointments for today.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <h3>Quick Actions</h3>
                </div>
                <div style="display: flex; flex-direction: column; gap: 12px; margin-top: 24px;">
                    <a href="${pageContext.request.contextPath}/patients" class="btn btn-secondary" style="text-align: left; justify-content: start;">
                        <span style="margin-right: 8px;">📋</span> Search Patient Records
                    </a>
                    <a href="${pageContext.request.contextPath}/surgery" class="btn btn-secondary" style="text-align: left; justify-content: start;">
                        <span style="margin-right: 8px;">✂️</span> Surgery Schedule
                    </a>
                    <a href="${pageContext.request.contextPath}/clinical" class="btn btn-secondary" style="text-align: left; justify-content: start;">
                        <span style="margin-right: 8px;">📑</span> Write Clinical Note
                    </a>
                </div>
            </div>
        </section>
    </main>

    <script>
        document.getElementById('nav-dashboard').classList.add('active');

        if (document.getElementById('doctorChart')) {
            new Chart(document.getElementById('doctorChart').getContext('2d'), {
                type: 'line',
                data: {
                    labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                    datasets: [{
                        label: 'Appointments',
                        data: [8, 12, 7, 15, 10, 4, 3],
                        borderColor: '#3b82f6',
                        backgroundColor: 'rgba(59, 130, 246, 0.1)',
                        fill: true,
                        tension: 0.4,
                        borderWidth: 2,
                        pointRadius: 0
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: { 
                        y: { display: false }, 
                        x: { 
                            grid: { display: false },
                            ticks: { font: { size: 10 }, color: '#94a3b8' } 
                        } 
                    },
                    plugins: { legend: { display: false } }
                }
            });
        }
    </script>
</body>
</html>