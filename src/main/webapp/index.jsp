<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>HMSystem - Advanced Healthcare Management</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        </head>

        <body class="landing-body">
            <nav class="landing-nav">
                <div class="sidebar-header" style="border: none; padding: 0;">HMSystem</div>
                <div class="nav-links">
                    <a href="#features">Features</a>
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <a href="${pageContext.request.contextPath}/dashboard.jsp"
                                class="btn btn-primary">Dashboard</a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login">Login</a>
                            <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Join Now</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </nav>

            <header class="landing-hero">
                <div class="hero-badge"
                    style="background: var(--surface); padding: 8px 16px; border-radius: 100px; border: 1px solid var(--glass-border); margin-bottom: 2rem; font-size: 0.9rem; color: var(--primary);">
                    ✨ Next-Gen Hospital Management Solution
                </div>
                <h1>Elevating Healthcare <br> Through Innovation</h1>
                <p>A comprehensive, data-driven platform designed to streamline hospital operations, enhance patient
                    care, and
                    empower medical professionals.</p>
                <div style="display: flex; gap: 20px;">
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-primary"
                        style="padding: 16px 32px; font-size: 1.1rem;">Build Your System</a>
                    <a href="#features" class="btn btn-secondary" style="padding: 16px 32px; font-size: 1.1rem;">Explore
                        Features</a>
                </div>
            </header>

            <section id="features" class="landing-section">
                <div class="section-header">
                    <h2>Everything You Need to Scale</h2>
                    <p>From patient records to resource scheduling, manage every aspect of your healthcare facility with
                        unprecedented precision.</p>
                </div>
                <div class="feature-grid">
                    <div class="feature-card">
                        <span class="feature-icon">🚑</span>
                        <h3>Patient Care</h3>
                        <p>Complete medical histories, real-time diagnosis tracking, and personalized treatment plans in
                            one
                            secure dashboard.</p>
                    </div>
                    <div class="feature-card">
                        <span class="feature-icon">👨‍⚕️</span>
                        <h3>Staff Optimization</h3>
                        <p>Intelligent scheduling for doctors and nurses, ensuring optimal coverage and reducing
                            administrative
                            overhead.</p>
                    </div>
                    <div class="feature-card">
                        <span class="feature-icon">📅</span>
                        <h3>Smart Scheduling</h3>
                        <p>Automated appointment booking and conflict resolution to maximize facility utilization and
                            patient
                            satisfaction.</p>
                    </div>
                </div>
            </section>

            <section class="cta-section">
                <h2>Ready to transform your facility?</h2>
                <p style="color: var(--text-secondary); margin-bottom: 30px;">Join hundreds of healthcare providers
                    already
                    optimizing their operations with HMSystem.</p>
                <a href="${pageContext.request.contextPath}/register" class="btn btn-primary"
                    style="padding: 14px 40px;">Get Started for Free</a>
            </section>

            <footer
                style="padding: 40px; text-align: center; border-top: 1px solid var(--border); color: var(--text-secondary);">
                <p>&copy; 2026 HMSystem. All rights reserved.</p>
            </footer>

            <script>
                // Smooth scroll for anchor links
                document.querySelectorAll('a[href^="#"]').forEach(anchor => {
                    anchor.addEventListener('click', function (e) {
                        e.preventDefault();
                        document.querySelector(this.getAttribute('href')).scrollIntoView({
                            behavior: 'smooth'
                        });
                    });
                });
            </script>
        </body>

        </html>