package com.example.Hospital_Management_System.service;

import java.util.regex.Pattern;

public class ValidationService {

    private static final String EMAIL_REGEX = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
    private static final String PHONE_REGEX = "^[+]?[0-9]{10,13}$";
    private static final String PASSWORD_STRENGTH_REGEX = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=])(?=\\S+$).{8,}$";

    public static boolean isValidEmail(String email) {
        if (email == null) return false;
        return Pattern.compile(EMAIL_REGEX).matcher(email).matches();
    }

    public static boolean isValidPhone(String phone) {
        if (phone == null || phone.isEmpty()) return true; // Phone might be optional
        return Pattern.compile(PHONE_REGEX).matcher(phone).matches();
    }

    public static boolean isStrongPassword(String password) {
        if (password == null) return false;
        // At least 8 chars, 1 digit, 1 lower, 1 upper, 1 special, no whitespace
        return Pattern.compile(PASSWORD_STRENGTH_REGEX).matcher(password).matches();
    }
    
    public static String getPasswordStrengthRequirement() {
        return "Password must be at least 8 characters long, contain at least one digit, one uppercase letter, one lowercase letter, one special character (@#$%^&+=), and no whitespace.";
    }
}
