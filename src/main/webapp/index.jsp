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
                <div class="sidebar-header" style="border: none; padding: 0;">MediFlow</div>
                <div class="nav-links">
                    <a href="#features">Features</a>
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary">Dashboard</a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login">Login</a>
                            <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Join Now</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </nav>

            <div class="landing-hero-new">
                <div class="hero-image-container">
                    <img src="${pageContext.request.contextPath}/images/doctor-hero.png" alt="Confident Professional Doctor">
                </div>
                <div class="hero-text-new">
                    <div class="brand-mediflow">
                        <div class="brand-logo-mockup"></div>
                        Mediflow
                    </div>
                    <h1>Manage Your Hospital Efficiently with Mediflow</h1>
                    <p class="hero-subtitle">All-in-one platform to manage appointments, patient records, billing, and analytics in one place.</p>
                    
                    <ul class="feature-list-new">
                        <li class="feature-item-new">
                            <div class="feature-icon-mockup">📅</div>
                            <div class="feature-content">
                                <h3>Appointments</h3>
                                <p>Streamline scheduling and reduce no-shows</p>
                            </div>
                        </li>
                        <li class="feature-item-new">
                            <div class="feature-icon-mockup">📂</div>
                            <div class="feature-content">
                                <h3>Patient Records</h3>
                                <p>Secure, centralized digital health records</p>
                            </div>
                        </li>
                        <li class="feature-item-new">
                            <div class="feature-icon-mockup">💳</div>
                            <div class="feature-content">
                                <h3>Billing & Payments</h3>
                                <p>Automated invoicing and payment tracking</p>
                            </div>
                        </li>
                        <li class="feature-item-new">
                            <div class="feature-icon-mockup">📊</div>
                            <div class="feature-content">
                                <h3>Reports & Analytics</h3>
                                <p>Data-driven insights for hospital operations</p>
                            </div>
                        </li>
                    </ul>
    
                    <div class="hero-actions-new">
                        <a href="${pageContext.request.contextPath}/register" class="btn-mediflow-primary">Try it Free</a>
                        <a href="#" class="btn-mediflow-secondary">Request Demo</a>
                    </div>
                </div>
            </div>
    
            <section class="info-cards-section">
                <div class="info-cards-grid">
                    <div class="info-card-new">
                        <span class="info-card-icon-mockup">🕒</span>
                        <h3>24/7 Support</h3>
                        <p>Access round-the-clock assistance</p>
                    </div>
                    <div class="info-card-new">
                        <span class="info-card-icon-mockup">🛡️</span>
                        <h3>Secure & Compliant</h3>
                        <p>HIPAA-compliant & enterprise-grade security</p>
                    </div>
                    <div class="info-card-new">
                        <span class="info-card-icon-mockup">👤</span>
                        <h3>User Friendly</h3>
                        <p>Intuitive, easy-to-navigate interface</p>
                    </div>
                </div>
            </section>
    
            <div class="bottom-banner-cta">
                Transform Your Hospital Operations with <span>Mediflow</span> Today!
            </div>
    
            <script>
                // Smooth scroll for anchor links
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