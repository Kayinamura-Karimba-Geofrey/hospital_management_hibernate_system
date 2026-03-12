<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>ADMIN Dashboard - HMSystem</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
                <style>
                    .role-badge {
                        display: inline-block;
                        padding: 4px 12px;
                        border-radius: 20px;
                        font-size: 0.8rem;
                        font-weight: 600;
                        text-transform: uppercase;
                        margin-bottom: 10px;
                    }

                    .ADMIN-badge {
                        background: rgba(255, 69, 58, 0.2);
                        color: #ff453a;
                    }

                    .text-muted {
                        opacity: 0.6;
                        font-size: 0.9rem;
                    }
                </style>
            </head>

            <body>
                <jsp:include page="includes/sidebar.jsp" />
                <script>document.getElementById('nav-dashboard').classList.add('active');</script>

                <div class="main-content">
                    <div class="hero">
                        <h1>Dashboard Overview</h1>
                        <p>Hospital management system monitoring and metrics.</p>
                    </div>

                    <div class="stats-grid">
                        <div class="stat-card">
                            <p class="text-muted" style="margin: 0;">Total Patients</p>
                            <div class="value">${not empty totalPatients ? totalPatients : 0}</div>
                        </div>
                        <div class="stat-card">
                            <p class="text-muted" style="margin: 0;">Active Staff</p>
                            <div class="value">${not empty activeStaff ? activeStaff : 0}</div>
                        </div>
                        <div class="stat-card">
                            <p class="text-muted" style="margin: 0;">Appointments</p>
                            <div class="value">${not empty totalAppointments ? totalAppointments : 0}</div>
                        </div>
                    </div>

                    <div class="card" style="height: 400px; margin-top: 30px;">
                        <h3 style="margin-top: 0;">Hospital Capacity Overview</h3>
                        <canvas id="adminChart"></canvas>
                    </div>

                    <div class="action-btns" style="display: flex; gap: 15px; margin-top: 30px;">
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Add New User</a>
                        <a href="${pageContext.request.contextPath}/analytics" class="btn btn-secondary">Full
                            Analytics</a>
                    </div>
                </div>

                <script>
                    if (document.getElementById('adminChart')) {
                        new Chart(document.getElementById('adminChart').getContext('2d'), {
                            type: 'doughnut',
                            data: {
                                labels: [<c:forEach var="entry" items="${stats}">"${entry.key}",</c:forEach>],
                                datasets: [{
                                    data: [<c:forEach var="entry" items="${stats}">${entry.value},</c:forEach>],
                                    backgroundColor: ['#3b82f6', '#1e3a8a', '#60a5fa', '#93c5fd'],
                                    borderWidth: 0
                                }]
                            },
                            options: {
                                responsive: true,
                                maintainAspectRatio: false,
                                plugins: {
                                    legend: {
                                        position: 'right',
                                        labels: {
                                            color: '#1c1c1e',
                                            font: {
                                                size: 14,
                                                weight: '500'
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