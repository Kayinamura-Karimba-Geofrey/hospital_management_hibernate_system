<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>Dashboard - Hospital Management System</title>
        <style>
            :root {
                --primary: #4a148c;
                --secondary: #6a1b9a;
                --light: #f3e5f5;
                --dark: #311b92;
                --accent: #ff4081;
                --white: #ffffff;
                --gray: #f8f9fa;
            }

            body {
                font-family: 'Segoe UI', sans-serif;
                margin: 0;
                background: var(--gray);
                display: flex;
                min-height: 100vh;
            }

            .sidebar {
                width: 250px;
                background: var(--primary);
                color: var(--white);
                padding: 20px 0;
                flex-shrink: 0;
            }

            .sidebar-header {
                padding: 0 20px 20px;
                border-bottom: 1px solid rgba(255, 255, 255, 0.1);
                font-size: 1.5rem;
                font-weight: bold;
                text-align: center;
            }

            .sidebar-nav {
                margin-top: 20px;
            }

            .sidebar-nav a {
                display: block;
                padding: 15px 25px;
                color: rgba(255, 255, 255, 0.8);
                text-decoration: none;
                transition: all 0.3s;
            }

            .sidebar-nav a:hover {
                background: rgba(255, 255, 255, 0.1);
                color: var(--white);
                padding-left: 35px;
            }

            .main-content {
                flex-grow: 1;
                padding: 40px;
            }

            .header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 40px;
            }

            .stats-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 20px;
            }

            .stat-card {
                background: var(--white);
                padding: 25px;
                border-radius: 12px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
                text-align: center;
                transition: transform 0.3s;
            }

            .stat-card:hover {
                transform: translateY(-5px);
            }

            .stat-card h3 {
                color: #666;
                font-size: 0.9rem;
                margin-top: 0;
            }

            .stat-card .value {
                font-size: 2rem;
                font-weight: bold;
                color: var(--primary);
            }

            .action-btns {
                margin-top: 40px;
                display: flex;
                gap: 15px;
            }

            .btn {
                padding: 12px 25px;
                border-radius: 8px;
                text-decoration: none;
                font-weight: bold;
                transition: all 0.3s;
            }

            .btn-primary {
                background: var(--primary);
                color: white;
            }

            .btn-secondary {
                background: var(--secondary);
                color: white;
            }

            .hero {
                background: linear-gradient(135deg, var(--primary), var(--secondary));
                color: white;
                padding: 60px;
                border-radius: 20px;
                margin-bottom: 40px;
            }

            .hero h1 {
                margin: 0;
                font-size: 2.5rem;
            }

            .hero p {
                opacity: 0.9;
                font-size: 1.1rem;
            }
        </style>
    </head>

    <body>
        <div class="sidebar">
            <div class="sidebar-header">HMS Admin</div>
            <div class="sidebar-nav">
                <a href="${pageContext.request.contextPath}/index.jsp">🏠 Dashboard</a>
                <a href="${pageContext.request.contextPath}/departments">🏥 Departments</a>
                <a href="${pageContext.request.contextPath}/doctors">👨‍⚕️ Doctors</a>
                <a href="${pageContext.request.contextPath}/nurses">👩‍⚕️ Nurses</a>
                <a href="${pageContext.request.contextPath}/patients">🚑 Patients</a>
                <a href="${pageContext.request.contextPath}/appointments">📅 Appointments</a>
                <a href="${pageContext.request.contextPath}/register">🔐 Registration</a>
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <a href="${pageContext.request.contextPath}/logout" style="color: #ff8a80;">🚪 Logout</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login">🔑 Login</a>
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
                <p>Monitor and manage hospital operations from one central place.</p>
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

            <div class="action-btns">
                <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Add New User</a>
                <a href="${pageContext.request.contextPath}/appointments" class="btn btn-secondary">Manage Schedule</a>
            </div>
        </div>
    </body>

    </html>