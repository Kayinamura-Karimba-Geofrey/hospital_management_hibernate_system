package com.example.Hospital_Management_System.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

/**
 * Entity representing a system notification.
 * Alerts users about appointments, billing, or general system updates.
 */
@Entity
@Table(name = "notifications")
public class Notification {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(nullable = false)
    private String message;

    @Column(nullable = false)
    private String type; // e.g., APPOINTMENT, BILLING, SYSTEM

    @Column(name = "is_read")
    private boolean isRead = false;

    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();

    /** Default constructor for JPA. */
    public Notification() {}

    /**
     * Constructs a new Notification.
     * @param user The user who will receive the notification.
     * @param message The alert message content.
     * @param type The category of the notification (e.g., APPOINTMENT).
     */
    public Notification(User user, String message, String type) {
        this.user = user;
        this.message = message;
        this.type = type;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public boolean isRead() { return isRead; }
    public void setRead(boolean read) { isRead = read; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
