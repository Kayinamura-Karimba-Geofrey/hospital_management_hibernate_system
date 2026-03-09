<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>DOCTOR Dashboard - HMSystem</title>
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

                    .DOCTOR-badge {
                        background: rgba(10, 132, 255, 0.2);
                        color: #0a84ff;
                    }

                    .grid-3 {
                        display: grid;
                        grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                        gap: 20px;
                        margin-top: 20px;
                    }

                    .card-list {
                        list-style: none;
                        padding: 0;
                        margin: 15px 0;
                    }

                    .card-list li {
                        padding: 10px;
                        border-bottom: 1px solid rgba(255, 255, 255, 0.05);
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                    }

                    .card-list li:last-child {
                        border-bottom: none;
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
                        <span class="role-badge DOCTOR-badge">DOCTOR</span>
                        <h1>Welcome back, ${sessionScope.user.fullName}</h1>
                        <p>Your personalized health management portal is ready.</p>
                    </div>

                    <div class="grid-3">
                        <div class="stat-card"
                            style="background: rgba(10, 132, 255, 0.05); border-radius: 15px; padding: 25px; border: 1px solid rgba(10, 132, 255, 0.2);">
                            <h3>My Patients</h3>
                            <h2 style="font-size: 3rem; color: #0a84ff;">${myPatientsCount}</h2>
                            <p class="text-muted">Assigned under your care</p>
                            <a href="${pageContext.request.contextPath}/patients"
                                style="color: #0a84ff; text-decoration: none; font-size: 0.9rem;">View All →</a>
                        </div>

                        <div class="stat-card"
                            style="background: rgba(255, 255, 255, 0.03); border-radius: 15px; padding: 25px; border: 1px solid rgba(255,255,255,0.05);">
                            <h3>Today's Schedule</h3>
                            <ul class="card-list">
                                <c:forEach var="app" items="${myAppointments}" end="4">
                                    <li>
                                        <span>${app.patient.name}</span>
                                        <span class="text-muted">${app.appointmentTime}</span>
                                    </li>
                                </c:forEach>
                                <c:if test="${empty myAppointments}">
                                    <li><span class="text-muted">No appointments today</span></li>
                                </c:if>
                            </ul>
                            <a href="${pageContext.request.contextPath}/appointments" class="text-muted">Full Schedule
                                →</a>
                        </div>

                        <div class="stat-card"
                            style="background: rgba(255, 255, 255, 0.03); border-radius: 15px; padding: 25px; border: 1px solid rgba(255,255,255,0.05);">
                            <h3>Patient Load</h3>
                            <canvas id="doctorChart" style="max-height: 150px;"></canvas>
                        </div>
                    </div>
                </div>

                <script>
                    if (document.getElementById('doctorChart')) {
                        new Chart(document.getElementById('doctorChart').getContext('2d'), {
                            type: 'bar',
                            data: {
                                labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
                                datasets: [{
                                    label: 'Appointments',
                                    data: [12, 19, 3, 5, 2],
                                    backgroundColor: '#0a84ff'
                                }]
                            },
                            options: {
                                responsive: true,
                                maintainAspectRatio: false,
                                scales: { y: { beginAtZero: true, grid: { color: 'rgba(255,255,255,0.1)' }, ticks: { color: '#fff' } }, x: { ticks: { color: '#fff' } } },
                                plugins: { legend: { display: false } }
                            }
                        });
                    }
                </script>
            </body>

            </html>