<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nurse Station | MediFlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="dashboard-body">
    <jsp:include page="includes/sidebar.jsp" />

    <main class="main-content">
        <header class="dashboard-header">
            <div>
                <span class="role-badge NURSE-badge">NURSE STATION</span>
                <h1>Welcome, ${sessionScope.user.fullName}</h1>
                <p>Monitoring ${myPatientsCount} patients in the ${nurse.department.name} department.</p>
            </div>
            <div style="display: flex; gap: 12px;">
                <button class="btn btn-secondary">Request Handover</button>
                <button class="btn btn-primary">Start Medication Round</button>
            </div>
        </header>

        <section class="stats-grid">
            <div class="stat-card">
                <div class="stat-header">
                    <span class="stat-icon" style="background: rgba(59, 130, 246, 0.1); color: var(--primary);">🏥</span>
                    <span class="stat-label">Department</span>
                </div>
                <div class="stat-value" style="font-size: 1.5rem;">${nurse.department.name}</div>
                <p style="font-size: 0.8rem; color: var(--text-muted); margin-top: 8px;">Active Unit: ${nurse.department.name}</p>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <span class="stat-icon" style="background: rgba(16, 185, 129, 0.1); color: var(--success);">👥</span>
                    <span class="stat-label">Active Ward</span>
                </div>
                <div class="stat-value" style="font-size: 1.8rem;">${myPatientsCount}</div>
                <p style="font-size: 0.8rem; color: var(--text-muted); margin-top: 8px;">Patients requiring vitals: 4</p>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <span class="stat-icon" style="background: rgba(245, 158, 11, 0.1); color: var(--warning);">⚠️</span>
                    <span class="stat-label">Urgent Tasks</span>
                </div>
                <div class="stat-value" style="font-size: 1.8rem; color: var(--danger);">3</div>
                <p style="font-size: 0.8rem; color: var(--text-muted); margin-top: 8px;">Check Bed 4A immediately</p>
            </div>
        </section>

        <section class="dashboard-grid" style="margin-top: 32px;">
            <div class="card" style="grid-column: span 2;">
                <div class="card-header">
                    <h3>Patient Care List</h3>
                </div>
                <div class="table-container" style="margin-top: 16px;">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Patient</th>
                                <th>Bed #</th>
                                <th>Last Vitals</th>
                                <th>Next Action</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="patient" items="${wardPatients}" end="5">
                                <tr>
                                    <td style="font-weight: 500;">${patient.name}</td>
                                    <td>${patient.bedNumber}</td>
                                    <td>
                                        <span class="text-muted" style="font-size: 0.85rem;">15 mins ago</span>
                                    </td>
                                    <td>
                                        <span class="status-pill status-active" style="background: rgba(245, 158, 11, 0.1); color: var(--warning);">Meds Due</span>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/patient-file?id=${patient.id}" class="btn btn-secondary" style="padding: 6px 12px; font-size: 0.8rem;">Open File</a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty wardPatients}">
                                <tr>
                                    <td colspan="5" style="text-align: center; color: var(--text-muted); padding: 40px;">No patients currently assigned to your station.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <h3>Shift Information</h3>
                </div>
                <div class="activity-list" style="margin-top: 24px;">
                    <div style="padding: 12px 0; border-bottom: 1px solid var(--slate-100);">
                        <p style="font-weight: 600; font-size: 0.9rem;">Lead Doctor</p>
                        <p style="font-size: 0.85rem; color: var(--text-muted);">Dr. Sarah Williams (ICU)</p>
                    </div>
                    <div style="padding: 12px 0; border-bottom: 1px solid var(--slate-100);">
                        <p style="font-weight: 600; font-size: 0.9rem;">Station Capacity</p>
                        <p style="font-size: 0.85rem; color: var(--text-muted);">85% (17/20 beds occupied)</p>
                    </div>
                    <div style="padding: 12px 0;">
                        <p style="font-weight: 600; font-size: 0.9rem;">Medical Supplies</p>
                        <p style="font-size: 0.85rem; color: var(--success);">Stock verified at 07:00 AM</p>
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