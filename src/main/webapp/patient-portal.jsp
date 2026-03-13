<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Health Records | MediFlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="dashboard-body">
    <jsp:include page="includes/sidebar.jsp" />

    <main class="main-content">
        <header class="dashboard-header">
            <div>
                <h1>Health Records</h1>
                <p>Complete medical history and clinical documentation for ${sessionScope.user.fullName}</p>
            </div>
        </header>

        <c:if test="${empty patient}">
            <div class="card" style="border-left: 4px solid var(--warning);">
                <div class="card-header">
                    <h3>⚠️ Profile Linkage Required</h3>
                </div>
                <p style="margin-top: 12px; color: var(--text-muted);">We couldn't find a clinical record matching your account. Please contact the hospital administration to link your patient profile with your login credentials.</p>
            </div>
        </c:if>

        <c:if test="${not empty patient}">
            <section class="dashboard-grid">
                <div class="card">
                    <div class="card-header">
                        <h3>Clinical Summary</h3>
                    </div>
                    <div class="activity-list" style="margin-top: 16px;">
                        <div style="padding: 12px 0; border-bottom: 1px solid var(--slate-100); display: flex; justify-content: space-between;">
                            <span style="color: var(--text-muted);">Diagnosis</span>
                            <span style="font-weight: 500;">${patient.disease}</span>
                        </div>
                        <div style="padding: 12px 0; border-bottom: 1px solid var(--slate-100); display: flex; justify-content: space-between;">
                            <span style="color: var(--text-muted);">Primary Physician</span>
                            <span style="font-weight: 500;">Dr. ${patient.doctor.name}</span>
                        </div>
                        <c:if test="${not empty record}">
                            <div style="padding: 12px 0; border-bottom: 1px solid var(--slate-100); display: flex; justify-content: space-between;">
                                <span style="color: var(--text-muted);">Blood Type</span>
                                <span style="font-weight: 500;">${record.bloodType}</span>
                            </div>
                            <div style="padding: 12px 0; display: flex; justify-content: space-between;">
                                <span style="color: var(--text-muted);">Allergies</span>
                                <span style="font-weight: 500; color: var(--danger);">${record.allergies}</span>
                            </div>
                        </c:if>
                    </div>
                </div>

                <div class="card" style="grid-column: span 2;">
                    <div class="card-header">
                        <h3>Upcoming Consultations</h3>
                    </div>
                    <div class="table-responsive" style="margin-top: 16px;">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Doctor</th>
                                    <th>Date</th>
                                    <th>Type</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="app" items="${appointments}">
                                    <tr>
                                        <td style="font-weight: 500;">Dr. ${app.doctor.name}</td>
                                        <td>${app.appointmentDate}</td>
                                        <td>Follow-up</td>
                                        <td><span class="status-pill status-active">Confirmed</span></td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty appointments}">
                                    <tr><td colspan="4" style="text-align: center; color: var(--text-muted); padding: 40px;">No upcoming appointments.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </section>

            <section class="card" style="margin-top: 32px;">
                <div class="card-header">
                    <h3>Billing & Invoice History</h3>
                </div>
                <div class="table-responsive" style="margin-top: 16px;">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Invoice #</th>
                                <th>Date</th>
                                <th>Description</th>
                                <th>Amount</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="inv" items="${invoices}">
                                <tr>
                                    <td style="font-weight: 600;">#${inv.id}</td>
                                    <td>${inv.invoiceDate}</td>
                                    <td>Clinical Consultation</td>
                                    <td style="font-weight: 600; color: var(--primary);">$${inv.totalAmount}</td>
                                    <td>
                                        <span class="status-pill ${inv.status == 'PAID' ? 'status-active' : 'status-pending'}" 
                                              style="${inv.status != 'PAID' ? 'background: rgba(245, 158, 11, 0.1); color: var(--warning);' : ''}">
                                            ${inv.status}
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty invoices}">
                                <tr><td colspan="5" style="text-align: center; color: var(--text-muted); padding: 40px;">No billing records found.</td></tr>
                             </c:if>
                        </tbody>
                    </table>
                </div>
            </section>
        </c:if>
    </main>
</body>
</html>
      </html>