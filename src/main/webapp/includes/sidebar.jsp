<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <div class="sidebar">
            <div class="sidebar-header">HMSystem</div>
            <div class="sidebar-nav">
                <a href="${pageContext.request.contextPath}/dashboard.jsp" id="nav-dashboard"><span>🏠</span>
                    <span>Dashboard</span></a>

                <c:if test="${sessionScope.role == 'ADMIN'}">
                    <a href="${pageContext.request.contextPath}/departments" id="nav-departments"><span>🏥</span>
                        <span>Departments</span></a>
                    <a href="${pageContext.request.contextPath}/register" id="nav-register"><span>🔐</span>
                        <span>Registration</span></a>
                </c:if>

                <c:if test="${sessionScope.role == 'ADMIN' || sessionScope.role == 'DOCTOR'}">
                    <a href="${pageContext.request.contextPath}/doctors" id="nav-doctors"><span>👨‍⚕️</span>
                        <span>Doctors</span></a>
                    <a href="${pageContext.request.contextPath}/surgery" id="nav-surgery"><span>🔪</span>
                        <span>Surgeries</span></a>
                    <a href="${pageContext.request.contextPath}/analytics" id="nav-analytics"><span>📊</span>
                        <span>Analytics</span></a>
                </c:if>

                <c:if test="${sessionScope.role == 'ADMIN' || sessionScope.role == 'NURSE'}">
                    <a href="${pageContext.request.contextPath}/nurses" id="nav-nurses"><span>👩‍⚕️</span>
                        <span>Nurses</span></a>
                </c:if>

                <c:if
                    test="${sessionScope.role == 'ADMIN' || sessionScope.role == 'DOCTOR' || sessionScope.role == 'NURSE'}">
                    <a href="${pageContext.request.contextPath}/clinical" id="nav-clinical"><span>📂</span>
                        <span>Clinical
                            Records</span></a>
                    <a href="${pageContext.request.contextPath}/patients" id="nav-patients"><span>👤</span>
                        <span>Patients</span></a>
                    <a href="${pageContext.request.contextPath}/facility" id="nav-facility"><span>🏢</span>
                        <span>Facility</span></a>
                    <a href="${pageContext.request.contextPath}/appointments" id="nav-appointments"><span>📅</span>
                        <span>Appointments</span></a>
                </c:if>

                <c:if test="${sessionScope.role == 'ADMIN' || sessionScope.role == 'ACCOUNTANT'}">
                    <a href="${pageContext.request.contextPath}/financial" id="nav-billing"><span>💰</span>
                        <span>Billing</span></a>
                    <a href="${pageContext.request.contextPath}/inventory" id="nav-inventory"><span>📦</span>
                        <span>Inventory</span></a>
                </c:if>

                <c:if test="${sessionScope.role == 'PATIENT'}">
                    <a href="${pageContext.request.contextPath}/patient-portal" id="nav-portal"><span>👤</span> <span>My
                            Portal</span></a>
                </c:if>

                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <a href="${pageContext.request.contextPath}/logout" class="logout-btn"><span>🚪</span>
                            <span>Logout</span></a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="logout-btn"><span>🔑</span>
                            <span>Login</span></a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>