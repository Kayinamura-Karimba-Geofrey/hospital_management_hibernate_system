package com.example.Hospital_Management_System.servlet;

import com.example.Hospital_Management_System.dao.UserDAO;
import com.example.Hospital_Management_System.entity.User;
import dev.samstevens.totp.code.CodeVerifier;
import dev.samstevens.totp.code.DefaultCodeGenerator;
import dev.samstevens.totp.code.DefaultCodeVerifier;
import dev.samstevens.totp.code.HashingAlgorithm;
import dev.samstevens.totp.exceptions.QrGenerationException;
import dev.samstevens.totp.qr.QrData;
import dev.samstevens.totp.qr.QrGenerator;
import dev.samstevens.totp.qr.ZxingPngQrGenerator;
import dev.samstevens.totp.secret.DefaultSecretGenerator;
import dev.samstevens.totp.secret.SecretGenerator;
import dev.samstevens.totp.time.SystemTimeProvider;
import dev.samstevens.totp.time.TimeProvider;
import dev.samstevens.totp.util.Utils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet for handling Two-Factor Authentication (2FA) setup and verification.
 * Manages TOTP secret generation, QR code display, and OTP code validation.
 */
@WebServlet("/2fa")
public class TwoFactorServlet extends HttpServlet {

    private UserDAO userDAO;
    private SecretGenerator secretGenerator;
    private QrGenerator qrGenerator;
    private CodeVerifier codeVerifier;

    @Override
    /**
     * Initializes the DAO and generators for 2FA.
     */
    public void init() {
        userDAO = new UserDAO();
        secretGenerator = new DefaultSecretGenerator();
        qrGenerator = new ZxingPngQrGenerator();
        
        TimeProvider timeProvider = new SystemTimeProvider();
        DefaultCodeGenerator codeGenerator = new DefaultCodeGenerator();
        codeVerifier = new DefaultCodeVerifier(codeGenerator, timeProvider);
    }

    @Override
    /**
     * Handles GET requests to display the 2FA setup (QR code) or verification form.
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User tempUser = (User) session.getAttribute("tempUser");

        if (tempUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (!tempUser.isTwoFactorEnabled() || tempUser.getTwoFactorSecret() == null) {
            // Setup 2FA
            String secret = tempUser.getTwoFactorSecret();
            if (secret == null) {
                secret = secretGenerator.generate();
                tempUser.setTwoFactorSecret(secret);
                userDAO.updateUser(tempUser); // Save secret immediately
            }

            QrData data = new QrData.Builder()
                    .label(tempUser.getEmail())
                    .secret(secret)
                    .issuer("HMSystem")
                    .algorithm(HashingAlgorithm.SHA1)
                    .digits(6)
                    .period(30)
                    .build();

            try {
                byte[] imageData = qrGenerator.generate(data);
                String mimeType = qrGenerator.getImageMimeType();
                String dataUri = Utils.getDataUriForImage(imageData, mimeType);
                request.setAttribute("qrCode", dataUri);
                request.setAttribute("setup", true);
            } catch (QrGenerationException e) {
                e.printStackTrace();
                request.setAttribute("error", "Error generating QR code.");
            }
        } else {
            request.setAttribute("setup", false);
        }

        request.getRequestDispatcher("2fa.jsp").forward(request, response);
    }

    @Override
    /**
     * Handles POST requests to verify the 6-digit TOTP code.
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User tempUser = (User) session.getAttribute("tempUser");

        if (tempUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String code = request.getParameter("code");
        String action = request.getParameter("action");
        String secret = tempUser.getTwoFactorSecret();

        if ("skip".equalsIgnoreCase(action) && !tempUser.isTwoFactorEnabled()) {
            // User chose to skip 2FA setup
            session.removeAttribute("tempUser");
            session.setAttribute("user", tempUser);
            session.setAttribute("role", tempUser.getRole());
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        if (codeVerifier.isValidCode(secret, code)) {
            // Valid code, enable 2FA if not already
            if (!tempUser.isTwoFactorEnabled()) {
                tempUser.setTwoFactorEnabled(true);
                userDAO.updateUser(tempUser);
            }

            // Log user in
            session.removeAttribute("tempUser");
            session.setAttribute("user", tempUser);
            session.setAttribute("role", tempUser.getRole());
            response.sendRedirect(request.getContextPath() + "/dashboard");
        } else {
            // Invalid code
            request.setAttribute("error", "Invalid authentication code.");
            // Re-show setup screen if they are partly through setup
            if (!tempUser.isTwoFactorEnabled()) {
               request.setAttribute("setup", true);
               
               QrData data = new QrData.Builder()
                    .label(tempUser.getEmail())
                    .secret(secret)
                    .issuer("HMSystem")
                    .algorithm(HashingAlgorithm.SHA1)
                    .digits(6)
                    .period(30)
                    .build();

                try {
                    byte[] imageData = qrGenerator.generate(data);
                    String mimeType = qrGenerator.getImageMimeType();
                    String dataUri = Utils.getDataUriForImage(imageData, mimeType);
                    request.setAttribute("qrCode", dataUri);
                } catch (QrGenerationException e) {
                    e.printStackTrace();
                }
            } else {
                request.setAttribute("setup", false);
            }
            request.getRequestDispatcher("2fa.jsp").forward(request, response);
        }
    }
}
