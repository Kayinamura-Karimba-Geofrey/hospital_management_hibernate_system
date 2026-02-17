<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Login - Hospital Management System</title>
            <style>
                :root {
                    --primary: #6366f1;
                    --primary-hover: #4f46e5;
                    --bg-gradient: linear-gradient(135deg, #0f172a 0%, #1e1b4b 100%);
                    --glass-bg: rgba(255, 255, 255, 0.05);
                    --glass-border: rgba(255, 255, 255, 0.1);
                    --text-main: #f8fafc;
                    --text-muted: #94a3b8;
                }

                body {
                    font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                    background: var(--bg-gradient);
                    height: 100vh;
                    margin: 0;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    color: var(--text-main);
                    overflow: hidden;
                }

                .login-card {
                    background: var(--glass-bg);
                    backdrop-filter: blur(12px);
                    -webkit-backdrop-filter: blur(12px);
                    border: 1px solid var(--glass-border);
                    padding: 3rem;
                    border-radius: 24px;
                    width: 100%;
                    max-width: 400px;
                    box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
                    animation: fadeIn 0.6s ease-out;
                }

                @keyframes fadeIn {
                    from {
                        opacity: 0;
                        transform: translateY(20px);
                    }

                    to {
                        opacity: 1;
                        transform: translateY(0);
                    }
                }

                .header {
                    text-align: center;
                    margin-bottom: 2.5rem;
                }

                .header h1 {
                    font-size: 2rem;
                    font-weight: 700;
                    margin-bottom: 0.5rem;
                    background: linear-gradient(to right, #818cf8, #c084fc);
                    -webkit-background-clip: text;
                    background-clip: text;
                    -webkit-text-fill-color: transparent;
                }

                .header p {
                    color: var(--text-muted);
                    font-size: 0.875rem;
                }

                .form-group {
                    margin-bottom: 1.5rem;
                }

                .form-group label {
                    display: block;
                    font-size: 0.875rem;
                    font-weight: 500;
                    margin-bottom: 0.5rem;
                    color: var(--text-muted);
                }

                .input-wrapper {
                    position: relative;
                }

                input {
                    width: 100%;
                    padding: 0.75rem 1rem;
                    background: rgba(255, 255, 255, 0.03);
                    border: 1px solid var(--glass-border);
                    border-radius: 12px;
                    color: white;
                    font-size: 1rem;
                    transition: all 0.2s;
                    box-sizing: border-box;
                }

                input:focus {
                    outline: none;
                    border-color: var(--primary);
                    background: rgba(255, 255, 255, 0.07);
                    box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.1);
                }

                .btn-login {
                    width: 100%;
                    padding: 0.875rem;
                    background: var(--primary);
                    color: white;
                    border: none;
                    border-radius: 12px;
                    font-size: 1rem;
                    font-weight: 600;
                    cursor: pointer;
                    transition: all 0.2s;
                    margin-top: 1rem;
                }

                .btn-login:hover {
                    background: var(--primary-hover);
                    transform: translateY(-1px);
                }

                .btn-login:active {
                    transform: translateY(0);
                }

                .error-msg {
                    background: rgba(239, 68, 68, 0.1);
                    border: 1px solid rgba(239, 68, 68, 0.2);
                    color: #fca5a5;
                    padding: 0.75rem;
                    border-radius: 8px;
                    font-size: 0.875rem;
                    margin-bottom: 1.5rem;
                    text-align: center;
                }

                .footer-links {
                    text-align: center;
                    margin-top: 2rem;
                    font-size: 0.875rem;
                    color: var(--text-muted);
                }

                .footer-links a {
                    color: var(--primary);
                    text-decoration: none;
                    font-weight: 500;
                }

                .footer-links a:hover {
                    text-decoration: underline;
                }
            </style>
        </head>

        <body>
            <div class="login-card">
                <div class="header">
                    <h1>Welcome Back</h1>
                    <p>Please enter your details to sign in</p>
                </div>

                <c:if test="${not empty error}">
                    <div class="error-msg">
                        ${error}
                    </div>
                </c:if>

                <form action="login" method="POST">
                    <div class="form-group">
                        <label for="username">Username</label>
                        <div class="input-wrapper">
                            <input type="text" id="username" name="username" required placeholder="Enter your username">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="password">Password</label>
                        <div class="input-wrapper">
                            <input type="password" id="password" name="password" required placeholder="••••••••">
                        </div>
                    </div>

                    <button type="submit" class="btn-login">Sign In</button>
                </form>

                <div class="footer-links">
                    <p>Don't have an account? <a href="register">Sign up</a></p>
                    <p style="margin-top: 0.5rem;"><a href="${pageContext.request.contextPath}/index.jsp">Back to
                            Home</a></p>
                </div>
            </div>
        </body>

        </html>