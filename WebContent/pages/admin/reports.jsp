<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, java.util.*, com.ngo.util.DBConnection" %>

<%
String role = (String) session.getAttribute("role");
if (role == null || !role.equals("ADMIN")) {
    response.sendRedirect("../../login.html");
    return;
}

int totalBeneficiaries=0,totalAided=0,improvedCount=0;
double impactPercent=0;

Map<String,Integer> programSuccess=new LinkedHashMap<>();
Map<String,Double> programEffectiveness=new LinkedHashMap<>();
Map<String,Double> incomeTrend=new LinkedHashMap<>();
int struggling=0,stable=0,approved=0,pending=0,rejected=0;

try(Connection con=DBConnection.getConnection()){
PreparedStatement ps; ResultSet rs;

// TOTALS
ps=con.prepareStatement("SELECT COUNT(*) FROM beneficiaries");
rs=ps.executeQuery(); if(rs.next()) totalBeneficiaries=rs.getInt(1);
rs.close(); ps.close();

ps=con.prepareStatement("SELECT COUNT(DISTINCT beneficiary_id) FROM aid_requests WHERE LOWER(status)='approved'");
rs=ps.executeQuery(); if(rs.next()) totalAided=rs.getInt(1);
rs.close(); ps.close();

ps=con.prepareStatement("SELECT COUNT(*) FROM post_aid_impact WHERE employed='YES'");
rs=ps.executeQuery(); if(rs.next()) improvedCount=rs.getInt(1);
rs.close(); ps.close();

if(totalAided>0) impactPercent=(improvedCount*100.0)/totalAided;

// PROGRAM SUCCESS
ps=con.prepareStatement(
"SELECT p.program_name, COUNT(pa.impact_id) " +
"FROM post_aid_impact pa JOIN beneficiaries b ON pa.beneficiary_id=b.beneficiary_id " +
"JOIN programs p ON b.program_id=p.program_id WHERE pa.employed='YES' GROUP BY p.program_name");
rs=ps.executeQuery();
while(rs.next()) programSuccess.put(rs.getString(1), rs.getInt(2));
rs.close(); ps.close();

// PROGRAM EFFECTIVENESS %
ps=con.prepareStatement(
"SELECT p.program_name, ROUND(SUM(CASE WHEN pa.employed='YES' THEN 1 ELSE 0 END)*100.0/COUNT(pa.impact_id),2) " +
"FROM post_aid_impact pa JOIN beneficiaries b ON pa.beneficiary_id=b.beneficiary_id " +
"JOIN programs p ON b.program_id=p.program_id GROUP BY p.program_name");
rs=ps.executeQuery();
while(rs.next()) programEffectiveness.put(rs.getString(1), rs.getDouble(2));
rs.close(); ps.close();

// STRUGGLE / STABLE
ps=con.prepareStatement("SELECT COUNT(*) FROM post_aid_impact WHERE struggling='YES'");
rs=ps.executeQuery(); if(rs.next()) struggling=rs.getInt(1);
rs.close(); ps.close();

ps=con.prepareStatement("SELECT COUNT(*) FROM post_aid_impact WHERE struggling='NO'");
rs=ps.executeQuery(); if(rs.next()) stable=rs.getInt(1);
rs.close(); ps.close();

// AID STATUS
ps=con.prepareStatement("SELECT status, COUNT(*) FROM aid_requests GROUP BY status");
rs=ps.executeQuery();
while(rs.next()){
 String s=rs.getString(1).toLowerCase();
 if(s.contains("approved")) approved=rs.getInt(2);
 else if(s.contains("pending")) pending=rs.getInt(2);
 else rejected=rs.getInt(2);
}
rs.close(); ps.close();

// INCOME TREND (FIXED)
ps = con.prepareStatement(
"SELECT DATE_FORMAT(request_date,'%Y-%m') AS ym, " +
"DATE_FORMAT(request_date,'%b-%Y') AS label, " +
"AVG(amount) AS avg_amt " +
"FROM aid_requests " +
"WHERE request_date IS NOT NULL " +
"GROUP BY ym, label " +
"ORDER BY ym"
);
rs = ps.executeQuery();
while(rs.next()){
    incomeTrend.put(rs.getString("label"), rs.getDouble("avg_amt"));
}
rs.close();
ps.close();
}
%>

