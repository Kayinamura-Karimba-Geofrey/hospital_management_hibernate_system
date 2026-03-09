package com.example.Hospital_Management_System.servlet;

import com.example.Hospital_Management_System.entity.InventoryItem;
import com.example.Hospital_Management_System.service.InventoryService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

/**
 * Servlet for managing hospital inventory.
 * Handles tracking, adding, and updating stock levels for medicines and supplies.
 */
@WebServlet("/inventory")
public class InventoryServlet extends HttpServlet {
    private InventoryService inventoryService;

    public void init() {
        inventoryService = new InventoryService();
    }

    /**
     * Handles GET requests to list all inventory items and highlight low stock items.
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<InventoryItem> allItems = inventoryService.getAllItems();
        List<InventoryItem> lowStockItems = inventoryService.getLowStockItems();
        
        request.setAttribute("items", allItems);
        request.setAttribute("lowStockItems", lowStockItems);
        request.getRequestDispatcher("inventory.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("addOrUpdateItem".equals(action)) {
            addOrUpdateItem(request);
        } else if ("updateQuantity".equals(action)) {
            updateQuantity(request);
        }

        response.sendRedirect(request.getContextPath() + "/inventory");
    }

    private void addOrUpdateItem(HttpServletRequest request) {
        String idStr = request.getParameter("itemId");
        InventoryItem item = null;
        
        if (idStr != null && !idStr.isEmpty()) {
            item = inventoryService.getItemById(Integer.parseInt(idStr));
        }
        
        if (item == null) {
            item = new InventoryItem();
        }

        item.setName(request.getParameter("name"));
        item.setType(request.getParameter("type"));
        item.setQuantity(Integer.parseInt(request.getParameter("quantity")));
        item.setUnitPrice(Double.parseDouble(request.getParameter("unitPrice")));
        String expiryDateStr = request.getParameter("expiryDate");
        if (expiryDateStr != null && !expiryDateStr.isEmpty()) {
             item.setExpiryDate(LocalDate.parse(expiryDateStr));
        }
        item.setMinThreshold(Integer.parseInt(request.getParameter("minThreshold")));
        
        inventoryService.saveOrUpdateItem(item);
    }

    private void updateQuantity(HttpServletRequest request) {
        int itemId = Integer.parseInt(request.getParameter("itemId"));
        int delta = Integer.parseInt(request.getParameter("delta"));
        inventoryService.updateQuantity(itemId, delta);
    }
}
