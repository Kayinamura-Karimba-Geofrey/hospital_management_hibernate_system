package com.example.Hospital_Management_System.servlet;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String loginURI = req.getContextPath() + "/login";
        String registerURI = req.getContextPath() + "/register";
        String successURI = req.getContextPath() + "/registration-success.jsp";
        
        boolean loggedIn = session != null && session.getAttribute("user") != null;
        boolean loginRequest = req.getRequestURI().equals(loginURI);
        boolean registerRequest = req.getRequestURI().equals(registerURI);
        boolean successRequest = req.getRequestURI().equals(successURI);
        boolean isStaticResource = req.getRequestURI().endsWith(".css") || 
                                   req.getRequestURI().endsWith(".js") || 
                                   req.getRequestURI().endsWith(".png") || 
                                   req.getRequestURI().endsWith(".jpg");

        if (loggedIn || loginRequest || registerRequest || successRequest || isStaticResource) {
            chain.doFilter(request, response);
        } else {
            res.sendRedirect(loginURI);
        }
    }

    @Override
    public void destroy() {
    }
}
