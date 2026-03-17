<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediFlow | Advanced Healthcare Management</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="landing-body">
    <nav class="landing-nav">
        <div class="brand-font">
            <span class="logo-medi">Medi</span><span class="logo-flow">Flow</span>
        </div>
        <div class="nav-links">
            <a href="#features">Features</a>
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary">Go to Dashboard</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login">Sign In</a>
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Get Started</a>
                </c:otherwise>
            </c:choose>
        </div>
    </nav>

    <main>
        <section class="landing-hero-new">
            <div class="hero-content-column">
                <div class="hero-text-new">
                    <h1>Tomorrow's Healthcare, <br>Managed Today.</h1>
                    <p class="hero-subtitle">Experience the next generation of hospital management. Mediflow combines intelligence with intuition to streamline every aspect of patient care.</p>
                    
                    <div class="hero-actions-new">
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Start Free Trial</a>
                        <a href="#features" class="btn btn-secondary">Explore Features</a>
                    </div>
                    
                    <div style="display: flex; gap: 40px; margin-top: 20px;">
                        <div>
                            <h3 style="font-size: 1.5rem; color: var(--primary);">99.9%</h3>
                            <p style="font-size: 0.8rem; color: var(--text-muted);">Uptime SLA</p>
                        </div>
                        <div>
                            <h3 style="font-size: 1.5rem; color: var(--primary);">150+</h3>
                            <p style="font-size: 0.8rem; color: var(--text-muted);">Hospitals Trusted</p>
                        </div>
                        <div>
                            <h3 style="font-size: 1.5rem; color: var(--primary);">24/7</h3>
                            <p style="font-size: 0.8rem; color: var(--text-muted);">Expert Support</p>
                        </div>
                    </div>
                </div>
            </div>
            <div class="hero-image-container">
                <img src="${pageContext.request.contextPath}/images/doctor-hero.png" alt="MediFlow Professional Interface">
            </div>
        </section>

        <section id="features" class="features-section">
            <div class="section-header">
                <h2>Intelligent Features for <br>Modern Care</h2>
                <p style="color: var(--text-muted); max-width: 600px; margin: 0 auto;">Everything you need to manage your hospital with precision and ease.</p>
            </div>

            <div class="info-cards-grid">
                <div class="info-card-new">
                    <h3>Precision Records</h3>
                    <p>Unified patient data with real-time updates and historical tracking for better clinical decisions.</p>
                </div>
                <div class="info-card-new">
                    <h3>Smart Scheduling</h3>
                    <p>AI-powered appointment management that reduces wait times and optimizes staff allocation.</p>
                </div>
                <div class="info-card-new">
                    <h3>Seamless Billing</h3>
                    <p>Automated invoicing and insurance integration that ensures 100% financial transparency.</p>
                </div>
                <div class="info-card-new">
                    <h3>Safe & Secure</h3>
                    <p>Enterprise-grade encryption and HIPAA compliance to keep patient data protected at all times.</p>
                </div>
                <div class="info-card-new">
                    <h3>Advanced Analytics</h3>
                    <p>Gain deep insights into hospital performance with beautiful, interactive reporting dashboards.</p>
                </div>
                <div class="info-card-new">
                    <h3>Mobile Ready</h3>
                    <p>Access your hospital management system from anywhere, on any device, with full functionality.</p>
                </div>
            </div>
        </section>

        <section style="background: var(--slate-900); padding: 100px 10%; text-align: center; color: white;">
            <h2 style="color: white; font-size: 3rem; margin-bottom: 24px;">Ready to Transform Your Workflow?</h2>
            <p style="color: #94a3b8; font-size: 1.25rem; margin-bottom: 40px; max-width: 700px; margin-left: auto; margin-right: auto;">Join hundreds of medical institutions already using MediFlow to redefine healthcare excellence.</p>
            <a href="${pageContext.request.contextPath}/register" class="btn btn-primary" style="padding: 16px 48px; border-radius: 12px; font-size: 1.1rem;">Get Started for Free</a>
        </section>
    </main>

    <footer style="padding: 60px 10%; border-top: 1px solid var(--border-light); background: white;">
        <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 40px;">
            <div class="brand-font">
                <span class="logo-medi">Medi</span><span class="logo-flow">Flow</span>
            </div>
            <div style="display: flex; gap: 32px; color: var(--text-muted); font-size: 0.9rem;">
                <a href="#">Privacy Policy</a>
                <a href="#">Terms of Service</a>
                <a href="#">Cookie Policy</a>
            </div>
            <p style="color: var(--text-muted); font-size: 0.9rem;">&copy; 2026 MediFlow Inc. All rights reserved.</p>
        </div>
    </footer>

    <script>
        // Interaction micro-animations
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth'
                    });
                }
            });
        });
    </script>
</body>
</html>
   
        </html>