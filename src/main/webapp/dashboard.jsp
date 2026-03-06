<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Dashboard - HMSystem</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        </head>

        <body>
            <div class="sidebar">
                <div class="sidebar-header">HMSystem</div>
                <div class="sidebar-nav">
                    <a href="${pageContext.request.contextPath}/dashboard.jsp" class="active"><span>🏠</span>
                        <span>Dashboard</span></a>
                    <a href="${pageContext.request.contextPath}/departments"><span>🏥</span>
                        <span>Departments</span></a>
                    <a href="${pageContext.request.contextPath}/doctors"><span>👨‍⚕️</span> <span>Doctors</span></a>
                    <a href="${pageContext.request.contextPath}/nurses"><span>👩‍⚕️</span> <span>Nurses</span></a>
                    <a href="${pageContext.request.contextPath}/clinical"><span>📂</span> <span>Clinical
                            Records</span></a>
                    <a href="${pageContext.request.contextPath}/patients"><span>👤</span> <span>Patients</span></a>
                    <a href="${pageContext.request.contextPath}/financial"><span>💰</span> <span>Billing</span></a>
                    <a href="${pageContext.request.contextPath}/inventory"><span>📦</span> <span>Inventory</span></a>
                    <a href="${pageContext.request.contextPath}/facility"><span>🏢</span> <span>Facility</span></a>
                    <a href="${pageContext.request.contextPath}/surgery"><span>🔪</span> <span>Surgeries</span></a>
                    <a href="${pageContext.request.contextPath}/appointments"><span>📅</span>
                        <span>Appointments</span></a>
                    <a href="${pageContext.request.contextPath}/register"><span>🔐</span> <span>Registration</span></a>
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <a href="${pageContext.request.contextPath}/logout" class="logout-btn"><span>🚪</span>
                                <span>Logout</span></a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login" class="logout-btn"><span>🔑</span>
                                <span>Login</span></a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
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

                <div class="stats-grid">
                    <div class="stat-card">
                        <h3>Total Patients</h3>
                        <div class="value">Ready</div>
                    </div>
                    <div class="stat-card">
                        <h3>Active Doctors</h3>
                        <div class="value">Active</div>
                    </div>
                    <div class="stat-card">
                        <h3>Nurses</h3>
                        <div class="value">On-Duty</div>
                    </div>
                    <div class="stat-card">
                        <h3>Appointments</h3>
                        <div class="value">Scheduled</div>
                    </div>
                </div>

                <div class="action-btns" style="display: flex; gap: 15px;">
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Add New User</a>
                    <a href="${pageContext.request.contextPath}/appointments" class="btn btn-secondary">Manage
                        Schedule</a>
                </div>
            </div>
        </body>

        </html>