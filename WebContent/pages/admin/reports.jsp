<%@ page import="java.sql.*" %>
<%@ page import="com.ngo.util.DBConnection" %>

<%
    // ✅ Session check (Admin only)
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("ADMIN")) {
        response.sendRedirect("../../login.html");
        return;
    }

    int totalBeneficiaries = 0;
    int totalAided = 0;
    int improvedCount = 0;
    double impactPercent = 0.0;

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        con = DBConnection.getConnection();

        // ✅ 1) Total Beneficiaries
        ps = con.prepareStatement("SELECT COUNT(*) FROM beneficiaries");
        rs = ps.executeQuery();
        if (rs.next()) totalBeneficiaries = rs.getInt(1);
        rs.close(); ps.close();

        // ✅ 2) Total Beneficiaries Aided
        ps = con.prepareStatement("SELECT COUNT(*) FROM analytics_data WHERE amount > 0");
        rs = ps.executeQuery();
        if (rs.next()) totalAided = rs.getInt(1);
        rs.close(); ps.close();

        // ✅ 3) Improved After Aid
        ps = con.prepareStatement("SELECT COUNT(*) FROM analytics_data WHERE amount > 0 AND employed='Yes'");
        rs = ps.executeQuery();
        if (rs.next()) improvedCount = rs.getInt(1);
        rs.close(); ps.close();

        // ✅ 4) Impact %
        if (totalAided > 0) {
            impactPercent = (improvedCount * 100.0) / totalAided;
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch(Exception ex) {}
        try { if (ps != null) ps.close(); } catch(Exception ex) {}
        try { if (con != null) con.close(); } catch(Exception ex) {}
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reports - NGO Impact System</title>

    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

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
            width: 70%;
            border-collapse: collapse;
            background: white;
            margin-bottom: 25px;
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

        /* ✅ Card Styling */
        .card {
            width: 70%;
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.12);
            margin-top: 20px;
        }

        /* ✅ Chart box for reducing size */
        .chart-box {
            width: 330px;
            height: 330px;
            margin: 0 auto;
        }
        .chart-box canvas {
            width: 100% !important;
            height: 100% !important;
        }

        a {
            text-decoration: none;
            color: #3498db;
            font-weight: bold;
        }
        .btn-back {
            display: inline-block;
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
        <td><%= improvedCount %></td>
    </tr>

    <tr>
        <td>Impact Percentage</td>
        <td><%= String.format("%.2f", impactPercent) %> %</td>
    </tr>
</table>

<div class="card">
    <h3 style="text-align:center;">📈 Impact Visualization</h3>

    <div class="chart-box">
        <canvas id="impactChart"></canvas>
    </div>
</div>

<script>
    const improved = Number("<%= improvedCount %>");
    const aided = Number("<%= totalAided %>");
    const notImproved = Math.max(aided - improved, 0);

    let activeText = ""; // ✅ will update on click

    // ✅ Center text plugin
    const centerTextPlugin = {
        id: "centerTextPlugin",
        afterDraw(chart) {
            const ctx = chart.ctx;
            const meta = chart.getDatasetMeta(0);
            if (!meta || !meta.data || !meta.data.length) return;

            const x = meta.data[0].x;
            const y = meta.data[0].y;

            ctx.save();
            ctx.textAlign = "center";
            ctx.textBaseline = "middle";
            ctx.fillStyle = "#2c3e50";

            const impactPercent = aided > 0 ? ((improved / aided) * 100).toFixed(1) : "0.0";
            const text = activeText || `Impact\n${impactPercent}%`;
            const lines = text.split("\n");

            ctx.font = "bold 18px Arial";
            ctx.fillText(lines[0], x, y - 12);

            ctx.font = "bold 16px Arial";
            ctx.fillText(lines[1], x, y + 12);

            ctx.restore();
        }
    };

    const chart = new Chart(document.getElementById("impactChart"), {
        type: "doughnut",
        data: {
            labels: ["Improved", "Not Improved"],
            datasets: [{
                data: [improved, notImproved],
                borderWidth: 3,
                hoverOffset: 12
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            cutout: "65%",
            plugins: {
                legend: {
                    position: "top",
                    labels: { padding: 15 }
                },
                tooltip: {
                    callbacks: {
                        label: function(ctx) {
                            const total = improved + notImproved;
                            const val = ctx.raw;
                            const pct = total > 0 ? ((val / total) * 100).toFixed(1) : 0;
                            return `${ctx.label}: ${val} (${pct}%)`;
                        }
                    }
                }
            },

            // ✅ click slice => show value in center
            onClick: (evt, elements) => {
                if (elements.length > 0) {
                    const index = elements[0].index;
                    const label = chart.data.labels[index];
                    const val = chart.data.datasets[0].data[index];

                    const total = improved + notImproved;
                    const pct = total > 0 ? ((val / total) * 100).toFixed(1) : 0;

                    activeText = `${label}\n${val} (${pct}%)`;
                } else {
                    activeText = ""; // reset
                }
                chart.update();
            }
        },
        plugins: [centerTextPlugin]
    });
</script>

<div class="btn-back">
    <a href="admin_dashboard.html">⬅ Back to Dashboard</a>
</div>

</body>
</html>
