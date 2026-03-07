<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Login - HMSystem</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        </head>

        <body>
            <div class="auth-container">
                <div class="auth-card">
                    <div class="auth-header">
                        <h1>Welcome Back</h1>
                        <p>Advanced Health Management System</p>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="btn-danger"
                            style="padding: 12px; border-radius: 8px; font-size: 0.9rem; margin-bottom: 20px; text-align: center;">
                            ${error}
                        </div>
                    </c:if>

                    <form action="login" method="POST">
                        <input type="hidden" name="csrfToken" value="${csrfToken}">
                        <div class="form-group">
                            <label for="email">Email Address</label>
                            <input type="email" id="email" name="email" required placeholder="Enter your email">
                        </div>

                        <div class="form-group">
                            <label for="password">Password (Registered Name for Doctors)</label>
                            <input type="password" id="password" name="password" required placeholder="••••••••">
                        </div>

                        <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 10px;">Sign
                            In</button>
                    </form>

                    <div style="text-align: center; margin-top: 25px; font-size: 0.9rem; color: var(--text-secondary);">
                        <p>Don't have an account? <a href="register"
                                style="color: var(--primary); text-decoration: none; font-weight: 600;">Sign up</a></p>
                        <p style="margin-top: 15px;"><a href="${pageContext.request.contextPath}/index.jsp"
                                style="color: var(--text-secondary); text-decoration: none;">🏠 Back to Home</a></p>
                    </div>
                </div>
            </div>
        </body>

        </html>