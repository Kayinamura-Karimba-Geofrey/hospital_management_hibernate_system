<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | MediFlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="dashboard-body">
    <jsp:include page="includes/sidebar.jsp" />

    <main class="main-content">
        <header class="dashboard-header">
            <div>
                <h1>Enterprise Overview</h1>
                <p>Real-time insights across all departments</p>
            </div>
            <div style="display: flex; gap: 12px;">
                <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Add New User</a>
                <button class="btn btn-secondary">Download Report</button>
            </div>
        </header>

        <section class="stats-grid">
            <div class="stat-card">
                <div class="stat-header">
                    <span class="stat-icon" style="background: rgba(59, 130, 246, 0.1); color: var(--primary);">👥</span>
                    <span class="stat-label">Total Patients</span>
                </div>
                <div class="stat-value">${not empty totalPatients ? totalPatients : 0}</div>
                <div class="stat-trend trend-up">↑ 4.2% from last month</div>
            </div>
            
            <div class="stat-card">
                <div class="stat-header">
                    <span class="stat-icon" style="background: rgba(16, 185, 129, 0.1); color: var(--success);">👨‍⚕️</span>
                    <span class="stat-label">Active Staff</span>
                </div>
                <div class="stat-value">${not empty activeStaff ? activeStaff : 0}</div>
                <div class="stat-trend trend-up">↑ 2 new doctors joined</div>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <span class="stat-icon" style="background: rgba(245, 158, 11, 0.1); color: var(--warning);">📅</span>
                    <span class="stat-label">Appointments</span>
                </div>
                <div class="stat-value">${not empty totalAppointments ? totalAppointments : 0}</div>
                <div class="stat-trend" style="color: var(--text-muted);">8 expected today</div>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <span class="stat-icon" style="background: rgba(139, 92, 246, 0.1); color: #8b5cf6;">💰</span>
                    <span class="stat-label">Revenue Overview</span>
                </div>
                <div class="stat-value">$12.4k</div>
                <div class="stat-trend trend-down">↓ 1.5% decrease</div>
            </div>
        </section>

        <section class="dashboard-grid" style="margin-top: 32px;">
            <div class="card" style="grid-column: span 2;">
                <div class="card-header">
                    <h3>Hospital Capacity & Load</h3>
                    <p>Current distribution across departments</p>
                </div>
                <div style="height: 350px; margin-top: 24px;">
                    <canvas id="adminChart"></canvas>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <h3>Appointment Requests (${fn:length(requestedAppointments)})</h3>
                </div>
                <div class="activity-list" style="margin-top: 24px; display: flex; flex-direction: column; gap: 20px;">
                    <c:forEach var="req" items="${requestedAppointments}">
                        <div style="display: flex; gap: 16px; align-items: start; padding-bottom: 15px; border-bottom: 1px solid var(--slate-100);">
                            <span style="font-size: 1.5rem;">📅</span>
                            <div style="flex-grow: 1;">
                                <p style="font-weight: 600; font-size: 0.95rem; color: var(--slate-900);">${req.patient.name}</p>
                                <p style="font-size: 0.8rem; color: var(--text-muted); margin-top: 2px;">Requested: ${req.appointmentDate} at ${req.appointmentTime}</p>
                            </div>
                            <div style="display: flex; gap: 8px;">
                                <form action="${pageContext.request.contextPath}/appointments" method="post" style="display: inline;">
                                    <input type="hidden" name="action" value="approve">
                                    <input type="hidden" name="csrfToken" value="${csrfToken}">
                                    <input type="hidden" name="id" value="${req.id}">
                                    <button type="submit" class="btn btn-primary" style="padding: 4px 10px; font-size: 0.75rem;">Approve</button>
                                </form>
                                <button type="button" class="btn btn-secondary" onclick="document.getElementById('rejectModal_${req.id}').style.display='block'" style="padding: 4px 10px; font-size: 0.75rem; color: var(--danger); border-color: rgba(239, 68, 68, 0.2);">Decline</button>
                                
                                <!-- Reject Modal -->
                                <div id="rejectModal_${req.id}" style="display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.5); z-index: 1000; align-items: center; justify-content: center; backdrop-filter: blur(4px);">
                                    <div class="card" style="width: 100%; max-width: 400px; margin: 10vh auto; background: white;">
                                        <div class="card-header" style="display: flex; justify-content: space-between; align-items: center;">
                                            <h3>Decline Appointment</h3>
                                            <button onclick="document.getElementById('rejectModal_${req.id}').style.display='none'" style="background:none; border:none; font-size: 1.5rem; cursor:pointer;">&times;</button>
                                        </div>
                                        <form action="${pageContext.request.contextPath}/appointments" method="post" style="margin-top: 20px;">
                                            <input type="hidden" name="action" value="reject">
                                            <input type="hidden" name="csrfToken" value="${csrfToken}">
                                            <input type="hidden" name="id" value="${req.id}">
                                            <div class="form-group">
                                                <label>Reason for Rejection</label>
                                                <textarea name="rejectionReason" required rows="3" style="width: 100%; padding: 10px; border-radius: 8px; border: 1px solid var(--border); margin-top: 8px;" placeholder="Please explain why this appointment is being declined..."></textarea>
                                            </div>
                                            <div style="margin-top: 25px; display: flex; gap: 10px;">
                                                <button type="submit" class="btn btn-primary" style="flex-grow: 1; background: var(--danger); border-color: var(--danger);">Confirm Decline</button>
                                                <button type="button" onclick="document.getElementById('rejectModal_${req.id}').style.display='none'" class="btn btn-secondary">Cancel</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty requestedAppointments}">
                        <p style="text-align: center; color: var(--text-muted); font-size: 0.9rem;">No pending appointment requests.</p>
                    </c:if>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <h3>Recent Activity</h3>
                </div>
                <div class="activity-list" style="margin-top: 24px; display: flex; flex-direction: column; gap: 20px;">
                    <div style="display: flex; gap: 16px; align-items: start;">
                        <span style="font-size: 1.5rem;">📝</span>
                        <div>
                            <p style="font-weight: 600; font-size: 0.95rem; color: var(--slate-900);">New patient registration</p>
                            <p style="font-size: 0.8rem; color: var(--text-muted); margin-top: 2px;">2 minutes ago</p>
                        </div>
                    </div>
                    <div style="display: flex; gap: 16px; align-items: start;">
                        <span style="font-size: 1.5rem;">🏥</span>
                        <div>
                            <p style="font-weight: 600; font-size: 0.95rem; color: var(--slate-900);">ICU capacity reached 85%</p>
                            <p style="font-size: 0.8rem; color: var(--text-muted); margin-top: 2px;">1 hour ago</p>
                        </div>
                    </div>
                </div>
                <a href="#" class="btn btn-secondary" style="width: 100%; margin-top: 24px; text-align: center;">View All Logs</a>
            </div>
        </section>
    </main>

    <script>
        document.getElementById('nav-dashboard').classList.add('active');

        if (document.getElementById('adminChart')) {
            new Chart(document.getElementById('adminChart').getContext('2d'), {
                type: 'doughnut',
                data: {
                    labels: [<c:forEach var="entry" items="${stats}">"${entry.key}",</c:forEach>],
                    datasets: [{
                        data: [<c:forEach var="entry" items="${stats}">${entry.value},</c:forEach>],
                        backgroundColor: [
                            'rgba(59, 130, 246, 0.85)', 
                            'rgba(16, 185, 129, 0.85)', 
                            'rgba(245, 158, 11, 0.85)', 
                            'rgba(139, 92, 246, 0.85)',
                            'rgba(236, 72, 153, 0.85)'
                        ],
                        hoverOffset: 20,
                        borderWidth: 0,
                        borderRadius: 8
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    cutout: '70%',
                    plugins: {
                        legend: {
                            position: 'right',
                            labels: {
                                padding: 20,
                                usePointStyle: true,
                                pointStyle: 'circle',
                                font: {
                                    size: 13,
                                    family: "'Inter', sans-serif"
                                }
                            }
                        }
                    }
                }
            });
        }
    </script>
</body>
</html>