<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Patient File: ${patient.name} - HMSystem</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
            <style>
                .tabs {
                    display: flex;
                    gap: 10px;
                    margin-bottom: 30px;
                    border-bottom: 1px solid var(--border);
                    padding-bottom: 10px;
                }

                .tab-btn {
                    padding: 12px 24px;
                    background: transparent;
                    border: none;
                    color: var(--text-secondary);
                    cursor: pointer;
                    font-weight: 600;
                    font-family: 'Outfit', sans-serif;
                    border-radius: 8px;
                }

                .tab-btn.active {
                    background: var(--primary-glow);
                    color: var(--primary);
                }

                .tab-content {
                    display: none;
                    animation: fadeIn 0.3s ease;
                }

                .tab-content.active {
                    display: block;
                }

                @keyframes fadeIn {
                    from {
                        opacity: 0;
                        transform: translateY(10px);
                    }

                    to {
                        opacity: 1;
                        transform: translateY(0);
                    }
                }

                .info-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                    gap: 20px;
                    margin-bottom: 30px;
                }

                .info-item {
                    background: rgba(255, 255, 255, 0.03);
                    padding: 15px;
                    border-radius: 12px;
                    border: 1px solid var(--glass-border);
                }

                .info-item label {
                    font-size: 0.75rem;
                    text-transform: uppercase;
                    letter-spacing: 1px;
                    margin-bottom: 5px;
                }

                .info-item div {
                    font-size: 1.1rem;
                    font-weight: 600;
                    color: var(--primary);
                }

                .record-section {
                    margin-bottom: 30px;
                }

                .record-section h3 {
                    margin-bottom: 15px;
                    font-size: 1.25rem;
                    border-left: 4px solid var(--primary);
                    padding-left: 15px;
                }

                .badge {
                    padding: 4px 10px;
                    border-radius: 6px;
                    font-size: 0.85rem;
                    font-weight: 600;
                }

                .badge-success {
                    background: rgba(0, 230, 118, 0.1);
                    color: var(--success);
                }

                .badge-warning {
                    background: rgba(255, 171, 0, 0.1);
                    color: #ffab00;
                }
            </style>
        </head>

        <body>
            <jsp:include page="includes/sidebar.jsp" />
            <script>document.getElementById('nav-clinical').classList.add('active');</script>

            <div class="main-content">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
                    <div>
                        <a href="${pageContext.request.contextPath}/clinical"
                            style="color: var(--text-secondary); text-decoration: none; font-size: 0.9rem;">← Back to
                            Directory</a>
                        <h1 style="margin-top: 10px;">Medical File: ${patient.name}</h1>
                    </div>
                    <div class="info-item" style="text-align: right;">
                        <label>Last Updated</label>
                        <div>${record.lastUpdated != null ? record.lastUpdated.toLocalDate() : 'Never'}</div>
                    </div>
                </div>

                <div class="tabs">
                    <button class="tab-btn active" onclick="openTab(event, 'ehr')">EHR & Vitals</button>
                    <button class="tab-btn" onclick="openTab(event, 'prescriptions')">Prescriptions</button>
                    <button class="tab-btn" onclick="openTab(event, 'labs')">Lab Reports</button>
                </div>

                <!-- EHR TAB -->
                <div id="ehr" class="tab-content active">
                    <form action="${pageContext.request.contextPath}/clinical?action=updateEHR" method="post"
                        enctype="multipart/form-data" class="card">
                        <input type="hidden" name="csrfToken" value="${csrfToken}">
                        <input type="hidden" name="patientId" value="${patient.id}">

                        <div class="record-section">
                            <h3>Current Vitals</h3>
                            <div class="info-grid">
                                <div class="form-group">
                                    <label>Blood Pressure</label>
                                    <input type="text" name="bloodPressure" value="${record.bloodPressure}"
                                        placeholder="e.g. 120/80">
                                </div>
                                <div class="form-group">
                                    <label>Heart Rate (bpm)</label>
                                    <input type="number" name="heartRate" value="${record.heartRate}" placeholder="72">
                                </div>
                                <div class="form-group">
                                    <label>Temperature (°C)</label>
                                    <input type="number" step="0.1" name="temperature" value="${record.temperature}"
                                        placeholder="36.6">
                                </div>
                            </div>
                        </div>

                        <div class="record-section">
                            <h3>Medical Summary</h3>
                            <div class="form-group">
                                <label>Medical History</label>
                                <textarea name="medicalHistory" rows="4"
                                    placeholder="Previous surgeries, chronic conditions...">${record.medicalHistory}</textarea>
                            </div>
                            <div class="form-group">
                                <label>Allergies</label>
                                <textarea name="allergies" rows="2"
                                    placeholder="Medication, food, or environmental allergies...">${record.allergies}</textarea>
                            </div>
                            <div class="form-group">
                                <label>Immunization Records</label>
                                <textarea name="immunizations" rows="3"
                                    placeholder="List of vaccines and dates...">${record.immunizations}</textarea>
                            </div>
                            <div class="form-group">
                                <label>Patient Document (Scan, X-Ray, etc.)</label>
                                <input type="file" name="recordFile">
                                <c:if test="${not empty record.filePath}">
                                    <div style="margin-top: 10px;">
                                        <a href="${pageContext.request.contextPath}/clinical?action=download&path=${record.filePath}"
                                            class="btn btn-info btn-sm">📎 Download Current Attachment</a>
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <div style="text-align: right;">
                            <button type="submit" class="btn btn-primary">Save Clinical Changes</button>
                        </div>
                    </form>
                </div>

                <!-- PRESCRIPTIONS TAB -->
                <div id="prescriptions" class="tab-content">
                    <c:if test="${sessionScope.role == 'DOCTOR' || sessionScope.role == 'ADMIN'}">
                        <div class="card">
                            <div
                                style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                                <h3>New Prescription</h3>
                            </div>
                            <form action="${pageContext.request.contextPath}/clinical?action=addPrescription"
                                method="post" class="info-grid"
                                style="grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));">
                                <input type="hidden" name="csrfToken" value="${csrfToken}">
                                <input type="hidden" name="patientId" value="${patient.id}">
                                <div class="form-group">
                                    <label>Medication</label>
                                    <input type="text" name="medicationName" required placeholder="Aspirin">
                                </div>
                                <div class="form-group">
                                    <label>Dosage</label>
                                    <input type="text" name="dosage" required placeholder="500mg">
                                </div>
                                <div class="form-group">
                                    <label>Frequency</label>
                                    <input type="text" name="frequency" required placeholder="Once daily">
                                </div>
                                <div class="form-group">
                                    <label>Instructions</label>
                                    <input type="text" name="instructions" placeholder="After meals">
                                </div>
                                <div class="form-group" style="display: flex; align-items: flex-end;">
                                    <button type="submit" class="btn btn-primary" style="width: 100%;">Add</button>
                                </div>
                            </form>
                        </div>
                    </c:if>

                    <div class="card">
                        <h3>Prescription History</h3>
                        <div class="table-container">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Date</th>
                                        <th>Medication</th>
                                        <th>Dosage</th>
                                        <th>Frequency</th>
                                        <th>Doctor</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="presc" items="${prescriptions}">
                                        <tr>
                                            <td>${presc.prescribedDate.toLocalDate()}</td>
                                            <td><strong>${presc.medicationName}</strong></td>
                                            <td>${presc.dosage}</td>
                                            <td>${presc.frequency}</td>
                                            <td>Dr. ${presc.doctor.name}</td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty prescriptions}">
                                        <tr>
                                            <td colspan="5" style="text-align: center; color: var(--text-secondary);">No
                                                active prescriptions.</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- LABS TAB -->
                <div id="labs" class="tab-content">
                    <c:if test="${sessionScope.role == 'DOCTOR' || sessionScope.role == 'ADMIN'}">
                        <div class="card">
                            <h3>Request Lab Diagnostics</h3>
                            <form action="${pageContext.request.contextPath}/clinical?action=requestLab" method="post"
                                style="display: flex; gap: 20px; align-items: flex-end;">
                                <input type="hidden" name="csrfToken" value="${csrfToken}">
                                <input type="hidden" name="patientId" value="${patient.id}">
                                <div class="form-group" style="flex-grow: 1;">
                                    <label>Test Name</label>
                                    <input type="text" name="testName" required
                                        placeholder="Complete Blood Count (CBC)">
                                </div>
                                <div class="form-group">
                                    <button type="submit" class="btn btn-primary" style="padding: 12px 30px;">Request
                                        Test</button>
                                </div>
                            </form>
                        </div>
                    </c:if>

                    <div class="card">
                        <h3>Test Results</h3>
                        <div class="table-container">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Date</th>
                                        <th>Test Type</th>
                                        <th>Status</th>
                                        <th>Action/Result</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="test" items="${labTests}">
                                        <tr>
                                            <td>${test.requestedDate.toLocalDate()}</td>
                                            <td>${test.testName}</td>
                                            <td>
                                                <span
                                                    class="badge badge-${test.status == 'PENDING' ? 'warning' : 'success'}">
                                                    ${test.status}
                                                </span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${test.status == 'COMPLETED'}">
                                                        <a href="${pageContext.request.contextPath}/${test.resultFileUrl}"
                                                            target="_blank" class="btn btn-info"
                                                            style="padding: 6px 12px; font-size: 0.8rem;">View
                                                            Report</a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <form
                                                            action="${pageContext.request.contextPath}/clinical?action=uploadLabResult"
                                                            method="post" enctype="multipart/form-data"
                                                            style="display: flex; gap: 10px;">
                                                            <input type="hidden" name="csrfToken" value="${csrfToken}">
                                                            <input type="hidden" name="patientId" value="${patient.id}">
                                                            <input type="hidden" name="testId" value="${test.id}">
                                                            <input type="file" name="resultFile" required
                                                                style="font-size: 0.8rem; padding: 4px;">
                                                            <button type="submit" class="btn btn-primary"
                                                                style="padding: 6px 12px; font-size: 0.8rem;">Upload</button>
                                                        </form>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <script>
                function openTab(evt, tabName) {
                    var i, tabcontent, tablinks;
                    tabcontent = document.getElementsByClassName("tab-content");
                    for (i = 0; i < tabcontent.length; i++) {
                        tabcontent[i].classList.remove("active");
                    }
                    tablinks = document.getElementsByClassName("tab-btn");
                    for (i = 0; i < tablinks.length; i++) {
                        tablinks[i].classList.remove("active");
                    }
                    document.getElementById(tabName).classList.add("active");
                    evt.currentTarget.classList.add("active");
                }
            </script>
        </body>

        </html>