<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>PATIENT Dashboard - HMSystem</title>
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
                        <span class="role-badge PATIENT-badge">PATIENT</span>
                        <h1>Welcome back, ${sessionScope.user.fullName}</h1>
                        <p>Your personalized health management portal is ready.</p>
                    </div>

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
                                    <li><span class="text-muted">You have no upcoming appointments</span></li>
                                </c:if>
                            </ul>
                            <a href="${pageContext.request.contextPath}/patient-portal" class="btn btn-primary btn-sm"
                                style="display: block; text-align: center; margin-top: 10px;">Book Appointment</a>
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
                            <a href="${pageContext.request.contextPath}/patient-portal" class="text-muted">View Billing
                                History →</a>
                        </div>

                        <div class="stat-card"
                            style="background: rgba(255, 255, 255, 0.03); border-radius: 15px; padding: 25px; border: 1px solid rgba(255,255,255,0.05);">
                            <h3>Clinical Summary</h3>
                            <c:if test="${not empty medicalRecord}">
                                <div style="margin-top: 15px;">
                                    <p><strong>Primary Doctor:</strong> ${medicalRecord.doctor.name}</p>
                                    <p><strong>Last Visit:</strong> ${medicalRecord.lastVisitDate}</p>
                                    <p><strong>Status:</strong> <span class="text-muted">${medicalRecord.status}</span>
                                    </p>
                                </div>
                            </c:if>
                            <c:if test="${empty medicalRecord}">
                                <p class="text-muted">No clinical records found.</p>
                            </c:if>
                            <a href="${pageContext.request.contextPath}/patient-portal" class="text-muted">Full Health
                                Record →</a>
                        </div>
                    </div>
                </div>
            </body>

            </html>