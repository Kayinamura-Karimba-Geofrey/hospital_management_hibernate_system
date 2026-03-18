<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Appointments - HMSystem</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        </head>

        <body>
            <jsp:include page="includes/sidebar.jsp" />
            <script>document.getElementById('nav-appointments').classList.add('active');</script>
            <div class="main-content">
                <h2>Appointment Scheduling</h2>

                <div class="card">
                    <h3>${editableApp != null ? 'Edit' : 'Schedule New'} Appointment</h3>
                    <form action="appointments" method="post"
                        style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; align-items: end;">
                        <input type="hidden" name="csrfToken" value="${csrfToken}">
                        <input type="hidden" name="id" value="${editableApp.id}">
                        <div class="form-group">
                            <label>Select Patient</label>
                            <select name="patientId" required>
                                <option value="" disabled>Select Patient</option>
                                <c:forEach var="p" items="${patients}">
                                    <option value="${p.id}" ${(editableApp !=null && editableApp.patient.id==p.id)
                                        ? 'selected' : '' }>${p.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Date</label>
                            <input type="date" name="appointmentDate" required value="${editableApp.appointmentDate}">
                        </div>
                        <div class="form-group">
                            <label>Time</label>
                            <input type="time" name="appointmentTime" required value="${editableApp.appointmentTime}">
                        </div>
                        <div class="form-actions" style="display: flex; gap: 10px;">
                            <button type="submit" class="btn btn-primary" style="flex-grow: 1;">
                                ${editableApp != null ? 'Update' : 'Book'} Appointment
                            </button>
                            <c:if test="${editableApp != null}">
                                <a href="appointments" class="btn btn-secondary">Cancel</a>
                            </c:if>
                        </div>
                    </form>
                </div>

                <div class="card">
                    <div class="card-header">
                        <h3>Upcoming Appointments</h3>
                    </div>
                    <div class="table-container">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Patient</th>
                                    <th>Physician</th>
                                    <th>Date & Time</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="app" items="${appointments}">
                                    <tr>
                                        <td style="color: var(--text-muted); font-size: 0.8rem;">#${app.id}</td>
                                        <td style="font-weight: 600; color: var(--slate-900);">${app.patient.name}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty app.doctor}">
                                                    Dr. ${app.doctor.name}
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: var(--text-muted); font-style: italic;">Pending assignment</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div style="font-weight: 500;">${app.appointmentDate}</div>
                                            <div style="font-size: 0.8rem; color: var(--text-muted);">${app.appointmentTime}</div>
                                        </td>
                                        <td>
                                            <span class="status-pill ${app.status == 'REQUESTED' ? 'status-requested' : (app.status == 'REJECTED' ? 'status-rejected' : 'status-active')}">
                                                ${app.status != null ? app.status : 'CONFIRMED'}
                                            </span>
                                            <c:if test="${app.status == 'REJECTED' && not empty app.rejectionReason}">
                                                <div style="font-size: 0.75rem; color: var(--text-muted); margin-top: 4px; max-width: 250px;">
                                                    <strong style="color: var(--danger);">Reason:</strong> ${app.rejectionReason}
                                                </div>
                                            </c:if>
                                        </td>
                                        <td>
                                            <div style="display: flex; gap: 8px;">
                                                <a href="appointments?action=edit&id=${app.id}" class="btn btn-secondary" style="padding: 6px 12px; font-size: 0.75rem;">Reschedule</a>
                                                <a href="javascript:void(0)" onclick="confirmDelete('${app.id}')" class="btn btn-secondary" style="padding: 6px 12px; font-size: 0.75rem; color: var(--danger); border-color: rgba(239, 68, 68, 0.2);">Cancel</a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty appointments}">
                                    <tr>
                                        <td colspan="6" style="text-align: center; color: var(--text-muted); padding: 40px;">No appointments scheduled for this period.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <script>
                function confirmDelete(id) {
                    if (confirm("Are you sure you want to delete this appointment?")) {
                        window.location.href = "appointments?action=delete&id=" + id;
                    }
                }
            </script>
        </body>

        </html>