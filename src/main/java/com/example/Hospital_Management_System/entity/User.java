package com.example.Hospital_Management_System.entity;

import jakarta.persistence.*;

/**
 * Entity representing an application user.
 * Stores authentication credentials, roles, and 2FA settings.
 */
@Entity
@Table(name = "app_users")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String username;

    @Column(nullable = false)
    private String password;

    @Column(nullable = false)
    private String email;

    @Column(nullable = false)
    private String fullName;

    @Column(nullable = false)
    private String role;

    @Column(name = "two_factor_secret")
    private String twoFactorSecret;

    @Column(name = "is_two_factor_enabled", nullable = false)
    private boolean isTwoFactorEnabled = false;

    /** Default constructor for JPA. */
    public User() {}

    /**
     * Constructs a new User with full details.
     * @param username The unique login name.
     * @param password The hashed password.
     * @param email The contact email.
     * @param fullName The user's display name.
     * @param role The security role (e.g., ADMIN, DOCTOR).
     */
    public User(String username, String password, String email, String fullName, String role) {
        this.username = username;
        this.password = password;
        this.email = email;
        this.fullName = fullName;
        this.role = role;
    }


    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getTwoFactorSecret() { return twoFactorSecret; }
    public void setTwoFactorSecret(String twoFactorSecret) { this.twoFactorSecret = twoFactorSecret; }

    public boolean isTwoFactorEnabled() { return isTwoFactorEnabled; }
    public void setTwoFactorEnabled(boolean isTwoFactorEnabled) { this.isTwoFactorEnabled = isTwoFactorEnabled; }
}
