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
                    <form action="patients" method="post"
                        style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; align-items: end;">
                        <input type="hidden" name="csrfToken" value="${csrfToken}">
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
                            <label>Email Address</label>
                            <input type="email" name="email" required placeholder="patient@example.com"
                                value="${editablePatient.email}">
                        </div>
                        <div class="form-group">
                            <label>Phone Number</label>
                            <input type="text" name="phone" placeholder="+1234567890" value="${editablePatient.phone}">
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
                    <div class="card-header">
                        <h3>All Patients</h3>
                    </div>
                    <div class="table-container">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Patient Details</th>
                                    <th>Diagnosis</th>
                                    <th>Assigned Medical Team</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${patients}">
                                    <tr>
                                        <td style="color: var(--text-muted); font-size: 0.8rem;">#${p.id}</td>
                                        <td>
                                            <div style="font-weight: 600; color: var(--slate-900);">${p.name}</div>
                                            <div style="font-size: 0.8rem; color: var(--text-muted);">${p.email}</div>
                                        </td>
                                        <td>
                                            <span class="status-pill status-active">${p.disease}</span>
                                        </td>
                                        <td>
                                            <div style="font-size: 0.9rem;">
                                                <span style="color: var(--text-muted);">Doctor:</span> Dr. ${p.doctor.name}
                                            </div>
                                            <div style="font-size: 0.85rem; margin-top: 4px;">
                                                <span style="color: var(--text-muted);">Nurse:</span> ${p.nurse.name}
                                            </div>
                                        </td>
                                        <td>
                                            <div style="display: flex; gap: 8px;">
                                                <a href="patients?action=edit&id=${p.id}" class="btn btn-secondary" style="padding: 6px 12px; font-size: 0.75rem;">Edit</a>
                                                <a href="javascript:void(0)" onclick="confirmDelete('${p.id}')" class="btn btn-secondary" style="padding: 6px 12px; font-size: 0.75rem; color: var(--danger); border-color: rgba(239, 68, 68, 0.2);">Delete</a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty patients}">
                                    <tr>
                                        <td colspan="5" style="text-align: center; color: var(--text-muted); padding: 40px;">
                                            No patients found in the system.
                                        </td>
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