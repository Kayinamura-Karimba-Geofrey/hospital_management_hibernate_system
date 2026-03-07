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
                        <input type="hidden" name="id" value="${editableNurse.id}">
                        <div class="form-group">
                            <label>Full Name</label>
                            <input type="text" name="name" required placeholder="Nurse Jane Smith"
                                value="${editableNurse.name}">
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
                    <h3>Nurses on Duty</h3>
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Department</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="nurse" items="${nurses}">
                                    <tr>
                                        <td>${nurse.id}</td>
                                        <td>${nurse.name}</td>
                                        <td>${nurse.department.name}</td>
                                        <td style="display: flex; gap: 10px;">
                                            <a href="nurses?action=edit&id=${nurse.id}"
                                                class="btn btn-info btn-sm">Edit</a>
                                            <a href="javascript:void(0)" onclick="confirmDelete('${nurse.id}')"
                                                class="btn btn-danger btn-sm">Delete</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty nurses}">
                                    <tr>
                                        <td colspan="4"
                                            style="text-align: center; color: var(--text-secondary); padding: 40px;">No
                                            nurses
                                            found.</td>
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