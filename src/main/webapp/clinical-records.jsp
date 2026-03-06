<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Clinical Records - HMSystem</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        </head>

        <body>
            <div class="sidebar">
                <div class="sidebar-header">HMSystem</div>
                <div class="sidebar-nav">
                    <a href="${pageContext.request.contextPath}/dashboard.jsp"><span>🏠</span>
                        <span>Dashboard</span></a>
                    <a href="${pageContext.request.contextPath}/departments"><span>🏥</span>
                        <span>Departments</span></a>
                    <a href="${pageContext.request.contextPath}/doctors"><span>👨‍⚕️</span> <span>Doctors</span></a>
                    <a href="${pageContext.request.contextPath}/nurses"><span>👩‍⚕️</span> <span>Nurses</span></a>
                    <a href="${pageContext.request.contextPath}/clinical" class="active"><span>📂</span> <span>Clinical
                            Records</span></a>
                    <a href="${pageContext.request.contextPath}/patients"><span>👤</span> <span>Patients</span></a>
                    <a href="${pageContext.request.contextPath}/financial"><span>💰</span> <span>Billing</span></a>
                    <a href="${pageContext.request.contextPath}/inventory"><span>📦</span> <span>Inventory</span></a>
                    <a href="${pageContext.request.contextPath}/appointments"><span>📅</span>
                        <span>Appointments</span></a>
                    <a href="${pageContext.request.contextPath}/logout" class="logout-btn"><span>🚪</span>
                        <span>Logout</span></a>
                </div>
            </div>

            <div class="main-content">
                <div class="hero">
                    <h1>Clinical Records</h1>
                    <p>Access and manage Electronic Health Records, Prescriptions, and Laboratory Diagnostics.</p>
                </div>

                <div class="card">
                    <div class="section-header" style="text-align: left; margin-bottom: 20px;">
                        <h2>Patient Directory</h2>
                        <p>Select a patient to view or update their medical file.</p>
                    </div>

                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Current Diagnosis</th>
                                    <th>Physician</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="patient" items="${patients}">
                                    <tr>
                                        <td>#${patient.id}</td>
                                        <td><strong>${patient.name}</strong></td>
                                        <td>${patient.disease}</td>
                                        <td>${patient.doctor != null ? patient.doctor.name : 'N/A'}</td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/clinical?id=${patient.id}"
                                                class="btn btn-primary" style="padding: 8px 16px; font-size: 0.85rem;">
                                                Open File
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty patients}">
                                    <tr>
                                        <td colspan="5"
                                            style="text-align: center; padding: 40px; color: var(--text-secondary);">
                                            No patients found in the system.
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </body>

        </html>