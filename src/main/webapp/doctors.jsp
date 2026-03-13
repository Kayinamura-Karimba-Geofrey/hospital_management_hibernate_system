<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Doctors - HMSystem</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        </head>

        <body>
            <jsp:include page="includes/sidebar.jsp" />
            <script>document.getElementById('nav-doctors').classList.add('active');</script>
            <div class="main-content">
                <h2>Doctor Management</h2>

                <div class="card">
                    <c:if test="${not empty error}">
                        <div class="error-alert"
                            style="background: rgba(255, 75, 43, 0.1); color: #ff4b2b; padding: 10px; border-radius: 8px; margin-bottom: 15px; border: 1px solid rgba(255, 75, 43, 0.2);">
                            ${error}
                        </div>
                    </c:if>
                    <h3>${editableDoc != null ? 'Edit' : 'Add New'} Doctor</h3>
                    <form action="doctors" method="post"
                        style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; align-items: end;">
                        <input type="hidden" name="csrfToken" value="${csrfToken}">
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
                            <label>Email Address</label>
                            <input type="email" name="email" required placeholder="email@hmsystem.com"
                                value="${editableDoc.email}">
                        </div>
                        <div class="form-group">
                            <label>Phone Number</label>
                            <input type="text" name="phone" placeholder="e.g. +1234567890" value="${editableDoc.phone}">
                        </div>
                        <div class="form-group">
                            <label>Department</label>
                            <select name="departmentId" required>
                                <option value="" disabled>Select Dept</option>
                                <c:forEach var="dept" items="${departments}">
                                    <option value="${dept.id}" ${ (editableDoc !=null && editableDoc.department !=null
                                        && editableDoc.department.id==dept.id) ? 'selected' : '' }>
                                        ${dept.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-actions" style="display: flex; gap: 10px;">
                            <button type="submit" class="btn btn-primary" style="flex-grow: 1;">
                                ${editableDoc != null ? 'Update' : 'Add'} Doctor
                            </button>
                            <c:if test="${editableDoc != null}">
                                <a href="doctors" class="btn btn-secondary">Cancel</a>
                            </c:if>
                        </div>
                    </form>
                </div>

                <div class="card">
                    <div class="card-header">
                        <h3>Active Medical Staff</h3>
                    </div>
                    <div class="table-container">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Physician</th>
                                    <th>Specialisation</th>
                                    <th>Contact Information</th>
                                    <th>Department</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="doc" items="${doctors}">
                                    <tr>
                                        <td style="color: var(--text-muted); font-size: 0.8rem;">#${doc.id}</td>
                                        <td style="font-weight: 600; color: var(--slate-900);">${doc.name}</td>
                                        <td>
                                            <span class="status-pill status-active">${doc.specialisation}</span>
                                        </td>
                                        <td>
                                            <div style="font-size: 0.9rem;">${doc.email}</div>
                                            <div style="font-size: 0.8rem; color: var(--text-muted); margin-top: 2px;">${doc.phone}</div>
                                        </td>
                                        <td>
                                            <div class="badge DOCTOR-badge">${doc.department.name}</div>
                                        </td>
                                        <td>
                                            <div style="display: flex; gap: 8px;">
                                                <a href="doctors?action=edit&id=${doc.id}" class="btn btn-secondary" style="padding: 6px 12px; font-size: 0.75rem;">Edit</a>
                                                <a href="javascript:void(0)" onclick="confirmDelete('${doc.id}')" class="btn btn-secondary" style="padding: 6px 12px; font-size: 0.75rem; color: var(--danger); border-color: rgba(239, 68, 68, 0.2);">Delete</a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty doctors}">
                                    <tr>
                                        <td colspan="6" style="text-align: center; color: var(--text-muted); padding: 40px;">No medical staff records found.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
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