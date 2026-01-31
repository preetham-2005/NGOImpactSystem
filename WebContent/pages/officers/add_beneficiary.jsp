<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Beneficiary - NGO Impact System</title>

    <!-- Prevent back after logout -->
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />

    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f8;
            padding: 30px;
        }

        .topbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .logout a {
            text-decoration: none;
            padding: 8px 14px;
            background: #e74c3c;
            color: white;
            border-radius: 6px;
            font-size: 14px;
        }

        .logout a:hover { background: #c0392b; }

        h2 { color: #2c3e50; margin: 0; }

        .form-box {
            background: white;
            padding: 25px;
            width: 420px;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.15);
        }

        label {
            display: block;
            margin-top: 12px;
            font-weight: bold;
        }

        input, select {
            width: 100%;
            padding: 8px;
            margin-top: 6px;
            box-sizing: border-box;
        }

        button {
            margin-top: 18px;
            width: 100%;
            padding: 10px;
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 15px;
        }

        button:hover { background-color: #2980b9; }

        .back { margin-top: 15px; }

        .back a {
            text-decoration: none;
            color: #3498db;
            font-weight: bold;
        }
    </style>
</head>

<body>

<div class="topbar">
    <h2>➕ Add Beneficiary</h2>

    <div class="logout">
        <a href="<%=request.getContextPath()%>/LogoutServlet"
           onclick="return confirm('Do you want to logout?')">Logout</a>
    </div>
</div>

<div class="form-box">

    <!-- FORM SUBMITS TO SERVLET -->
    <form action="<%=request.getContextPath()%>/AddBeneficiaryServlet" method="post">

        <label>Beneficiary Name</label>
        <input type="text" name="name" required>

        <label>Region</label>
        <select name="region_id" required>
            <option value="">-- Select Region --</option>
            <option value="1">Region A</option>
            <option value="2">Region B</option>
            <option value="3">Region C</option>
        </select>

        <label>Program</label>
        <select name="program_id" required>
            <option value="">-- Select Program --</option>
            <option value="1">Education Sponsorship</option>
            <option value="2">Medical Aid</option>
            <option value="3">Food Distribution</option>
            <option value="4">Skill Training</option>
        </select>

        <label>Income Before Aid</label>
        <input type="number" name="income_before" step="0.01" min="0" required>

        <label>Email</label>
        <input type="email" name="email" required>

        <button type="submit">Save Beneficiary</button>

    </form>

</div>

<div class="back">
    <a href="<%=request.getContextPath()%>/pages/officers/officer_dashboard.jsp">⬅ Back to Dashboard</a>
</div>

</body>
</html>
