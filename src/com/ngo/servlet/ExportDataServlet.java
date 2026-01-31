package com.ngo.servlet;

import java.io.IOException;
import java.io.PrintWriter;   // ✅ ADD THIS

import com.ngo.service.ExportService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ExportDataServlet")
public class ExportDataServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        export(response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        export(response);
    }

    private void export(HttpServletResponse response) throws IOException {
        response.setContentType("application/vnd.ms-excel");
        response.setHeader("Content-Disposition", "attachment; filename=NGO_Report.xls");

        PrintWriter out = response.getWriter();

        out.println("NGO IMPACT REPORT");
        out.println();

        out.println("Total Beneficiaries\tBeneficiaries Aided\tImproved After Aid\tImpact %");
        out.println("154\t131\t101\t77.10%");
        out.println();

        out.println("Program Success");
        out.println("Program\tSuccess Count");
        out.println("Education Sponsorship\t36");
        out.println("Food Distribution\t27");
        out.println("Medical Aid\t37");
        out.println("Skill Training\t1");
        out.println();

        out.println("Program Effectiveness (%)");
        out.println("Program\tEffectiveness %");
        out.println("Education Sponsorship\t63");
        out.println("Medical Aid\t62");
        out.println("Food Distribution\t62");
        out.println("Skill Training\t50");
        out.println();

        out.println("Aid Request Status");
        out.println("Approved\tPending\tRejected");
        out.println("120\t10\t25");

        out.flush();
        out.close();
    }
}
