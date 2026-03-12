<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Two-Factor Authentication - HMSystem</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
            <style>
                .qr-container {
                    background: #fff;
                    padding: 20px;
                    border-radius: 20px;
                    display: inline-block;
                    margin-bottom: 30px;
                    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                }

                .qr-container img {
                    display: block;
                    width: 200px;
                    height: 200px;
                }

                .form-control {
                    width: 100%;
                    padding: 16px;
                    background: rgba(255, 255, 255, 0.05);
                    border: 1.5px solid var(--border);
                    border-radius: 16px;
                    color: #fff;
                    font-size: 1.5rem;
                    text-align: center;
                    letter-spacing: 8px;
                    font-weight: 700;
                    font-family: 'Outfit', sans-serif;
                    transition: all 0.3s ease;
                }

                .form-control:focus {
                    outline: none;
                    border-color: var(--primary);
                    background: rgba(255, 255, 255, 0.1);
                    box-shadow: 0 0 0 4px rgba(0, 122, 255, 0.2);
                }

                .btn-submit {
                    width: 100%;
                    padding: 16px;
                    background: linear-gradient(135deg, #007aff 0%, #0056b3 100%);
                    border: none;
                    border-radius: 16px;
                    color: #fff;
                    font-size: 1rem;
                    font-weight: 700;
                    cursor: pointer;
                    box-shadow: 0 4px 15px rgba(0, 122, 255, 0.3);
                    transition: all 0.3s ease;
                }

                .btn-submit:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 8px 25px rgba(0, 122, 255, 0.4);
                }

                .error-msg {
                    background: rgba(255, 59, 48, 0.1);
                    color: #ff3b30;
                    padding: 15px;
                    border-radius: 12px;
                    margin-bottom: 25px;
                    font-size: 0.95rem;
                    border: 1px solid rgba(255, 59, 48, 0.2);
                    text-align: center;
                }
            </style>
        </head>

        <body>

            <div class="auth-container">
                <div class="auth-card">
                    <div class="auth-header">
                        <h1>Two-Factor Check</h1>
                        <p>Verify your identity to continue</p>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="error-msg">${error}</div>
                    </c:if>

                    <c:if test="${setup}">
                        <p style="color: var(--card-text-dim); margin-bottom: 20px;">Scan this QR code with your Authenticator app (e.g. Google Authenticator) to set up
                            2FA.</p>
                        <div class="qr-container">
                            <img src="${qrCode}" alt="2FA QR Code">
                        </div>
                    </c:if>

                    <c:if test="${not setup}">
                        <p style="color: var(--card-text-dim); margin-bottom: 30px;">Enter the 6-digit code from your Authenticator app to continue.</p>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/2fa" method="POST">
                        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                        <div class="form-group">
                            <label>Authentication Code</label>
                            <input type="text" name="code" class="form-control" placeholder="000000" maxlength="6"
                                pattern="[0-9]{6}" required autocomplete="off" autofocus>
                        </div>
                        <button type="submit" class="btn-submit">Verify Identity</button>
                    </form>

                    <div style="text-align: center; margin-top: 30px; font-size: 0.95rem;">
                        <p style="color: var(--card-text-dim);">Need help? <a href="#" style="color: var(--primary); text-decoration: none; font-weight: 600;">Contact Support</a></p>
                        <p style="margin-top: 20px;"><a href="${pageContext.request.contextPath}/login" style="color: var(--card-text-dim); text-decoration: none; opacity: 0.8;">🏠 Back to Login</a></p>
                    </div>
                </div>
            </div>

        </body>

        </html>