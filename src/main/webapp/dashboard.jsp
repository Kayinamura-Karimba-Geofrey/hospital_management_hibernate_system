<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Dashboard - HMSystem</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
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