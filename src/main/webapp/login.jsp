<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In | MediFlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="https://www.google.com/recaptcha/api.js?render=6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI"></script>
    <script>
        function onLoginSubmit(e) {
            e.preventDefault();
            grecaptcha.ready(function () {
                grecaptcha.execute('6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI', { action: 'login' }).then(function (token) {
                    document.getElementById("g-recaptcha-response").value = token;
                    document.getElementById("login-form").submit();
                });
            });
        }
    </script>
</head>
<body>
    <div class="auth-container">
        <div class="auth-card">
            <div class="auth-header">
                <div class="brand-font" style="margin-bottom: 24px; font-size: 1.8rem;">
                    <span class="logo-medi">Medi</span><span class="logo-flow">Flow</span>
                </div>
                <h1>Welcome Back</h1>
                <p>Sign in to your healthcare dashboard</p>
            </div>

            <c:if test="${not empty error}">
                <div style="background: var(--primary-soft); color: var(--danger); padding: 12px; border-radius: var(--radius-sm); font-size: 0.9rem; margin-bottom: 24px; text-align: center; font-weight: 500;">
                    ${error}
                </div>
            </c:if>

            <form id="login-form" action="login" method="POST">
                <input type="hidden" name="csrfToken" value="${csrfToken}">
                <input type="hidden" id="g-recaptcha-response" name="g-recaptcha-response">
                
                <div class="form-group">
                    <label for="identifier">Email or Username</label>
                    <input type="text" id="identifier" name="email" required placeholder="name@hospital.com">
                </div>

                <div class="form-group">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                        <label for="password" style="margin-bottom: 0;">Password</label>
                        <a href="#" style="font-size: 0.8rem; color: var(--primary); font-weight: 500;">Forgot?</a>
                    </div>
                    <input type="password" id="password" name="password" required placeholder="••••••••">
                </div>

                <button type="button" class="btn btn-primary" onclick="onLoginSubmit(event)" style="width: 100%; margin-top: 8px;">
                    Sign In to MediFlow
                </button>
            </form>

            <div style="text-align: center; margin-top: 32px; font-size: 0.9rem; color: var(--text-muted);">
                Don't have an account? <a href="register" style="color: var(--primary); font-weight: 600;">Create Account</a>
                <div style="margin-top: 24px; padding-top: 24px; border-top: 1px solid var(--slate-100);">
                        Back to Home
                </div>
            </div>
        </div>
    </div>
</body>
</html>