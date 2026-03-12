<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>NURSE Dashboard - HMSystem</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
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

                    .NURSE-badge {
                        background: rgba(255, 159, 10, 0.2);
                        color: #ff9f0a;
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
                        <span class="role-badge NURSE-badge">NURSE</span>
                        <h1>Welcome back, ${sessionScope.user.fullName}</h1>
                        <p>Your personalized health management portal is ready.</p>
                    </div>

                    <div class="stats-grid">
                        <div class="stat-card">
                            <h3>Department</h3>
                            <div class="value" style="font-size: 1.8rem;">${nurse.department.name}</div>
                            <p class="text-muted" style="margin-top: 10px;">Current Shift: Morning</p>
                        </div>

                        <div class="stat-card">
                            <h3>Patients in Ward</h3>
                            <div class="value">${myPatientsCount}</div>
                            <a href="${pageContext.request.contextPath}/patients" class="text-muted" style="text-decoration: none; font-size: 0.9rem;">Verify Vitals →</a>
                        </div>

                        <div class="stat-card">
                            <h3>Urgent Tasks</h3>
                            <ul class="card-list">
                                <li><span>Check Bed 4A</span> <span style="color: var(--danger); font-weight: 600;">URGENT</span></li>
                                <li><span>Medication Round</span> <span class="text-muted">09:00 AM</span></li>
                                <li><span>Shift Handover</span> <span class="text-muted">02:00 PM</span></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </body>

            </html>