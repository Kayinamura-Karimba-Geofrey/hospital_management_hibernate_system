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

        String path = req.getRequestURI().substring(req.getContextPath().length());

        boolean loggedIn = session != null && session.getAttribute("user") != null;
        
        boolean isPublicPage = path.equals("/") ||
                               path.equals("/index.jsp") ||
                               path.equals("/login") || 
                               path.equals("/register") || 
                               path.equals("/registration-success.jsp") || 
                               path.equals("/login.jsp") ||
                               path.equals("/register.jsp");
                               
        boolean isStaticResource = path.endsWith(".css") || 
                                   path.endsWith(".js") || 
                                   path.endsWith(".png") || 
                                   path.endsWith(".jpg") ||
                                   path.endsWith(".svg") ||
                                   path.endsWith(".ico") ||
                                   path.endsWith(".woff2");

        if (loggedIn || isPublicPage || isStaticResource) {
            chain.doFilter(request, response);
        } else {
            res.sendRedirect(req.getContextPath() + "/login");
        }
    }

    @Override
    public void destroy() {
    }
}
