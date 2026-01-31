package com.ngo.util;

import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;

public class EmailUtil {

    private static final String fromEmail = "kpreethamkotagiri1@gmail.com";
    private static final String password  = "nqrfjaojjunnyjtd";  // App password

    private static Session getSession() {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        return Session.getInstance(props,
            new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(fromEmail, password);
                }
            });
    }

    // ✅ METHOD USED BY DASHBOARD REPORT
    public static void sendReport(String toEmail, String content) throws Exception {
        Message message = new MimeMessage(getSession());
        message.setFrom(new InternetAddress(fromEmail));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject("NGO Impact Dashboard Report");
        message.setContent(content, "text/html");
        Transport.send(message);
    }

    // ✅ METHOD REQUIRED BY YOUR SERVLET
    public static void sendEmail(String toEmail, String subject, String messageText) {
        try {
            Message message = new MimeMessage(getSession());
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setText(messageText);
            Transport.send(message);
            System.out.println("Email sent successfully!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
