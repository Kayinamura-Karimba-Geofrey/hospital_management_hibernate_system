<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Nurses - HMSystem</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        </head>

        <body>
            <jsp:include page="includes/sidebar.jsp" />
            <script>document.getElementById('nav-nurses').classList.add('active');</script>
            <div class="main-content">
                <h2>Nurse Management</h2>

                <div class="card">
                    <h3>${editableNurse != null ? 'Edit' : 'Add New'} Nurse</h3>
                    <form action="nurses" method="post"
                        style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; align-items: end;">
                        <input type="hidden" name="csrfToken" value="${csrfToken}">
                        <input type="hidden" name="id" value="${editableNurse.id}">
                        <div class="form-group">
                            <label>Full Name</label>
                            <input type="text" name="name" required placeholder="Nurse Jane Smith"
                                value="${editableNurse.name}">
                        </div>
                        <div class="form-group">
                            <label>Email Address</label>
                            <input type="email" name="email" required placeholder="jane.smith@hospital.com"
                                value="${editableNurse.email}">
                        </div>
                        <div class="form-group">
                            <label>Department</label>
                            <select name="departmentId" required>
                                <option value="" disabled>Select Dept</option>
                                <c:forEach var="dept" items="${departments}">
                                    <option value="${dept.id}" ${ (editableNurse !=null && editableNurse.department
                                        !=null && editableNurse.department.id==dept.id) ? 'selected' : '' }>
                                        ${dept.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-actions" style="display: flex; gap: 10px;">
                            <button type="submit" class="btn btn-primary" style="flex-grow: 1;">
                                ${editableNurse != null ? 'Update' : 'Add'} Nurse
                            </button>
                            <c:if test="${editableNurse != null}">
                                <a href="nurses" class="btn btn-secondary">Cancel</a>
                            </c:if>
                        </div>
                    </form>
                </div>

                <div class="card">
                    <div class="card-header">
                        <h3>Nursing Staff on Duty</h3>
                    </div>
                    <div class="table-container">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Nurse Name</th>
                                    <th>Contact Information</th>
                                    <th>Department</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="nurse" items="${nurses}">
                                    <tr>
                                        <td style="color: var(--text-muted); font-size: 0.8rem;">#${nurse.id}</td>
                                        <td style="font-weight: 600; color: var(--slate-900);">${nurse.name}</td>
                                        <td>
                                            <div style="font-size: 0.9rem;">${nurse.email}</div>
                                        </td>
                                        <td>
                                            <div class="badge NURSE-badge">${nurse.department.name}</div>
                                        </td>
                                        <td>
                                            <div style="display: flex; gap: 8px;">
                                                <a href="nurses?action=edit&id=${nurse.id}" class="btn btn-secondary" style="padding: 6px 12px; font-size: 0.75rem;">Edit</a>
                                                <a href="javascript:void(0)" onclick="confirmDelete('${nurse.id}')" class="btn btn-secondary" style="padding: 6px 12px; font-size: 0.75rem; color: var(--danger); border-color: rgba(239, 68, 68, 0.2);">Delete</a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty nurses}">
                                    <tr>
                                        <td colspan="5" style="text-align: center; color: var(--text-muted); padding: 40px;">No nursing staff records found.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <script>
                function confirmDelete(id) {
                    if (confirm("Are you sure you want to delete this nurse?")) {
                        window.location.href = "nurses?action=delete&id=" + id;
                    }
                }
            </script>
        </body>

        </html>