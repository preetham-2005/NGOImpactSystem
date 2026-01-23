package com.ngo.servlet;

import java.io.IOException;

import com.ngo.service.ExportService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ExportDataServlet")
public class ExportDataServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        // ✅ Download CSV directly
        res.setContentType("text/csv");
        res.setHeader("Content-Disposition", "attachment; filename=ngo_export_data.csv");

        try {
            ExportService service = new ExportService();
            String csv = service.exportAllDataCSV();

            res.getWriter().write(csv);

        } catch (Exception e) {
            e.printStackTrace();
            res.getWriter().write("Error exporting CSV: " + e.getMessage());
        }
    }
}
