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
                <button onclick="document.getElementById('requestModal').style.display='block'" class="btn btn-primary">Request Appointment</button>
            </div>
        </header>

        <!-- Request Appointment Modal -->
        <div id="requestModal" style="display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.5); z-index: 1000; align-items: center; justify-content: center; backdrop-filter: blur(4px);">
            <div class="card" style="width: 100%; max-width: 400px; margin: 10vh auto;">
                <div class="card-header" style="display: flex; justify-content: space-between; align-items: center;">
                    <h3>Request Appointment</h3>
                    <button onclick="document.getElementById('requestModal').style.display='none'" style="background:none; border:none; font-size: 1.5rem; cursor:pointer;">&times;</button>
                </div>
                <form action="${pageContext.request.contextPath}/appointments?action=request" method="post" style="margin-top: 20px;">
                    <input type="hidden" name="csrfToken" value="${csrfToken}">
                    <div class="form-group">
                        <label>Preferred Date</label>
                        <input type="date" name="appointmentDate" required style="width: 100%; padding: 10px; border-radius: 8px; border: 1px solid var(--border);">
                    </div>
                    <div class="form-group" style="margin-top: 15px;">
                        <label>Preferred Time</label>
                        <input type="time" name="appointmentTime" required style="width: 100%; padding: 10px; border-radius: 8px; border: 1px solid var(--border);">
                    </div>
                    <div style="margin-top: 25px; display: flex; gap: 10px;">
                        <button type="submit" class="btn btn-primary" style="flex-grow: 1;">Submit Request</button>
                        <button type="button" onclick="document.getElementById('requestModal').style.display='none'" class="btn btn-secondary">Cancel</button>
                    </div>
                </form>
            </div>
        </div>

        <section class="stats-grid">
            <div class="stat-card">
                <div class="stat-header">
                    <span class="stat-icon" style="background: rgba(16, 185, 129, 0.1); color: var(--success);">📅</span>
                    <span class="stat-label">Next Appointment</span>
                </div>
                <c:choose>
                    <c:when test="${not empty myAppointments}">
                        <div class="stat-value">${myAppointments[0].appointmentDate}</div>
                        <p class="stat-trend" style="color: var(--text-muted);">With Dr. ${myAppointments[0].doctor.name}</p>
                    </c:when>
                    <c:otherwise>
                        <div class="stat-value" style="font-size: 1.5rem; color: var(--text-muted);">None Scheduled</div>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <div class="stat-card">
                <div class="stat-header">
                    <span class="stat-icon" style="background: rgba(59, 130, 246, 0.1); color: var(--primary);">💰</span>
                    <span class="stat-label">Outstanding Balance</span>
                </div>
                <div class="stat-value">$240.00</div>
                <p class="stat-trend" style="color: var(--text-muted);">Due by end of month</p>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <span class="stat-icon" style="background: rgba(139, 92, 246, 0.1); color: #8b5cf6;">📑</span>
                    <span class="stat-label">Medical Records</span>
                </div>
                <div class="stat-value">${not empty medicalRecord ? 'Available' : 'Pending'}</div>
                <p class="stat-trend" style="color: var(--text-muted);">Updated 2 days ago</p>
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
                                        <span class="status-pill ${app.status == 'REQUESTED' ? 'status-pending' : (app.status == 'REJECTED' ? 'status-inactive' : 'status-active')}"
                                              style="${app.status == 'REQUESTED' ? 'background: rgba(245, 158, 11, 0.1); color: var(--warning);' : (app.status == 'REJECTED' ? 'background: rgba(239, 68, 68, 0.1); color: var(--danger);' : '')}">
                                            ${app.status != null ? app.status : 'CONFIRMED'}
                                        </span>
                                        <c:if test="${app.status == 'REJECTED' && not empty app.rejectionReason}">
                                            <div style="font-size: 0.75rem; color: var(--text-muted); margin-top: 4px; max-width: 250px;">
                                                <strong style="color: var(--danger);">Reason:</strong> ${app.rejectionReason}
                                            </div>
                                        </c:if>
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