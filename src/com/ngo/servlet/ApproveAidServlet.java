package com.ngo.servlet;

import java.io.IOException;

import com.ngo.service.AidService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ApproveAidServlet")
public class ApproveAidServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        int requestId = Integer.parseInt(req.getParameter("request_id"));
        String action = req.getParameter("action");

        AidService service = new AidService();

        if ("approve".equalsIgnoreCase(action)) {
            service.approveRequest(requestId);
        } 
        else if ("reject".equalsIgnoreCase(action)) {
            service.rejectRequest(requestId);
        }

        // ✅ Back to manager approve page
        res.sendRedirect(req.getContextPath() + "/pages/manager/approve_aid.jsp");
    }
}
