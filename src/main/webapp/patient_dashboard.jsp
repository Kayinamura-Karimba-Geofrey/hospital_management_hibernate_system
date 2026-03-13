<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Portal | MediFlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="dashboard-body">
    <jsp:include page="includes/sidebar.jsp" />

    <main class="main-content">
        <header class="dashboard-header">
            <div>
                <span class="role-badge PATIENT-badge">PATIENT PORTAL</span>
                <h1>Welcome back, ${sessionScope.user.fullName}</h1>
                <p>Your health journey, managed with precision.</p>
            </div>
            <div style="display: flex; gap: 12px;">
                <a href="${pageContext.request.contextPath}/patient-portal" class="btn btn-primary">Book New Appointment</a>
            </div>
        </header>

        <section class="stats-grid">
            <div class="stat-card">
                <div class="stat-header">
                    <span class="stat-icon" style="background: rgba(16, 185, 129, 0.1); color: var(--success);">📅</span>
                    <span class="stat-label">Next Appointment</span>
                </div>
                <c:choose>
                    <c:when test="${not empty myAppointments}">
                        <div class="stat-value" style="font-size: 1.25rem;">${myAppointments[0].appointmentDate}</div>
                        <p style="font-size: 0.8rem; color: var(--text-muted); margin-top: 8px;">With Dr. ${myAppointments[0].doctor.name}</p>
                    </c:when>
                    <c:otherwise>
                        <div class="stat-value" style="font-size: 1.1rem; color: var(--text-muted);">None Scheduled</div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <span class="stat-icon" style="background: rgba(59, 130, 246, 0.1); color: var(--primary);">💰</span>
                    <span class="stat-label">Outstanding Balance</span>
                </div>
                <div class="stat-value">$240.00</div>
                <p style="font-size: 0.8rem; color: var(--text-muted); margin-top: 8px;">Due by end of month</p>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <span class="stat-icon" style="background: rgba(139, 92, 246, 0.1); color: #8b5cf6;">📑</span>
                    <span class="stat-label">Medical Records</span>
                </div>
                <div class="stat-value">${not empty medicalRecord ? 'Available' : 'Pending'}</div>
                <p style="font-size: 0.8rem; color: var(--text-muted); margin-top: 8px;">Updated 2 days ago</p>
            </div>
        </section>

        <section class="dashboard-grid" style="margin-top: 32px;">
            <div class="card" style="grid-column: span 2;">
                <div class="card-header">
                    <h3>Appointment History</h3>
                </div>
                <div class="table-container" style="margin-top: 16px;">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Doctor</th>
                                <th>Date</th>
                                <th>Time</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="app" items="${myAppointments}">
                                <tr>
                                    <td style="font-weight: 500;">Dr. ${app.doctor.name}</td>
                                    <td>${app.appointmentDate}</td>
                                    <td>${app.appointmentTime}</td>
                                    <td>
                                        <span class="status-pill status-active">Confirmed</span>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty myAppointments}">
                                <tr>
                                    <td colspan="4" style="text-align: center; color: var(--text-muted); padding: 40px;">No upcoming appointments found.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <h3>Health Tips</h3>
                </div>
                <div style="margin-top: 24px;">
                    <div style="background: var(--primary-soft); padding: 16px; border-radius: 12px; margin-bottom: 16px;">
                        <p style="font-weight: 600; color: var(--primary); font-size: 0.9rem; margin-bottom: 4px;">Hydration Goal</p>
                        <p style="font-size: 0.8rem; color: var(--slate-600);">Remember to drink at least 8 glasses of water today for optimal recovery.</p>
                    </div>
                    <div style="background: rgba(16, 185, 129, 0.05); padding: 16px; border-radius: 12px;">
                        <p style="font-weight: 600; color: var(--success); font-size: 0.9rem; margin-bottom: 4px;">Next Checkup</p>
                        <p style="font-size: 0.8rem; color: var(--slate-600);">Your annual physical is due in 3 months. Schedule early!</p>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <script>
        document.getElementById('nav-dashboard').classList.add('active');
    </script>
</body>
</html>