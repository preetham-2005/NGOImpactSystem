<%@ page import="java.sql.*" %>
<%@ page import="com.ngo.util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Post Aid Impact Reports - NGO Impact System</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Outfit:wght@400;500;600;700&display=swap" rel="stylesheet">

<style>
    :root {
        --bg-gradient: linear-gradient(135deg, #0f172a 0%, #1e1b4b 100%);
        --primary: #4f46e5;
        --primary-hover: #4338ca;
        --accent: #10b981;
        --danger: #ef4444;
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
    header {
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
        font-family: "Outfit", sans-serif;
        font-size: 24px;
        font-weight: 600;
        letter-spacing: -0.5px;
    }

    .container {
        padding: 40px;
        max-width: 1100px;
        margin: auto;
    }

    .card {
        background: var(--card-bg);
        backdrop-filter: blur(16px);
        border: 1px solid var(--card-border);
        padding: 30px;
        border-radius: 16px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.25);
    }

    h2 {
        font-family: "Outfit", sans-serif;
        font-size: 22px;
        font-weight: 600;
        color: var(--text-main);
        margin: 0 0 25px 0;
        text-align: left;
    }

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

    .badge {
        padding: 6px 14px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 600;
        display: inline-block;
        text-align: center;
        letter-spacing: 0.5px;
    }

    .yes {
        background: rgba(16, 185, 129, 0.15);
        color: var(--accent);
        border: 1px solid rgba(16, 185, 129, 0.3);
    }

    .no {
        background: rgba(239, 68, 68, 0.15);
        color: var(--danger);
        border: 1px solid rgba(239, 68, 68, 0.3);
    }

    .btn {
        margin-top: 25px;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        background: var(--primary);
        color: white;
        padding: 10px 20px;
        border-radius: 8px;
        text-decoration: none;
        font-weight: 500;
        font-size: 14px;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        border: 1px solid rgba(255, 255, 255, 0.1);
    }

    .btn:hover {
        background: var(--primary-hover);
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(79, 70, 229, 0.4);
    }

    .empty-msg {
        text-align: center;
        padding: 30px;
        color: var(--text-muted);
        font-weight: 500;
        font-size: 15px;
        background: rgba(30, 41, 59, 0.2) !important;
    }

    .beneficiary-name {
        color: var(--text-main);
        font-weight: 600;
    }
</style>
</head>

<body>

<header>📌 Post Aid Impact Reports</header>

<div class="container">
    <div class="card">
        <h2>Impact Reports List</h2>

        <table>
            <thead>
                <tr>
                    <th>Impact ID</th>
                    <th>Beneficiary ID</th>
                    <th>Beneficiary Name</th>
                    <th>Income After</th>
                    <th>Employed</th>
                    <th>Struggling</th>
                </tr>
            </thead>

            <tbody>
            <%
                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                try {
                    con = DBConnection.getConnection();

                    String sql = "SELECT p.impact_id, p.beneficiary_id, b.name AS beneficiary_name, p.income_after, p.employed, p.struggling " +
                                 "FROM post_aid_impact p " +
                                 "LEFT JOIN beneficiaries b ON p.beneficiary_id = b.beneficiary_id " +
                                 "ORDER BY p.impact_id DESC";

                    ps = con.prepareStatement(sql);
                    rs = ps.executeQuery();

                    boolean found = false;

                    while(rs.next()){
                        found = true;

                        String employed = rs.getString("employed");
                        String struggling = rs.getString("struggling");
                        String name = rs.getString("beneficiary_name");
                        if(name == null) name = "N/A";
            %>
                        <tr>
                            <td><%= rs.getInt("impact_id") %></td>
                            <td><%= rs.getInt("beneficiary_id") %></td>
                            <td class="beneficiary-name"><%= name %></td>
                            <td>₹<%= String.format("%.2f", rs.getDouble("income_after")) %></td>

                            <td>
                                <span class="badge <%= "YES".equalsIgnoreCase(employed) ? "yes" : "no" %>">
                                    <%= employed %>
                                </span>
                            </td>

                            <td>
                                <span class="badge <%= "YES".equalsIgnoreCase(struggling) ? "no" : "yes" %>">
                                    <%= struggling %>
                                </span>
                            </td>
                        </tr>
            <%
                    }

                    if(!found){
            %>
                        <tr>
                            <td colspan="6" class="empty-msg">⚠ No Post-Aid Impact Records Found</td>
                        </tr>
            <%
                    }

                } catch(Exception e){
            %>
                    <tr>
                        <td colspan="6" class="empty-msg" style="color: var(--danger);">❌ Error: <%= e.getMessage() %></td>
                    </tr>
            <%
                    e.printStackTrace();
                } finally {
                    try { if(rs!=null) rs.close(); } catch(Exception e){}
                    try { if(ps!=null) ps.close(); } catch(Exception e){}
                    try { if(con!=null) con.close(); } catch(Exception e){}
                }
            %>
            </tbody>
        </table>

        <a class="btn" href="manager_dashboard.html">
            <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M15.75 19.5L8.25 12l7.5-7.5"/></svg>
            Back to Dashboard
        </a>
    </div>
</div>

</body>
</html>