<!DOCTYPE html>
<html>
<head>
<title>NGO Analytics Dashboard</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
body{font-family:Poppins;background:#1e3c72;margin:0;padding:30px}
.cards{display:grid;grid-template-columns:repeat(4,1fr);gap:20px;margin-bottom:30px}
.card{background:#2a5298;color:white;padding:20px;border-radius:14px;text-align:center}

.chart-grid{display:grid;grid-template-columns:repeat(2,1fr);gap:25px}
.chart-card{background:white;border-radius:14px;padding:15px;height:350px}
.chart-card canvas{width:100%!important;height:100%!important}
.full{grid-column:span 2;height:380px}

.btn{padding:10px 15px;border:none;border-radius:8px;font-weight:bold;color:white;cursor:pointer}
</style>
</head>

<body>

<!-- BACK BUTTON -->
<button onclick="history.back()" class="btn" style="background:#607d8b;">⬅ Back</button>

<div class="cards">
<div class="card"><h3>Total Beneficiaries</h3><h1><%=totalBeneficiaries%></h1></div>
<div class="card"><h3>Beneficiaries Aided</h3><h1><%=totalAided%></h1></div>
<div class="card"><h3>Improved After Aid</h3><h1><%=improvedCount%></h1></div>
<div class="card"><h3>Impact %</h3><h1><%=String.format("%.2f",impactPercent)%>%</h1></div>
</div>

<div class="chart-grid">
<div class="chart-card"><canvas id="programChart"></canvas></div>
<div class="chart-card"><canvas id="effectivenessChart"></canvas></div>
<div class="chart-card"><canvas id="struggleChart"></canvas></div>
<div class="chart-card"><canvas id="statusChart"></canvas></div>
<div class="chart-card full"><canvas id="incomeChart"></canvas></div>
</div>

<!-- BUTTONS -->
<div style="text-align:center;margin-top:30px;">
<form action="../../ExportDataServlet" method="get" style="display:inline;">
<button class="btn" style="background:#4CAF50;">⬇ Download Excel</button>
</form>

<form action="../../SendReportServlet" method="post" style="display:inline;margin-left:10px;">
<input type="hidden" name="totalBeneficiaries" value="<%=totalBeneficiaries%>">
<input type="hidden" name="totalAided" value="<%=totalAided%>">
<input type="hidden" name="improved" value="<%=improvedCount%>">
<input type="hidden" name="impact" value="<%=String.format("%.2f",impactPercent)%>">
<input type="email" name="email" placeholder="Enter Email" required style="padding:8px;border-radius:6px;border:none;">
<button type="submit" class="btn" style="background:#ff5722;">📧 Email Report</button>
</form>
</div>

<script>
const programLabels=[<%=programSuccess.keySet().stream().map(k->"\""+k+"\"").reduce((a,b)->a+","+b).orElse("")%>];
const programValues=[<%=programSuccess.values().stream().map(Object::toString).reduce((a,b)->a+","+b).orElse("")%>];

const effLabels=[<%=programEffectiveness.keySet().stream().map(k->"\""+k+"\"").reduce((a,b)->a+","+b).orElse("")%>];
const effValues=[<%=programEffectiveness.values().stream().map(Object::toString).reduce((a,b)->a+","+b).orElse("")%>];

const incomeLabels=[<%=incomeTrend.keySet().stream().map(k->"\""+k+"\"").reduce((a,b)->a+","+b).orElse("")%>];
const incomeValues=[<%=incomeTrend.values().stream().map(Object::toString).reduce((a,b)->a+","+b).orElse("")%>];

new Chart(programChart,{type:'bar',data:{labels:programLabels,datasets:[{label:'Success Count',data:programValues,backgroundColor:'#4caf50'}]},options:{responsive:true,maintainAspectRatio:false}});
new Chart(effectivenessChart,{type:'bar',data:{labels:effLabels,datasets:[{label:'Effectiveness %',data:effValues,backgroundColor:'#00c853'}]},options:{responsive:true,maintainAspectRatio:false}});
new Chart(struggleChart,{type:'doughnut',data:{labels:['Struggling','Stable'],datasets:[{data:[<%=struggling%>,<%=stable%>],backgroundColor:['#ff9800','#4caf50']}]},options:{responsive:true,maintainAspectRatio:false}});
new Chart(statusChart,{type:'pie',data:{labels:['Approved','Pending','Rejected'],datasets:[{data:[<%=approved%>,<%=pending%>,<%=rejected%>],backgroundColor:['#4caf50','#ffc107','#f44336']}]},options:{responsive:true,maintainAspectRatio:false}});
new Chart(incomeChart,{type:'line',data:{labels:incomeLabels,datasets:[{label:'Average Aid Amount',data:incomeValues,borderColor:'#673ab7',tension:0.3,fill:false}]},options:{responsive:true,maintainAspectRatio:false}});
</script>

</body>
</html>
