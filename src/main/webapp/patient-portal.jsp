<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.core" %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>Patient Portal - HMSystem</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                <style>
                    .portal-grid {
                        display: grid;
                        grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                        gap: 20px;
                        margin-top: 20px;
                    }

                    .portal-card {
                        background: rgba(255, 255, 255, 0.05);
                        backdrop-filter: blur(10px);
                        border: 1px solid rgba(255, 255, 255, 0.1);
                        border-radius: 15px;
                        padding: 20px;
                    }

                    .portal-card h3 {
                        margin-top: 0;
                        color: #4facfe;
                        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
                        padding-bottom: 10px;
                        display: flex;
                        align-items: center;
                        gap: 10px;
                    }

                    .data-list {
                        list-style: none;
                        padding: 0;
                    }

                    .data-item {
                        padding: 10px 0;
                        border-bottom: 1px solid rgba(255, 255, 255, 0.05);
                    }

                    .data-item:last-child {
                        border-bottom: none;
                    }

                    .status-badge {
                        padding: 2px 8px;
                        border-radius: 10px;
                        font-size: 0.8em;
                    }

                    .status-paid {
                        background: rgba(0, 255, 0, 0.2);
                        color: #00ff00;
                    }

                    .status-pending {
                        background: rgba(255, 165, 0, 0.2);
                        color: #ffa500;
                    }
                </style>
            </head>

            <body>
                <div class="sidebar">
                    <div class="sidebar-header">HMSystem</div>
                    <div class="sidebar-nav">
                        <a href="${pageContext.request.contextPath}/dashboard.jsp"><span>🏠</span>
                            <span>Dashboard</span></a>
                        <a href="${pageContext.request.contextPath}/patient-portal" class="active"><span>👤</span>
                            <span>My Portal</span></a>
                        <a href="${pageContext.request.contextPath}/logout" class="logout-btn"><span>🚪</span>
                            <span>Logout</span></a>
                    </div>
                </div>
                <div class="main-content">
                    <div class="hero">
                        <h1>Patient Portal</h1>
                        <p>Welcome, ${sessionScope.user.fullName}. Here is your healthcare overview.</p>
                    </div>

                    <c:if test="${empty patient}">
                        <div class="portal-card" style="margin-top: 20px;">
                            <h3>⚠️ Profile Incomplete</h3>
                            <p>We couldn't find a clinical record matching your account. Please contact the hospital
                                administration to link your patient profile.</p>
                        </div>
                    </c:if>

                    <c:if test="${not empty patient}">
                        <div class="portal-grid">
                            <!-- Clinical Summary -->
                            <div class="portal-card">
                                <h3><span>📂</span> Clinical Overview</h3>
                                <div class="data-list">
                                    <div class="data-item"><strong>Name:</strong> ${patient.name}</div>
                                    <div class="data-item"><strong>Diagnosis:</strong> ${patient.disease}</div>
                                    <div class="data-item"><strong>Primary Doctor:</strong> ${patient.doctor.name}</div>
                                    <c:if test="${not empty record}">
                                        <div class="data-item"><strong>Blood Type:</strong> ${record.bloodType}</div>
                                        <div class="data-item"><strong>Allergies:</strong> ${record.allergies}</div>
                                    </c:if>
                                </div>
                            </div>

                            <!-- Upcoming Appointments -->
                            <div class="portal-card">
                                <h3><span>📅</span> Appointments</h3>
                                <div class="data-list">
                                    <c:choose>
                                        <c:when test="${empty appointments}">
                                            <p>No upcoming appointments found.</p>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="app" items="${appointments}">
                                                <div class="data-item">
                                                    <div><strong>Date:</strong> ${app.appointmentDate}</div>
                                                    <div><strong>Doctor:</strong> ${app.doctor.name}</div>
                                                </div>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <!-- Billing History -->
                            <div class="portal-card">
                                <h3><span>💰</span> Billing History</h3>
                                <div class="data-list">
                                    <c:choose>
                                        <c:when test="${empty invoices}">
                                            <p>No billing records found.</p>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="inv" items="${invoices}">
                                                <div class="data-item"
                                                    style="display: flex; justify-content: space-between; align-items: center;">
                                                    <div>
                                                        <strong>#${inv.id}</strong> - ${inv.invoiceDate}
                                                        <div style="font-size: 1.2em; color: #4facfe;">
                                                            $${inv.totalAmount}</div>
                                                    </div>
                                                    <span
                                                        class="status-badge ${inv.status == 'PAID' ? 'status-paid' : 'status-pending'}">${inv.status}</span>
                                                </div>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>
            </body>

            </html>