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
            <jsp:include page="includes/sidebar.jsp" />
            <script>document.getElementById('nav-surgery').classList.add('active');</script>

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
                                        <div style="font-weight: 600; font-size: 1.1rem;">${s.patient.name}</div>
                                        <div style="font-size: 0.8rem; opacity: 0.7;">Equipment: ${s.equipment}</div>
                                    </td>
                                    <td>
                                        <div style="font-size: 0.8rem; opacity: 0.6;">SURGEON</div>
                                        <strong>Dr. ${s.surgeon.name}</strong>
                                        <div style="font-size: 0.75rem; color: var(--primary);">Anes: ${s.anesthetist !=
                                            null ? s.anesthetist.name : 'N/A'}</div>
                                    </td>
                                    <td style="text-align: right;">
                                        <div class="time-badge">${s.surgeryDateTime}</div>
                                        <div style="font-size: 0.8rem; margin-top: 5px; opacity: 0.6;">Duration:
                                            ${s.durationMinutes} min</div>
                                        <div
                                            style="margin-top: 10px; display: flex; gap: 5px; justify-content: flex-end;">
                                            <button class="btn btn-secondary"
                                                style="padding: 4px 8px; font-size: 0.7rem; background: rgba(255,255,255,0.1);"
                                                onclick="editSurgery('${s.id}', '${s.patient.id}', '${s.surgeon.id}', '${s.anesthetist.id}', '${s.otRoomName}', '${s.surgeryDateTime}', '${s.durationMinutes}', '${s.equipment}')">
                                                Edit
                                            </button>
                                            <form
                                                action="${pageContext.request.contextPath}/surgery?action=deleteSurgery"
                                                method="post" style="margin: 0;"
                                                onsubmit="return confirm('Are you sure?')">
                                                <input type="hidden" name="csrfToken" value="${csrfToken}">
                                                <input type="hidden" name="surgeryId" value="${s.id}">
                                                <button type="submit" class="btn btn-danger"
                                                    style="padding: 4px 8px; font-size: 0.7rem; background: rgba(255, 82, 82, 0.2); color: #ff5252; border: 1px solid rgba(255, 82, 82, 0.3);">
                                                    Delete
                                                </button>
                                            </form>
                                        </div>
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
                        <h3 id="form-title">Schedule Surgery</h3>
                        <form id="surgery-form"
                            action="${pageContext.request.contextPath}/surgery?action=scheduleSurgery" method="post">
                            <input type="hidden" name="csrfToken" value="${csrfToken}">
                            <input type="hidden" name="surgeryId" id="form-surgeryId">
                            <div class="form-group">
                                <label>Patient</label>
                                <select name="patientId" required>
                                    <c:forEach var="p" items="${patients}">
                                        <option value="${p.id}">${p.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Lead Surgeon</label>
                                <select name="surgeonId" required>
                                    <c:forEach var="d" items="${doctors}">
                                        <option value="${d.id}">Dr. ${d.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Anesthetist</label>
                                <select name="anesthetistId">
                                    <option value="">Select Anesthetist (Optional)</option>
                                    <c:forEach var="d" items="${doctors}">
                                        <option value="${d.id}">Dr. ${d.name}</option>
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
                            <div style="display: flex; gap: 10px; margin-top: 10px;">
                                <button type="submit" id="submit-btn" class="btn btn-primary" style="flex: 1;">Confirm
                                    Schedule</button>
                                <button type="button" id="cancel-btn" class="btn btn-secondary"
                                    style="display: none; flex: 1;" onclick="resetForm()">Cancel</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <script>
                function editSurgery(id, patientId, surgeonId, anesthetistId, room, dateTime, duration, equipment) {
                    document.getElementById('form-title').innerText = 'Update Surgery';
                    document.getElementById('form-surgeryId').value = id;
                    document.querySelector('select[name="patientId"]').value = patientId;
                    document.querySelector('select[name="surgeonId"]').value = surgeonId;
                    document.querySelector('select[name="anesthetistId"]').value = anesthetistId || "";
                    document.querySelector('select[name="otRoomName"]').value = room;

                    // Format dateTime for input (remove 'T' if present or fix format)
                    if (dateTime) {
                        // The value from EL might be '2026-03-10T08:00'
                        document.querySelector('input[name="dateTime"]').value = dateTime;
                    }

                    document.querySelector('input[name="duration"]').value = duration;
                    document.querySelector('input[name="equipment"]').value = equipment === 'null' ? "" : equipment;

                    document.getElementById('submit-btn').innerText = 'Update Schedule';
                    document.getElementById('cancel-btn').style.display = 'block';
                    window.scrollTo({ top: 0, behavior: 'smooth' });
                }

                function resetForm() {
                    document.getElementById('form-title').innerText = 'Schedule Surgery';
                    document.getElementById('form-surgeryId').value = '';
                    document.getElementById('surgery-form').reset();
                    document.getElementById('submit-btn').innerText = 'Confirm Schedule';
                    document.getElementById('cancel-btn').style.display = 'none';
                }
            </script>
        </body>

        </html>