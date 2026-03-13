<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Departments - HMSystem</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        </head>

        <body>
            <jsp:include page="includes/sidebar.jsp" />
            <script>document.getElementById('nav-departments').classList.add('active');</script>
            <div class="main-content">
                <h2>Hospital Departments</h2>

                <div class="card">
                    <h3>${editableDept != null ? 'Edit' : 'Add New'} Department</h3>
                    <form action="departments" method="post"
                        style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; align-items: end;">
                        <input type="hidden" name="csrfToken" value="${csrfToken}">
                        <input type="hidden" name="id" value="${editableDept.id}">
                        <div class="form-group">
                            <label>Department Name</label>
                            <input type="text" name="name" required placeholder="e.g. Cardiology"
                                value="${editableDept.name}">
                        </div>
                        <div class="form-group">
                            <label>Location</label>
                            <input type="text" name="location" required placeholder="e.g. Wing A, Floor 3"
                                value="${editableDept.location}">
                        </div>
                        <div class="form-actions" style="display: flex; gap: 10px;">
                            <button type="submit" class="btn btn-primary" style="flex-grow: 1;">
                                ${editableDept != null ? 'Update' : 'Add'} Department
                            </button>
                            <c:if test="${editableDept != null}">
                                <a href="departments" class="btn btn-secondary">Cancel</a>
                            </c:if>
                        </div>
                    </form>
                </div>

                <div class="card">
                    <div class="card-header">
                        <h3>Department Overview</h3>
                    </div>
                    <div class="table-container">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Dept ID</th>
                                    <th>Department Name</th>
                                    <th>Facility Location</th>
                                    <th>Operations</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="dept" items="${departments}">
                                    <tr>
                                        <td style="color: var(--text-muted); font-size: 0.8rem;">#${dept.id}</td>
                                        <td style="font-weight: 600; color: var(--slate-900); text-transform: uppercase; letter-spacing: 0.02em;">${dept.name}</td>
                                        <td>
                                            <div style="font-size: 0.9rem; color: var(--text-muted);">${dept.location}</div>
                                        </td>
                                        <td>
                                            <div style="display: flex; gap: 8px;">
                                                <a href="departments?action=edit&id=${dept.id}" class="btn btn-secondary" style="padding: 6px 12px; font-size: 0.75rem;">Edit</a>
                                                <a href="javascript:void(0)" onclick="confirmDelete('${dept.id}')" class="btn btn-secondary" style="padding: 6px 12px; font-size: 0.75rem; color: var(--danger); border-color: rgba(239, 68, 68, 0.2);">Delete</a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty departments}">
                                    <tr>
                                        <td colspan="4" style="text-align: center; color: var(--text-muted); padding: 40px;">No operational departments found.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <script>
                function confirmDelete(id) {
                    if (confirm("Are you sure you want to delete this department?")) {
                        window.location.href = "departments?action=delete&id=" + id;
                    }
                }
            </script>
        </body>

        </html>