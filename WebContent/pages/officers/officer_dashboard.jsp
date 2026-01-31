<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // 🔒 SESSION SECURITY
    if (session == null || session.getAttribute("role") == null ||
        !"OFFICER".equalsIgnoreCase((String) session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.html");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Field Officer Dashboard - NGO Impact System</title>

    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />

    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f6f8; margin: 0; }
        .header { background-color: #34495e; color: white; padding: 15px; text-align: center; position: relative; }
        .container { padding: 30px; }
        .card { background-color: white; padding: 20px; margin-bottom: 20px; border-radius: 8px; box-shadow: 0 2px 6px rgba(0,0,0,0.15); }
        .card h3 { margin-top: 0; color: #2c3e50; }
        .card p { color: #555; }
        .card a { display: inline-block; margin-top: 10px; padding: 10px 15px; background-color: #3498db; color: white; text-decoration: none; border-radius: 5px; }
        .card a:hover { background-color: #2980b9; }
        .logout { position: absolute; right: 20px; top: 18px; }
        .logout a { text-decoration: none; padding: 8px 14px; background: #e74c3c; color: white; border-radius: 6px; font-size: 14px; }
        .logout a:hover { background: #c0392b; }
        .msg { padding: 10px; margin-bottom: 15px; border-radius: 5px; font-weight: bold; }
        .success { background: #d4edda; color: #155724; }
        .fail { background: #f8d7da; color: #721c24; }
    </style>
</head>

<body>

<div class="header">
    <h2>Field Officer Dashboard</h2>

    <div class="logout">
        <a href="<%=request.getContextPath()%>/LogoutServlet"
           onclick="return confirm('Do you want to logout?')">Logout</a>
    </div>
</div>

<div class="container">

    <!-- ✅ SUCCESS / FAIL MESSAGE DISPLAY -->
    <%
    String msg = request.getParameter("msg");

    if ("success".equals(msg)) {
%>
        <div class="msg success">Beneficiary added successfully!</div>
<%
    } else if ("aid_requested".equals(msg)) {
%>
        <div class="msg success">Aid request submitted successfully!</div>
<%
    } else if ("impact_success".equals(msg)) {   // 🔥 ADD THIS
%>
        <div class="msg success">Impact details updated successfully!</div>
<%
    } else if ("fail".equals(msg)) {
%>
        <div class="msg fail">Operation failed. Please try again.</div>
<%
    }
%>


    <div class="card">
        <h3>Register Beneficiary</h3>
        <p>Add new beneficiaries to the NGO system.</p>
        <a href="add_beneficiary.jsp">Add Beneficiary</a>
    </div>

    <div class="card">
        <h3>Distribute Aid</h3>
        <p>Record aid distribution details.</p>
        <a href="distribute_aid.jsp">Distribute Aid</a>
    </div>

    <div class="card">
        <h3>Post-Aid Impact</h3>
        <p>Update beneficiary impact after aid distribution.</p>
        <a href="post_impact.jsp">Update Impact</a>
    </div>

</div>

</body>
</html>
