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
            <jsp:include page="includes/sidebar.jsp" />
            <script>document.getElementById('nav-clinical').classList.add('active');</script>

            <div class="main-content">
                <div class="hero">
                    <h1>Clinical Records</h1>
                    <p>Access and manage Electronic Health Records, Prescriptions, and Laboratory Diagnostics.</p>
                </div>

                <div class="card">
                    <div class="card-header">
                        <h3>Patient Clinical Directory</h3>
                        <p>Select a patient to view or update their electronic health record.</p>
                    </div>

                    <div class="table-container">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Patient Name</th>
                                    <th>Current Diagnosis</th>
                                    <th>Primary Physician</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="patient" items="${patients}">
                                    <tr>
                                        <td style="color: var(--text-muted); font-size: 0.8rem;">#${patient.id}</td>
                                        <td style="font-weight: 600; color: var(--slate-900);">${patient.name}</td>
                                        <td>
                                            <span class="status-pill status-active">${patient.disease}</span>
                                        </td>
                                        <td>
                                            <div style="font-size: 0.9rem;">Dr. ${patient.doctor != null ? patient.doctor.name : 'Unassigned'}</div>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/clinical?id=${patient.id}"
                                                class="btn btn-primary" style="padding: 6px 16px; font-size: 0.75rem;">
                                                Manage EHR
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty patients}">
                                    <tr>
                                        <td colspan="5" style="text-align: center; padding: 40px; color: var(--text-muted);">
                                            No patients found in the clinical records system.
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