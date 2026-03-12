<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Advanced Analytics - HMSystem</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
            <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
                .chart-card {
                    background: var(--surface-solid);
                    border: 1.5px solid var(--border);
                    border-radius: 20px;
                    padding: 25px;
                    box-shadow: var(--card-shadow);
                    transition: all 0.3s ease;
                }

                .chart-card h3 {
                    color: var(--card-text);
                    margin-top: 0;
                    margin-bottom: 20px;
                }

                .audit-section {
                    background: rgba(255, 255, 255, 0.02);
                    border-radius: 15px;
                    padding: 20px;
                    margin-top: 30px;
                }

                .audit-table {
                    width: 100%;
                    border-collapse: collapse;
                    margin-top: 15px;
                }

                .audit-table th,
                .audit-table td {
                    text-align: left;
                    padding: 12px;
                    border-bottom: 1px solid rgba(255, 255, 255, 0.05);
                }

                .badge-create {
                    color: #00ff00;
                    background: rgba(0, 255, 0, 0.1);
                    padding: 4px 8px;
                    border-radius: 4px;
                }

                .badge-update {
                    color: #ffa500;
                    background: rgba(255, 165, 0, 0.1);
                    padding: 4px 8px;
                    border-radius: 4px;
                }

                .badge-delete {
                    color: #ff4b2b;
                    background: rgba(255, 75, 43, 0.1);
                    padding: 4px 8px;
                    border-radius: 4px;
                }
            </style>
        </head>

        <body>
            <jsp:include page="includes/sidebar.jsp" />
            <script>document.getElementById('nav-analytics').classList.add('active');</script>
            <div class="main-content">
                <div class="hero" style="margin-bottom: 30px;">
                    <h1>Advanced Analytics</h1>
                    <p>Intelligence and Audit Dashboard</p>
                </div>

                <div class="stats-grid">
                    <div class="stat-card">
                        <p class="text-muted">Total Patients</p>
                        <div class="value">${totalPatients}</div>
                    </div>
                    <div class="stat-card">
                        <p class="text-muted">Doctors</p>
                        <div class="value">${totalDoctors}</div>
                    </div>
                    <div class="stat-card">
                        <p class="text-muted">Nurses</p>
                        <div class="value">${totalNurses}</div>
                    </div>
                    <div class="stat-card">
                        <p class="text-muted">Active Staff</p>
                        <div class="value">${activeStaff}</div>
                    </div>
                </div>

                <div class="analytics-grid">
                    <div class="chart-card">
                        <h3>Patient Inflow (Monthly)</h3>
                        <canvas id="inflowChart"></canvas>
                    </div>
                    <div class="chart-card">
                        <h3>Revenue Distribution</h3>
                        <canvas id="revenueChart"></canvas>
                    </div>
                    <div class="chart-card" style="grid-column: span 2; height: 350px;">
                        <h3>Bed Occupancy Status</h3>
                        <canvas id="bedChart"></canvas>
                    </div>
                </div>

                <div class="audit-section">
                    <h3>🛡️ Security Audit Logs</h3>
                    <table class="audit-table">
                        <thead>
                            <tr>
                                <th>Timestamp</th>
                                <th>User</th>
                                <th>Action</th>
                                <th>Entity</th>
                                <th>Details</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="log" items="${auditLogs}">
                                <tr>
                                    <td>${log.timestamp}</td>
                                    <td>${log.user.fullName}</td>
                                    <td><span class="badge-${log.action.toLowerCase()}">${log.action}</span></td>
                                    <td>${log.entityName} (#${log.entityId})</td>
                                    <td>${log.details}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <script>
                // Inflow Chart
                const inflowCtx = document.getElementById('inflowChart').getContext('2d');
                new Chart(inflowCtx, {
                    type: 'line',
                    data: {
                        labels: [<c:forEach var="entry" items="${inflowData}">"${entry.key}",</c:forEach>],
                        datasets: [{
                            label: 'New Patients',
                            data: [<c:forEach var="entry" items="${inflowData}">${entry.value},</c:forEach>],
                            borderColor: '#4facfe',
                            backgroundColor: 'rgba(79, 172, 254, 0.2)',
                            fill: true,
                            tension: 0.4
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: { legend: { labels: { color: '#ffffff', font: { weight: '500' } } } },
                        scales: {
                            y: { ticks: { color: 'rgba(255, 255, 255, 0.7)' }, grid: { color: 'rgba(255, 255, 255, 0.1)' } },
                            x: { ticks: { color: 'rgba(255, 255, 255, 0.7)' }, grid: { display: false } }
                        }
                    }
                });

                // Revenue Chart
                const revenueCtx = document.getElementById('revenueChart').getContext('2d');
                new Chart(revenueCtx, {
                    type: 'doughnut',
                    data: {
                        labels: [<c:forEach var="entry" items="${revenueData}">"${entry.key}",</c:forEach>],
                        datasets: [{
                            data: [<c:forEach var="entry" items="${revenueData}">${entry.value},</c:forEach>],
                            backgroundColor: ['#00f2fe', '#4facfe'],
                            borderWidth: 0
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: { legend: { position: 'bottom', labels: { color: '#ffffff', font: { weight: '500' } } } }
                    }
                });

                // Bed Occupancy Chart
                const bedCtx = document.getElementById('bedChart').getContext('2d');
                new Chart(bedCtx, {
                    type: 'bar',
                    data: {
                        labels: [<c:forEach var="entry" items="${bedData}">"${entry.key}",</c:forEach>],
                        datasets: [{
                            label: 'Beds',
                            data: [<c:forEach var="entry" items="${bedData}">${entry.value},</c:forEach>],
                            backgroundColor: ['#4facfe', '#00f2fe', '#ffa500'],
                            borderRadius: 5
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        indexAxis: 'y',
                        plugins: { legend: { display: false } },
                        scales: {
                            y: { ticks: { color: 'rgba(255, 255, 255, 0.7)' }, grid: { display: false } },
                            x: { ticks: { color: 'rgba(255, 255, 255, 0.7)' }, grid: { color: 'rgba(255, 255, 255, 0.1)' } }
                        }
                    }
                });
            </script>
        </body>

        </html>