<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Patients - Hospital Management System</title>
            <style>
                :root {
                    --primary: #4a148c;
                    --secondary: #6a1b9a;
                    --white: #ffffff;
                    --gray: #f8f9fa;
                    --danger: #c62828;
                    --info: #0277bd;
                }

                body {
                    font-family: 'Segoe UI', sans-serif;
                    margin: 0;
                    background: var(--gray);
                    display: flex;
                }

                .sidebar {
                    width: 250px;
                    background: var(--primary);
                    color: var(--white);
                    min-height: 100vh;
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

                .card {
                    background: var(--white);
                    padding: 25px;
                    border-radius: 12px;
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
                    margin-bottom: 30px;
                }

                h2 {
                    color: var(--primary);
                    margin-top: 0;
                }

                .form-group {
                    margin-bottom: 1rem;
                }

                label {
                    display: block;
                    margin-bottom: 0.5rem;
                    font-weight: bold;
                }

                input,
                select {
                    width: 100%;
                    padding: 0.8rem;
                    border: 1px solid #ddd;
                    border-radius: 5px;
                    box-sizing: border-box;
                }

                .btn {
                    padding: 10px 20px;
                    border-radius: 5px;
                    cursor: pointer;
                    border: none;
                    font-weight: bold;
                    text-decoration: none;
                    display: inline-block;
                    font-size: 0.9rem;
                }

                .btn-primary {
                    background: var(--primary);
                    color: white;
                }

                .btn-info {
                    background: var(--info);
                    color: white;
                    margin-right: 5px;
                }

                .btn-danger {
                    background: var(--danger);
                    color: white;
                }

                table {
                    width: 100%;
                    border-collapse: collapse;
                    margin-top: 20px;
                }

                th,
                td {
                    padding: 12px;
                    text-align: left;
                    border-bottom: 1px solid #eee;
                }

                th {
                    background: #fdfafd;
                    color: var(--primary);
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
                </div>
            </div>
            <div class="main-content">
                <h2>Patient Records</h2>

                <div class="card">
                    <h3>${editablePatient != null ? 'Edit' : 'Register New'} Patient</h3>
                    <form action="patients" method="post"
                        style="display: grid; grid-template-columns: 1fr 1fr 1fr 1fr auto; gap: 15px; align-items: end;">
                        <input type="hidden" name="id" value="${editablePatient.id}">
                        <div class="form-group">
                            <label>Patient Name</label>
                            <input type="text" name="name" required placeholder="John Doe"
                                value="${editablePatient.name}">
                        </div>
                        <div class="form-group">
                            <label>Disease/Diagnosis</label>
                            <input type="text" name="disease" required placeholder="e.g. Fever"
                                value="${editablePatient.disease}">
                        </div>
                        <div class="form-group">
                            <label>Assigned Doctor</label>
                            <select name="doctorId" required>
                                <option value="" disabled>Select Doctor</option>
                                <c:forEach var="doc" items="${doctors}">
                                    <option value="${doc.id}" ${(editablePatient !=null &&
                                        editablePatient.doctor.id==doc.id) ? 'selected' : '' }>${doc.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Assigned Nurse</label>
                            <select name="nurseId" required>
                                <option value="" disabled>Select Nurse</option>
                                <c:forEach var="nurse" items="${nurses}">
                                    <option value="${nurse.id}" ${(editablePatient !=null &&
                                        editablePatient.nurse.id==nurse.id) ? 'selected' : '' }>${nurse.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-primary" style="height: 45px;">
                            ${editablePatient != null ? 'Update' : 'Register'}
                        </button>
                        <c:if test="${editablePatient != null}">
                            <a href="patients" class="btn"
                                style="background: #ccc; height: 45px; display: flex; align-items: center; justify-content: center; box-sizing: border-box;">Cancel</a>
                        </c:if>
                    </form>
                </div>

                <div class="card">
                    <h3>All Patients</h3>
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Diagnosis</th>
                                <th>Doctor</th>
                                <th>Nurse</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${patients}">
                                <tr>
                                    <td>${p.id}</td>
                                    <td>${p.name}</td>
                                    <td>${p.disease}</td>
                                    <td>${p.doctor.name}</td>
                                    <td>${p.nurse.name}</td>
                                    <td>
                                        <a href="patients?action=edit&id=${p.id}" class="btn btn-info">Edit</a>
                                        <a href="javascript:void(0)" onclick="confirmDelete(${p.id})"
                                            class="btn btn-danger">Delete</a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty patients}">
                                <tr>
                                    <td colspan="6" style="text-align: center; color: #999;">No patients found.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

            <script>
                function confirmDelete(id) {
                    if (confirm("Are you sure you want to delete this patient record?")) {
                        window.location.href = "patients?action=delete&id=" + id;
                    }
                }
            </script>
        </body>

        </html>