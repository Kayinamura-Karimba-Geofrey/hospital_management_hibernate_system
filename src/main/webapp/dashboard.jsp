<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Dashboard - HMSystem</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
            <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        </head>

        <body>
            <jsp:include page="includes/sidebar.jsp" />
            <script>document.getElementById('nav-dashboard').classList.add('active');</script>
            <div class="main-content">
                <div class="hero">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <h1>Welcome back, ${sessionScope.user.fullName}</h1>
                        </c:when>
                        <c:otherwise>
                            <h1>Hospital Management System</h1>
                        </c:otherwise>
                    </c:choose>
                    <p>Advanced healthcare administration and patient care monitoring.</p>
                </div>

                <div class="stats-grid"
                    style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-top: 30px;">
                    <div class="stat-card"
                        style="background: rgba(255, 255, 255, 0.05); border-radius: 12px; padding: 20px; text-align: center; border: 1px solid rgba(255, 255, 255, 0.1);">
                        <p style="opacity: 0.7; margin: 0;">Total Patients</p>
                        <h2 style="margin: 10px 0; color: #4facfe;">${not empty totalPatients ? totalPatients : 0}</h2>
                    </div>
                    <div class="stat-card"
                        style="background: rgba(255, 255, 255, 0.05); border-radius: 12px; padding: 20px; text-align: center; border: 1px solid rgba(255, 255, 255, 0.1);">
                        <p style="opacity: 0.7; margin: 0;">Active Staff</p>
                        <h2 style="margin: 10px 0; color: #00f2fe;">${not empty activeStaff ? activeStaff : 0}</h2>
                    </div>
                </div>

                <div class="chart-container"
                    style="background: rgba(255, 255, 255, 0.03); border-radius: 15px; padding: 25px; margin-top: 30px; height: 350px; border: 1px solid rgba(255, 255, 255, 0.05);">
                    <h3 style="margin-top: 0;">Quick Hospital Overview</h3>
                    <canvas id="quickChart"></canvas>
                </div>

                <div class="action-btns" style="display: flex; gap: 15px; margin-top: 30px;">
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Add New User</a>
                    <a href="${pageContext.request.contextPath}/appointments" class="btn btn-secondary">Manage
                        Schedule</a>
                </div>
            </div>

            <script>
                const ctx = document.getElementById('quickChart').getContext('2d');
                new Chart(ctx, {
                    type: 'doughnut',
                    data: {
                        labels: ['Patients', 'Doctors', 'Nurses', 'Appointments'],
                        datasets: [{
                            data: [
                                ${ not empty totalPatients? totalPatients: 0 },
                                ${ not empty totalDoctors? totalDoctors: 0 },
                                ${ not empty totalNurses? totalNurses: 0 },
                                ${ not empty totalAppointments? totalAppointments: 0 }
                            ],
                            backgroundColor: ['#4facfe', '#00f2fe', '#ffa500', '#7ed56f'],
                            borderWidth: 0
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                position: 'right',
                                labels: { color: '#fff', font: { size: 14 } }
                            }
                        }
                    }
                });
            </script>
        </body>

        </html>