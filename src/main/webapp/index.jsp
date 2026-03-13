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
            <div class="landing-hero-new">
                <div class="hero-image-container">
                    <img src="${pageContext.request.contextPath}/images/doctor-hero.png" alt="Professional Doctor">
                </div>
                <div class="hero-text-new">
                    <div class="brand-mediflow">
                        <div class="brand-logo-mockup"></div>
                        MediFlow
                    </div>
                    <h1>The All-in-One Hospital Management Software</h1>
                    <p class="hero-subtitle">Streamline hospital operations, improve patient care, and boost efficiency with our powerful, easy-to-use platform.</p>
                    
                    <ul class="feature-list-new">
                        <li class="feature-item-new">
                            <div class="feature-icon-mockup">💼</div>
                            <div class="feature-content">
                                <h3>Manage Patient Records</h3>
                                <p>Keep accurate, up-to-date patient records</p>
                            </div>
                        </li>
                        <li class="feature-item-new">
                            <div class="feature-icon-mockup">📅</div>
                            <div class="feature-content">
                                <h3>Simplify Appointment Scheduling</h3>
                                <p>Easily schedule, manage, and track appointments</p>
                            </div>
                        </li>
                        <li class="feature-item-new">
                            <div class="feature-icon-mockup">📈</div>
                            <div class="feature-content">
                                <h3>Automate Billing & Reporting</h3>
                                <p>Generate invoices, track payments, and view financial reports</p>
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
                        <span class="info-card-icon-mockup">💙</span>
                        <h3>24/7 Support</h3>
                        <p>Access round-the-clock assistance</p>
                    </div>
                    <div class="info-card-new">
                        <span class="info-card-icon-mockup">🛡️</span>
                        <h3>Secure & Compliant</h3>
                        <p>HIPAA-compliant & enterprise-grade security</p>
                    </div>
                    <div class="info-card-new">
                        <span class="info-card-icon-mockup">🌐</span>
                        <h3>User-Friendly</h3>
                        <p>Intuitive, easy-to-navigate interface</p>
                    </div>
                </div>
            </section>
    
            <div class="bottom-banner-cta">
                Transform Your Hospital Operations with <span>MediFlow</span> Today!
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
        </html>