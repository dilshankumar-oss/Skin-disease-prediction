<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String httpSessionVal = (String) request.getAttribute("httpSessionVal");
    String cookieVal = (String) request.getAttribute("cookieVal");
    String hiddenFieldVal = (String) request.getAttribute("hiddenFieldVal");
    String urlRewritingVal = (String) request.getAttribute("urlRewritingVal");
    
    // Check main session for nav
    String username = (String) session.getAttribute("sessionUser");
    boolean isLoggedIn = (username != null);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Session Management Comparison | DermAnalysis</title>
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
                <li><a href="WelcomeServlet" class="active">Session Compare (Q5)</a></li>
                <li><a href="login.html" class="text-highlight">Switch User</a></li>
            </ul>
        </nav>

        <header>
            <h1 class="glow-text">Session Management Comparison</h1>
            <p class="subtitle">Demonstrating the 4 core state-preservation techniques in Java Servlets (Assignment Q5)</p>
        </header>

        <!-- Intro -->
        <div class="card glass-card">
            <h2>Understanding Session Tracking</h2>
            <p style="margin-top: 10px; color: var(--text-secondary);">
                HTTP is a stateless protocol. To track user context across multiple requests, developers use state management.
                Below, we inspect how our authentication servlet (<code>LoginServlet</code>) passed the username to this servlet (<code>WelcomeServlet</code>) using all 4 J2EE methodologies.
            </p>
        </div>

        <!-- Techniques Grid -->
        <div class="grid-2 mb-20">
            
            <!-- HttpSession -->
            <div class="card glass-card tech-card hover-glow">
                <div class="tech-header">
                    <h3>1. HttpSession API</h3>
                    <% if (httpSessionVal != null) { %>
                        <span class="badge badge-success">Active</span>
                    <% } else { %>
                        <span class="badge badge-danger">Null / Inactive</span>
                    <% } %>
                </div>
                <p style="color: var(--text-secondary); font-size: 0.9rem; margin-bottom: 20px;">
                    Saves user-specific objects in the server's memory. The server allocates a unique session ID (JSESSIONID) and links it to the client via temporary cookies or URL parameters.
                </p>
                <div style="margin-bottom: 15px; font-size: 0.85rem; color: var(--text-secondary);">
                    <b>Pros:</b> Highly secure, stores complex Java objects, server-managed.<br>
                    <b>Cons:</b> Consumes server RAM, requires session clustering for multi-server setups.
                </div>
                <div class="tech-value <%= httpSessionVal == null ? "missing" : "" %>">
                    <%= httpSessionVal != null ? "Value: " + httpSessionVal : "Value Not Present in Session" %>
                </div>
            </div>

            <!-- Cookies -->
            <div class="card glass-card tech-card hover-glow">
                <div class="tech-header">
                    <h3>2. HTTP Cookies</h3>
                    <% if (cookieVal != null) { %>
                        <span class="badge badge-success">Active</span>
                    <% } else { %>
                        <span class="badge badge-danger">Null / Disabled</span>
                    <% } %>
                </div>
                <p style="color: var(--text-secondary); font-size: 0.9rem; margin-bottom: 20px;">
                    Small text files stored directly on the client's browser. With each HTTP request, the browser automatically attaches all relevant cookies in the request header.
                </p>
                <div style="margin-bottom: 15px; font-size: 0.85rem; color: var(--text-secondary);">
                    <b>Pros:</b> Persists across browser restarts, reduces server memory load.<br>
                    <b>Cons:</b> Vulnerable to tampering, limit of 4KB size, users can disable cookies.
                </div>
                <div class="tech-value <%= cookieVal == null ? "missing" : "" %>">
                    <%= cookieVal != null ? "Value: " + cookieVal : "Cookie 'cookieUser' Not Found" %>
                </div>
            </div>

            <!-- Hidden Fields -->
            <div class="card glass-card tech-card hover-glow">
                <div class="tech-header">
                    <h3>3. Hidden Form Fields</h3>
                    <% if (hiddenFieldVal != null) { %>
                        <span class="badge badge-success">Active</span>
                    <% } else { %>
                        <span class="badge badge-warning">Active on Form POST only</span>
                    <% } %>
                </div>
                <p style="color: var(--text-secondary); font-size: 0.9rem; margin-bottom: 20px;">
                    Uses hidden input tags <code>&lt;input type="hidden"&gt;</code> inside HTML forms. Values are sent to the server when the user submits/posts the form.
                </p>
                <div style="margin-bottom: 15px; font-size: 0.85rem; color: var(--text-secondary);">
                    <b>Pros:</b> Works even if cookies are disabled, no server memory footprint.<br>
                    <b>Cons:</b> Only works with form submissions (POST/GET), data is lost on clicking static links.
                </div>
                <div class="tech-value <%= hiddenFieldVal == null ? "missing" : "" %>">
                    <%= hiddenFieldVal != null ? "Value: " + hiddenFieldVal : "No POST Form Field submitted" %>
                </div>
            </div>

            <!-- URL Rewriting -->
            <div class="card glass-card tech-card hover-glow">
                <div class="tech-header">
                    <h3>4. URL Rewriting</h3>
                    <% if (urlRewritingVal != null) { %>
                        <span class="badge badge-success">Active</span>
                    <% } else { %>
                        <span class="badge badge-warning">Active on Parameter GET only</span>
                    <% } %>
                </div>
                <p style="color: var(--text-secondary); font-size: 0.9rem; margin-bottom: 20px;">
                    Appends user information directly onto the query string of destination URLs (e.g. <code>WelcomeServlet?urlUser=name</code>).
                </p>
                <div style="margin-bottom: 15px; font-size: 0.85rem; color: var(--text-secondary);">
                    <b>Pros:</b> Independent of cookies, works with simple hyperlinks.<br>
                    <b>Cons:</b> Exposes sensitive data in browser history, bookmarks, and logs; text-only parameters.
                </div>
                <div class="tech-value <%= urlRewritingVal == null ? "missing" : "" %>">
                    <%= urlRewritingVal != null ? "Value: " + urlRewritingVal : "Parameter 'urlUser' absent in link query" %>
                </div>
            </div>
            
        </div>

        <div class="card glass-card">
            <h2>Detailed Evaluation Table</h2>
            <div class="table-wrapper" style="margin-top: 20px;">
                <table>
                    <thead>
                        <tr>
                            <th>Parameter</th>
                            <th>HttpSession</th>
                            <th>Cookie</th>
                            <th>Hidden Field</th>
                            <th>URL Rewriting</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><b>Stored Value</b></td>
                            <td><span class="text-highlight"><%= httpSessionVal != null ? httpSessionVal : "null" %></span></td>
                            <td><span class="text-highlight"><%= cookieVal != null ? cookieVal : "null" %></span></td>
                            <td><span class="text-highlight"><%= hiddenFieldVal != null ? hiddenFieldVal : "null" %></span></td>
                            <td><span class="text-highlight"><%= urlRewritingVal != null ? urlRewritingVal : "null" %></span></td>
                        </tr>
                        <tr>
                            <td><b>Storage Location</b></td>
                            <td>Server Memory</td>
                            <td>Client Browser File</td>
                            <td>HTML Document DOM</td>
                            <td>Request Query String</td>
                        </tr>
                        <tr>
                            <td><b>Data Persistence</b></td>
                            <td>Until session timeout</td>
                            <td>Set by MaxAge parameter</td>
                            <td>Only single page load</td>
                            <td>Only current hyperlink click</td>
                        </tr>
                        <tr>
                            <td><b>Security Level</b></td>
                            <td>High (Encrypted on Server)</td>
                            <td>Medium-Low (Clear text on client)</td>
                            <td>Low (Visible in Page Source)</td>
                            <td>Very Low (Visible in URL Bar)</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="text-center mt-20">
                <a href="login.html" class="btn btn-secondary">Switch Authenticated User Credentials</a>
            </div>
        </div>

    </div>

    <script src="js/app.js"></script>
</body>
</html>
