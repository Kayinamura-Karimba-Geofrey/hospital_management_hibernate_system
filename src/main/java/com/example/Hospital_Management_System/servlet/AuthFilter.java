package com.example.Hospital_Management_System.servlet;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Filter for authentication, role-based authorization, and CSRF protection.
 * intercepts all requests to ensure users are logged in and have appropriate permissions.
 */
@WebFilter("/*")
public class AuthFilter implements Filter {
    private static final java.util.Map<String, String[]> roleAccess = new java.util.HashMap<>();

    static {
        roleAccess.put("ADMIN", new String[]{"*"});
        roleAccess.put("DOCTOR", new String[]{"dashboard", "doctors", "patients", "clinical", "surgery", "appointments", "facility", "analytics"});
        roleAccess.put("NURSE", new String[]{"dashboard", "nurses", "patients", "clinical", "facility", "appointments"});
        roleAccess.put("ACCOUNTANT", new String[]{"dashboard", "financial", "inventory"});
        roleAccess.put("PATIENT", new String[]{"patient-portal", "dashboard", "appointments"});
    }

    /**
     * Filters requests to enforce security policies.
     * Generates CSRF tokens, validates POST request tokens, and checks user roles.
     */
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(true); // Ensure session for CSRF

        String path = req.getServletPath();
        String method = req.getMethod();
        
        // 1. Generate CSRF token if missing
        if (session.getAttribute("csrfToken") == null) {
            session.setAttribute("csrfToken", java.util.UUID.randomUUID().toString());
        }

        boolean isPublicPage = path == null || path.isEmpty() || path.equals("/") ||
                               path.endsWith("index.jsp") ||
                               path.endsWith("login") || 
                               path.endsWith("logout") || 
                               path.endsWith("register") || 
                               path.endsWith("registration-success.jsp") || 
                               path.endsWith("login.jsp") ||
                               path.endsWith("register.jsp") ||
                               path.endsWith("2fa") ||
                               path.endsWith("2fa.jsp");
                                
        boolean isStaticResource = path.endsWith(".css") || 
                                   path.endsWith(".js") || 
                                   path.endsWith(".png") || 
                                   path.endsWith(".jpg") ||
                                   path.endsWith(".svg") ||
                                   path.endsWith(".ico") ||
                                   path.endsWith(".woff2");

        if (isStaticResource) {
            chain.doFilter(request, response);
            return;
        }

        // 2. CSRF Protection for state-changing methods (including public ones like login/register)
        if ("POST".equalsIgnoreCase(method)) {
            String sessionToken = (String) session.getAttribute("csrfToken");
            String requestToken = req.getParameter("csrfToken");
            if (sessionToken == null || !sessionToken.equals(requestToken)) {
                res.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid or missing CSRF token");
                return;
            }
        }

        if (isPublicPage) {
            chain.doFilter(request, response);
            return;
        }

        // 3. Auth Check
        if (session.getAttribute("user") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // 4. Role-based Authorization
        String userRole = (String) session.getAttribute("role");
        if (userRole == null || !hasAccess(userRole, path)) {
            res.sendRedirect(req.getContextPath() + "/dashboard?error=unauthorized");
            return;
        }

        chain.doFilter(request, response);
    }

    private boolean hasAccess(String role, String path) {
        if ("ADMIN".equals(role)) return true;
        String[] allowed = roleAccess.get(role);
        if (allowed == null) return false;

        String page = path.startsWith("/") ? path.substring(1) : path;
        for (String p : allowed) {
            if (p.equals("*") || page.startsWith(p)) return true;
        }
        return false;
    }

    @Override
    public void destroy() {
    }
}
