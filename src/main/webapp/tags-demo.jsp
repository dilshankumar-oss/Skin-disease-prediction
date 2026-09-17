<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://skindisease.com/tags" prefix="custom" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="mytags" %>
<%
    // Session state check for nav
    String username = (String) session.getAttribute("sessionUser");
    boolean isLoggedIn = (username != null);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JSP Custom Tags (Q11 & Q14) | DermAnalysis</title>
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
                <li><a href="lifecycle.jsp">Servlet Lifecycle (Q1)</a></li>
                <% if (isLoggedIn) { %>
                    <li><a href="WelcomeServlet">Session Compare (Q5)</a></li>
                    <li><a href="login.html" class="text-highlight">Switch User</a></li>
                <% } else { %>
                    <li><a href="login.html" class="text-highlight">Login / Signup</a></li>
                <% } %>
            </ul>
        </nav>

        <header>
            <h1 class="glow-text">Custom Tags & Libraries</h1>
            <p class="subtitle">Assignment Q11 & Q14: Create and develop custom tag libraries and tag files in JSP</p>
        </header>

        <div class="grid-2">
            
            <!-- Java Class Custom Tag (Q11 / Q14) -->
            <div class="card glass-card hover-glow">
                <h2>1. Java Tag Library (TLD-mapped)</h2>
                <p style="color: var(--text-muted); font-size: 0.8rem; margin-bottom: 25px;">
                    Defined in a Java Class extending <code>SimpleTagSupport</code> and declared in <code>custom.tld</code>.
                </p>

                <!-- Example 1: Default format -->
                <div style="background: rgba(255, 255, 255, 0.03); border: 1px solid rgba(255,255,255,0.05); padding: 15px; border-radius: 8px; margin-bottom: 20px;">
                    <span style="font-size: 0.78rem; color: var(--text-muted); display: block; font-family: monospace;">&lt;custom:currentDate /&gt;</span>
                    <span style="font-size: 1.05rem; font-weight: 600; color: var(--accent-secondary); margin-top: 5px; display: inline-block;">
                        <custom:currentDate />
                    </span>
                </div>

                <!-- Example 2: Custom format attribute passed -->
                <div style="background: rgba(255, 255, 255, 0.03); border: 1px solid rgba(255,255,255,0.05); padding: 15px; border-radius: 8px;">
                    <span style="font-size: 0.78rem; color: var(--text-muted); display: block; font-family: monospace;">&lt;custom:currentDate format="yyyy-MM-dd HH:mm:ss" /&gt;</span>
                    <span style="font-size: 1.05rem; font-weight: 600; color: var(--accent-primary); margin-top: 5px; display: inline-block; font-family: monospace;">
                        <custom:currentDate format="yyyy-MM-dd HH:mm:ss" />
                    </span>
                </div>
            </div>

            <!-- JSP Tag File (Q14) -->
            <div class="card glass-card hover-glow">
                <h2>2. JSP Tag File Components</h2>
                <p style="color: var(--text-muted); font-size: 0.8rem; margin-bottom: 25px;">
                    Defined dynamically inside a standalone <code>alert.tag</code> file under the <code>/WEB-INF/tags/</code> directory.
                </p>

                <!-- Alert Tag Demos -->
                <mytags:alert title="Database Connection Alert" type="success">
                    The tag file renders this success alert box with custom icons and gradients.
                </mytags:alert>

                <mytags:alert title="J2EE Deployment Warning" type="warning">
                    Make sure to restart Apache Tomcat if you modify TLD configurations.
                </mytags:alert>

                <mytags:alert title="System Error Occurred" type="danger">
                    Critical warning generated dynamically using the Tag File.
                </mytags:alert>
            </div>

        </div>

        <!-- Code Snippet Evaluation -->
        <div class="card glass-card" style="margin-top: 20px;">
            <h2>Tag Library Declaration & Syntax</h2>
            <p style="color: var(--text-secondary); font-size: 0.9rem; line-height: 1.5; margin-top: 10px;">
                To import and execute these tags inside a JSP, insert these directives at the top of the JSP file:
            </p>
            <div style="background: rgba(0, 0, 0, 0.3); padding: 15px; border-radius: 8px; font-family: monospace; font-size: 0.8rem; margin-top: 15px; color: #a5d6ff; border: 1px solid rgba(255, 255, 255, 0.05); overflow-x: auto; display: grid; gap: 8px;">
                <div>
                    <span style="color: #ff7b72;">&lt;&#37;@ taglib</span> <span style="color: #79c0ff;">uri</span>=<span style="color: #a5d6ff;">"http://skindisease.com/tags"</span> <span style="color: #79c0ff;">prefix</span>=<span style="color: #a5d6ff;">"custom"</span> <span style="color: #ff7b72;">&#37;&gt;</span>
                    <span style="color: #8b949e; margin-left: 15px;">&lt;!-- Loads custom.tld mapping --&gt;</span>
                </div>
                <div>
                    <span style="color: #ff7b72;">&lt;&#37;@ taglib</span> <span style="color: #79c0ff;">tagdir</span>=<span style="color: #a5d6ff;">"/WEB-INF/tags"</span> <span style="color: #79c0ff;">prefix</span>=<span style="color: #a5d6ff;">"mytags"</span> <span style="color: #ff7b72;">&#37;&gt;</span>
                    <span style="color: #8b949e; margin-left: 15px;">&lt;!-- Loads .tag files in tags/ --&gt;</span>
                </div>
            </div>
        </div>

    </div>

    <script src="js/app.js"></script>
</body>
</html>
