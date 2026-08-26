<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.ngo.util.DBConnection" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Approve Aid Requests - NGO Impact System</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Outfit:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --bg-gradient: linear-gradient(135deg, #0f172a 0%, #1e1b4b 100%);
            --primary: #4f46e5;
            --primary-hover: #4338ca;
            --accent: #10b981;
            --danger: #ef4444;
            --warning: #f59e0b;
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

        h2 {
            font-family: "Outfit", sans-serif;
            text-align: center;
            font-size: 26px;
            font-weight: 700;
            margin: 40px 0 20px 0;
            color: var(--text-main);
        }

        .summary {
            display: flex;
            gap: 20px;
            justify-content: center;
            margin-bottom: 40px;
            flex-wrap: wrap;
        }

        .box {
            background: var(--card-bg);
            backdrop-filter: blur(12px);
            border: 1px solid var(--card-border);
            padding: 20px 30px;
            border-radius: 14px;
            text-align: center;
            min-width: 220px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.15);
            transition: transform 0.3s;
        }

        .box:hover {
            transform: translateY(-3px);
        }

        .box h3 {
            margin: 0;
            font-family: "Outfit", sans-serif;
            font-size: 15px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: var(--text-muted);
        }

        .box p {
            margin: 10px 0 0 0;
            font-size: 32px;
            font-weight: 700;
        }

        .pending p { color: var(--warning); }
        .approved p { color: var(--accent); }
        .rejected p { color: var(--danger); }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 30px;
        }

        .section-card {
            background: var(--card-bg);
            backdrop-filter: blur(16px);
            border: 1px solid var(--card-border);
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.25);
            margin-bottom: 40px;
        }

        h3.section-title {
            font-family: "Outfit", sans-serif;
            font-size: 18px;
            font-weight: 600;
            margin-top: 0;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            overflow: hidden;
            border-radius: 12px;
            border: 1px solid var(--card-border);
            margin-bottom: 10px;
        }

        th {
            background: rgba(15, 23, 42, 0.9);
            color: var(--text-main);
            padding: 14px;
            font-family: "Outfit", sans-serif;
            font-size: 13px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            text-align: left;
            border-bottom: 1px solid var(--card-border);
        }

        td {
            padding: 14px;
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

        .btn {
            padding: 8px 16px;
            border: none;
            cursor: pointer;
            border-radius: 8px;
            font-weight: 600;
            font-size: 13px;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border: 1px solid rgba(255, 255, 255, 0.05);
        }

        .approve {
            background: rgba(16, 185, 129, 0.15);
            color: var(--accent);
            border-color: rgba(16, 185, 129, 0.3);
        }

        .approve:hover {
            background: var(--accent);
            color: #0f172a;
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
            transform: translateY(-1px);
        }

        .reject {
            background: rgba(239, 68, 68, 0.15);
            color: var(--danger);
            border-color: rgba(239, 68, 68, 0.3);
        }

        .reject:hover {
            background: var(--danger);
            color: white;
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
            transform: translateY(-1px);
        }

        .back {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-top: 10px;
            text-decoration: none;
            padding: 10px 20px;
            background: var(--primary);
            color: white;
            border-radius: 8px;
            font-weight: 500;
            font-size: 14px;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .back:hover {
            background: var(--primary-hover);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.4);
        }

        .beneficiary-name {
            color: var(--text-main);
            font-weight: 600;
        }

        .no-data {
            text-align: center;
            color: var(--text-muted);
            padding: 20px;
            font-style: italic;
        }
    </style>
</head>

<body>

<h2>✅ Review & Approval Center</h2>

<%
    String msg = request.getParameter("msg");
    if("updated".equals(msg)){
%>
    <div style="max-width: 1200px; margin: 0 auto 20px auto; padding: 14px 20px; background: rgba(16,185,129,0.15); border: 1px solid rgba(16,185,129,0.3); border-radius: 12px; color: #10b981; text-align: center; font-weight: 600;">
        ✅ Aid distribution request status updated successfully!
    </div>
<%
    } else if("beneficiary_updated".equals(msg)){
%>
    <div style="max-width: 1200px; margin: 0 auto 20px auto; padding: 14px 20px; background: rgba(16,185,129,0.15); border: 1px solid rgba(16,185,129,0.3); border-radius: 12px; color: #10b981; text-align: center; font-weight: 600;">
        👥 Beneficiary registration profile status updated successfully!
    </div>
<%
    }

    int pendingBeneficiaries = 0;
    int pendingCount = 0, approvedCount = 0, rejectedCount = 0;

    try(Connection con = DBConnection.getConnection()){
        // Count pending beneficiaries
        PreparedStatement bps = con.prepareStatement("SELECT COUNT(*) FROM beneficiaries WHERE status='PENDING'");
        ResultSet brs = bps.executeQuery();
        if(brs.next()) pendingBeneficiaries = brs.getInt(1);
        brs.close(); bps.close();

        // Count aid requests
        String countSql = "SELECT status, COUNT(*) as total FROM aid_requests GROUP BY status";
        PreparedStatement cps = con.prepareStatement(countSql);
        ResultSet crs = cps.executeQuery();

        while(crs.next()){
            String st = crs.getString("status");
            int total = crs.getInt("total");

            if("PENDING".equalsIgnoreCase(st)) pendingCount = total;
            if("APPROVED".equalsIgnoreCase(st)) approvedCount = total;
            if("REJECTED".equalsIgnoreCase(st)) rejectedCount = total;
        }
        crs.close(); cps.close();
    }catch(Exception e){
        e.printStackTrace();
    }
%>

<div class="summary">
    <div class="box pending">
        <h3>👥 Pending Beneficiaries</h3>
        <p><%= pendingBeneficiaries %></p>
    </div>
    <div class="box pending">
        <h3>💸 Pending Aid Requests</h3>
        <p><%= pendingCount %></p>
    </div>
    <div class="box approved">
        <h3>✅ Approved Aid</h3>
        <p><%= approvedCount %></p>
    </div>
    <div class="box rejected">
        <h3>❌ Rejected Aid</h3>
        <p><%= rejectedCount %></p>
    </div>
</div>

<div class="container">

    <!-- 1. PENDING BENEFICIARIES APPROVAL -->
    <div class="section-card">
        <h3 class="section-title" style="color: #38bdf8;">👥 Pending Beneficiary Registrations</h3>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Region</th>
                    <th>Program</th>
                    <th>Income Before</th>
                    <th>Email</th>
                    <th style="width: 200px;">Action</th>
                </tr>
            </thead>
            <tbody>
            <%
                try(Connection con = DBConnection.getConnection()){
                    String bsql = "SELECT b.beneficiary_id, b.name, r.region_name, p.program_name, b.income_before, b.email " +
                                  "FROM beneficiaries b " +
                                  "LEFT JOIN regions r ON b.region_id = r.region_id " +
                                  "LEFT JOIN programs p ON b.program_id = p.program_id " +
                                  "WHERE b.status='PENDING' ORDER BY b.beneficiary_id DESC";
                    PreparedStatement bps = con.prepareStatement(bsql);
                    ResultSet brs = bps.executeQuery();
                    boolean hasPendingB = false;

                    while(brs.next()){
                        hasPendingB = true;
            %>
            <tr>
                <td><%= brs.getInt("beneficiary_id") %></td>
                <td class="beneficiary-name"><%= brs.getString("name") %></td>
                <td><%= brs.getString("region_name") != null ? brs.getString("region_name") : "N/A" %></td>
                <td><%= brs.getString("program_name") != null ? brs.getString("program_name") : "N/A" %></td>
                <td>₹<%= String.format("%.2f", brs.getDouble("income_before")) %></td>
                <td style="color: #6366f1;"><%= brs.getString("email") %></td>
                <td>
                    <form action="../../ApproveBeneficiaryServlet" method="post" style="display:inline;">
                        <input type="hidden" name="beneficiary_id" value="<%= brs.getInt("beneficiary_id") %>">
                        <input type="hidden" name="action" value="APPROVE">
                        <button class="btn approve">Approve</button>
                    </form>

                    <form action="../../ApproveBeneficiaryServlet" method="post" style="display:inline; margin-left: 5px;">
                        <input type="hidden" name="beneficiary_id" value="<%= brs.getInt("beneficiary_id") %>">
                        <input type="hidden" name="action" value="REJECT">
                        <button class="btn reject">Reject</button>
                    </form>
                </td>
            </tr>
            <%
                    }
                    if(!hasPendingB){
            %>
                <tr><td colspan="7" class="no-data">No pending beneficiary registrations.</td></tr>
            <%
                    }
                }catch(Exception e){
            %>
                <tr><td colspan="7" class="no-data" style="color: var(--danger);">Error loading beneficiaries: <%= e.getMessage() %></td></tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>

    <!-- 2. PENDING AID REQUESTS -->
    <div class="section-card">
        <h3 class="section-title" style="color: var(--warning);">💸 Pending Aid Distribution Requests</h3>
        <table>
            <thead>
                <tr>
                    <th>Request ID</th>
                    <th>Beneficiary ID</th>
                    <th>Beneficiary Name</th>
                    <th>Aid Type</th>
                    <th>Amount</th>
                    <th>Date</th>
                    <th>Requested By</th>
                    <th style="width: 200px;">Action</th>
                </tr>
            </thead>
            <tbody>
            <%
                try(Connection con = DBConnection.getConnection()){
                    String sql = "SELECT ar.request_id, ar.beneficiary_id, b.name AS beneficiary_name, ar.aid_type, ar.amount, ar.request_date, ar.requested_by " +
                                 "FROM aid_requests ar " +
                                 "LEFT JOIN beneficiaries b ON ar.beneficiary_id = b.beneficiary_id " +
                                 "WHERE ar.status='PENDING' ORDER BY ar.request_id DESC";
                    PreparedStatement ps = con.prepareStatement(sql);
                    ResultSet rs = ps.executeQuery();
                    boolean hasPending = false;

                    while(rs.next()){
                        hasPending = true;
                        String name = rs.getString("beneficiary_name");
                        if (name == null) name = "N/A";
            %>
            <tr>
                <td><%= rs.getInt("request_id") %></td>
                <td><%= rs.getInt("beneficiary_id") %></td>
                <td class="beneficiary-name"><%= name %></td>
                <td><%= rs.getString("aid_type") %></td>
                <td>₹<%= String.format("%.2f", rs.getDouble("amount")) %></td>
                <td><%= rs.getString("request_date") %></td>
                <td><%= rs.getString("requested_by") %></td>
                <td>
                    <form action="../../ApproveAidServlet" method="post" style="display:inline;">
                        <input type="hidden" name="request_id" value="<%= rs.getInt("request_id") %>">
                        <input type="hidden" name="action" value="APPROVE">
                        <button class="btn approve">Approve</button>
                    </form>

                    <form action="../../ApproveAidServlet" method="post" style="display:inline; margin-left: 5px;">
                        <input type="hidden" name="request_id" value="<%= rs.getInt("request_id") %>">
                        <input type="hidden" name="action" value="REJECT">
                        <button class="btn reject">Reject</button>
                    </form>
                </td>
            </tr>
            <%
                    }
                    if(!hasPending){
            %>
                <tr><td colspan="8" class="no-data">No pending aid requests.</td></tr>
            <%
                    }
                }catch(Exception e){
            %>
                <tr><td colspan="8" class="no-data" style="color: var(--danger);">Error loading data: <%= e.getMessage() %></td></tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>

    <!-- 2. APPROVED HISTORY -->
    <div class="section-card">
        <h3 class="section-title" style="color: var(--accent);">✅ Approved Requests History</h3>
        <table>
            <thead>
                <tr>
                    <th>Request ID</th>
                    <th>Beneficiary ID</th>
                    <th>Beneficiary Name</th>
                    <th>Aid Type</th>
                    <th>Amount</th>
                    <th>Date</th>
                    <th>Requested By</th>
                </tr>
            </thead>
            <tbody>
            <%
                try(Connection con = DBConnection.getConnection()){
                    String sql = "SELECT ar.request_id, ar.beneficiary_id, b.name AS beneficiary_name, ar.aid_type, ar.amount, ar.request_date, ar.requested_by " +
                                 "FROM aid_requests ar " +
                                 "LEFT JOIN beneficiaries b ON ar.beneficiary_id = b.beneficiary_id " +
                                 "WHERE ar.status='APPROVED' ORDER BY ar.request_id DESC";
                    PreparedStatement ps = con.prepareStatement(sql);
                    ResultSet rs = ps.executeQuery();
                    boolean hasApproved = false;

                    while(rs.next()){
                        hasApproved = true;
                        String name = rs.getString("beneficiary_name");
                        if (name == null) name = "N/A";
            %>
            <tr>
                <td><%= rs.getInt("request_id") %></td>
                <td><%= rs.getInt("beneficiary_id") %></td>
                <td class="beneficiary-name"><%= name %></td>
                <td><%= rs.getString("aid_type") %></td>
                <td>₹<%= String.format("%.2f", rs.getDouble("amount")) %></td>
                <td><%= rs.getString("request_date") %></td>
                <td><%= rs.getString("requested_by") %></td>
            </tr>
            <%
                    }
                    if(!hasApproved){
            %>
                <tr><td colspan="7" class="no-data">No approved aid history.</td></tr>
            <%
                    }
                }catch(Exception e){
            %>
                <tr><td colspan="7" class="no-data" style="color: var(--danger);">Error loading data: <%= e.getMessage() %></td></tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>

    <!-- 3. REJECTED HISTORY -->
    <div class="section-card">
        <h3 class="section-title" style="color: var(--danger);">❌ Rejected Requests History</h3>
        <table>
            <thead>
                <tr>
                    <th>Request ID</th>
                    <th>Beneficiary ID</th>
                    <th>Beneficiary Name</th>
                    <th>Aid Type</th>
                    <th>Amount</th>
                    <th>Date</th>
                    <th>Requested By</th>
                </tr>
            </thead>
            <tbody>
            <%
                try(Connection con = DBConnection.getConnection()){
                    String sql = "SELECT ar.request_id, ar.beneficiary_id, b.name AS beneficiary_name, ar.aid_type, ar.amount, ar.request_date, ar.requested_by " +
                                 "FROM aid_requests ar " +
                                 "LEFT JOIN beneficiaries b ON ar.beneficiary_id = b.beneficiary_id " +
                                 "WHERE ar.status='REJECTED' ORDER BY ar.request_id DESC";
                    PreparedStatement ps = con.prepareStatement(sql);
                    ResultSet rs = ps.executeQuery();
                    boolean hasRejected = false;

                    while(rs.next()){
                        hasRejected = true;
                        String name = rs.getString("beneficiary_name");
                        if (name == null) name = "N/A";
            %>
            <tr>
                <td><%= rs.getInt("request_id") %></td>
                <td><%= rs.getInt("beneficiary_id") %></td>
                <td class="beneficiary-name"><%= name %></td>
                <td><%= rs.getString("aid_type") %></td>
                <td>₹<%= String.format("%.2f", rs.getDouble("amount")) %></td>
                <td><%= rs.getString("request_date") %></td>
                <td><%= rs.getString("requested_by") %></td>
            </tr>
            <%
                    }
                    if(!hasRejected){
            %>
                <tr><td colspan="7" class="no-data">No rejected aid history.</td></tr>
            <%
                    }
                }catch(Exception e){
            %>
                <tr><td colspan="7" class="no-data" style="color: var(--danger);">Error loading data: <%= e.getMessage() %></td></tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>

    <a class="back" href="manager_dashboard.html">
        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M15.75 19.5L8.25 12l7.5-7.5"/></svg>
        Back to Dashboard
    </a>

</div>

</body>
</html>
