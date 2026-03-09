package com.example.Hospital_Management_System.servlet;

import com.example.Hospital_Management_System.dao.UserDAO;
import com.example.Hospital_Management_System.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;

    public void init() {
        userDAO = new UserDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String recaptchaToken = request.getParameter("g-recaptcha-response");

        // Advanced reCAPTCHA v3 Validation
        boolean isHuman = com.example.Hospital_Management_System.service.ReCaptchaService.verify(recaptchaToken);
        if (!isHuman) {
            request.setAttribute("error", "Security check failed. Automated activity detected.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.validateUserByEmail(email, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("tempUser", user);
            response.sendRedirect(request.getContextPath() + "/2fa");
        } else {
            request.setAttribute("error", "Invalid email or password");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
