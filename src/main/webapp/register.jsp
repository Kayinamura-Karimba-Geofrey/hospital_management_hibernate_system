<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>User Registration - Hospital Management System</title>
            <style>
                body {
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    min-height: 100vh;
                    margin: 0;
                    color: #333;
                    padding: 20px;
                }

                .container {
                    background: rgba(255, 255, 255, 0.95);
                    padding: 2rem;
                    border-radius: 15px;
                    box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
                    width: 100%;
                    max-width: 450px;
                }

                h2 {
                    text-align: center;
                    color: #4a148c;
                    margin-top: 0;
                }

                .form-group {
                    margin-bottom: 1.2rem;
                }

                label {
                    display: block;
                    margin-bottom: 0.5rem;
                    font-weight: bold;
                    color: #555;
                }

                input,
                select {
                    width: 100%;
                    padding: 0.8rem;
                    border: 1px solid #ddd;
                    border-radius: 8px;
                    box-sizing: border-box;
                    font-size: 1rem;
                }

                input:focus,
                select:focus {
                    outline: none;
                    border-color: #667eea;
                    box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.2);
                }

                button {
                    width: 100%;
                    padding: 1rem;
                    background: #6a1b9a;
                    color: white;
                    border: none;
                    border-radius: 8px;
                    cursor: pointer;
                    font-size: 1.1rem;
                    font-weight: bold;
                    transition: all 0.3s;
                    margin-top: 1rem;
                }

                button:hover {
                    background: #4a148c;
                    transform: translateY(-1px);
                }

                .hidden {
                    display: none;
                }
            </style>
            <script>
                function toggleDept() {
                    var role = document.getElementById("role").value;
                    var deptDiv = document.getElementById("dept-div");
                    if (role === "DOCTOR" || role === "NURSE") {
                        deptDiv.classList.remove("hidden");
                        document.getElementById("dept-select").required = true;
                    } else {
                        deptDiv.classList.add("hidden");
                        document.getElementById("dept-select").required = false;
                    }
                }
            </script>
        </head>

        <body>
            <div class="container">
                <h2>System Registration</h2>
                <form action="register" method="post">
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
                    <div class="form-group hidden" id="dept-div">
                        <label>Assigned Department</label>
                        <select name="departmentId" id="dept-select">
                            <option value="" disabled selected>Select Department</option>
                            <c:forEach var="dept" items="${departments}">
                                <option value="${dept.id}">${dept.name} (${dept.location})</option>
                            </c:forEach>
                        </select>
                        <small style="color: #666;">Note: Doctors and Nurses must be assigned to a department.</small>
                    </div>
                    <div class="form-group">
                        <label>Password</label>
                        <input type="password" name="password" required placeholder="Create a strong password">
                    </div>
                    <button type="submit">Complete Registration</button>
                    <p style="text-align: center; margin-top: 1rem;">
                        <a href="${pageContext.request.contextPath}/index.jsp"
                            style="color: #6a1b9a; text-decoration: none;">Back to Home</a>
                    </p>
                </form>
            </div>
        </body>

        </html>