<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Patients - HMSystem</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        </head>

        <body>
            <jsp:include page="includes/sidebar.jsp" />
            <script>document.getElementById('nav-patients').classList.add('active');</script>
            <div class="main-content">
                <h2>Patient Records</h2>

                <div class="card">
                    <h3>${editablePatient != null ? 'Edit' : 'Register New'} Patient</h3>
                    <form action="patients" method="post"
                        style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; align-items: end;">
                        <input type="hidden" name="id" value="${editablePatient.id}">
                        <input type="hidden" name="csrfToken" value="${csrfToken}">
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
                        <div class="form-actions" style="display: flex; gap: 10px;">
                            <button type="submit" class="btn btn-primary" style="flex-grow: 1;">
                                ${editablePatient != null ? 'Update' : 'Register'}
                            </button>
                            <c:if test="${editablePatient != null}">
                                <a href="patients" class="btn btn-secondary">Cancel</a>
                            </c:if>
                        </div>
                    </form>
                </div>

                <div class="card">
                    <h3>All Patients</h3>
                    <div class="table-container">
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
                                        <td style="display: flex; gap: 10px;">
                                            <a href="patients?action=edit&id=${p.id}"
                                                class="btn btn-info btn-sm">Edit</a>
                                            <a href="javascript:void(0)" onclick="confirmDelete('${p.id}')"
                                                class="btn btn-danger btn-sm">Delete</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty patients}">
                                    <tr>
                                        <td colspan="6"
                                            style="text-align: center; color: var(--text-secondary); padding: 40px;">No
                                            patients
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
                    if (confirm("Are you sure you want to delete this patient record?")) {
                        window.location.href = "patients?action=delete&id=" + id;
                    }
                }
            </script>
        </body>

        </html>