<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Distribute Aid - NGO Impact System</title>

    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Outfit:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
        :root {
            --bg-gradient: linear-gradient(135deg, #0f172a 0%, #1e1b4b 100%);
            --primary: #10b981;
            --primary-hover: #059669;
            --accent: #6366f1;
            --danger: #ef4444;
            --text-main: #f8fafc;
            --text-muted: #cbd5e1;
            --card-bg: rgba(30, 41, 59, 0.7);
            --card-border: rgba(255, 255, 255, 0.08);
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: "Inter", sans-serif;
            background: var(--bg-gradient);
            color: var(--text-main);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }

        .topbar {
            width: 100%;
            max-width: 500px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        h2 {
            font-family: "Outfit", sans-serif;
            font-size: 24px;
            font-weight: 700;
            color: var(--text-main);
            letter-spacing: -0.5px;
        }

        .logout a {
            text-decoration: none;
            padding: 8px 16px;
            background: rgba(239, 68, 68, 0.15);
            color: var(--danger);
            border: 1px solid rgba(239, 68, 68, 0.3);
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            transition: all 0.2s;
        }

        .logout a:hover {
            background: var(--danger);
            color: white;
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
        }

        .form-box {
            background: var(--card-bg);
            backdrop-filter: blur(16px);
            border: 1px solid var(--card-border);
            padding: 35px;
            width: 100%;
            max-width: 500px;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.3);
        }

        label {
            display: block;
            margin-top: 16px;
            font-size: 13px;
            font-weight: 500;
            color: var(--text-muted);
            letter-spacing: 0.5px;
        }

        input, select {
            width: 100%;
            padding: 12px 16px;
            margin-top: 6px;
            border-radius: 10px;
            border: 1px solid rgba(255,255,255,0.1);
            background: rgba(15, 23, 42, 0.6);
            color: white;
            outline: none;
            font-size: 14px;
            transition: all 0.3s;
        }

        input:focus, select:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.25);
            background: rgba(15, 23, 42, 0.8);
        }

        select option {
            background: #1e293b;
            color: white;
        }

        button {
            margin-top: 25px;
            width: 100%;
            padding: 13px;
            background: var(--primary);
            color: #0f172a;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-size: 15px;
            font-weight: 600;
            transition: all 0.3s;
            box-shadow: 0 4px 15px rgba(16, 185, 129, 0.3);
        }

        button:hover {
            background: var(--primary-hover);
            transform: translateY(-1.5px);
            box-shadow: 0 6px 20px rgba(16, 185, 129, 0.4);
        }

        .back {
            margin-top: 25px;
            text-align: center;
        }

        .back a {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            color: var(--text-muted);
            font-weight: 500;
            font-size: 14px;
            transition: color 0.2s;
        }

        .back a:hover {
            color: var(--primary);
        }
    </style>
</head>

<body>

<div class="topbar">
    <h2>💸 Distribute Aid</h2>

    <div class="logout">
        <a href="<%= request.getContextPath() %>/LogoutServlet"
           onclick="return confirm('Do you want to logout?')">Logout</a>
    </div>
</div>

<div class="form-box">
    <form action="<%= request.getContextPath() %>/DistributeAidServlet" method="post">

        <label>Beneficiary ID</label>
        <input type="number" name="beneficiary_id" min="1" required placeholder="Enter beneficiary registration ID">

        <label>Aid Type</label>
        <select name="aid_type" required>
            <option value="">-- Select Aid Type --</option>
            <option value="Cash">Cash</option>
            <option value="Food">Food</option>
            <option value="Medical">Medical</option>
            <option value="Education">Education</option>
        </select>

        <label>Aid Amount</label>
        <input type="number" name="amount" step="0.01" min="0" required placeholder="Enter distribution value">

        <label>Date of Distribution</label>
        <input type="date" name="date" required>

        <button type="submit">Submit Aid Request</button>
    </form>
</div>

<div class="back">
    <a href="officer_dashboard.jsp">
        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M15.75 19.5L8.25 12l7.5-7.5"/></svg>
        Back to Dashboard
    </a>
</div>

</body>
</html>
