package com.example.Hospital_Management_System.service;

import com.example.Hospital_Management_System.dao.UserDAO;
import com.example.Hospital_Management_System.entity.User;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

public class UserServiceTest {

    private UserService userService;

    @Mock
    private UserDAO userDAO;

    @BeforeEach
    public void setUp() {
        MockitoAnnotations.openMocks(this);
        userService = new UserService(userDAO);
    }

    @Test
    public void testHashPassword() {
        String password = "testPassword";
        String hashedPassword = userService.hashPassword(password);
        assertNotEquals(password, hashedPassword);
        assertTrue(userService.checkPassword(password, hashedPassword));
    }

    @Test
    public void testExistsByUsername() {
        when(userDAO.existsByUsername("admin")).thenReturn(true);
        assertTrue(userService.existsByUsername("admin"));
        verify(userDAO).existsByUsername("admin");
    }

    @Test
    public void testSaveUser() {
        User user = new User("user1", "pass", "email@test.com", "User One", "PATIENT");
        userService.save(user);
        verify(userDAO).saveUser(user);
    }
}
