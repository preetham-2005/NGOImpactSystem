<%@ page import="java.sql.*" %>
<%@ page import="com.ngo.util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Post Aid Impact Reports</title>

<style>
    body{
        font-family: Arial, sans-serif;
        background: #f4f6f8;
        margin:0;
        padding:0;
    }

    header{
        background:#2c3e50;
        color:white;
        padding:18px;
        text-align:center;
        font-size:24px;
        font-weight:bold;
    }

    .container{
        padding:25px;
        max-width:1100px;
        margin:auto;
    }

    .card{
        background:white;
        padding:20px;
        border-radius:12px;
        box-shadow:0 2px 10px rgba(0,0,0,0.12);
    }

    h2{
        text-align:center;
        margin:0 0 20px;
        color:#2c3e50;
    }

    table{
        width:100%;
        border-collapse:collapse;
        margin-top:15px;
    }

    th{
        background:#2c3e50;
        color:white;
        padding:12px;
        font-size:15px;
        text-align:center;
    }

    td{
        padding:10px;
        border:1px solid #ddd;
        text-align:center;
        font-size:14px;
        background:#fff;
    }

    tr:nth-child(even) td{
        background:#f9f9f9;
    }

    .badge{
        padding:5px 10px;
        border-radius:18px;
        font-size:12px;
        font-weight:bold;
        display:inline-block;
    }

    .yes{ background:#27ae60; color:white; }
    .no{ background:#e74c3c; color:white; }

    .btn{
        margin-top:18px;
        display:inline-block;
        background:#3498db;
        color:white;
        padding:10px 16px;
        border-radius:8px;
        text-decoration:none;
        font-weight:bold;
    }

    .btn:hover{
        background:#2980b9;
    }

    .empty-msg{
        text-align:center;
        padding:15px;
        color:#555;
        font-weight:bold;
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

                    String sql = "SELECT impact_id, beneficiary_id, income_after, employed, struggling " +
                                 "FROM post_aid_impact ORDER BY impact_id DESC";

                    ps = con.prepareStatement(sql);
                    rs = ps.executeQuery();

                    boolean found = false;

                    while(rs.next()){
                        found = true;

                        String employed = rs.getString("employed");
                        String struggling = rs.getString("struggling");
            %>
                        <tr>
                            <td><%= rs.getInt("impact_id") %></td>
                            <td><%= rs.getInt("beneficiary_id") %></td>
                            <td>₹ <%= rs.getDouble("income_after") %></td>

                            <td>
                                <span class="badge <%= employed.equalsIgnoreCase("YES") ? "yes" : "no" %>">
                                    <%= employed %>
                                </span>
                            </td>

                            <td>
                                <span class="badge <%= struggling.equalsIgnoreCase("YES") ? "no" : "yes" %>">
                                    <%= struggling %>
                                </span>
                            </td>
                        </tr>
            <%
                    }

                    if(!found){
            %>
                        <tr>
                            <td colspan="5" class="empty-msg">⚠ No Post-Aid Impact Records Found</td>
                        </tr>
            <%
                    }

                } catch(Exception e){
                    out.println("<tr><td colspan='5' class='empty-msg'>❌ Error: "+e.getMessage()+"</td></tr>");
                    e.printStackTrace();
                } finally {
                    try { if(rs!=null) rs.close(); } catch(Exception e){}
                    try { if(ps!=null) ps.close(); } catch(Exception e){}
                    try { if(con!=null) con.close(); } catch(Exception e){}
                }
            %>
            </tbody>
        </table>

        <a class="btn" href="manager_dashboard.html">⬅ Back</a>
    </div>
</div>

</body>
</html>
