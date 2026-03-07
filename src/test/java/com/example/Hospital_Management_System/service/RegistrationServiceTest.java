package com.example.Hospital_Management_System.service;

import com.example.Hospital_Management_System.entity.User;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockedStatic;
import org.mockito.MockitoAnnotations;

import static org.mockito.Mockito.*;

public class RegistrationServiceTest {

    private RegistrationService registrationService;

    @Mock
    private UserService userService;

    @Mock
    private SessionFactory sessionFactory;

    @Mock
    private Session session;

    @Mock
    private Transaction transaction;

    @BeforeEach
    public void setUp() {
        MockitoAnnotations.openMocks(this);
        registrationService = new RegistrationService(userService);
    }

    @Test
    public void testRegisterPatient() throws Exception {
        User user = new User("patient1", "pass", "p@test.com", "Patient One", "PATIENT");
        
        try (MockedStatic<HibernateUtil> mockedHibernate = mockStatic(HibernateUtil.class)) {
            mockedHibernate.when(HibernateUtil::getSessionFactory).thenReturn(sessionFactory);
            when(sessionFactory.openSession()).thenReturn(session);
            when(session.beginTransaction()).thenReturn(transaction);

            registrationService.registerUser(user, "PATIENT", null, "Patient One", "p@test.com");

            verify(session).persist(user);
            verify(transaction).commit();
            verify(session).close();
        }
    }
}
