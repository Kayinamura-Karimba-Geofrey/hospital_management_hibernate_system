<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Billing & Invoicing - HMSystem</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        </head>

        <body>
            <jsp:include page="includes/sidebar.jsp" />
            <script>document.getElementById('nav-billing').classList.add('active');</script>

            <div class="main-content">
                <div class="hero">
                    <h1>Billing & Invoicing</h1>
                    <p>Manage patient accounts, insurance claims, and hospital revenue.</p>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 30px; margin-bottom: 30px;">
                    <!-- GENERATE INVOICE -->
                    <div class="card">
                        <div class="section-header">
                            <h2>Generate New Invoice</h2>
                        </div>
                        <form action="${pageContext.request.contextPath}/financial?action=generateInvoice"
                            method="post">
                            <div class="form-group">
                                <label>Select Patient</label>
                                <select name="patientId" required>
                                    <option value="">-- Choose Patient --</option>
                                    <c:forEach var="p" items="${allPatients}">
                                        <option value="${p.id}" ${selectedPatient.id==p.id ? 'selected' : '' }>${p.name}
                                            (#${p.id})</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Service Description</label>
                                <input type="text" name="description" required
                                    placeholder="Consultation Fee, Lab Test, etc.">
                            </div>
                            <div class="form-group">
                                <label>Amount ($)</label>
                                <input type="number" step="0.01" name="amount" required placeholder="0.00">
                            </div>
                            <button type="submit" class="btn btn-primary" style="width: 100%;">Create Invoice</button>
                        </form>
                    </div>

                    <!-- INSURANCE LOOKUP -->
                    <div class="card">
                        <div class="section-header">
                            <h2>Insurance Management</h2>
                        </div>
                        <form action="${pageContext.request.contextPath}/financial" method="get"
                            style="display: flex; gap: 10px; margin-bottom: 20px;">
                            <select name="patientId" style="flex-grow: 1;">
                                <option value="">-- Select Patient --</option>
                                <c:forEach var="p" items="${allPatients}">
                                    <option value="${p.id}" ${selectedPatient.id==p.id ? 'selected' : '' }>${p.name}
                                    </option>
                                </c:forEach>
                            </select>
                            <button type="submit" class="btn btn-secondary">Load</button>
                        </form>

                        <c:if test="${not empty selectedPatient}">
                            <form action="${pageContext.request.contextPath}/financial?action=updateInsurance"
                                method="post">
                                <input type="hidden" name="patientId" value="${selectedPatient.id}">
                                <div class="form-group">
                                    <label>Provider</label>
                                    <input type="text" name="provider" value="${insurance.provider}" required
                                        placeholder="Blue Cross">
                                </div>
                                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                                    <div class="form-group">
                                        <label>Policy #</label>
                                        <input type="text" name="policyNumber" value="${insurance.policyNumber}"
                                            required>
                                    </div>
                                    <div class="form-group">
                                        <label>Coverage (%)</label>
                                        <input type="number" name="coveragePercentage"
                                            value="${insurance.coveragePercentage}" required>
                                    </div>
                                </div>
                                <button type="submit" class="btn btn-primary" style="width: 100%;">Update
                                    Coverage</button>
                            </form>
                        </c:if>
                    </div>
                </div>

                <div class="card">
                    <div class="section-header">
                        <h2>Invoice History</h2>
                    </div>
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Patient</th>
                                    <th>Description</th>
                                    <th>Amount</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="inv" items="${allInvoices}">
                                    <tr>
                                        <td>${inv.invoiceDate.toLocalDate()}</td>
                                        <td><strong>${inv.patient.name}</strong></td>
                                        <td>${inv.description}</td>
                                        <td>$${inv.amount}</td>
                                        <td>
                                            <span
                                                class="badge ${inv.status == 'PAID' ? 'badge-success' : 'badge-warning'}">
                                                ${inv.status}
                                            </span>
                                        </td>
                                        <td>
                                            <c:if test="${inv.status == 'UNPAID'}">
                                                <form
                                                    action="${pageContext.request.contextPath}/financial?action=updatePaymentStatus"
                                                    method="post">
                                                    <input type="hidden" name="invoiceId" value="${inv.id}">
                                                    <input type="hidden" name="status" value="PAID">
                                                    <button type="submit" class="btn btn-primary"
                                                        style="padding: 4px 10px; font-size: 0.75rem;">Mark
                                                        Paid</button>
                                                </form>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </body>

        </html>