package com.ngo.util;

import java.io.FileWriter;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Mock Email Service for Development/Testing
 * Logs emails to file instead of sending through SMTP
 * Useful when SMTP is blocked or unavailable
 */
public class MockEmailUtil {

    private static final String LOG_FILE = "E:\\NGOImpactSystem\\email_log.txt";
    private static final DateTimeFormatter DTF = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    /**
     * Mock sendReport - logs to file instead of sending
     */
    public static void sendReport(String toEmail, String content) throws Exception {
        if (toEmail == null || toEmail.trim().isEmpty()) {
            throw new IllegalArgumentException("Recipient email cannot be null or empty");
        }

        try {
            logEmail("REPORT", toEmail, "NGO Impact Dashboard Report", content);
            System.out.println("[MOCK] Report email logged to file for: " + toEmail);
        } catch (IOException e) {
            System.err.println("[ERROR] Failed to log report: " + e.getMessage());
            throw e;
        }
    }

    /**
     * Mock sendEmail - logs to file instead of sending
     */
    public static void sendEmail(String toEmail, String subject, String messageText) {
        try {
            if (toEmail == null || toEmail.trim().isEmpty()) {
                System.err.println("[WARN] Attempted to send email with null/empty recipient");
                return;
            }
            if (subject == null || subject.trim().isEmpty()) {
                System.err.println("[WARN] Attempted to send email with null/empty subject");
                return;
            }
            if (messageText == null || messageText.trim().isEmpty()) {
                System.err.println("[WARN] Attempted to send email with null/empty message body");
                return;
            }

            logEmail("NORMAL", toEmail, subject, messageText);
            System.out.println("[MOCK] Email logged to file for: " + toEmail);
        } catch (IOException e) {
            System.err.println("[ERROR] Failed to log email: " + e.getMessage());
        }
    }

    /**
     * Helper method to log email to file
     */
    private static void logEmail(String type, String toEmail, String subject, String body) throws IOException {
        try (FileWriter fw = new FileWriter(LOG_FILE, true)) {
            fw.write("\n" + "=".repeat(80) + "\n");
            fw.write("TIME: " + LocalDateTime.now().format(DTF) + "\n");
            fw.write("TYPE: " + type + "\n");
            fw.write("TO: " + toEmail + "\n");
            fw.write("SUBJECT: " + subject + "\n");
            fw.write("BODY:\n");
            fw.write(body + "\n");
            fw.write("=".repeat(80) + "\n");
            fw.flush();
        }
    }

    /**
     * Validate email format
     */
    private static boolean isValidEmail(String email) {
        return email != null && email.matches("^[A-Za-z0-9+_.-]+@(.+)$");
    }
}
