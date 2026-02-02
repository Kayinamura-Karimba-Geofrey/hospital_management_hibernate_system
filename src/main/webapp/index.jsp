<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>Hospital Management System</title>
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: #f0f2f5;
                margin: 0;
                padding: 0;
            }

            .navbar {
                background: #4a148c;
                color: white;
                padding: 1rem 2rem;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .navbar a {
                color: white;
                text-decoration: none;
                margin-left: 1rem;
            }

            .hero {
                background: linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5)), url('https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80');
                background-size: cover;
                height: 400px;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                color: white;
                text-align: center;
            }

            .hero h1 {
                font-size: 3rem;
                margin-bottom: 0.5rem;
            }

            .features {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 2rem;
                padding: 4rem 2rem;
                max-width: 1200px;
                margin: 0 auto;
            }

            .card {
                background: white;
                padding: 2rem;
                border-radius: 10px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                text-align: center;
            }
        </style>
    </head>

    <body>
        <div class="navbar">
            <div class="logo">HMS Pro</div>
            <div>
                <a href="index.jsp">Home</a>
                <a href="register">Register</a>
            </div>
        </div>
        <div class="hero">
            <h1>Welcome to Hospital Management</h1>
            <p>Advanced healthcare solutions for modern hospitals.</p>
        </div>
        <div class="features">
            <div class="card">
                <h3>Doctors</h3>
                <p>Manage medical professionals across 5 departments.</p>
            </div>
            <div class="card">
                <h3>Patients</h3>
                <p>Track patient records and medical history seamlessly.</p>
            </div>
            <div class="card">
                <h3>Appointments</h3>
                <p>Integrated scheduling system for patients and doctors.</p>
            </div>
        </div>
    </body>

    </html>