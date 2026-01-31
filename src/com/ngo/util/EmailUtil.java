package com.ngo.util;

import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;

public class EmailUtil {

    /**
     * Use mock email by default for development (logs to file instead of SMTP)
     * Set USE_REAL_EMAIL = true to actually send emails
     * Set EMAIL_SERVICE = mailtrap or gmail (default: gmail)
     */
    private static final boolean USE_MOCK_EMAIL = System.getenv("USE_REAL_EMAIL") == null ||
            !System.getenv("USE_REAL_EMAIL").equalsIgnoreCase("true");

    private static final String EMAIL_SERVICE = System.getenv("EMAIL_SERVICE") != null ? System.getenv("EMAIL_SERVICE")
            : "gmail";

    // Email Configuration (read from environment or use defaults)
    private static final String fromEmail = System.getenv("EMAIL_FROM") != null ? System.getenv("EMAIL_FROM")
            : "noreply@ngo-system.com";
    private static final String smtpUsername = System.getenv("SMTP_USERNAME") != null ? System.getenv("SMTP_USERNAME")
            : "kpreethamkotagiri1@gmail.com";
    private static final String smtpPassword = System.getenv("SMTP_PASSWORD") != null ? System.getenv("SMTP_PASSWORD")
            : "nqrfjaojjunnyjtd";

    private static Session getSession() {
        Properties props = new Properties();

        if ("mailtrap".equalsIgnoreCase(EMAIL_SERVICE)) {
            // Mailtrap Configuration (free testing service)
            System.out.println("[INFO] Using Mailtrap SMTP");
            props.put("mail.smtp.host", "live.smtp.mailtrap.io");
            props.put("mail.smtp.port", "587");
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.starttls.required", "true");
        } else {
            // Gmail SMTP Configuration (default)
            System.out.println("[INFO] Using Gmail SMTP");
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "465");
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.socketFactory.port", "465");
            props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
            props.put("mail.smtp.socketFactory.fallback", "false");
        }

        props.put("mail.smtp.connectiontimeout", "10000");
        props.put("mail.smtp.timeout", "10000");
        props.put("mail.smtp.writetimeout", "10000");

        // Debug mode: uncomment to see SMTP conversation
        // props.put("mail.debug", "true");

        return Session.getInstance(props,
                new Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        System.out.println("[DEBUG] Authenticating with: " + smtpUsername);
                        return new PasswordAuthentication(smtpUsername, smtpPassword);
                    }
                });
    }

    // ✅ METHOD USED BY DASHBOARD REPORT
    public static void sendReport(String toEmail, String content) throws Exception {
        // Use mock email for development if enabled
        if (USE_MOCK_EMAIL) {
            MockEmailUtil.sendReport(toEmail, content);
            return;
        }

        if (toEmail == null || toEmail.trim().isEmpty()) {
            throw new IllegalArgumentException("Recipient email cannot be null or empty");
        }
        if (!isValidEmail(toEmail)) {
            throw new IllegalArgumentException("Invalid recipient email format: " + toEmail);
        }
        if (content == null || content.trim().isEmpty()) {
            throw new IllegalArgumentException("Email content cannot be null or empty");
        }

        try {
            System.out.println("[DEBUG] Sending report to: " + toEmail);
            System.out.println("[DEBUG] From email: " + fromEmail);

            Message message = new MimeMessage(getSession());
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("NGO Impact Dashboard Report");
            message.setContent(content, "text/html");
            Transport.send(message);
            System.out.println("[INFO] Report email sent successfully to " + toEmail);
        } catch (MessagingException me) {
            System.err.println("[ERROR] Messaging error sending to " + toEmail + ": " + me.getMessage());
            me.printStackTrace();
            throw me;
        } catch (Exception e) {
            System.err.println("[ERROR] Unexpected error: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    // ✅ METHOD REQUIRED BY YOUR SERVLET (suppresses exceptions)
    public static void sendEmail(String toEmail, String subject, String messageText) {
        // Use mock email for development if enabled
        if (USE_MOCK_EMAIL) {
            MockEmailUtil.sendEmail(toEmail, subject, messageText);
            return;
        }

        try {
            if (toEmail == null || toEmail.trim().isEmpty()) {
                System.err.println("[WARN] Attempted to send email with null/empty recipient");
                return;
            }
            if (!isValidEmail(toEmail)) {
                System.err.println("[WARN] Invalid recipient email format: " + toEmail);
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

            System.out.println("[DEBUG] Sending email to: " + toEmail);
            System.out.println("[DEBUG] Subject: " + subject);
            System.out.println("[DEBUG] From email: " + fromEmail);

            Message message = new MimeMessage(getSession());
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setText(messageText);
            Transport.send(message);
            System.out.println("[INFO] Email sent successfully to " + toEmail);
        } catch (MessagingException me) {
            System.err.println("[ERROR] Messaging error sending to " + toEmail + ": " + me.getMessage());
            me.printStackTrace();
        } catch (Exception e) {
            System.err.println("[ERROR] Unexpected error sending email to " + toEmail + ": " + e.getMessage());
            e.printStackTrace();
        }
    }

    // ✅ HELPER METHOD: Validate email format
    private static boolean isValidEmail(String email) {
        return email != null && email.matches("^[A-Za-z0-9+_.-]+@(.+)$");
    }
}
