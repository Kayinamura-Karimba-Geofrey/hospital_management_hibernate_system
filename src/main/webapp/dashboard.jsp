<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>${sessionScope.role} Dashboard - HMSystem</title>
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

                    .DOCTOR-badge {
                        background: rgba(10, 132, 255, 0.2);
                        color: #0a84ff;
                    }

                    .NURSE-badge {
                        background: rgba(255, 159, 10, 0.2);
                        color: #ff9f0a;
                    }

                    .PATIENT-badge {
                        background: rgba(48, 209, 88, 0.2);
                        color: #30d158;
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
                        <span class="role-badge ${sessionScope.role}-badge">${sessionScope.role}</span>
                        <h1>Welcome back, ${sessionScope.user.fullName}</h1>
                        <p>Your personalized health management portal is ready.</p>
                    </div>

                    <%-- ADMIN DASHBOARD --%>
                        <c:if test="${sessionScope.role == 'ADMIN'}">
                            <div class="stats-grid"
                                style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-top: 30px;">
                                <div class="stat-card"
                                    style="background: rgba(255, 255, 255, 0.05); border-radius: 12px; padding: 20px; text-align: center; border: 1px solid rgba(255, 255, 255, 0.1);">
                                    <p class="text-muted" style="margin: 0;">Total Patients</p>
                                    <h2 style="margin: 10px 0; color: #4facfe;">${not empty totalPatients ?
                                        totalPatients : 0}</h2>
                                </div>
                                <div class="stat-card"
                                    style="background: rgba(255, 255, 255, 0.05); border-radius: 12px; padding: 20px; text-align: center; border: 1px solid rgba(255, 255, 255, 0.1);">
                                    <p class="text-muted" style="margin: 0;">Active Staff</p>
                                    <h2 style="margin: 10px 0; color: #00f2fe;">${not empty activeStaff ? activeStaff :
                                        0}</h2>
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
                                <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Add New
                                    User</a>
                                <a href="${pageContext.request.contextPath}/analytics" class="btn btn-secondary">Full
                                    Analytics</a>
                            </div>
                        </c:if>

                        <%-- DOCTOR DASHBOARD --%>
                            <c:if test="${sessionScope.role == 'DOCTOR'}">
                                <div class="grid-3">
                                    <div class="stat-card"
                                        style="background: rgba(10, 132, 255, 0.05); border-radius: 15px; padding: 25px; border: 1px solid rgba(10, 132, 255, 0.2);">
                                        <h3>My Patients</h3>
                                        <h2 style="font-size: 3rem; color: #0a84ff;">${myPatientsCount}</h2>
                                        <p class="text-muted">Assigned under your care</p>
                                        <a href="${pageContext.request.contextPath}/patients"
                                            style="color: #0a84ff; text-decoration: none; font-size: 0.9rem;">View All
                                            →</a>
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
                                        <a href="${pageContext.request.contextPath}/appointments"
                                            class="text-muted">Full Schedule →</a>
                                    </div>

                                    <div class="stat-card"
                                        style="background: rgba(255, 255, 255, 0.03); border-radius: 15px; padding: 25px; border: 1px solid rgba(255,255,255,0.05);">
                                        <h3>Patient Load</h3>
                                        <canvas id="doctorChart" style="max-height: 150px;"></canvas>
                                    </div>
                                </div>
                            </c:if>

                            <%-- PATIENT DASHBOARD --%>
                                <c:if test="${sessionScope.role == 'PATIENT'}">
                                    <div class="grid-3">
                                        <div class="stat-card"
                                            style="background: rgba(48, 209, 88, 0.05); border-radius: 15px; padding: 25px; border: 1px solid rgba(48, 209, 88, 0.2);">
                                            <h3>My Appointments</h3>
                                            <ul class="card-list">
                                                <c:forEach var="app" items="${myAppointments}" end="2">
                                                    <li>
                                                        <div>
                                                            <div style="font-weight: 600;">${app.doctor.name}</div>
                                                            <div class="text-muted">${app.appointmentDate}</div>
                                                        </div>
                                                        <span class="role-badge"
                                                            style="background: rgba(48, 209, 88, 0.2); color: #30d158;">Confirmed</span>
                                                    </li>
                                                </c:forEach>
                                                <c:if test="${empty myAppointments}">
                                                    <li><span class="text-muted">You have no upcoming
                                                            appointments</span></li>
                                                </c:if>
                                            </ul>
                                            <a href="${pageContext.request.contextPath}/patient-portal"
                                                class="btn btn-primary btn-sm"
                                                style="display: block; text-align: center; margin-top: 10px;">Book
                                                Appointment</a>
                                        </div>

                                        <div class="stat-card"
                                            style="background: rgba(255, 255, 255, 0.03); border-radius: 15px; padding: 25px; border: 1px solid rgba(255,255,255,0.05);">
                                            <h3>Recent Bills</h3>
                                            <ul class="card-list">
                                                <c:forEach var="inv" items="${myInvoices}" end="2">
                                                    <li>
                                                        <span>Invoice #${inv.id}</span>
                                                        <span style="font-weight: 600;">$${inv.totalAmount}</span>
                                                    </li>
                                                </c:forEach>
                                                <c:if test="${empty myInvoices}">
                                                    <li><span class="text-muted">No recent billing activity</span></li>
                                                </c:if>
                                            </ul>
                                            <a href="${pageContext.request.contextPath}/patient-portal"
                                                class="text-muted">View Billing History →</a>
                                        </div>

                                        <div class="stat-card"
                                            style="background: rgba(255, 255, 255, 0.03); border-radius: 15px; padding: 25px; border: 1px solid rgba(255,255,255,0.05);">
                                            <h3>Clinical Summary</h3>
                                            <c:if test="${not empty medicalRecord}">
                                                <div style="margin-top: 15px;">
                                                    <p><strong>Primary Doctor:</strong> ${medicalRecord.doctor.name}</p>
                                                    <p><strong>Last Visit:</strong> ${medicalRecord.lastVisitDate}</p>
                                                    <p><strong>Status:</strong> <span
                                                            class="text-muted">${medicalRecord.status}</span></p>
                                                </div>
                                            </c:if>
                                            <c:if test="${empty medicalRecord}">
                                                <p class="text-muted">No clinical records found.</p>
                                            </c:if>
                                            <a href="${pageContext.request.contextPath}/patient-portal"
                                                class="text-muted">Full Health Record →</a>
                                        </div>
                                    </div>
                                </c:if>

                                <%-- NURSE DASHBOARD --%>
                                    <c:if test="${sessionScope.role == 'NURSE'}">
                                        <div class="grid-3">
                                            <div class="stat-card"
                                                style="background: rgba(255, 159, 10, 0.05); border-radius: 15px; padding: 25px; border: 1px solid rgba(255, 159, 10, 0.2);">
                                                <h3>Department: <span
                                                        style="color: #ff9f0a;">${nurse.department.name}</span></h3>
                                                <p class="text-muted" style="margin-top: 10px;">Current Shift: Morning
                                                </p>
                                            </div>

                                            <div class="stat-card"
                                                style="background: rgba(255, 255, 255, 0.03); border-radius: 15px; padding: 25px; border: 1px solid rgba(255,255,255,0.05);">
                                                <h3>Patients in Ward</h3>
                                                <h2 style="font-size: 2.5rem;">${myPatientsCount}</h2>
                                                <a href="${pageContext.request.contextPath}/patients"
                                                    class="text-muted">Verify Vitals →</a>
                                            </div>

                                            <div class="stat-card"
                                                style="background: rgba(255, 255, 255, 0.03); border-radius: 15px; padding: 25px; border: 1px solid rgba(255,255,255,0.05);">
                                                <h3>Urgent Tasks</h3>
                                                <ul class="card-list">
                                                    <li><span>Check Bed 4A</span> <span
                                                            style="color: #ff453a;">URGENT</span></li>
                                                    <li><span>Medication Round</span> <span class="text-muted">09:00
                                                            AM</span></li>
                                                    <li><span>Shift Handover</span> <span class="text-muted">02:00
                                                            PM</span></li>
                                                </ul>
                                            </div>
                                        </div>
                                    </c:if>
                </div>

                <script>
                    // ADMIN CHART
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

                    // DOCTOR CHART
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