<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>

<%
    // ✅ Session check (Admin only)
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("ADMIN")) {
        response.sendRedirect("../../login.html");   // ✅ correct path
        return;
    }

    int totalBeneficiaries = 0;
    int totalAided = 0;
    int improvedCount = 0;
    double impactPercent = 0.0;

    Connection con = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        // ✅ Use DBConnection utility class
        con = DBConnection.getConnection();
        stmt = con.createStatement();

        // ✅ Total beneficiaries
        rs = stmt.executeQuery("SELECT COUNT(*) FROM beneficiaries");
        if (rs.next()) totalBeneficiaries = rs.getInt(1);

        // ✅ Total aided beneficiaries (distinct)
        rs = stmt.executeQuery("SELECT COUNT(DISTINCT beneficiary_id) FROM aid_distribution");
        if (rs.next()) totalAided = rs.getInt(1);

        // ✅ Improved: employed YES and struggling NO
        rs = stmt.executeQuery("SELECT COUNT(*) FROM post_aid_impact WHERE employed='YES' AND struggling='NO'");
        if (rs.next()) improvedCount = rs.getInt(1);

        // ✅ Impact %
        if (totalAided > 0) {
            impactPercent = (improvedCount * 100.0) / totalAided;
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch(Exception ex) {}
        try { if (stmt != null) stmt.close(); } catch(Exception ex) {}
        try { if (con != null) con.close(); } catch(Exception ex) {}
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reports - NGO Impact System</title>

    <!-- ✅ Prevent back after logout -->
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />

    <!-- ✅ Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f8;
            padding: 20px;
        }
        h2 {
            color: #2c3e50;
        }
        table {
            width: 70%;
            border-collapse: collapse;
            background: white;
            margin-bottom: 25px;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ccc;
            text-align: center;
        }
        th {
            background-color: #3498db;
            color: white;
        }
        .card {
            width: 70%;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.15);
        }
        a {
            text-decoration: none;
            color: #3498db;
            font-weight: bold;
        }
        .btn-back {
            display: inline-block;
            margin-top: 20px;
        }
    </style>
</head>

<body>

<h2>📊 NGO Impact Reports</h2>

<table>
    <tr>
        <th>Metric</th>
        <th>Value</th>
    </tr>

    <tr>
        <td>Total Beneficiaries</td>
        <td><%= totalBeneficiaries %></td>
    </tr>

    <tr>
        <td>Total Beneficiaries Aided</td>
        <td><%= totalAided %></td>
    </tr>

    <tr>
        <td>Improved After Aid</td>
        <td><%= improvedCount %></td>
    </tr>

    <tr>
        <td>Impact Percentage</td>
        <td><%= String.format("%.2f", impactPercent) %> %</td>
    </tr>
</table>

<div class="card">
    <h3>📈 Impact Visualization</h3>
    <canvas id="impactChart"></canvas>
</div>

<script>
    // ✅ FIX: No "Expression expected" errors in VS Code
    const improvedJS = Number("<%= improvedCount %>");
    const aidedJS = Number("<%= totalAided %>");
    const notImprovedJS = aidedJS - improvedJS;

    new Chart(document.getElementById("impactChart"), {
        type: "pie",
        data: {
            labels: ["Improved", "Not Improved"],
            datasets: [{
                data: [improvedJS, notImprovedJS]
            }]
        }
    });
</script>

<div class="btn-back">
    <a href="admin_dashboard.html">⬅ Back to Dashboard</a>
</div>

</body>
</html>
