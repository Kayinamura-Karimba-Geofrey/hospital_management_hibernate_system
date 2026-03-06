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
                    <h3>${editableDoc != null ? 'Edit' : 'Add New'} Doctor</h3>
                    <form action="doctors" method="post"
                        style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; align-items: end;">
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
                    <h3>Active Doctors</h3>
                    <div class="table-container">
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
                                        <td style="display: flex; gap: 10px;">
                                            <a href="doctors?action=edit&id=${doc.id}"
                                                class="btn btn-info btn-sm">Edit</a>
                                            <a href="javascript:void(0)" onclick="confirmDelete('${doc.id}')"
                                                class="btn btn-danger btn-sm">Delete</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty doctors}">
                                    <tr>
                                        <td colspan="5"
                                            style="text-align: center; color: var(--text-secondary); padding: 40px;">No
                                            doctors
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
                    if (confirm("Are you sure you want to delete this doctor?")) {
                        window.location.href = "doctors?action=delete&id=" + id;
                    }
                }
            </script>
        </body>

        </html>