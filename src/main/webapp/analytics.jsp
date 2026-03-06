<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Advanced Analytics - HMSystem</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
            <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
            <style>
                .analytics-grid {
                    display: grid;
                    grid-template-columns: repeat(2, 1fr);
                    gap: 20px;
                    margin-bottom: 30px;
                }

                .chart-container {
                    background: rgba(255, 255, 255, 0.05);
                    backdrop-filter: blur(10px);
                    border: 1px solid rgba(255, 255, 255, 0.1);
                    border-radius: 15px;
                    padding: 20px;
                    height: 350px;
                }

                .stats-row {
                    display: grid;
                    grid-template-columns: repeat(4, 1fr);
                    gap: 20px;
                    margin-bottom: 30px;
                }

                .stat-card {
                    background: linear-gradient(135deg, rgba(79, 172, 254, 0.1), rgba(0, 242, 254, 0.1));
                    backdrop-filter: blur(5px);
                    border: 1px solid rgba(255, 255, 255, 0.1);
                    border-radius: 12px;
                    padding: 20px;
                    text-align: center;
                }

                .stat-card h2 {
                    margin: 10px 0;
                    font-size: 2em;
                    color: #4facfe;
                }

                .stat-card p {
                    margin: 0;
                    opacity: 0.8;
                    font-size: 0.9em;
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

                <div class="stats-row">
                    <div class="stat-card">
                        <p>Total Patients</p>
                        <h2>${totalPatients}</h2>
                    </div>
                    <div class="stat-card">
                        <p>Growth %</p>
                        <h2>+12%</h2>
                    </div>
                    <div class="stat-card">
                        <p>Billing Units</p>
                        <h2>${totalInvoices}</h2>
                    </div>
                    <div class="stat-card">
                        <p>Active Staff</p>
                        <h2>24</h2>
                    </div>
                </div>

                <div class="analytics-grid">
                    <div class="chart-container">
                        <h3>Patient Inflow (Monthly)</h3>
                        <canvas id="inflowChart"></canvas>
                    </div>
                    <div class="chart-container">
                        <h3>Revenue Distribution</h3>
                        <canvas id="revenueChart"></canvas>
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
                        plugins: { legend: { labels: { color: '#fff' } } },
                        scales: {
                            y: { ticks: { color: 'rgba(255,255,255,0.7)' }, grid: { color: 'rgba(255,255,255,0.1)' } },
                            x: { ticks: { color: 'rgba(255,255,255,0.7)' }, grid: { color: 'rgba(255,255,255,0.1)' } }
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
                        plugins: { legend: { position: 'bottom', labels: { color: '#fff' } } }
                    }
                });
            </script>
        </body>

        </html>