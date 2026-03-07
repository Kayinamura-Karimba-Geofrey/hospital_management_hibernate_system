<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Registration - HMSystem</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
            <script>
                function toggleDept() {
                    var role = document.getElementById("role").value;
                    var deptDiv = document.getElementById("dept-div");
                    if (role === "DOCTOR" || role === "NURSE") {
                        deptDiv.style.display = "block";
                        document.getElementById("dept-select").required = true;
                    } else {
                        deptDiv.style.display = "none";
                        document.getElementById("dept-select").required = false;
                    }
                }
            </script>
        </head>

        <body>
            <div class="auth-container">
                <div class="auth-card" style="max-width: 500px;">
                    <div class="auth-header">
                        <h1>System Registration</h1>
                        <p>Join Advanced Health Management System</p>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="btn-danger"
                            style="padding: 12px; border-radius: 8px; font-size: 0.9rem; margin-bottom: 20px; text-align: center;">
                            ${error}
                        </div>
                    </c:if>

                    <form action="register" method="post">
                        <input type="hidden" name="csrfToken" value="${csrfToken}">
                        <div class="form-group">
                            <label>Username</label>
                            <input type="text" name="username" required placeholder="Choose a username">
                        </div>
                        <div class="form-group">
                            <label>Full Name</label>
                            <input type="text" name="fullName" required placeholder="Enter your full name">
                        </div>
                        <div class="form-group">
                            <label>Email Address</label>
                            <input type="email" name="email" required placeholder="email@example.com">
                        </div>
                        <div class="form-group">
                            <label>Select Role</label>
                            <select name="role" id="role" required onchange="toggleDept()">
                                <option value="" disabled selected>Select your role</option>
                                <option value="PATIENT">Patient</option>
                                <option value="DOCTOR">Doctor</option>
                                <option value="NURSE">Nurse</option>
                            </select>
                        </div>
                        <div class="form-group" id="dept-div" style="display: none;">
                            <label>Assigned Department</label>
                            <select name="departmentId" id="dept-select">
                                <option value="" disabled selected>Select Department</option>
                                <c:forEach var="dept" items="${departments}">
                                    <option value="${dept.id}">${dept.name} (${dept.location})</option>
                                </c:forEach>
                            </select>
                            <small style="color: var(--text-secondary); display: block; margin-top: 5px;">Note: Doctors
                                and
                                Nurses must be assigned to a department.</small>
                        </div>
                        <div class="form-group">
                            <label>Password</label>
                            <input type="password" name="password" required placeholder="Create a strong password">
                        </div>
                        <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 10px;">Complete
                            Registration</button>
                    </form>

                    <div style="text-align: center; margin-top: 25px; font-size: 0.9rem; color: var(--text-secondary);">
                        <p>Already have an account? <a href="${pageContext.request.contextPath}/login"
                                style="color: var(--primary); text-decoration: none; font-weight: 600;">Login here</a>
                        </p>
                        <p style="margin-top: 15px;"><a href="${pageContext.request.contextPath}/index.jsp"
                                style="color: var(--text-secondary); text-decoration: none;">🏠 Back to Home</a></p>
                    </div>
                </div>
            </div>
        </body>

        </html>