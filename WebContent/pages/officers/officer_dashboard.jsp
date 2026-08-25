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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Field Officer Dashboard - NGO Impact System</title>

    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Outfit:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
        :root {
            --bg-gradient: linear-gradient(135deg, #0f172a 0%, #1e1b4b 100%);
            --primary: #6366f1;
            --primary-hover: #4f46e5;
            --accent: #818cf8;
            --text-main: #f8fafc;
            --text-muted: #94a3b8;
            --card-bg: rgba(30, 41, 59, 0.7);
            --card-border: rgba(255, 255, 255, 0.08);
            --sidebar-bg: rgba(15, 23, 42, 0.85);
            --success: #10b981;
            --danger: #ef4444;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: "Inter", sans-serif;
        }

        body {
            background: var(--bg-gradient);
            color: var(--text-main);
            min-height: 100vh;
            display: flex;
            overflow-x: hidden;
        }

        /* Sidebar */
        .sidebar {
            width: 280px;
            background: var(--sidebar-bg);
            backdrop-filter: blur(20px);
            border-right: 1px solid var(--card-border);
            display: flex;
            flex-direction: column;
            padding: 30px;
            position: fixed;
            height: 100vh;
            z-index: 100;
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 50px;
        }

        .brand svg {
            width: 32px;
            height: 32px;
            color: var(--primary);
        }

        .brand h2 {
            font-family: "Outfit", sans-serif;
            font-size: 20px;
            font-weight: 800;
            letter-spacing: -0.5px;
            background: linear-gradient(to right, #ffffff, #c7d2fe);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .user-profile {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 15px;
            background: rgba(255,255,255,0.03);
            border: 1px solid rgba(255,255,255,0.05);
            border-radius: 12px;
            margin-bottom: 40px;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, var(--primary), var(--accent));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-family: "Outfit", sans-serif;
            color: #0f172a;
        }

        .user-info h4 {
            font-size: 14px;
            font-weight: 600;
        }

        .user-info p {
            font-size: 11px;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-top: 2px;
        }

        .nav-links {
            list-style: none;
            display: flex;
            flex-direction: column;
            gap: 10px;
            flex-grow: 1;
        }

        .nav-link a {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 16px;
            color: var(--text-muted);
            text-decoration: none;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.2s;
        }

        .nav-link a:hover, .nav-link.active a {
            color: white;
            background: rgba(99, 102, 241, 0.1);
            transform: translateX(4px);
        }

        .nav-link.active a {
            border: 1px solid rgba(99, 102, 241, 0.2);
            color: var(--primary);
        }

        .logout-btn {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 16px;
            color: #ef4444;
            text-decoration: none;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.2s;
            border: 1px solid rgba(239, 68, 68, 0.1);
            background: rgba(239, 68, 68, 0.05);
            margin-top: auto;
        }

        .logout-btn:hover {
            background: #ef4444;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
        }

        /* Main Content */
        .main-content {
            margin-left: 280px;
            flex-grow: 1;
            padding: 50px;
            max-width: 1200px;
        }

        .welcome-header {
            margin-bottom: 40px;
        }

        .welcome-header h1 {
            font-family: "Outfit", sans-serif;
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .welcome-header p {
            color: var(--text-muted);
            font-size: 15px;
        }

        /* Success/Fail Alerts */
        .msg {
            padding: 16px 20px;
            margin-bottom: 30px;
            border-radius: 12px;
            font-weight: 500;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .success {
            background: rgba(16, 185, 129, 0.15);
            color: var(--success);
            border: 1px solid rgba(16, 185, 129, 0.2);
        }

        .fail {
            background: rgba(239, 68, 68, 0.15);
            color: var(--danger);
            border: 1px solid rgba(239, 68, 68, 0.2);
        }

        /* Dashboard Grid */
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
        }

        .action-card {
            background: var(--card-bg);
            backdrop-filter: blur(16px);
            border: 1px solid var(--card-border);
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            display: flex;
            flex-direction: column;
        }

        .action-card:hover {
            transform: translateY(-5px);
            border-color: rgba(99, 102, 241, 0.3);
            box-shadow: 0 15px 35px rgba(99, 102, 241, 0.15);
        }

        .card-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            background: rgba(99, 102, 241, 0.1);
            color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
        }

        .action-card h3 {
            font-family: "Outfit", sans-serif;
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 10px;
        }

        .action-card p {
            color: var(--text-muted);
            font-size: 14px;
            line-height: 1.5;
            margin-bottom: 25px;
            flex-grow: 1;
        }

        .action-card a {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            background: var(--primary);
            color: white;
            padding: 10px 20px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.2s;
            border: 1px solid rgba(255,255,255,0.05);
            width: fit-content;
        }

        .action-card a:hover {
            background: var(--primary-hover);
            transform: translateY(-1px);
        }

        @media(max-width: 992px) {
            body { flex-direction: column; }
            .sidebar {
                width: 100%;
                height: auto;
                position: relative;
                padding: 20px;
            }
            .main-content { margin-left: 0; padding: 30px; }
            .brand { margin-bottom: 25px; }
            .user-profile { display: none; }
        }
    </style>
</head>
<body>

    <!-- Sidebar -->
    <div class="sidebar">
        <div class="brand">
            <svg fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 21a9.004 9.004 0 008.716-6.747M12 21a9.004 9.004 0 01-8.716-6.747M12 21c2.485 0 4.5-4.03 4.5-9S14.485 3 12 3m0 18c-2.485 0-4.5-4.03-4.5-9S9.515 3 12 3m0 0a8.997 8.997 0 017.843 4.582M12 3a8.997 8.997 0 00-7.843 4.582m15.686 0A11.953 11.953 0 0112 10.5c-2.998 0-5.74-1.1-7.843-2.918m15.686 0A8.959 8.959 0 0121 12c0 .778-.099 1.533-.284 2.253m0 0A17.919 17.919 0 0112 16.5c-3.162 0-6.133-.815-8.716-2.247m0 0A9.015 9.015 0 013 12c0-.778.099-1.533.284-2.253"/></svg>
            <h2>Field Officer</h2>
        </div>

        <div class="user-profile">
            <div class="user-avatar">FO</div>
            <div class="user-info">
                <h4>Field Officer</h4>
                <p>Access Level: Entry</p>
            </div>
        </div>

        <ul class="nav-links">
            <li class="nav-link active">
                <a href="#">
                    <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M2.25 12l8.954-8.955c.44-.439 1.152-.439 1.591 0L21.75 12M4.5 9.75v10.125c0 .621.504 1.125 1.125 1.125H9.75v-4.875c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125V21h4.125c.621 0 1.125-.504 1.125-1.125V9.75M8.25 21h8.25"/></svg>
                    Dashboard
                </a>
            </li>
            <li class="nav-link">
                <a href="add_beneficiary.jsp">
                    <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M19 7.5v3m0 0v3m0-3h3m-3 0h-3m-2.25-4.125a3.375 3.375 0 11-6.75 0 3.375 3.375 0 016.75 0zM4 19.235v-.11a6.375 6.375 0 0112.75 0v.109A12.318 12.318 0 0110.374 21c-2.331 0-4.512-.645-6.374-1.766z"/></svg>
                    Add Beneficiary
                </a>
            </li>
            <li class="nav-link">
                <a href="distribute_aid.jsp">
                    <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 6v12m-3-2.818l.879.659c1.171.879 3.07.879 4.242 0 1.172-.879 1.172-2.303 0-3.182C13.536 12.219 12.768 12 12 12c-.725 0-1.45-.22-2.003-.659-1.106-.879-1.106-2.303 0-3.182s2.9-.879 4.006 0l.415.33M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                    Distribute Aid
                </a>
            </li>
            <li class="nav-link">
                <a href="post_impact.jsp">
                    <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M2.25 18L9 11.25l4.306 4.307a11.95 11.95 0 015.814-5.519l2.74-1.22m0 0l-5.94-2.28m5.94 2.28l-2.28 5.941"/></svg>
                    Update Impact
                </a>
            </li>
        </ul>

        <a href="<%=request.getContextPath()%>/LogoutServlet" class="logout-btn" onclick="return confirm('Do you want to logout?')">
            <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M15.75 9V5.25A2.25 2.25 0 0013.5 3h-6a2.25 2.25 0 00-2.25 2.25v13.5A2.25 2.25 0 007.5 21h6a2.25 2.25 0 002.25-2.25V15M12 9l-3 3m0 0l3 3m-3-3h12.75"/></svg>
            Sign Out
        </a>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="welcome-header">
            <h1>Field Officer Dashboard</h1>
            <p>Manage community outreach, execute aid distribution, and report program outcomes.</p>
        </div>

        <%
            String msg = request.getParameter("msg");
            if ("success".equals(msg)) {
        %>
            <div class="msg success">
                <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                Beneficiary registered successfully!
            </div>
        <%
            } else if ("aid_requested".equals(msg)) {
        %>
            <div class="msg success">
                <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                Aid distribution request submitted to Manager queue.
            </div>
        <%
            } else if ("impact_success".equals(msg)) {
        %>
            <div class="msg success">
                <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                Post-aid impact details updated successfully.
            </div>
        <%
            } else if ("fail".equals(msg)) {
        %>
            <div class="msg fail">
                <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m9-.75a9 9 0 11-18 0 9 9 0 0118 0zm-9 3.75h.008v.008H12v-.008z"/></svg>
                Operation failed. Please verify the IDs and try again.
            </div>
        <%
            }
        %>

        <div class="dashboard-grid">
            
            <div class="action-card">
                <div class="card-icon">
                    <svg width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M19 7.5v3m0 0v3m0-3h3m-3 0h-3m-2.25-4.125a3.375 3.375 0 11-6.75 0 3.375 3.375 0 016.75 0zM4 19.235v-.11a6.375 6.375 0 0112.75 0v.109A12.318 12.318 0 0110.374 21c-2.331 0-4.512-.645-6.374-1.766z"/></svg>
                </div>
                <h3>Register Beneficiary</h3>
                <p>Create a baseline profile for new beneficiaries, registering their region, program, and baseline monthly income.</p>
                <a href="add_beneficiary.jsp">Add Beneficiary</a>
            </div>

            <div class="action-card">
                <div class="card-icon">
                    <svg width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 6v12m-3-2.818l.879.659c1.171.879 3.07.879 4.242 0 1.172-.879 1.172-2.303 0-3.182C13.536 12.219 12.768 12 12 12c-.725 0-1.45-.22-2.003-.659-1.106-.879-1.106-2.303 0-3.182s2.9-.879 4.006 0l.415.33M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                </div>
                <h3>Distribute Aid</h3>
                <p>Initiate aid requests (cash, food, medicine, or tuition) for pre-registered beneficiaries for Program Manager approval.</p>
                <a href="distribute_aid.jsp">Record Distribution</a>
            </div>

            <div class="action-card">
                <div class="card-icon">
                    <svg width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M2.25 18L9 11.25l4.306 4.307a11.95 11.95 0 015.814-5.519l2.74-1.22m0 0l-5.94-2.28m5.94 2.28l-2.28 5.941"/></svg>
                </div>
                <h3>Post-Aid Impact</h3>
                <p>Register follow-up results including post-aid income levels and employment outcomes to measure program impact.</p>
                <a href="post_impact.jsp">Update Impact</a>
            </div>

        </div>
    </div>

</body>
</html>
