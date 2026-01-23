<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.ngo.util.DBConnection" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Beneficiaries List</title>

<style>
    body {
        font-family: "Segoe UI", Arial, sans-serif;
        margin: 0;
        background: #f4f6f8;
        color: #2c3e50;
    }

    /* Header */
    .header {
        background: linear-gradient(90deg, #2c3e50, #1a5276);
        color: white;
        padding: 18px 25px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        box-shadow: 0px 4px 8px rgba(0,0,0,0.15);
    }

    .header h2 {
        margin: 0;
        font-size: 22px;
        letter-spacing: 0.5px;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .header a {
        text-decoration: none;
        background: #3498db;
        padding: 10px 15px;
        border-radius: 8px;
        color: white;
        font-weight: 600;
        transition: 0.2s;
    }

    .header a:hover {
        background: #2471a3;
    }

    /* Container */
    .container {
        padding: 25px;
        max-width: 1200px;
        margin: auto;
    }

    /* Card */
    .card {
        background: white;
        padding: 20px;
        border-radius: 12px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    }

    /* Search bar */
    .search-box {
        display: flex;
        justify-content: space-between;
        margin-bottom: 15px;
        flex-wrap: wrap;
        gap: 10px;
    }

    .search-box input {
        padding: 10px;
        width: 280px;
        border-radius: 8px;
        border: 1px solid #ccc;
        outline: none;
        font-size: 14px;
    }

    .count-badge {
        background: #27ae60;
        color: white;
        padding: 8px 14px;
        border-radius: 20px;
        font-size: 14px;
        font-weight: 600;
        height: fit-content;
    }

    /* Table */
    table {
        width: 100%;
        border-collapse: collapse;
        overflow: hidden;
        border-radius: 10px;
    }

    th {
        background: #2c3e50;
        color: white;
        padding: 12px;
        font-size: 14px;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    td {
        padding: 12px;
        font-size: 14px;
        border-bottom: 1px solid #e5e5e5;
        text-align: center;
    }

    tr:nth-child(even) {
        background: #f9fbfc;
    }

    tr:hover {
        background: #eaf2f8;
        transition: 0.2s;
    }

    .email {
        font-weight: 600;
        color: #3498db;
    }

    /* Responsive */
    @media(max-width: 768px) {
        th, td {
            font-size: 12px;
            padding: 8px;
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
    <a href="manager_dashboard.html">⬅ Back</a>
</div>

<div class="container">
    <div class="card">

        <div class="search-box">
            <input type="text" id="searchInput" placeholder="🔍 Search by name, email..." onkeyup="searchBeneficiary()"/>
            <div class="count-badge">
                ✅ Total Beneficiaries: 
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
                    String sql = "SELECT beneficiary_id, name, region_id, program_id, income_before, email FROM beneficiaries";
                    PreparedStatement ps = con.prepareStatement(sql);
                    ResultSet rs = ps.executeQuery();

                    while (rs.next()) {
            %>
                <tr>
                    <td><%= rs.getInt("beneficiary_id") %></td>
                    <td><%= rs.getString("name") %></td>
                    <td><%= rs.getInt("region_id") %></td>
                    <td><%= rs.getInt("program_id") %></td>
                    <td>₹ <%= rs.getDouble("income_before") %></td>
                    <td class="email"><%= rs.getString("email") %></td>
                </tr>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            %>
            </tbody>
        </table>

    </div>
</div>

</body>
</html>
