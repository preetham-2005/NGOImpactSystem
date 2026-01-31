<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.ngo.util.DBConnection" %>

<%
String action = request.getParameter("action");

/* ================= CSV DOWNLOAD PART ================= */
if ("csv".equals(action)) {

    response.setContentType("text/csv");
    response.setHeader("Content-Disposition", "attachment; filename=\"ngo_full_report.csv\"");

    Connection con = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        con = DBConnection.getConnection();
        stmt = con.createStatement();

        // ===== BENEFICIARIES =====
        out.println("===== BENEFICIARY DATA =====");
        out.println("ID,Name,Age,Gender,Address,Phone");

        rs = stmt.executeQuery("SELECT id,name,age,gender,address,phone FROM beneficiaries");
        while(rs.next()){
            out.println(
                rs.getInt("id") + "," +
                rs.getString("name") + "," +
                rs.getInt("age") + "," +
                rs.getString("gender") + "," +
                rs.getString("address") + "," +
                rs.getString("phone")
            );
        }
        rs.close();

        // ===== AID REQUEST =====
        out.println("\n===== AID REQUEST DATA =====");
        out.println("RequestID,BeneficiaryID,AidType,Amount,Status,RequestDate");

        rs = stmt.executeQuery("SELECT request_id,beneficiary_id,aid_type,amount,status,request_date FROM aid_requests");
        while(rs.next()){
            out.println(
                rs.getInt("request_id") + "," +
                rs.getInt("beneficiary_id") + "," +
                rs.getString("aid_type") + "," +
                rs.getDouble("amount") + "," +
                rs.getString("status") + "," +
                rs.getDate("request_date")
            );
        }
        rs.close();

        // ===== IMPACT DATA =====
        out.println("\n===== IMPACT / ANALYTICS DATA =====");
        out.println("BeneficiaryID,AmountGiven,Employed,EducationImproved,HealthImproved");

        rs = stmt.executeQuery("SELECT beneficiary_id,amount,employed,education_improved,health_improved FROM analytics_data");
        while(rs.next()){
            out.println(
                rs.getInt("beneficiary_id") + "," +
                rs.getDouble("amount") + "," +
                rs.getString("employed") + "," +
                rs.getString("education_improved") + "," +
                rs.getString("health_improved")
            );
        }

    } catch(Exception e){
        e.printStackTrace();
    } finally {
        try { if(rs!=null) rs.close(); } catch(Exception e){}
        try { if(stmt!=null) stmt.close(); } catch(Exception e){}
        try { if(con!=null) con.close(); } catch(Exception e){}
    }

    return; // STOP PAGE HERE AFTER DOWNLOAD
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Export Data</title>

<style>
body{
    font-family: Arial, sans-serif;
    padding:40px;
}
.export-box{
    background:#f4f6f8;
    padding:25px;
    width:450px;
    border-radius:10px;
    box-shadow:0 4px 10px rgba(0,0,0,0.1);
}
button{
    padding:12px 18px;
    background:#3498db;
    color:white;
    border:none;
    border-radius:6px;
    font-weight:bold;
    cursor:pointer;
}
button:hover{
    background:#2980b9;
}
</style>
</head>
<body>

<div class="export-box">
    <h2>📁 Export Data</h2>
    <p>Export beneficiary, <b>aid request</b> and impact data as CSV.</p>

    <!-- SAME PAGE CALL -->
    <a href="export.jsp?action=csv">
        <button>⬇ Export CSV</button>
    </a>
</div>

</body>
</html>
