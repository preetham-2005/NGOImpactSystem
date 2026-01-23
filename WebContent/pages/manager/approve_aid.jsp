<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.ngo.util.DBConnection" %>

<html>
<head>
    <title>Approve Aid Requests</title>

    <style>
        body{font-family:Arial;background:#f5f5f5;padding:20px;}
        h2{text-align:center;margin-bottom:20px;}

        .summary{
            display:flex;
            gap:15px;
            justify-content: center;
            margin-bottom: 25px;
            flex-wrap: wrap;
        }

        .box{
            background:white;
            padding:15px 22px;
            border-radius:10px;
            box-shadow:0 2px 8px rgba(0,0,0,0.1);
            text-align:center;
            min-width:200px;
        }

        .box h3{margin:0;font-size:16px;color:#333;}
        .box p{margin:10px 0 0 0;font-size:24px;font-weight:bold;}

        .pending p{color:#e67e22;}
        .approved p{color:#27ae60;}
        .rejected p{color:#e74c3c;}

        table{width:100%;border-collapse:collapse;margin-top:15px;background:white;}
        th,td{border:1px solid #ccc;padding:10px;text-align:center;}
        th{background:#2c3e50;color:white;}

        .btn{
            padding:7px 12px;
            border:none;
            cursor:pointer;
            border-radius:6px;
            font-weight:bold;
        }
        .approve{background:#27ae60;color:white;}
        .reject{background:#e74c3c;color:white;}

        .back{
            display:inline-block;
            margin-top:20px;
            text-decoration:none;
            padding:10px 15px;
            background:#3498db;
            color:white;
            border-radius:7px;
        }
    </style>
</head>

<body>

<h2>✅ Approve / Reject Aid Requests</h2>

<%
    int pendingCount = 0, approvedCount = 0, rejectedCount = 0;

    try(Connection con = DBConnection.getConnection()){
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
    }catch(Exception e){
        e.printStackTrace();
    }
%>

<!-- ✅ COUNTS TOP -->
<div class="summary">
    <div class="box pending">
        <h3>⏳ Pending</h3>
        <p><%= pendingCount %></p>
    </div>
    <div class="box approved">
        <h3>✅ Approved</h3>
        <p><%= approvedCount %></p>
    </div>
    <div class="box rejected">
        <h3>❌ Rejected</h3>
        <p><%= rejectedCount %></p>
    </div>
</div>

<!-- ✅ PENDING TABLE -->
<h3>⏳ Pending Requests</h3>
<table>
<tr>
    <th>Request ID</th>
    <th>Beneficiary ID</th>
    <th>Aid Type</th>
    <th>Amount</th>
    <th>Date</th>
    <th>Requested By</th>
    <th>Action</th>
</tr>

<%
    try(Connection con = DBConnection.getConnection()){

        String sql = "SELECT * FROM aid_requests WHERE status='PENDING' ORDER BY request_id DESC";
        PreparedStatement ps = con.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while(rs.next()){
%>
<tr>
    <td><%= rs.getInt("request_id") %></td>
    <td><%= rs.getInt("beneficiary_id") %></td>
    <td><%= rs.getString("aid_type") %></td>
    <td><%= rs.getDouble("amount") %></td>
    <td><%= rs.getString("request_date") %></td>
    <td><%= rs.getString("requested_by") %></td>

    <td>
        <form action="../../ApproveAidServlet" method="post" style="display:inline;">
            <input type="hidden" name="request_id" value="<%= rs.getInt("request_id") %>">
            <input type="hidden" name="action" value="APPROVE">
            <button class="btn approve">Approve</button>
        </form>

        <form action="../../ApproveAidServlet" method="post" style="display:inline;">
            <input type="hidden" name="request_id" value="<%= rs.getInt("request_id") %>">
            <input type="hidden" name="action" value="REJECT">
            <button class="btn reject">Reject</button>
        </form>
    </td>
</tr>
<%
        }
    }catch(Exception e){
        e.printStackTrace();
    }
%>
</table>

<!-- ✅ APPROVED TABLE -->
<h3 style="margin-top:35px;">✅ Approved Requests History</h3>
<table>
<tr>
    <th>Request ID</th>
    <th>Beneficiary ID</th>
    <th>Aid Type</th>
    <th>Amount</th>
    <th>Date</th>
    <th>Requested By</th>
</tr>

<%
    try(Connection con = DBConnection.getConnection()){

        String sql = "SELECT * FROM aid_requests WHERE status='APPROVED' ORDER BY request_id DESC";
        PreparedStatement ps = con.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while(rs.next()){
%>
<tr>
    <td><%= rs.getInt("request_id") %></td>
    <td><%= rs.getInt("beneficiary_id") %></td>
    <td><%= rs.getString("aid_type") %></td>
    <td><%= rs.getDouble("amount") %></td>
    <td><%= rs.getString("request_date") %></td>
    <td><%= rs.getString("requested_by") %></td>
</tr>
<%
        }
    }catch(Exception e){
        e.printStackTrace();
    }
%>
</table>

<!-- ✅ REJECTED TABLE -->
<h3 style="margin-top:35px;">❌ Rejected Requests History</h3>
<table>
<tr>
    <th>Request ID</th>
    <th>Beneficiary ID</th>
    <th>Aid Type</th>
    <th>Amount</th>
    <th>Date</th>
    <th>Requested By</th>
</tr>

<%
    try(Connection con = DBConnection.getConnection()){

        String sql = "SELECT * FROM aid_requests WHERE status='REJECTED' ORDER BY request_id DESC";
        PreparedStatement ps = con.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while(rs.next()){
%>
<tr>
    <td><%= rs.getInt("request_id") %></td>
    <td><%= rs.getInt("beneficiary_id") %></td>
    <td><%= rs.getString("aid_type") %></td>
    <td><%= rs.getDouble("amount") %></td>
    <td><%= rs.getString("request_date") %></td>
    <td><%= rs.getString("requested_by") %></td>
</tr>
<%
        }
    }catch(Exception e){
        e.printStackTrace();
    }
%>
</table>

<a class="back" href="manager_dashboard.html">⬅ Back</a>

</body>
</html>
