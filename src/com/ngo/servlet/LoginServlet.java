package com.ngo.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

import com.ngo.model.User;
import com.ngo.service.AuthService;
import com.ngo.util.RedirectUtil;   // ✅ Correct import

public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        User user = new AuthService().login(username, password);

        if (user != null) {

            HttpSession session = req.getSession();
            session.setAttribute("role", user.getRole());

            if ("ADMIN".equals(user.getRole())) {
                RedirectUtil.redirect(req, res, "/pages/admin/admin_dashboard.html");
            } else {
                RedirectUtil.redirect(req, res, "/pages/officers/officer_dashboard.html");
            }

        } else {
            RedirectUtil.redirect(req, res, "/login.html");
        }
    }
}
