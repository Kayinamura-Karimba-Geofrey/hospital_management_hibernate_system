<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Surgery Schedule - HMSystem</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
            <style>
                .surgery-table {
                    width: 100%;
                    border-collapse: separate;
                    border-spacing: 0 10px;
                }

                .surgery-table tr {
                    background: rgba(255, 255, 255, 0.03);
                    border-radius: 12px;
                }

                .surgery-table td {
                    padding: 20px;
                    border: 1px solid var(--glass-border);
                    border-width: 1px 0;
                }

                .surgery-table td:first-child {
                    border-left-width: 1px;
                    border-radius: 12px 0 0 12px;
                }

                .surgery-table td:last-child {
                    border-right-width: 1px;
                    border-radius: 0 12px 12px 0;
                }

                .time-badge {
                    background: var(--primary);
                    color: white;
                    padding: 4px 12px;
                    border-radius: 20px;
                    font-size: 0.8rem;
                    font-weight: 600;
                }

                .room-tag {
                    color: var(--primary);
                    font-weight: 800;
                    font-size: 0.7rem;
                    letter-spacing: 1px;
                    display: block;
                    margin-bottom: 5px;
                }
            </style>
        </head>

        <body>
            <div class="sidebar">
                <div class="sidebar-header">HMSystem</div>
                <div class="sidebar-nav">
                    <a href="${pageContext.request.contextPath}/dashboard.jsp"><span>🏠</span>
                        <span>Dashboard</span></a>

                    <c:if test="${sessionScope.role == 'ADMIN'}">
                        <a href="${pageContext.request.contextPath}/departments"><span>🏥</span>
                            <span>Departments</span></a>
                        <a href="${pageContext.request.contextPath}/register"><span>🔐</span>
                            <span>Registration</span></a>
                    </c:if>

                    <c:if test="${sessionScope.role == 'ADMIN' || sessionScope.role == 'DOCTOR'}">
                        <a href="${pageContext.request.contextPath}/doctors"><span>👨‍⚕️</span> <span>Doctors</span></a>
                        <a href="${pageContext.request.contextPath}/surgery" class="active"><span>🔪</span>
                            <span>Surgeries</span></a>
                    </c:if>

                    <c:if test="${sessionScope.role == 'ADMIN' || sessionScope.role == 'NURSE'}">
                        <a href="${pageContext.request.contextPath}/nurses"><span>👩‍⚕️</span> <span>Nurses</span></a>
                    </c:if>

                    <c:if
                        test="${sessionScope.role == 'ADMIN' || sessionScope.role == 'DOCTOR' || sessionScope.role == 'NURSE'}">
                        <a href="${pageContext.request.contextPath}/clinical"><span>📂</span> <span>Clinical
                                Records</span></a>
                        <a href="${pageContext.request.contextPath}/patients"><span>👤</span> <span>Patients</span></a>
                        <a href="${pageContext.request.contextPath}/facility"><span>🏢</span> <span>Facility</span></a>
                        <a href="${pageContext.request.contextPath}/appointments"><span>📅</span>
                            <span>Appointments</span></a>
                    </c:if>

                    <c:if test="${sessionScope.role == 'ADMIN' || sessionScope.role == 'ACCOUNTANT'}">
                        <a href="${pageContext.request.contextPath}/financial"><span>💰</span> <span>Billing</span></a>
                        <a href="${pageContext.request.contextPath}/inventory"><span>📦</span>
                            <span>Inventory</span></a>
                    </c:if>

                    <c:if test="${sessionScope.role == 'PATIENT'}">
                        <a href="${pageContext.request.contextPath}/patient-portal"><span>👤</span> <span>My
                                Portal</span></a>
                    </c:if>

                    <a href="${pageContext.request.contextPath}/logout" class="logout-btn"><span>🚪</span>
                        <span>Logout</span></a>
                </div>
            </div>

            <div class="main-content">
                <div class="hero">
                    <h1>OT & Surgery Scheduling</h1>
                    <p>Coordinate surgical operations, anesthetists, and operating theater availability.</p>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 350px; gap: 30px;">
                    <div>
                        <h3>Upcoming Operations</h3>
                        <table class="surgery-table">
                            <c:forEach var="s" items="${surgeries}">
                                <tr>
                                    <td>
                                        <span class="room-tag">${s.otRoomName}</span>
                                        <div style="font-weight: 600; font-size: 1.1rem;">${s.patient.fullName}</div>
                                        <div style="font-size: 0.8rem; opacity: 0.7;">Equipment: ${s.equipment}</div>
                                    </td>
                                    <td>
                                        <div style="font-size: 0.8rem; opacity: 0.6;">SURGEON</div>
                                        <strong>Dr. ${s.surgeon.fullName}</strong>
                                        <div style="font-size: 0.75rem; color: var(--primary);">Anes: ${s.anesthetist !=
                                            null ? s.anesthetist.fullName : 'N/A'}</div>
                                    </td>
                                    <td style="text-align: right;">
                                        <div class="time-badge">${s.surgeryDateTime}</div>
                                        <div style="font-size: 0.8rem; margin-top: 5px; opacity: 0.6;">Duration:
                                            ${s.durationMinutes} min</div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty surgeries}">
                                <tr>
                                    <td colspan="3"
                                        style="text-align: center; padding: 40px; color: var(--text-secondary);">No
                                        surgeries scheduled.</td>
                                </tr>
                            </c:if>
                        </table>
                    </div>

                    <div class="card">
                        <h3>Schedule Surgery</h3>
                        <form action="${pageContext.request.contextPath}/surgery?action=scheduleSurgery" method="post">
                            <div class="form-group">
                                <label>Patient</label>
                                <select name="patientId" required>
                                    <c:forEach var="p" items="${patients}">
                                        <option value="${p.id}">${p.fullName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Lead Surgeon</label>
                                <select name="surgeonId" required>
                                    <c:forEach var="d" items="${doctors}">
                                        <option value="${d.id}">Dr. ${d.fullName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Operating Theater</label>
                                <select name="otRoomName">
                                    <option value="OT-1 (Main)">OT-1 (Main)</option>
                                    <option value="OT-2 (Cardiac)">OT-2 (Cardiac)</option>
                                    <option value="OT-3 (Minor)">OT-3 (Minor)</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Date & Time</label>
                                <input type="datetime-local" name="dateTime" required>
                            </div>
                            <div class="form-group">
                                <label>Duration (Minutes)</label>
                                <input type="number" name="duration" value="60" required>
                            </div>
                            <div class="form-group">
                                <label>Special Equipment</label>
                                <input type="text" name="equipment" placeholder="Laser, Robotic Arm, etc.">
                            </div>
                            <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 10px;">Confirm
                                Schedule</button>
                        </form>
                    </div>
                </div>
            </div>
        </body>

        </html>