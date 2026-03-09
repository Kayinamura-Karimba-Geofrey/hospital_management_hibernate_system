package com.example.Hospital_Management_System.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class ReCaptchaService {
    private static final Logger LOGGER = Logger.getLogger(ReCaptchaService.class.getName());

    public static boolean verify(String recaptchaResponse) {
        String secretKey = System.getenv("RECAPTCHA_SECRET_KEY");

        if (secretKey == null || secretKey.trim().isEmpty()) {
            LOGGER.warning("RECAPTCHA_SECRET_KEY environment variable is not set. Bypassing reCAPTCHA validation for development/testing.");
            return true; // Bypass validation if no key is provided
        }

        if (recaptchaResponse == null || recaptchaResponse.trim().isEmpty()) {
            LOGGER.warning("reCAPTCHA response token is empty.");
            return false;
        }

        try {
            URL url = new URL("https://www.google.com/recaptcha/api/siteverify");
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("POST");
            connection.setDoOutput(true);

            String postParams = "secret=" + secretKey + "&response=" + recaptchaResponse;

            try (OutputStream os = connection.getOutputStream()) {
                os.write(postParams.getBytes());
                os.flush();
            }

            int responseCode = connection.getResponseCode();
            if (responseCode != 200) {
                LOGGER.severe("Failed to verify reCAPTCHA. HTTP response code: " + responseCode);
                return false;
            }

            StringBuilder response = new StringBuilder();
            try (BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()))) {
                String inputLine;
                while ((inputLine = in.readLine()) != null) {
                    response.append(inputLine);
                }
            }

            String jsonResponse = response.toString();
            LOGGER.info("reCAPTCHA verification response: " + jsonResponse);

            // Simple robust regex parsing to avoid bringing in Jackson/Gson just for this
            boolean success = jsonResponse.contains("\"success\": true");
            
            // Check the score (reCAPTCHA v3 returns a score between 0.0 and 1.0)
            double score = 0.0;
            Pattern pattern = Pattern.compile("\"score\":\\s*([0-9.]+)");
            Matcher matcher = pattern.matcher(jsonResponse);
            if (matcher.find()) {
                score = Double.parseDouble(matcher.group(1));
            }

            LOGGER.info("reCAPTCHA score: " + score);

            // Accept registration if the score is 0.5 or higher.
            return success && score >= 0.5;

        } catch (Exception e) {
            LOGGER.severe("Exception during reCAPTCHA verification: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
