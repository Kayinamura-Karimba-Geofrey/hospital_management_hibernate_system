package com.example.Hospital_Management_System.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Explicit servlet for the root path to ensure we don't get 404s 
 * from welcome-file-list under certain Filter configurations.
 */
@WebServlet("")
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("HomeServlet: Root path hit, forwarding to index.jsp");
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}
