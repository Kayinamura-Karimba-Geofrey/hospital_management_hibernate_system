<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account | MediFlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script>
        function toggleDept() {
            var role = document.getElementById("role").value;
            var deptDiv = document.getElementById("dept-div");
            if (role === "DOCTOR" || role === "NURSE") {
                deptDiv.style.display = "block";
                document.getElementById("dept-select").required = true;
                document.getElementById("staff-pwd-note").style.display = "block";
                document.getElementById("reg-password").required = false;
                document.getElementById("reg-password").placeholder = "Leave blank for ID login";
            } else {
                deptDiv.style.display = "none";
                document.getElementById("dept-select").required = false;
                document.getElementById("staff-pwd-note").style.display = "none";
                document.getElementById("reg-password").required = true;
                document.getElementById("reg-password").placeholder = "Create a strong password";
            }
        }
    </script>
    <script src="https://www.google.com/recaptcha/api.js" async defer></script>
</head>
<body>
    <div class="auth-container">
        <div class="auth-card" style="max-width: 550px;">
            <div class="auth-header">
                <div class="brand-font" style="margin-bottom: 24px; font-size: 1.8rem;">
                    <span class="logo-medi">Medi</span><span class="logo-flow">Flow</span>
                </div>
                <h1>System Registration</h1>
                <p>Join the advanced healthcare network</p>
            </div>

            <c:if test="${not empty error}">
                <div style="background: var(--primary-soft); color: var(--danger); padding: 12px; border-radius: var(--radius-sm); font-size: 0.9rem; margin-bottom: 24px; text-align: center; font-weight: 500;">
                    ${error}
                </div>
            </c:if>

            <form action="register" method="post">
                <input type="hidden" name="csrfToken" value="${csrfToken}">
                
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                    <div class="form-group">
                        <label>Username</label>
                        <input type="text" name="username" required placeholder="johndoe">
                    </div>
                    <div class="form-group">
                        <label>Full Name</label>
                        <input type="text" name="fullName" required placeholder="John Doe">
                    </div>
                </div>

                <div class="form-group">
                    <label>Email Address</label>
                    <input type="email" name="email" required placeholder="john@example.com">
                </div>

                <div class="form-group">
                    <label>Account Role</label>
                    <select name="role" id="role" required onchange="toggleDept()">
                        <option value="" disabled selected>Select your role</option>
                        <option value="PATIENT">Patient</option>
                        <option value="DOCTOR">Doctor</option>
                        <option value="NURSE">Nurse</option>
                    </select>
                </div>

                <div class="form-group" id="dept-div" style="display: none; animation: fadeIn 0.3s ease;">
                    <label>Assigned Department</label>
                    <select name="departmentId" id="dept-select">
                        <option value="" disabled selected>Select Department</option>
                        <c:forEach var="dept" items="${departments}">
                            <option value="${dept.id}">${dept.name} — ${dept.location}</option>
                        </c:forEach>
                    </select>
                    <small style="color: var(--text-muted); display: block; margin-top: 8px; font-style: italic;">
                        Professional staff must be assigned to an active department.
                    </small>
                </div>

                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" id="reg-password" placeholder="Create a password">
                    <small id="pwd-hint" style="color: var(--text-muted); display: block; margin-top: 8px;">
                        Min. 8 chars, including uppercase, digit, and special symbol.
                    </small>
                    <small id="staff-pwd-note" style="color: var(--success); display: none; margin-top: 8px; font-weight: 600;">
                        Staff accounts can use their registered ID as initial password.
                    </small>
                </div>

                <div style="margin: 24px 0; display: flex; justify-content: center;">
                    <div class="g-recaptcha" data-sitekey="6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI"></div>
                </div>

                <button type="submit" class="btn btn-primary" style="width: 100%;">
                    Complete Registration
                </button>
            </form>

            <div style="text-align: center; margin-top: 32px; font-size: 0.9rem; color: var(--text-muted);">
                Already have an account? <a href="${pageContext.request.contextPath}/login" style="color: var(--primary); font-weight: 600;">Sign In</a>
                <div style="margin-top: 24px; padding-top: 24px; border-top: 1px solid var(--slate-100);">
                    <a href="${pageContext.request.contextPath}/index.jsp" style="display: inline-flex; align-items: center; gap: 8px;">
                        <span>←</span> Back to Home
                    </a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
ml>