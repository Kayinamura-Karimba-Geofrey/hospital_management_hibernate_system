package com.example.Hospital_Management_System.servlet;

import com.example.Hospital_Management_System.dao.InventoryDAO;
import com.example.Hospital_Management_System.entity.InventoryItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/inventory")
public class InventoryServlet extends HttpServlet {

    private InventoryDAO inventoryDAO;

    public void init() {
        inventoryDAO = new InventoryDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<InventoryItem> allItems = inventoryDAO.getAllItems();
        List<InventoryItem> lowStockItems = inventoryDAO.getLowStockItems();
        
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
            item = inventoryDAO.getById(Integer.parseInt(idStr));
        }
        
        if (item == null) {
            item = new InventoryItem();
        }

        item.setName(request.getParameter("name"));
        item.setType(request.getParameter("type"));
        item.setQuantity(Integer.parseInt(request.getParameter("quantity")));
        item.setUnitPrice(Double.parseDouble(request.getParameter("unitPrice")));
        item.setExpiryDate(LocalDate.parse(request.getParameter("expiryDate")));
        item.setMinThreshold(Integer.parseInt(request.getParameter("minThreshold")));
        
        inventoryDAO.saveOrUpdate(item);
    }

    private void updateQuantity(HttpServletRequest request) {
        int itemId = Integer.parseInt(request.getParameter("itemId"));
        int delta = Integer.parseInt(request.getParameter("delta")); // Positive to add, negative to consume
        
        InventoryItem item = inventoryDAO.getById(itemId);
        if (item != null) {
            item.setQuantity(item.getQuantity() + delta);
            inventoryDAO.saveOrUpdate(item);
        }
    }
}
