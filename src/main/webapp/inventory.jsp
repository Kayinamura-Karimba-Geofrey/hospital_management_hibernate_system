<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Inventory Management - HMSystem</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
            <style>
                .inventory-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                    gap: 20px;
                    margin-bottom: 40px;
                }

                .item-card {
                    background: rgba(255, 255, 255, 0.03);
                    border: 1px solid var(--glass-border);
                    padding: 20px;
                    border-radius: 16px;
                    position: relative;
                    transition: all 0.3s ease;
                }

                .item-card:hover {
                    transform: translateY(-5px);
                    background: rgba(255, 255, 255, 0.05);
                }

                .item-card.low-stock {
                    border-color: var(--danger);
                }

                .item-card.low-stock::after {
                    content: "LOW STOCK";
                    position: absolute;
                    top: 10px;
                    right: 10px;
                    background: var(--danger);
                    color: white;
                    font-size: 0.6rem;
                    padding: 2px 8px;
                    border-radius: 4px;
                    font-weight: 800;
                }

                .item-type {
                    font-size: 0.7rem;
                    color: var(--primary);
                    font-weight: 800;
                    letter-spacing: 1px;
                }

                .item-name {
                    font-size: 1.2rem;
                    font-weight: 600;
                    margin: 5px 0 15px 0;
                }

                .item-stats {
                    display: flex;
                    justify-content: space-between;
                    font-size: 0.9rem;
                }

                .stock-value {
                    font-size: 1.5rem;
                    font-weight: 800;
                    color: var(--text-primary);
                    margin-top: 5px;
                }
            </style>
        </head>

        <body>
            <jsp:include page="includes/sidebar.jsp" />
            <script>document.getElementById('nav-inventory').classList.add('active');</script>

            <div class="main-content">
                <div class="hero">
                    <h1>Pharmacy & Supplies</h1>
                    <p>Monitor laboratory reagents, surgical supplies, and pharmaceutical inventory.</p>
                </div>

                <div style="display: flex; gap: 30px; margin-bottom: 40px;">
                    <!-- ADD ITEM FORM -->
                    <div class="card" style="flex: 1;">
                        <h3 id="form-title">Add To Inventory</h3>
                        <form id="inventory-form"
                            action="${pageContext.request.contextPath}/inventory?action=addOrUpdateItem" method="post">
                            <input type="hidden" name="csrfToken" value="${csrfToken}">
                            <input type="hidden" name="itemId" id="form-itemId">
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                                <div class="form-group">
                                    <label>Item Name</label>
                                    <input type="text" name="name" required placeholder="Paracetamol">
                                </div>
                                <div class="form-group">
                                    <label>Type</label>
                                    <select name="type">
                                        <option value="MEDICINE">Medicine</option>
                                        <option value="SUPPLY">Supply</option>
                                    </select>
                                </div>
                            </div>
                            <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 10px;">
                                <div class="form-group">
                                    <label>Initial Qty</label>
                                    <input type="number" name="quantity" required>
                                </div>
                                <div class="form-group">
                                    <label>Min Thresh.</label>
                                    <input type="number" name="minThreshold" required>
                                </div>
                                <div class="form-group">
                                    <label>Exp. Date</label>
                                    <input type="date" name="expiryDate" required>
                                </div>
                            </div>
                            <div class="form-group">
                                <label>Unit Price ($)</label>
                                <input type="number" step="0.01" name="unitPrice" required>
                            </div>
                            <div style="display: flex; gap: 10px;">
                                <button type="submit" id="submit-btn" class="btn btn-primary" style="flex: 1;">Add
                                    Item</button>
                                <button type="button" id="cancel-btn" class="btn btn-secondary"
                                    style="display: none; flex: 1;" onclick="resetForm()">Cancel</button>
                            </div>
                        </form>
                    </div>

                    <!-- LOW STOCK SUMMARY -->
                    <div class="card" style="width: 350px;">
                        <h3>Critical Alerts</h3>
                        <div style="margin-top: 20px;">
                            <c:forEach var="low" items="${lowStockItems}">
                                <div
                                    style="display: flex; align-items: center; gap: 10px; margin-bottom: 12px; padding: 10px; background: rgba(255, 82, 82, 0.05); border-radius: 8px; border: 1px solid rgba(255, 82, 82, 0.2);">
                                    <div style="flex-grow: 1;">
                                        <div style="font-weight: 600; font-size: 0.9rem;">${low.name}</div>
                                        <div style="font-size: 0.75rem; color: var(--text-secondary);">Only
                                            ${low.quantity} remaining</div>
                                    </div>
                                </div>
                            </c:forEach>
                            <c:if test="${empty lowStockItems}">
                                <div style="text-align: center; color: var(--success); padding: 20px;">
                                    All stock levels healthy
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>

                <div class="inventory-grid">
                    <c:forEach var="item" items="${items}">
                        <div class="item-card ${item.quantity <= item.minThreshold ? 'low-stock' : ''}">
                            <div class="item-type">${item.type}</div>
                            <div class="item-name">${item.name}</div>
                            <div class="item-stats">
                                <div>
                                    <label style="font-size: 0.7rem; opacity: 0.6;">CURRENT STOCK</label>
                                    <div class="stock-value">${item.quantity}</div>
                                </div>
                                <div style="text-align: right;">
                                    <label style="font-size: 0.7rem; opacity: 0.6;">EXPIRY</label>
                                    <div style="font-weight: 600; color: var(--text-secondary)">
                                        ${item.expiryDate}
                                    </div>
                                </div>
                            </div>

                            <div style="margin-top: 20px; display: flex; gap: 10px;">
                                <form action="${pageContext.request.contextPath}/inventory?action=updateQuantity"
                                    method="post" style="flex: 1; display: flex; gap: 5px;">
                                    <input type="hidden" name="csrfToken" value="${csrfToken}">
                                    <input type="hidden" name="itemId" value="${item.id}">
                                    <input type="hidden" name="delta" value="10">
                                    <button type="submit" class="btn btn-secondary"
                                        style="padding: 5px; flex-grow: 1; font-size: 0.75rem;">+10 Stock</button>
                                </form>
                                <form action="${pageContext.request.contextPath}/inventory?action=updateQuantity"
                                    method="post" style="flex: 1; display: flex; gap: 5px;">
                                    <input type="hidden" name="csrfToken" value="${csrfToken}">
                                    <input type="hidden" name="itemId" value="${item.id}">
                                    <input type="hidden" name="delta" value="-1">
                                    <button type="submit" class="btn btn-primary"
                                        style="padding: 5px; flex-grow: 1; font-size: 0.75rem;" ${item.quantity <=0
                                        ? 'disabled' : '' }>Use 1</button>
                                </form>
                            </div>

                            <div style="margin-top: 10px; display: flex; gap: 10px;">
                                <button class="btn btn-secondary"
                                    style="flex: 1; padding: 5px; font-size: 0.75rem; background: rgba(255,255,255,0.1);"
                                    onclick="editItem('${item.id}', '${item.name}', '${item.type}', '${item.quantity}', '${item.minThreshold}', '${item.expiryDate}', '${item.unitPrice}')">
                                    Edit
                                </button>
                                <form action="${pageContext.request.contextPath}/inventory?action=delete" method="post"
                                    style="flex: 1;" onsubmit="return confirm('Are you sure?')">
                                    <input type="hidden" name="csrfToken" value="${csrfToken}">
                                    <input type="hidden" name="itemId" value="${item.id}">
                                    <button type="submit" class="btn btn-danger"
                                        style="width: 100%; padding: 5px; font-size: 0.75rem; background: rgba(255, 82, 82, 0.2); color: #ff5252; border: 1px solid rgba(255, 82, 82, 0.3);">
                                        Delete
                                    </button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </body>

        </html>