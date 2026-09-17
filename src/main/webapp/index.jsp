<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.skindisease.db.DBConnection" %>
<%
    // Check session
    String username = (String) session.getAttribute("sessionUser");
    boolean isLoggedIn = (username != null);
    
    // Check DB status
    boolean dbDriverLoaded = DBConnection.isDriverLoaded();
    String dbStatusMsg = DBConnection.getLoadStatusMessage();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DermAnalysis | J2EE Home</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
</head>
<body>

    <div class="container">
        
        <!-- Interactive Navigation Bar -->
        <nav class="nav-bar">
            <div class="nav-logo">
                <span>Derm</span>Analysis
            </div>
            <ul class="nav-links">
                <li><a href="index.jsp" class="active">Dashboard</a></li>
                <li><a href="AnalysisServlet?action=list">Disease Analysis</a></li>
                <li><a href="StudentServlet?action=list">Student Database (Q6)</a></li>
                <li><a href="lifecycle.jsp">Servlet Lifecycle (Q1)</a></li>
                <% if (isLoggedIn) { %>
                    <li><a href="WelcomeServlet">Session Compare (Q5)</a></li>
                    <li><a href="login.html" class="text-highlight">Switch User</a></li>
                <% } else { %>
                    <li><a href="login.html" class="text-highlight">Login / Signup</a></li>
                <% } %>
            </ul>
        </nav>

        <!-- Welcome Banner -->
        <header>
            <h1 class="glow-text">Skin Disease Analysis System</h1>
            <p class="subtitle">Comprehensive J2EE Servlets, JDBC, and Oracle Integration Panel</p>
        </header>

        <!-- Main Cards -->
        <div class="card glass-card">
            <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 20px;">
                <div>
                    <h2>Welcome to the Application</h2>
                    <p style="color: var(--text-secondary); max-width: 750px; margin-top: 10px;">
                        This system serves two purposes: providing a rule-based expert analysis model for identifying common skin conditions, and showcasing complete J2EE assignment requirements (dynamic servlet lifecycles, database transactions with JDBC, and session comparisons).
                    </p>
                </div>
                <div>
                    <% if (isLoggedIn) { %>
                        <div class="badge badge-success" style="padding: 10px 20px; font-size: 1rem; border-radius: 12px;">
                            Active User: <%= username %>
                        </div>
                    <% } else { %>
                        <a href="login.html" class="btn btn-primary">Login / Create Account</a>
                    <% } %>
                </div>
            </div>
        </div>

        <!-- Quick Status Metrics -->
        <div class="grid-3 mb-20">
            
            <!-- JDBC Connection State -->
            <div class="card glass-card hover-glow">
                <h3>Oracle JDBC Status</h3>
                <p style="margin: 10px 0; color: var(--text-secondary); font-size: 0.9rem;">
                    Checks if the Oracle driver library (`ojdbc11.jar`) is loaded into the Tomcat classpath successfully.
                </p>
                <div class="flex gap-10 mt-20" style="align-items: center;">
                    <% if (dbDriverLoaded) { %>
                        <span class="badge badge-success">Driver Registered</span>
                        <span style="font-size: 0.85rem; color: var(--accent-success);">Ready for Oracle DB</span>
                    <% } else { %>
                        <span class="badge badge-danger">Driver Error</span>
                        <span style="font-size: 0.82rem; color: var(--accent-error);">Check WEB-INF/lib</span>
                    <% } %>
                </div>
                <p style="margin-top: 15px; font-size: 0.78rem; color: var(--text-muted); font-family: monospace;">
                    <%= dbStatusMsg %>
                </p>
            </div>

            <!-- Active Session Details -->
            <div class="card glass-card hover-glow">
                <h3>Authentication Status</h3>
                <p style="margin: 10px 0; color: var(--text-secondary); font-size: 0.9rem;">
                    Tracks user logins via Oracle Database validation (Assignment Q2, Q3, Q4).
                </p>
                <div class="mt-20">
                    <% if (isLoggedIn) { %>
                        <p style="font-size: 0.9rem;">Authenticated: <span class="text-highlight"><%= username %></span></p>
                        <p style="font-size: 0.8rem; color: var(--text-muted); margin-top: 5px;">Method: HttpSession Container Token</p>
                    <% } else { %>
                        <p style="font-size: 0.9rem; color: var(--text-muted);">No active authenticated session.</p>
                        <a href="login.html" class="text-highlight" style="font-size: 0.85rem; display: inline-block; margin-top: 5px;">Login to begin checks →</a>
                    <% } %>
                </div>
            </div>

            <!-- Assignment Quick Links -->
            <div class="card glass-card hover-glow" style="grid-column: span 1;">
                <h3>J2EE Assignments Tasks (Q1-Q14)</h3>
                <ul style="list-style: none; font-size: 0.88rem; color: var(--text-secondary); margin-top: 10px; display: grid; gap: 8px; max-height: 250px; overflow-y: auto; padding-right: 5px;">
                    <li>✔ <b>Q1</b>: <a href="lifecycle.jsp">Servlet Life Cycle Demonstrator</a></li>
                    <li>✔ <b>Q2-Q4</b>: <a href="login.html">Login Verification & Oracle DB Insert</a></li>
                    <li>✔ <b>Q5</b>: <a href="<%= isLoggedIn ? "WelcomeServlet" : "login.html" %>">Session Management Comparison</a></li>
                    <li>✔ <b>Q6</b>: <a href="StudentServlet?action=list">Student Database Records Manager (Servlet CRUD)</a></li>
                    <li>✔ <b>Q7</b>: <a href="TodoServlet?action=list">To-Do List Application (JDBC CRUD)</a></li>
                    <li>✔ <b>Q8</b>: <a href="factorial.jsp">Factorial Calculator (JSP Declaration)</a></li>
                    <li>✔ <b>Q9</b>: <a href="overloading.jsp">Method Overloading in JSP</a></li>
                    <li>✔ <b>Q10</b>: <a href="usebean.jsp">JavaBean Display (jsp:useBean)</a></li>
                    <li>✔ <b>Q11 & Q14</b>: <a href="tags-demo.jsp">Tag Libraries & Tag Files</a></li>
                    <li>✔ <b>Q12</b>: <a href="student-direct-insert.jsp">Student Login & Direct JSP Insert</a></li>
                    <li>✔ <b>Q13</b>: <a href="implicit-objects.jsp">Implicit Objects & Session Tracking</a></li>
                </ul>
            </div>
            
        </div>

        <!-- Description of Skin Disease Classifier -->
        <div class="grid-2">
            
            <div class="card glass-card">
                <h2>Skin Disease Analysis System</h2>
                <p style="margin-top: 15px; color: var(--text-secondary); font-size: 0.95rem;">
                    The diagnosis engine utilizes a rule-based inference structure matching key physical signs:
                </p>
                <ul style="margin: 15px 0 0 20px; color: var(--text-secondary); font-size: 0.92rem; display: grid; gap: 8px;">
                    <li><b>Redness (Erythema)</b>: Localized swelling or flush caused by capillary dilation.</li>
                    <li><b>Itchiness (Pruritus)</b>: Nerve pathway stimulation indicating inflammation.</li>
                    <li><b>Scaling (Desquamation)</b>: Shedding of dead skin cells indicating hyperproliferation.</li>
                    <li><b>Duration</b>: Evaluates whether conditions are acute (&lt; 14 days) or chronic (&gt; 14 days).</li>
                </ul>
                <div class="mt-20">
                    <a href="AnalysisServlet?action=list" class="btn btn-primary">Open Analysis Panel</a>
                </div>
            </div>

            <div class="card glass-card">
                <h2>Project System Deployment Info</h2>
                <p style="color: var(--text-secondary); font-size: 0.92rem; margin-top: 10px;">
                    To compile and run this project, make sure to add this directory as an active project in <b>Eclipse IDE</b>. Run the application on <b>Apache Tomcat Server 10.x+</b>.
                </p>
                <div style="background: rgba(0,0,0,0.2); border-radius: 12px; padding: 15px; margin-top: 20px; font-family: monospace; font-size: 0.8rem; border-left: 3px solid var(--accent-secondary);">
                    <b>Deployment Setup Checklist:</b><br>
                    1. Import folder to Eclipse as dynamic web project.<br>
                    2. Check that ojdbc11.jar is in WEB-INF/lib.<br>
                    3. Create Tables in Oracle SQL Developer using schema.sql.<br>
                    4. Check database password in db.properties matches yours.<br>
                    5. Right click index.jsp -> Run on Server.
                </div>
            </div>
            
        </div>

    </div>

    <script src="js/app.js"></script>
</body>
</html>
