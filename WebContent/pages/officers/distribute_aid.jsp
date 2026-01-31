<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Distribute Aid - NGO Impact System</title>

    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />

    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f6f8; padding: 30px; }
        .topbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        h2 { color: #2c3e50; margin: 0; }
        .logout a { text-decoration: none; padding: 8px 14px; background: #e74c3c; color: white; border-radius: 6px; font-size: 14px; }
        .logout a:hover { background: #c0392b; }
        .form-box { background: white; padding: 25px; width: 420px; border-radius: 8px; box-shadow: 0 2px 6px rgba(0,0,0,0.15); }
        label { display: block; margin-top: 12px; font-weight: bold; }
        input, select { width: 100%; padding: 8px; margin-top: 6px; box-sizing: border-box; }
        button { margin-top: 18px; width: 100%; padding: 10px; background-color: #27ae60; color: white; border: none; border-radius: 5px; cursor: pointer; font-size: 15px; }
        button:hover { background-color: #219150; }
        .back { margin-top: 15px; }
        .back a { text-decoration: none; color: #3498db; font-weight: bold; }
    </style>
</head>

<body>

<div class="topbar">
    <h2>Distribute Aid</h2>

    <div class="logout">
        <a href="<%= request.getContextPath() %>/LogoutServlet"
           onclick="return confirm('Do you want to logout?')">Logout</a>
    </div>
</div>

<div class="form-box">

    <form action="<%= request.getContextPath() %>/DistributeAidServlet" method="post">

        <label>Beneficiary ID</label>
        <input type="number" name="beneficiary_id" min="1" required>

        <label>Aid Type</label>
        <select name="aid_type" required>
            <option value="">-- Select Aid Type --</option>
            <option value="Cash">Cash</option>
            <option value="Food">Food</option>
            <option value="Medical">Medical</option>
            <option value="Education">Education</option>
        </select>

        <label>Aid Amount</label>
        <input type="number" name="amount" step="0.01" min="0" required>

        <label>Date of Distribution</label>
        <input type="date" name="date" required>

        <button type="submit">Distribute Aid</button>
    </form>

</div>

<div class="back">
    <a href="officer_dashboard.jsp">Back to Dashboard</a>
</div>

</body>
</html>
