<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<div class="sidebar">
    <div class="sidebar-header">
        <span class="logo-medi">Medi</span><span class="logo-flow" style="color: white; opacity: 0.9;">Flow</span>
    </div>
    <div class="sidebar-nav">
        <a href="${pageContext.request.contextPath}/dashboard" id="nav-dashboard">
            <span class="icon">🏠</span> Dashboard
        </a>

        <c:if test="${sessionScope.role == 'ADMIN'}">
            <a href="${pageContext.request.contextPath}/departments" id="nav-departments">
                <span class="icon">🏢</span> Departments
            </a>
            <a href="${pageContext.request.contextPath}/register" id="nav-register">
                <span class="icon">👤</span> Registration
            </a>
        </c:if>

        <c:if test="${sessionScope.role == 'ADMIN' || sessionScope.role == 'DOCTOR'}">
            <a href="${pageContext.request.contextPath}/doctors" id="nav-doctors">
                <span class="icon">👨‍⚕️</span> Doctors
            </a>
            <a href="${pageContext.request.contextPath}/surgery" id="nav-surgery">
                <span class="icon">✂️</span> Surgeries
            </a>
            <a href="${pageContext.request.contextPath}/analytics" id="nav-analytics">
                <span class="icon">📊</span> Analytics
            </a>
        </c:if>

        <c:if test="${sessionScope.role == 'ADMIN' || sessionScope.role == 'NURSE'}">
            <a href="${pageContext.request.contextPath}/nurses" id="nav-nurses">
                <span class="icon">👩‍⚕️</span> Nurses
            </a>
        </c:if>

        <c:if test="${sessionScope.role == 'ADMIN' || sessionScope.role == 'DOCTOR' || sessionScope.role == 'NURSE'}">
            <a href="${pageContext.request.contextPath}/clinical" id="nav-clinical">
                <span class="icon">📑</span> Clinical Records
            </a>
            <a href="${pageContext.request.contextPath}/patients" id="nav-patients">
                <span class="icon">👥</span> Patients
            </a>
            <a href="${pageContext.request.contextPath}/facility" id="nav-facility">
                <span class="icon">🏥</span> Facility
            </a>
            <a href="${pageContext.request.contextPath}/appointments" id="nav-appointments">
                <span class="icon">📅</span> Appointments
            </a>
        </c:if>

        <c:if test="${sessionScope.role == 'ADMIN' || sessionScope.role == 'ACCOUNTANT'}">
            <a href="${pageContext.request.contextPath}/financial" id="nav-billing">
                <span class="icon">💰</span> Billing
            </a>
            <a href="${pageContext.request.contextPath}/inventory" id="nav-inventory">
                <span class="icon">📦</span> Inventory
            </a>
        </c:if>

        <c:if test="${sessionScope.role == 'PATIENT'}">
            <a href="${pageContext.request.contextPath}/patient-portal" id="nav-portal">
                <span class="icon">🛡️</span> My Portal
            </a>
        </c:if>

        <div style="margin-top: auto; padding-top: 32px; border-top: 1px solid rgba(255,255,255,0.05);">
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <a href="${pageContext.request.contextPath}/logout" class="logout-btn" style="color: var(--danger); opacity: 0.8;">
                        <span class="icon">🚪</span> Logout
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="logout-btn">
                        <span class="icon">🔑</span> Login
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script>
        (function () {
            var userId = "${sessionScope.user.id}";
            if (userId) {
                var protocol = window.location.protocol === "https:" ? "wss:" : "ws:";
                var wsUrl = protocol + "//" + window.location.host + "${pageContext.request.contextPath}/notifications/" + userId;
                var socket = new WebSocket(wsUrl);

                socket.onmessage = function (event) {
                    alert("Notification: " + event.data);
                };

                socket.onclose = function () {
                    console.log("Notification WebSocket closed.");
                };
            }
        })();
        
        // Active link highlighting
        document.querySelectorAll('.sidebar-nav a').forEach(link => {
            if (link.href === window.location.href) {
                link.classList.add('active');
            }
        });
    </script>
</div>