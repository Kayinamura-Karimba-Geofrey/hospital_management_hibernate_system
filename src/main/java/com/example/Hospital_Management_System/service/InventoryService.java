package com.example.Hospital_Management_System.service;

import com.example.Hospital_Management_System.dao.InventoryDAO;
import com.example.Hospital_Management_System.entity.InventoryItem;
import java.util.List;

public class InventoryService {
    private final InventoryDAO inventoryDAO;

    public InventoryService() {
        this.inventoryDAO = new InventoryDAO();
    }

    public List<InventoryItem> getAllItems() {
        return inventoryDAO.getAllItems();
    }

    public List<InventoryItem> getLowStockItems() {
        return inventoryDAO.getLowStockItems();
    }

    public InventoryItem getItemById(int id) {
        return inventoryDAO.getById(id);
    }

    public void saveOrUpdateItem(InventoryItem item) {
        inventoryDAO.saveOrUpdate(item);
    }

    public void updateQuantity(int itemId, int delta) {
        InventoryItem item = inventoryDAO.getById(itemId);
        if (item != null) {
            item.setQuantity(item.getQuantity() + delta);
            inventoryDAO.saveOrUpdate(item);
        }
    }
}
