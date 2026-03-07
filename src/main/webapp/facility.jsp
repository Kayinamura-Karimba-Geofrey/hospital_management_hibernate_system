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
                    margin-bottom: 15px;
                    padding: 10px 20px;
                    background: rgba(255, 255, 255, 0.05);
                    border-radius: 12px;
                    border-left: 4px solid var(--primary);
                }

                .bed-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
                    gap: 15px;
                }

                .bed-card {
                    background: rgba(255, 255, 255, 0.03);
                    border: 1px solid var(--glass-border);
                    padding: 15px;
                    border-radius: 12px;
                    text-align: center;
                    transition: all 0.3s ease;
                    cursor: pointer;
                }

                .bed-card:hover {
                    transform: translateY(-3px);
                    background: rgba(255, 255, 255, 0.07);
                }

                .bed-icon {
                    font-size: 1.5rem;
                    margin-bottom: 8px;
                    display: block;
                }

                .status-badge {
                    font-size: 0.7rem;
                    font-weight: 800;
                    padding: 2px 8px;
                    border-radius: 4px;
                    display: inline-block;
                    margin-top: 5px;
                }

                .status-available {
                    border-color: #4CAF50;
                    color: #4CAF50;
                }

                .status-occupied {
                    border-color: var(--danger);
                    color: var(--danger);
                }

                .status-cleaning {
                    border-color: #FFC107;
                    color: #FFC107;
                }

                .bed-card.AVAILABLE {
                    border-top: 4px solid #4CAF50;
                }

                .bed-card.OCCUPIED {
                    border-top: 4px solid var(--danger);
                }

                .bed-card.CLEANING {
                    border-top: 4px solid #FFC107;
                }

                .form-overlay {
                    display: none;
                    position: fixed;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                    background: rgba(0, 0, 0, 0.8);
                    backdrop-filter: blur(8px);
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
                                <div class="bed-card ${bed.status}"
                                    onclick="handleBedClick('${bed.id}', '${bed.bedNumber}', '${bed.status}')">
                                    <span class="bed-icon">🛏️</span>
                                    <div style="font-weight: 600;">Bed ${bed.bedNumber}</div>
                                    <span class="status-badge status-${bed.status.toLowerCase()}">${bed.status}</span>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- ADMISSION MODAL -->
            <div id="admissionModal" class="form-overlay" onclick="closeModal(event)">
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
                                    <option value="${p.id}">${p.fullName} (ID: ${p.id})</option>
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

            <script>
                function handleBedClick(id, num, status) {
                    if (status === 'AVAILABLE') {
                        document.getElementById('modalBedId').value = id;
                        document.getElementById('displayBedNum').value = "Bed " + num;
                        document.getElementById('admissionModal').style.display = 'flex';
                    } else if (status === 'OCCUPIED') {
                        alert("Bed is already occupied. Redirecting to patient file...");
                    } else {
                        alert("Bed is currently being cleaned and sanitized.");
                    }
                }
                function closeModal(e) {
                    if (e.target.id === 'admissionModal') {
                        document.getElementById('admissionModal').style.display = 'none';
                    }
                }
            </script>
        </body>

        </html>