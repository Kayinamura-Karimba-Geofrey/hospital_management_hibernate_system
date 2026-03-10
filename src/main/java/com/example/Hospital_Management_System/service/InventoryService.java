package com.example.Hospital_Management_System.service;

import com.example.Hospital_Management_System.dao.InventoryDAO;
import com.example.Hospital_Management_System.entity.InventoryItem;
import java.util.List;

/**
 * Service class for inventory management.
 * Handles stock levels for medicines and hospital supplies.
 */
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

    /**
     * Updates the quantity of an inventory item.
     * @param itemId The ID of the item.
     * @param delta The change in quantity (positive for restock, negative for use).
     */
    public void updateQuantity(int itemId, int delta) {
        InventoryItem item = inventoryDAO.getById(itemId);
        if (item != null) {
            int newQuantity = item.getQuantity() + delta;
            if (newQuantity < 0) {
                newQuantity = 0;
            }
            item.setQuantity(newQuantity);
            inventoryDAO.saveOrUpdate(item);
        }
    }

    /**
     * Deletes an inventory item from the system.
     * @param id The ID of the item to delete.
     */
    public void deleteItem(int id) {
        inventoryDAO.deleteItem(id);
    }
}
