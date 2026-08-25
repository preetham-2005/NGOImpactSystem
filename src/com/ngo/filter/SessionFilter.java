package com.ngo.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = {
    "/pages/*", 
    "/ExportDataServlet", 
    "/AnalyticsServlet", 
    "/ApproveAidServlet", 
    "/AddBeneficiaryServlet", 
    "/DistributeAidServlet", 
    "/PostAidImpactServlet"
})
public class SessionFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String path = req.getRequestURI();
        String contextPath = req.getContextPath();
        
        // Remove context path to simplify routing
        String relativePath = path.substring(contextPath.length());

        // Allow access to login resources and assets without session
        if (relativePath.equals("/login.html") || 
            relativePath.equals("/index.html") || 
            relativePath.equals("/") || 
            relativePath.startsWith("/css/") || 
            relativePath.startsWith("/assets/") || 
            relativePath.startsWith("/js/")) {
            chain.doFilter(request, response);
            return;
        }

        boolean isLoggedIn = (session != null && session.getAttribute("role") != null);

        if (!isLoggedIn) {
            // Redirect unauthenticated request to login page
            res.sendRedirect(contextPath + "/login.html");
            return;
        }

        String role = (String) session.getAttribute("role");

        // Role-based path checks
        if (relativePath.contains("/pages/admin/") || 
            relativePath.equals("/ExportDataServlet")) {
            if (!"ADMIN".equalsIgnoreCase(role)) {
                res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Admin role required.");
                return;
            }
        } 
        else if (relativePath.equals("/AnalyticsServlet")) {
            if (!"ADMIN".equalsIgnoreCase(role) && !"MANAGER".equalsIgnoreCase(role)) {
                res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Admin or Manager role required.");
                return;
            }
        }
        else if (relativePath.contains("/pages/manager/") || 
                 relativePath.equals("/ApproveAidServlet")) {
            if (!"MANAGER".equalsIgnoreCase(role)) {
                res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Manager role required.");
                return;
            }
        } 
        else if (relativePath.contains("/pages/officers/") || 
                 relativePath.equals("/AddBeneficiaryServlet") || 
                 relativePath.equals("/DistributeAidServlet") || 
                 relativePath.equals("/PostAidImpactServlet")) {
            if (!"OFFICER".equalsIgnoreCase(role)) {
                res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Field Officer role required.");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup if needed
    }
}
