<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Two-Factor Authentication | MediFlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="landing-body">
    <div class="auth-container">
        <div class="auth-card" style="text-align: center;">
            <div class="auth-header">
                <div class="brand-font" style="margin-bottom: 24px; font-size: 1.8rem;">
                    <span class="logo-medi">Medi</span><span class="logo-flow">Flow</span>
                </div>
                <h1>Security Check</h1>
                <p>Authenticating your secure session</p>
            </div>

            <c:if test="${not empty error}">
                <div style="background: var(--primary-soft); color: var(--danger); padding: 12px; border-radius: var(--radius-sm); font-size: 0.9rem; margin-bottom: 24px; text-align: center; font-weight: 500;">
                    ${error}
                </div>
            </c:if>

            <c:if test="${setup}">
                <div style="margin-bottom: 32px;">
                    <p style="color: var(--text-muted); margin-bottom: 24px; font-size: 0.9rem;">Scan this QR code with your Authenticator app to set up 2FA.</p>
                    <div style="background: white; padding: 20px; border-radius: 20px; display: inline-block; box-shadow: var(--shadow-md);">
                        <img src="${qrCode}" alt="2FA QR Code" style="width: 200px; height: 200px; display: block;">
                    </div>
                </div>
            </c:if>

            <c:if test="${not setup}">
                <p style="color: var(--text-muted); margin-bottom: 32px; font-size: 0.9rem;">Enter the 6-digit code from your app to continue.</p>
            </c:if>

            <form action="${pageContext.request.contextPath}/2fa" method="POST">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                
                <div class="form-group">
                    <label style="text-align: center; display: block;">Verification Code</label>
                    <input type="text" name="code" required placeholder="000000" maxlength="6" 
                           pattern="[0-9]{6}" autocomplete="off" autofocus
                           style="text-align: center; font-size: 2rem; letter-spacing: 12px; font-weight: 700; height: 70px; border-radius: 16px;">
                </div>

                <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 16px;">
                    Verify Identity
                </button>

                <c:if test="${setup}">
                    <button type="submit" name="action" value="skip" class="btn" 
                            style="width: 100%; margin-top: 12px; background: transparent; border: 1px solid var(--slate-200); color: var(--text-muted); font-weight: 500;">
                        Skip and Continue to Dashboard
                    </button>
                </c:if>
            </form>

            <div style="text-align: center; margin-top: 32px; font-size: 0.9rem; color: var(--text-muted);">
                Having trouble? <a href="#" style="color: var(--primary); font-weight: 600;">Contact Administrator</a>
                <div style="margin-top: 24px; padding-top: 24px; border-top: 1px solid var(--slate-100);">
                    <a href="${pageContext.request.contextPath}/login" style="display: inline-flex; align-items: center; gap: 8px;">
                        Back to Sign In
                    </a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
ml>