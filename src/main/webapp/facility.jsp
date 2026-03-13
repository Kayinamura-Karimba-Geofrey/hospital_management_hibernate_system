<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Facility Management - HMSystem</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
            <style>
                .ward-container {
                    margin-bottom: 40px;
                }

                .ward-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-bottom: 20px;
                    padding: 20px 30px;
                    background: var(--surface-solid);
                    border-radius: 20px;
                    border: 1px solid var(--border);
                    border-left: 6px solid var(--primary);
                    box-shadow: var(--card-shadow);
                }

                .bed-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fill, minmax(130px, 1fr));
                    gap: 20px;
                    margin-bottom: 40px;
                }

                .bed-card {
                    background: var(--surface-solid);
                    border: 1px solid var(--border);
                    padding: 20px 15px;
                    border-radius: 20px;
                    text-align: center;
                    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                    cursor: pointer;
                    box-shadow: var(--card-shadow);
                }

                .bed-card:hover {
                    transform: translateY(-8px);
                    border-color: var(--primary);
                    box-shadow: var(--card-shadow-hover);
                }

                .bed-icon {
                    font-size: 1.8rem;
                    margin-bottom: 12px;
                    display: block;
                }

                .status-badge {
                    font-size: 0.75rem;
                    font-weight: 800;
                    padding: 4px 12px;
                    border-radius: 8px;
                    display: inline-block;
                    margin-top: 8px;
                    text-transform: uppercase;
                    letter-spacing: 0.5px;
                }

                .status-available {
                    background: rgba(50, 215, 75, 0.1);
                    color: #32d74b;
                }

                .status-occupied {
                    background: rgba(255, 69, 58, 0.1);
                    color: var(--danger);
                }

                .status-cleaning {
                    background: rgba(255, 159, 10, 0.1);
                    color: #ff9f0a;
                }

                .bed-card.AVAILABLE {
                    border-top: 5px solid #32d74b;
                }

                .bed-card.OCCUPIED {
                    border-top: 5px solid var(--danger);
                }

                .bed-card.CLEANING {
                    border-top: 5px solid #ff9f0a;
                }

                .form-overlay {
                    display: none;
                    position: fixed;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                    background: rgba(10, 132, 255, 0.1);
                    backdrop-filter: blur(12px);
                    z-index: 1000;
                    justify-content: center;
                    align-items: center;
                }
            </style>
        </head>

        <body>
            <jsp:include page="includes/sidebar.jsp" />
            <script>document.getElementById('nav-facility').classList.add('active');</script>

            <div class="main-content">
                <div class="hero">
                    <h1>Ward & Bed Management</h1>
                    <p>Visual map of hospital capacity. Track patient admissions and bed status in real-time.</p>
                </div>

                <c:forEach var="ward" items="${wards}">
                    <div class="ward-container">
                        <div class="ward-header">
                            <div>
                                <h2 style="margin:0;">${ward.name}</h2>
                                <span
                                    style="font-size: 0.8rem; opacity: 0.7; color: var(--primary); text-transform: uppercase; font-weight: 800;">${ward.type}
                                    Unit</span>
                            </div>
                            <div style="text-align: right;">
                                <span style="font-size: 1.2rem; font-weight: 800;">${ward.beds.size()}</span>
                                <span style="font-size: 0.7rem; display: block; opacity: 0.6;">TOTAL BEDS</span>
                            </div>
                        </div>

                        <div class="bed-grid">
                            <c:forEach var="bed" items="${ward.beds}">
                                <c:set var="activeAdm" value="${null}" />
                                <c:forEach var="adm" items="${activeAdmissions}">
                                    <c:if test="${adm.bed.id == bed.id}">
                                        <c:set var="activeAdm" value="${adm}" />
                                    </c:if>
                                </c:forEach>

                                <div class="bed-card ${bed.status}"
                                    onclick="handleBedClick('${bed.id}', '${bed.bedNumber}', '${bed.status}', '${activeAdm.id}', '${activeAdm.patient.name}')">
                                    <span class="bed-icon">🛏️</span>
                                    <span class="badge" style="background: rgba(10, 132, 255, 0.1); color: var(--primary);">Bed ${bed.bedNumber}</span>
                                    <div style="margin-top: 10px;">
                                        <span class="status-pill ${bed.status == 'AVAILABLE' ? 'status-active' : (bed.status == 'OCCUPIED' ? 'status-critical' : 'status-warning')}">
                                            ${bed.status}
                                        </span>
                                    </div>
                                    <c:if test="${not empty activeAdm}">
                                        <div
                                            style="font-size: 0.7rem; margin-top: 5px; color: var(--text-secondary); font-weight: 600;">
                                            ${activeAdm.patient.name}
                                        </div>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- ADMISSION MODAL -->
            <div id="admissionModal" class="form-overlay" onclick="closeModal(event, 'admissionModal')">
                <div class="card" style="width: 400px;" onclick="event.stopPropagation()">
                    <h3 id="modalTitle">Admit Patient</h3>
                    <form action="${pageContext.request.contextPath}/facility?action=admit" method="post">
                        <input type="hidden" name="csrfToken" value="${csrfToken}">
                        <input type="hidden" name="bedId" id="modalBedId">
                        <div class="form-group">
                            <label>Assigned Bed</label>
                            <input type="text" id="displayBedNum" disabled style="background: rgba(255,255,255,0.05);">
                        </div>
                        <div class="form-group">
                            <label>Select Patient</label>
                            <select name="patientId" required>
                                <c:forEach var="p" items="${patients}">
                                    <option value="${p.id}">${p.name} (ID: ${p.id})</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div style="display: flex; gap: 10px; margin-top: 20px;">
                            <button type="button" class="btn btn-secondary" style="flex: 1;"
                                onclick="document.getElementById('admissionModal').style.display='none'">Cancel</button>
                            <button type="submit" class="btn btn-primary" style="flex: 1;">Confirm Admission</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- DISCHARGE/MAINTENANCE MODAL -->
            <div id="statusModal" class="form-overlay" onclick="closeModal(event, 'statusModal')">
                <div class="card" style="width: 400px;" onclick="event.stopPropagation()">
                    <h3 id="statusModalTitle">Bed Management</h3>
                    <div id="statusDetails" style="margin-bottom: 20px; font-size: 0.9rem;"></div>

                    <form id="statusForm" method="post" action="">
                        <input type="hidden" name="csrfToken" value="${csrfToken}">
                        <input type="hidden" name="admissionId" id="statusAdmissionId">
                        <input type="hidden" name="bedId" id="statusBedId">
                        <input type="hidden" name="action" id="statusAction">

                        <div style="display: flex; gap: 10px;">
                            <button type="button" class="btn btn-secondary" style="flex: 1;"
                                onclick="document.getElementById('statusModal').style.display='none'">Close</button>
                            <button type="submit" id="statusSubmitBtn" class="btn btn-primary"
                                style="flex: 1;">Action</button>
                        </div>
                    </form>
                </div>
            </div>

            <script>
                function handleBedClick(id, num, status, admId, patientName) {
                    if (status === 'AVAILABLE') {
                        document.getElementById('modalBedId').value = id;
                        document.getElementById('displayBedNum').value = "Bed " + num;
                        document.getElementById('admissionModal').style.display = 'flex';
                    } else if (status === 'OCCUPIED') {
                        document.getElementById('statusModalTitle').innerText = "Bed " + num + " (Occupied)";
                        document.getElementById('statusDetails').innerHTML = "Patient: <strong>" + patientName + "</strong><br>Currently admitted.";
                        document.getElementById('statusAdmissionId').value = admId;
                        document.getElementById('statusAction').value = "discharge";
                        document.getElementById('statusForm').action = "${pageContext.request.contextPath}/facility?action=discharge";
                        document.getElementById('statusSubmitBtn').innerText = "Discharge Patient";
                        document.getElementById('statusSubmitBtn').className = "btn btn-danger";
                        document.getElementById('statusModal').style.display = 'flex';
                    } else if (status === 'CLEANING') {
                        document.getElementById('statusModalTitle').innerText = "Bed " + num + " (Maintenance)";
                        document.getElementById('statusDetails').innerText = "This bed is currently being cleaned.";
                        document.getElementById('statusBedId').value = id;
                        document.getElementById('statusAction').value = "markReady";
                        document.getElementById('statusForm').action = "${pageContext.request.contextPath}/facility?action=markReady";
                        document.getElementById('statusSubmitBtn').innerText = "Mark as Ready";
                        document.getElementById('statusSubmitBtn').className = "btn btn-primary";
                        document.getElementById('statusModal').style.display = 'flex';
                    }
                }

                function closeModal(e, modalId) {
                    if (e.target.id === modalId) {
                        document.getElementById(modalId).style.display = 'none';
                    }
                }
            </script>
        </body>

        </html>