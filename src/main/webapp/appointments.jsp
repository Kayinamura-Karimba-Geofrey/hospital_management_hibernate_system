<!DOCTYPE html>
<html>

<head>
    <title>Appointments - HMSystem</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>

<body>
    <div class="sidebar">
        <div class="sidebar-header">HMSystem</div>
        <div class="sidebar-nav">
            <a href="${pageContext.request.contextPath}/index.jsp"><span>🏠</span> <span>Dashboard</span></a>
            <a href="${pageContext.request.contextPath}/departments"><span>🏥</span> <span>Departments</span></a>
            <a href="${pageContext.request.contextPath}/doctors"><span>👨‍⚕️</span> <span>Doctors</span></a>
            <a href="${pageContext.request.contextPath}/nurses"><span>👩‍⚕️</span> <span>Nurses</span></a>
            <a href="${pageContext.request.contextPath}/patients"><span>🚑</span> <span>Patients</span></a>
            <a href="${pageContext.request.contextPath}/appointments" class="active"><span>📅</span>
                <span>Appointments</span></a>
            <a href="${pageContext.request.contextPath}/register"><span>🔐</span> <span>Registration</span></a>
            <a href="${pageContext.request.contextPath}/logout"
                style="color: var(--danger); margin-top: auto; border-top: 1px solid var(--border);"><span>🚪</span>
                <span>Logout</span></a>
        </div>
    </div>
    <div class="main-content">
        <h2>Appointment Scheduling</h2>

        <div class="card">
            <h3>${editableApp != null ? 'Edit' : 'Schedule New'} Appointment</h3>
            <form action="appointments" method="post"
                style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; align-items: end;">
                <input type="hidden" name="id" value="${editableApp.id}">
                <div class="form-group">
                    <label>Select Patient</label>
                    <select name="patientId" required>
                        <option value="" disabled>Select Patient</option>
                        <c:forEach var="p" items="${patients}">
                            <option value="${p.id}" ${(editableApp !=null && editableApp.patient.id==p.id) ? 'selected'
                                : '' }>${p.name}</option>
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
            <h3>Upcoming Appointments</h3>
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Patient</th>
                            <th>Doctor</th>
                            <th>Date</th>
                            <th>Time</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="app" items="${appointments}">
                            <tr>
                                <td>${app.id}</td>
                                <td>${app.patient.name}</td>
                                <td>${app.patient.doctor.name}</td>
                                <td>${app.appointmentDate}</td>
                                <td>${app.appointmentTime}</td>
                                <td style="display: flex; gap: 10px;">
                                    <a href="appointments?action=edit&id=${app.id}" class="btn btn-info btn-sm">Edit</a>
                                    <a href="javascript:void(0)" onclick="confirmDelete('${app.id}')"
                                        class="btn btn-danger btn-sm">Delete</a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty appointments}">
                            <tr>
                                <td colspan="6"
                                    style="text-align: center; color: var(--text-secondary); padding: 40px;">No
                                    appointments scheduled.</td>
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