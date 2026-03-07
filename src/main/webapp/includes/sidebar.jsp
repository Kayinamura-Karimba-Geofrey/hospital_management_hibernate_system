<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <div class="sidebar">
            <div class="sidebar-header">HMSystem</div>
            <div class="sidebar-nav">
                <a href="${pageContext.request.contextPath}/dashboard" id="nav-dashboard">Dashboard</a>

                <c:if test="${sessionScope.role == 'ADMIN'}">
                    <a href="${pageContext.request.contextPath}/departments" id="nav-departments">Departments</a>
                    <a href="${pageContext.request.contextPath}/register" id="nav-register">Registration</a>
                </c:if>

                <c:if test="${sessionScope.role == 'ADMIN' || sessionScope.role == 'DOCTOR'}">
                    <a href="${pageContext.request.contextPath}/doctors" id="nav-doctors">Doctors</a>
                    <a href="${pageContext.request.contextPath}/surgery" id="nav-surgery">Surgeries</a>
                    <a href="${pageContext.request.contextPath}/analytics" id="nav-analytics">Analytics</a>
                </c:if>

                <c:if test="${sessionScope.role == 'ADMIN' || sessionScope.role == 'NURSE'}">
                    <a href="${pageContext.request.contextPath}/nurses" id="nav-nurses">Nurses</a>
                </c:if>

                <c:if
                    test="${sessionScope.role == 'ADMIN' || sessionScope.role == 'DOCTOR' || sessionScope.role == 'NURSE'}">
                    <a href="${pageContext.request.contextPath}/clinical" id="nav-clinical">Clinical Records</a>
                    <a href="${pageContext.request.contextPath}/patients" id="nav-patients">Patients</a>
                    <a href="${pageContext.request.contextPath}/facility" id="nav-facility">Facility</a>
                    <a href="${pageContext.request.contextPath}/appointments" id="nav-appointments">Appointments</a>
                </c:if>

                <c:if test="${sessionScope.role == 'ADMIN' || sessionScope.role == 'ACCOUNTANT'}">
                    <a href="${pageContext.request.contextPath}/financial" id="nav-billing">Billing</a>
                    <a href="${pageContext.request.contextPath}/inventory" id="nav-inventory">Inventory</a>
                </c:if>

                <c:if test="${sessionScope.role == 'PATIENT'}">
                    <a href="${pageContext.request.contextPath}/patient-portal" id="nav-portal">My Portal</a>
                </c:if>

                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="logout-btn">Login</a>
                    </c:otherwise>
                </c:choose>
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
            </script>
        </div>