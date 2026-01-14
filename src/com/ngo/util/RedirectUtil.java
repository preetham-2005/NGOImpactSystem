package com.ngo.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class RedirectUtil {

    public static void redirect(HttpServletRequest req, HttpServletResponse res, String path) throws IOException {

        // Ensure path starts with /
        if (!path.startsWith("/")) {
            path = "/" + path;
        }

        res.sendRedirect(req.getContextPath() + path);
    }
}
