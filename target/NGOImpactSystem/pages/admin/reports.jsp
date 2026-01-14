<%@ page import="java.sql.*" %>
<%
    // Session check (security)
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("ADMIN")) {
        response.sendRedirect("../login.html");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Reports - NGO Impact System</title>
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
            width: 60%;
            border-collapse: collapse;
            background: white;
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
        .back {
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

<%
    Connection con = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/ngo_impact_db",
            "root",
            "password"
        );

        stmt = con.createStatement();

        // Total beneficiaries
        rs = stmt.executeQuery("SELECT COUNT(*) FROM beneficiaries");
        rs.next();
        int totalBeneficiaries = rs.getInt(1);

        // Total aided
        rs = stmt.executeQuery("SELECT COUNT(DISTINCT beneficiary_id) FROM aid_distribution");
        rs.next();
        int totalAided = rs.getInt(1);

        // Improved after aid
        rs = stmt.executeQuery(
            "SELECT COUNT(*) FROM post_aid_impact WHERE employed = 'Yes'"
        );
        rs.next();
        int improved = rs.getInt(1);

        double impactPercent = 0;
        if (totalAided > 0) {
            impactPercent = (improved * 100.0) / totalAided;
        }
%>

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
        <td><%= improved %></td>
    </tr>

    <tr>
        <td>Impact Percentage</td>
        <td><%= String.format("%.2f", impactPercent) %> %</td>
    </tr>

<%
    } catch (Exception e) {
        out.println("<tr><td colspan='2'>Error loading reports</td></tr>");
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (con != null) con.close();
    }
%>

</table>

<div class="back">
    <a href="admin_dashboard.html">⬅ Back to Dashboard</a>
</div>

</body>
</html>
