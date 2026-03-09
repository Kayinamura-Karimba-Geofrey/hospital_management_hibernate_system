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
                        <span class="role-badge ADMIN-badge">ADMIN</span>
                        <h1>Welcome back, ${sessionScope.user.fullName}</h1>
                        <p>Your personalized health management portal is ready.</p>
                    </div>

                    <div class="stats-grid"
                        style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-top: 30px;">
                        <div class="stat-card"
                            style="background: rgba(255, 255, 255, 0.05); border-radius: 12px; padding: 20px; text-align: center; border: 1px solid rgba(255, 255, 255, 0.1);">
                            <p class="text-muted" style="margin: 0;">Total Patients</p>
                            <h2 style="margin: 10px 0; color: #4facfe;">${not empty totalPatients ? totalPatients : 0}
                            </h2>
                        </div>
                        <div class="stat-card"
                            style="background: rgba(255, 255, 255, 0.05); border-radius: 12px; padding: 20px; text-align: center; border: 1px solid rgba(255, 255, 255, 0.1);">
                            <p class="text-muted" style="margin: 0;">Active Staff</p>
                            <h2 style="margin: 10px 0; color: #00f2fe;">${not empty activeStaff ? activeStaff : 0}</h2>
                        </div>
                        <div class="stat-card"
                            style="background: rgba(255, 255, 255, 0.05); border-radius: 12px; padding: 20px; text-align: center; border: 1px solid rgba(255, 255, 255, 0.1);">
                            <p class="text-muted" style="margin: 0;">Appointments</p>
                            <h2 style="margin: 10px 0; color: #7ed56f;">${not empty totalAppointments ?
                                totalAppointments : 0}</h2>
                        </div>
                    </div>

                    <div class="chart-container"
                        style="background: rgba(255, 255, 255, 0.03); border-radius: 15px; padding: 25px; margin-top: 30px; height: 350px; border: 1px solid rgba(255, 255, 255, 0.05);">
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
                                labels: ['Patients', 'Doctors', 'Nurses', 'Appointments'],
                                datasets: [{
                                    data: [${ not empty totalPatients? totalPatients: 0 }, ${ not empty totalDoctors? totalDoctors: 0 }, ${ not empty totalNurses? totalNurses: 0 }, ${ not empty totalAppointments? totalAppointments: 0 }],
                                    backgroundColor: ['#4facfe', '#00f2fe', '#ffa500', '#7ed56f'],
                                    borderWidth: 0
                                }]
                            },
                            options: {
                                responsive: true,
                                maintainAspectRatio: false,
                                plugins: { legend: { position: 'right', labels: { color: '#fff', font: { size: 14 } } } }
                            }
                        });
                    }
                </script>
            </body>

            </html>