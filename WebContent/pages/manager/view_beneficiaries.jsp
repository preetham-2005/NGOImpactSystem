<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.ngo.util.DBConnection" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Beneficiaries List - NGO Impact System</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Outfit:wght@400;500;600;700&display=swap" rel="stylesheet">

<style>
    :root {
        --bg-gradient: linear-gradient(135deg, #0f172a 0%, #1e1b4b 100%);
        --primary: #4f46e5;
        --primary-hover: #4338ca;
        --accent: #10b981;
        --text-main: #f8fafc;
        --text-muted: #94a3b8;
        --card-bg: rgba(30, 41, 59, 0.7);
        --card-border: rgba(255, 255, 255, 0.08);
    }

    * { box-sizing: border-box; }

    body {
        font-family: "Inter", sans-serif;
        margin: 0;
        background: var(--bg-gradient);
        color: var(--text-main);
        min-height: 100vh;
        padding-bottom: 50px;
    }

    /* Header */
    .header {
        background: rgba(15, 23, 42, 0.8);
        backdrop-filter: blur(12px);
        border-bottom: 1px solid var(--card-border);
        padding: 20px 40px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        position: sticky;
        top: 0;
        z-index: 100;
    }

    .header h2 {
        margin: 0;
        font-family: "Outfit", sans-serif;
        font-size: 24px;
        font-weight: 600;
        letter-spacing: -0.5px;
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .header a {
        text-decoration: none;
        background: var(--primary);
        padding: 10px 20px;
        border-radius: 8px;
        color: white;
        font-weight: 500;
        font-size: 14px;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        border: 1px solid rgba(255,255,255,0.1);
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .header a:hover {
        background: var(--primary-hover);
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(79, 70, 229, 0.4);
    }

    /* Container */
    .container {
        padding: 40px;
        max-width: 1200px;
        margin: auto;
    }

    /* Card */
    .card {
        background: var(--card-bg);
        backdrop-filter: blur(16px);
        border: 1px solid var(--card-border);
        padding: 30px;
        border-radius: 16px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.25);
    }

    /* Search bar */
    .search-box {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 25px;
        flex-wrap: wrap;
        gap: 15px;
    }

    .search-box input {
        padding: 12px 20px;
        width: 320px;
        border-radius: 10px;
        border: 1px solid rgba(255, 255, 255, 0.1);
        background: rgba(15, 23, 42, 0.6);
        color: white;
        outline: none;
        font-size: 14px;
        transition: all 0.3s;
    }

    .search-box input:focus {
        border-color: var(--primary);
        box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.25);
    }

    .count-badge {
        background: var(--accent);
        color: #0f172a;
        padding: 8px 18px;
        border-radius: 20px;
        font-size: 14px;
        font-weight: 600;
        box-shadow: 0 4px 10px rgba(16, 185, 129, 0.3);
    }

    /* Table */
    table {
        width: 100%;
        border-collapse: collapse;
        overflow: hidden;
        border-radius: 12px;
        border: 1px solid var(--card-border);
    }

    th {
        background: rgba(15, 23, 42, 0.9);
        color: var(--text-main);
        padding: 16px;
        font-family: "Outfit", sans-serif;
        font-size: 14px;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        text-align: left;
        border-bottom: 1px solid var(--card-border);
    }

    td {
        padding: 16px;
        font-size: 14px;
        color: var(--text-muted);
        border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        background: rgba(30, 41, 59, 0.4);
    }

    tr:hover td {
        background: rgba(30, 41, 59, 0.8);
        color: white;
        transition: background-color 0.2s ease;
    }

    .email {
        font-weight: 500;
        color: var(--primary);
    }

    .beneficiary-name {
        color: var(--text-main);
        font-weight: 600;
    }

    /* Responsive */
    @media(max-width: 768px) {
        .header { padding: 20px; }
        .container { padding: 20px; }
        th, td {
            font-size: 12px;
            padding: 12px;
        }
        .search-box input {
            width: 100%;
        }
    }
</style>

<script>
    function searchBeneficiary() {
        let input = document.getElementById("searchInput").value.toLowerCase();
        let rows = document.querySelectorAll("#beneficiaryTable tbody tr");
        rows.forEach(row => {
            let text = row.innerText.toLowerCase();
            row.style.display = text.includes(input) ? "" : "none";
        });
    }
</script>

</head>
<body>

<!-- Header -->
<div class="header">
    <h2>👥 Beneficiaries List</h2>
    <a href="manager_dashboard.html">
        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M15.75 19.5L8.25 12l7.5-7.5"/></svg>
        Back to Dashboard
    </a>
</div>

<div class="container">
    <div class="card">

        <div class="search-box">
            <input type="text" id="searchInput" placeholder="🔍 Search by name, email..." onkeyup="searchBeneficiary()"/>
            <div class="count-badge">
                Total Beneficiaries: 
                <%
                    int count = 0;
                    try(Connection con = DBConnection.getConnection()){
                        Statement st = con.createStatement();
                        ResultSet rsCount = st.executeQuery("SELECT COUNT(*) FROM beneficiaries");
                        if(rsCount.next()) count = rsCount.getInt(1);
                    } catch(Exception e){ e.printStackTrace(); }
                    out.print(count);
                %>
            </div>
        </div>

        <table id="beneficiaryTable">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Region</th>
                    <th>Program</th>
                    <th>Income Before</th>
                    <th>Email</th>
                </tr>
            </thead>

            <tbody>
            <%
                try (Connection con = DBConnection.getConnection()) {
                    String sql = "SELECT b.beneficiary_id, b.name, r.region_name, p.program_name, b.income_before, b.email " +
                                 "FROM beneficiaries b " +
                                 "LEFT JOIN regions r ON b.region_id = r.region_id " +
                                 "LEFT JOIN programs p ON b.program_id = p.program_id " +
                                 "ORDER BY b.beneficiary_id ASC";
                    PreparedStatement ps = con.prepareStatement(sql);
                    ResultSet rs = ps.executeQuery();

                    while (rs.next()) {
            %>
                <tr>
                    <td><%= rs.getInt("beneficiary_id") %></td>
                    <td class="beneficiary-name"><%= rs.getString("name") %></td>
                    <td><%= rs.getString("region_name") != null ? rs.getString("region_name") : "N/A" %></td>
                    <td><%= rs.getString("program_name") != null ? rs.getString("program_name") : "N/A" %></td>
                    <td>₹<%= String.format("%.2f", rs.getDouble("income_before")) %></td>
                    <td class="email"><%= rs.getString("email") %></td>
                </tr>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
            %>
                <tr>
                    <td colspan="6" style="text-align: center; color: #ef4444;">❌ Error retrieving data: <%= e.getMessage() %></td>
                </tr>
            <%
                }
            %>
            </tbody>
        </table>

    </div>
</div>

</body>
</html>
