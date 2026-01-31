package com.ngo.servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.ngo.model.User;
import com.ngo.service.AuthService;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        User user = new AuthService().login(username, password);

        if (user != null) {
            HttpSession session = req.getSession();
            session.setAttribute("user", user);
            session.setAttribute("role", user.getRole());

            String role = user.getRole();

            if ("ADMIN".equalsIgnoreCase(role)) {
                res.sendRedirect(req.getContextPath() + "/pages/admin/admin_dashboard.html");
            }
            else if ("OFFICER".equalsIgnoreCase(role)) {
                res.sendRedirect(req.getContextPath() + "/pages/officers/officer_dashboard.jsp");
            }
            else if ("MANAGER".equalsIgnoreCase(role)) {
                res.sendRedirect(req.getContextPath() + "/pages/manager/manager_dashboard.html");
            }
            else {
                // Unknown role
                res.sendRedirect(req.getContextPath() + "/login.html");
            }

        } else {
            // Invalid username/password
            res.sendRedirect(req.getContextPath() + "/login.html");
        }
    }
}
