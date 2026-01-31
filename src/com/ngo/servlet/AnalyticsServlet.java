package com.ngo.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import com.google.gson.Gson;
import com.ngo.dao.BeneficiaryDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/AnalyticsServlet")
public class AnalyticsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        try {
            BeneficiaryDAO dao = new BeneficiaryDAO();

            int totalBeneficiaries = dao.getTotalBeneficiaries();
            double totalAid = dao.getTotalAidDistributed();

            Map<String, Integer> regionData = dao.getBeneficiaryCountByRegion();
            Map<String, Integer> programData = dao.getBeneficiaryCountByProgram();
            Map<String, Integer> impactData = dao.getEmploymentImpactStats();

            // 🔥 NEW — REAL REGION IMPROVEMENT %
            Map<String, Double> regionImprovementPercent = dao.getRegionImprovementPercent();

            Map<String, Object> result = new HashMap<>();
            result.put("totalBeneficiaries", totalBeneficiaries);
            result.put("totalAid", totalAid);
            result.put("regionData", regionData);
            result.put("programData", programData);
            result.put("impactData", impactData);

            // 🔥 ADD THIS
            result.put("regionImprovementPercent", regionImprovementPercent);

            Gson gson = new Gson();
            out.print(gson.toJson(result));

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
            out.print("{\"error\":\"Analytics loading failed\"}");
        }
    }
}
