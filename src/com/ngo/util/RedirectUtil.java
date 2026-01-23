package com.ngo.util;

import java.io.IOException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class RedirectUtil {
    public static void redirect(HttpServletRequest req, HttpServletResponse res, String path) throws IOException {
        res.sendRedirect(req.getContextPath() + path);
    }
}
