<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.skindisease.servlet.ServletLifeCycleDemo" %>
<%
    List<String> logs = ServletLifeCycleDemo.getLogs();
    
    // Check session
    String username = (String) session.getAttribute("sessionUser");
    boolean isLoggedIn = (username != null);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Servlet Life Cycle Demo | DermAnalysis</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
</head>
<body>

    <div class="container">
        
        <!-- Navigation -->
        <nav class="nav-bar">
            <div class="nav-logo">
                <span>Derm</span>Analysis
            </div>
            <ul class="nav-links">
                <li><a href="index.jsp">Dashboard</a></li>
                <li><a href="AnalysisServlet?action=list">Disease Analysis</a></li>
                <li><a href="StudentServlet?action=list">Student Database (Q6)</a></li>
                <li><a href="lifecycle.jsp" class="active">Servlet Lifecycle (Q1)</a></li>
                <% if (isLoggedIn) { %>
                    <li><a href="WelcomeServlet">Session Compare (Q5)</a></li>
                    <li><a href="login.html" class="text-highlight">Switch User</a></li>
                <% } else { %>
                    <li><a href="login.html" class="text-highlight">Login / Signup</a></li>
                <% } %>
            </ul>
        </nav>

        <header>
            <h1 class="glow-text">Servlet Life Cycle Console</h1>
            <p class="subtitle">Assignment Q1: Visualizing init(), service(), and destroy() state changes in real-time</p>
        </header>

        <div class="grid-2">
            
            <!-- Explanation Panel -->
            <div class="card glass-card">
                <h2>Servlet Lifecycle States</h2>
                <p style="color: var(--text-secondary); margin-top: 10px; font-size: 0.95rem;">
                    The Servlet Container (Tomcat) manages the life cycle of a servlet instance. The flow is as follows:
                </p>
                
                <div style="margin-top: 20px; display: grid; gap: 15px;">
                    <div>
                        <span class="badge badge-info">1. Loading & Instantiation</span>
                        <p style="font-size: 0.88rem; color: var(--text-secondary); margin-top: 5px;">
                            The servlet class is loaded into memory, and the container calls its zero-argument constructor to instantiate it.
                        </p>
                    </div>
                    
                    <div>
                        <span class="badge badge-warning">2. Initialization - init()</span>
                        <p style="font-size: 0.88rem; color: var(--text-secondary); margin-top: 5px;">
                            The container calls the <code>init()</code> method exactly once. This is used for setting up DB connection pools, configuration readouts, etc.
                        </p>
                    </div>

                    <div>
                        <span class="badge badge-success">3. Servicing Requests - service()</span>
                        <p style="font-size: 0.88rem; color: var(--text-secondary); margin-top: 5px;">
                            The container invokes the <code>service()</code> method for each client request. <code>service()</code> automatically delegates requests to specific HTTP method handlers (<code>doGet()</code>, <code>doPost()</code>, etc.).
                        </p>
                    </div>

                    <div>
                        <span class="badge badge-danger">4. Destruction - destroy()</span>
                        <p style="font-size: 0.88rem; color: var(--text-secondary); margin-top: 5px;">
                            When taking the servlet instance out of service (e.g. server shutdown or hot reload), the container executes the <code>destroy()</code> method to release resources.
                        </p>
                    </div>
                </div>
            </div>

            <!-- Execution Console Panel -->
            <div class="card glass-card">
                <h2>Interactive Container Tester</h2>
                <p style="color: var(--text-secondary); font-size: 0.9rem; margin-bottom: 20px;">
                    Send standard HTTP GET requests to the lifecycle servlet to trigger the container's <code>service()</code> mechanism.
                </p>

                <div class="flex gap-10 mb-20">
                    <a href="ServletLifeCycleDemo" target="lifecycleFrame" class="btn btn-primary" onclick="triggerConsoleUpdate()">
                        Trigger Servlet Request (service())
                    </a>
                    <a href="ServletLifeCycleDemo?action=clear" class="btn btn-secondary">
                        Clear Console Logs
                    </a>
                </div>

                <h3>Real-Time JVM Server Logs:</h3>
                <div class="terminal-console mt-20">
                    <% if (logs == null || logs.isEmpty()) { %>
                        <div class="console-line text-muted">Console idle. Click the button above to dispatch a servlet transaction.</div>
                    <% } else {
                        for (String log : logs) { 
                            String[] parts = log.split(": ", 2);
                            String timestamp = parts[0];
                            String content = parts.length > 1 ? parts[1] : "";
                            
                            String method = "";
                            if (content.contains("[init()]")) method = "[init()]";
                            else if (content.contains("[service()]")) method = "[service()]";
                            else if (content.contains("[destroy()]")) method = "[destroy()]";
                            
                            String desc = content.replace(method, "");
                        %>
                            <div class="console-line">
                                <span class="timestamp">[<%= timestamp %>]</span>
                                <span class="method"><%= method %></span>
                                <span class="action"><%= desc %></span>
                            </div>
                    <%  }
                       } %>
                </div>
                
                <!-- Hidden iframe to allow invoking servlet in the background without jumping away from the console layout -->
                <iframe name="lifecycleFrame" style="display:none;" id="lifecycleFrame"></iframe>
            </div>
            
        </div>

    </div>

    <script src="js/app.js"></script>
    <script>
        // Reload page shortly after trigger to populate the server log outputs in the terminal panel
        function triggerConsoleUpdate() {
            setTimeout(() => {
                window.location.reload();
            }, 600);
        }
    </script>
</body>
</html>
