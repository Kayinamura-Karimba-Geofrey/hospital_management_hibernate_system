<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enterprise Analytics | MediFlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="dashboard-body">
    <jsp:include page="includes/sidebar.jsp" />

    <main class="main-content">
        <header class="dashboard-header">
            <div>
                <h1>Enterprise Intelligence</h1>
                <p>Advanced metrics and security audit logs for system-wide monitoring.</p>
            </div>
            <div style="display: flex; gap: 12px;">
                <button class="btn btn-secondary">Generate Audit Report</button>
                <button class="btn btn-primary">Refresh Data</button>
            </div>
        </header>

        <section class="stats-grid">
            <div class="stat-card">
                <div class="stat-header">
                    <span class="stat-icon" style="background: rgba(59, 130, 246, 0.1); color: var(--primary);">👥</span>
                    <span class="stat-label">Total Patients</span>
                </div>
                <div class="stat-value">${totalPatients}</div>
                <div class="stat-trend trend-up">↑ 12% Month-over-Month</div>
            </div>
            <div class="stat-card">
                <div class="stat-header">
                    <span class="stat-icon" style="background: rgba(16, 185, 129, 0.1); color: var(--success);">👨‍⚕️</span>
                    <span class="stat-label">Doctors</span>
                </div>
                <div class="stat-value">${totalDoctors}</div>
                <div class="stat-trend trend-up">↑ 2 new additions</div>
            </div>
            <div class="stat-card">
                <div class="stat-header">
                    <span class="stat-icon" style="background: rgba(245, 158, 11, 0.1); color: var(--warning);">🩺</span>
                    <span class="stat-label">Nursing Staff</span>
                </div>
                <div class="stat-value">${totalNurses}</div>
                <div class="stat-trend">Full capacity reached</div>
            </div>
            <div class="stat-card">
                <div class="stat-header">
                    <span class="stat-icon" style="background: rgba(139, 92, 246, 0.1); color: #8b5cf6;">💪</span>
                    <span class="stat-label">Active Staff</span>
                </div>
                <div class="stat-value">${activeStaff}</div>
                <div class="stat-trend trend-up">↑ 98% Engagement</div>
            </div>
        </section>

        <section class="dashboard-grid" style="margin-top: 32px;">
            <div class="card" style="grid-column: span 2;">
                <div class="card-header">
                    <h3>Patient Inflow Velocity</h3>
                    <p>New registrations over the past 6 months</p>
                </div>
                <div style="height: 300px; margin-top: 24px;">
                    <canvas id="inflowChart"></canvas>
                </div>
            </div>
            <div class="card">
                <div class="card-header">
                    <h3>Revenue Distribution</h3>
                    <p>Allocation across service sectors</p>
                </div>
                <div style="height: 250px; margin-top: 24px;">
                    <canvas id="revenueChart"></canvas>
                </div>
            </div>
        </section>

        <section class="card" style="margin-top: 32px;">
            <div class="card-header">
                <h3>System Audit & Compliance</h3>
                <p>Real-time security logs and user activity tracking</p>
            </div>
            <div class="table-responsive" style="margin-top: 24px;">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Timestamp</th>
                            <th>Operator</th>
                            <th>Action</th>
                            <th>Resource</th>
                            <th>Details</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="log" items="${auditLogs}">
                            <tr>
                                <td style="font-size: 0.85rem; color: var(--text-muted);">${log.timestamp}</td>
                                <td style="font-weight: 500;">${log.user.fullName}</td>
                                        <td>
                                            <span class="status-pill ${log.action == 'DELETE' ? 'status-critical' : 'status-active'}">
                                                ${log.action}
                                            </span>
                                        </td>
                                <td style="font-family: monospace; font-size: 0.85rem;">${log.entityName} (#${log.entityId})</td>
                                <td style="font-size: 0.85rem;">${log.details}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty auditLogs}">
                            <tr><td colspan="5" style="text-align: center; color: var(--text-muted); padding: 40px;">End of secure audit log. No recent activity detected.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </section>
    </main>

    <script>
        document.getElementById('nav-analytics').classList.add('active');

        // Chart defaults
        Chart.defaults.color = '#94a3b8';
        Chart.defaults.font.family = "'Inter', sans-serif";

        const inflowCtx = document.getElementById('inflowChart').getContext('2d');
        new Chart(inflowCtx, {
            type: 'line',
            data: {
                labels: [<c:forEach var="entry" items="${inflowData}">"${entry.key}",</c:forEach>],
                datasets: [{
                    label: 'Registrations',
                    data: [<c:forEach var="entry" items="${inflowData}">${entry.value},</c:forEach>],
                    borderColor: '#3b82f6',
                    backgroundColor: 'rgba(59, 130, 246, 0.05)',
                    fill: true,
                    tension: 0.4,
                    borderWidth: 3,
                    pointRadius: 4,
                    pointBackgroundColor: '#3b82f6',
                    pointBorderColor: '#fff',
                    pointBorderWidth: 2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: { grid: { borderDash: [5, 5] }, ticks: { padding: 10 } },
                    x: { grid: { display: false }, ticks: { padding: 10 } }
                },
                plugins: { legend: { display: false } }
            }
        });

        const revenueCtx = document.getElementById('revenueChart').getContext('2d');
        new Chart(revenueCtx, {
            type: 'doughnut',
            data: {
                labels: [<c:forEach var="entry" items="${revenueData}">"${entry.key}",</c:forEach>],
                datasets: [{
                    data: [<c:forEach var="entry" items="${revenueData}">${entry.value},</c:forEach>],
                    backgroundColor: ['#3b82f6', '#10b981', '#f59e0b', '#8b5cf6'],
                    borderWidth: 0,
                    borderRadius: 5
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '75%',
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: { padding: 20, usePointStyle: true, pointStyle: 'circle' }
                    }
                }
            }
        });
    </script>
</body>
</html>
html>