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
                            <h2 id="form-title">Generate New Invoice</h2>
                        </div>
                        <form id="invoice-form"
                            action="${pageContext.request.contextPath}/financial?action=generateInvoice" method="POST">
                            <input type="hidden" name="csrfToken" value="${csrfToken}">
                            <input type="hidden" name="invoiceId" id="form-invoiceId">
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
                            <div style="display: flex; gap: 10px;">
                                <button type="submit" id="submit-btn" class="btn btn-primary" style="flex: 1;">Create
                                    Invoice</button>
                                <button type="button" id="cancel-btn" class="btn btn-secondary"
                                    style="display: none; flex: 1;" onclick="resetForm()">Cancel</button>
                            </div>
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
                                method="POST">
                                <input type="hidden" name="csrfToken" value="${csrfToken}">
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
                                            <div style="display: flex; gap: 5px; align-items: center;">
                                                <c:if test="${inv.status == 'UNPAID'}">
                                                    <form
                                                        action="${pageContext.request.contextPath}/financial?action=updatePaymentStatus"
                                                        method="post" style="margin: 0;">
                                                        <input type="hidden" name="csrfToken" value="${csrfToken}">
                                                        <input type="hidden" name="invoiceId" value="${inv.id}">
                                                        <input type="hidden" name="status" value="PAID">
                                                        <button type="submit" class="btn btn-primary"
                                                            style="padding: 4px 8px; font-size: 0.7rem;">Paid</button>
                                                    </form>
                                                    <button class="btn btn-secondary"
                                                        style="padding: 4px 8px; font-size: 0.7rem; background: rgba(255,255,255,0.1);"
                                                        onclick="editInvoice('${inv.id}', '${inv.patient.id}', '${inv.description}', '${inv.amount}')">
                                                        Edit
                                                    </button>
                                                </c:if>
                                                <form
                                                    action="${pageContext.request.contextPath}/financial?action=deleteInvoice"
                                                    method="post" style="margin: 0;"
                                                    onsubmit="return confirm('Are you sure?')">
                                                    <input type="hidden" name="csrfToken" value="${csrfToken}">
                                                    <input type="hidden" name="invoiceId" value="${inv.id}">
                                                    <button type="submit" class="btn btn-danger"
                                                        style="padding: 4px 8px; font-size: 0.7rem; background: rgba(255, 82, 82, 0.2); color: #ff5252; border: 1px solid rgba(255, 82, 82, 0.3);">
                                                        Delete
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <script>
                function editInvoice(id, patientId, description, amount) {
                    document.getElementById('form-title').innerText = 'Update Invoice';
                    document.getElementById('form-invoiceId').value = id;
                    document.querySelector('select[name="patientId"]').value = patientId;
                    // Disable patient selection for updates to maintain consistency
                    document.querySelector('select[name="patientId"]').disabled = true;
                    // Add a hidden field to pass patientId since disabled select doesn't submit
                    if (!document.getElementById('hidden-patientId')) {
                        let hidden = document.createElement('input');
                        hidden.type = 'hidden';
                        hidden.name = 'patientId';
                        hidden.id = 'hidden-patientId';
                        document.getElementById('invoice-form').appendChild(hidden);
                    }
                    document.getElementById('hidden-patientId').value = patientId;

                    document.querySelector('input[name="description"]').value = description;
                    document.querySelector('input[name="amount"]').value = amount;

                    document.getElementById('submit-btn').innerText = 'Update Invoice';
                    document.getElementById('cancel-btn').style.display = 'block';
                    window.scrollTo({ top: 0, behavior: 'smooth' });
                }

                function resetForm() {
                    document.getElementById('form-title').innerText = 'Generate New Invoice';
                    document.getElementById('form-invoiceId').value = '';
                    document.getElementById('invoice-form').reset();
                    document.querySelector('select[name="patientId"]').disabled = false;
                    let hidden = document.getElementById('hidden-patientId');
                    if (hidden) hidden.remove();

                    document.getElementById('submit-btn').innerText = 'Create Invoice';
                    document.getElementById('cancel-btn').style.display = 'none';
                }
            </script>
        </body>

        </html>