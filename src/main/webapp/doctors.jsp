<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Doctors - Hospital Management System</title>
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
                    <a href="${pageContext.request.contextPath}/logout"
                        style="color: #ff8a80; margin-top: 20px; border-top: 1px solid rgba(255,255,255,0.1);">🚪
                        Logout</a>
                </div>
            </div>
            <div class="main-content">
                <h2>Doctor Management</h2>

                <div class="card">
                    <h3>${editableDoc != null ? 'Edit' : 'Add New'} Doctor</h3>
                    <form action="doctors" method="post"
                        style="display: grid; grid-template-columns: 1fr 1fr 1fr auto; gap: 15px; align-items: end;">
                        <input type="hidden" name="id" value="${editableDoc.id}">
                        <div class="form-group">
                            <label>Full Name</label>
                            <input type="text" name="name" required placeholder="Dr. John Doe"
                                value="${editableDoc.name}">
                        </div>
                        <div class="form-group">
                            <label>Specialisation</label>
                            <input type="text" name="specialisation" required placeholder="e.g. Neurology"
                                value="${editableDoc.specialisation}">
                        </div>
                        <div class="form-group">
                            <label>Department</label>
                            <select name="departmentId" required>
                                <option value="" disabled>Select Dept</option>
                                <c:forEach var="dept" items="${departments}">
                                    <option value="${dept.id}" ${doc.department.id==dept.id || (editableDoc !=null &&
                                        editableDoc.department.id==dept.id) ? 'selected' : '' }>${dept.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-primary" style="height: 45px;">
                            ${editableDoc != null ? 'Update' : 'Add'} Doctor
                        </button>
                        <c:if test="${editableDoc != null}">
                            <a href="doctors" class="btn"
                                style="background: #ccc; height: 45px; display: flex; align-items: center; justify-content: center; box-sizing: border-box;">Cancel</a>
                        </c:if>
                    </form>
                </div>

                <div class="card">
                    <h3>Active Doctors</h3>
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Specialisation</th>
                                <th>Department</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="doc" items="${doctors}">
                                <tr>
                                    <td>${doc.id}</td>
                                    <td>${doc.name}</td>
                                    <td>${doc.specialisation}</td>
                                    <td>${doc.department.name}</td>
                                    <td>
                                        <a href="doctors?action=edit&id=${doc.id}" class="btn btn-info">Edit</a>
                                        <a href="javascript:void(0)" onclick="confirmDelete(${doc.id})"
                                            class="btn btn-danger">Delete</a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty doctors}">
                                <tr>
                                    <td colspan="5" style="text-align: center; color: #999;">No doctors found.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

            <script>
                function confirmDelete(id) {
                    if (confirm("Are you sure you want to delete this doctor?")) {
                        window.location.href = "doctors?action=delete&id=" + id;
                    }
                }
            </script>
        </body>

        </html>