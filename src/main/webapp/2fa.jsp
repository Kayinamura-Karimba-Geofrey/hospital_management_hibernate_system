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
                .auth-container {
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    min-height: 100vh;
                    background: radial-gradient(circle at top right, rgba(0, 242, 254, 0.1), transparent),
                        radial-gradient(circle at bottom left, rgba(79, 172, 254, 0.1), transparent);
                }

                .auth-card {
                    background: rgba(255, 255, 255, 0.05);
                    backdrop-filter: blur(20px);
                    -webkit-backdrop-filter: blur(20px);
                    border: 1px solid rgba(255, 255, 255, 0.1);
                    border-radius: 24px;
                    padding: 40px;
                    width: 100%;
                    max-width: 450px;
                    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
                    text-align: center;
                }

                .auth-card h2 {
                    margin-bottom: 10px;
                    font-size: 2rem;
                    background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
                    -webkit-background-clip: text;
                    -webkit-text-fill-color: transparent;
                }

                .auth-card p {
                    color: rgba(255, 255, 255, 0.7);
                    margin-bottom: 30px;
                    font-size: 0.95rem;
                }

                .qr-container {
                    background: #fff;
                    padding: 15px;
                    border-radius: 12px;
                    display: inline-block;
                    margin-bottom: 25px;
                }

                .qr-container img {
                    display: block;
                    width: 200px;
                    height: 200px;
                }

                .form-group {
                    margin-bottom: 20px;
                    text-align: left;
                }

                .form-group label {
                    display: block;
                    margin-bottom: 8px;
                    color: rgba(255, 255, 255, 0.9);
                    font-size: 0.9rem;
                }

                .form-control {
                    width: 100%;
                    padding: 12px 15px;
                    background: rgba(255, 255, 255, 0.05);
                    border: 1px solid rgba(255, 255, 255, 0.1);
                    border-radius: 12px;
                    color: #fff;
                    font-size: 1.1rem;
                    text-align: center;
                    letter-spacing: 4px;
                    transition: all 0.3s ease;
                }

                .form-control:focus {
                    outline: none;
                    border-color: #4facfe;
                    background: rgba(255, 255, 255, 0.1);
                    box-shadow: 0 0 0 4px rgba(79, 172, 254, 0.1);
                }

                .btn-submit {
                    width: 100%;
                    padding: 14px;
                    background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
                    border: none;
                    border-radius: 12px;
                    color: #fff;
                    font-size: 1rem;
                    font-weight: 600;
                    cursor: pointer;
                    transition: transform 0.2s, box-shadow 0.2s;
                }

                .btn-submit:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 10px 20px rgba(79, 172, 254, 0.3);
                }

                .error-msg {
                    background: rgba(255, 69, 58, 0.1);
                    color: #ff453a;
                    padding: 12px;
                    border-radius: 8px;
                    margin-bottom: 20px;
                    font-size: 0.9rem;
                    border: 1px solid rgba(255, 69, 58, 0.2);
                }

                .text-muted {
                    opacity: 0.7;
                    font-size: 0.85rem;
                    margin-top: 15px;
                }

                .text-muted a {
                    color: #4facfe;
                    text-decoration: none;
                }
            </style>
        </head>

        <body>

            <div class="auth-container">
                <div class="auth-card">
                    <h2>Two-Factor Authentication</h2>

                    <c:if test="${not empty error}">
                        <div class="error-msg">${error}</div>
                    </c:if>

                    <c:if test="${setup}">
                        <p>Scan this QR code with your Authenticator app (e.g. Google Authenticator, Authy) to set up
                            2FA for your account.</p>
                        <div class="qr-container">
                            <img src="${qrCode}" alt="2FA QR Code">
                        </div>
                    </c:if>

                    <c:if test="${not setup}">
                        <p>Enter the 6-digit code from your Authenticator app to continue.</p>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/2fa" method="POST">
                        <div class="form-group">
                            <label>Authentication Code</label>
                            <input type="text" name="code" class="form-control" placeholder="000000" maxlength="6"
                                pattern="[0-9]{6}" required autocomplete="off" autofocus>
                        </div>
                        <button type="submit" class="btn-submit">Verify Code</button>
                    </form>

                    <div class="text-muted">
                        Need help? <a href="#">Contact Support</a>
                        <br><br>
                        <a href="${pageContext.request.contextPath}/login">Back to Login</a>
                    </div>
                </div>
            </div>

        </body>

        </html>