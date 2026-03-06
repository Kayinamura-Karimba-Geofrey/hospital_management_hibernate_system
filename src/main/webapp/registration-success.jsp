<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Success - HMSystem</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>

<body>
    <div class="auth-container">
        <div class="auth-card" style="text-align: center;">
            <div class="auth-header">
                <div style="font-size: 3rem; margin-bottom: 20px;">✅</div>
                <h1 style="color: var(--success);">Registration Successful!</h1>
                <p>Your account has been created successfully.</p>
            </div>

            <div style="margin-top: 30px;">
                <a href="${pageContext.request.contextPath}/login" class="btn btn-primary"
                    style="display: inline-block; text-decoration: none;">Go to Login</a>
            </div>

            <div style="margin-top: 20px;">
                <a href="${pageContext.request.contextPath}/index.jsp"
                    style="color: var(--text-secondary); text-decoration: none; font-size: 0.9rem;">🏠 Back to Home</a>
            </div>
        </div>
    </div>
</body>

</html>