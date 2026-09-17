<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    <title>JSP Bean Display (Q10) | DermAnalysis</title>
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
            <h1 class="glow-text">JSP JavaBean display</h1>
            <p class="subtitle">Assignment Q10: Create JSP program to display parameter values using &lt;jsp:useBean&gt; Tag</p>
        </header>

        <!-- Instantiate the JavaBean and populate properties dynamically from request params -->
        <jsp:useBean id="paramBean" class="com.skindisease.model.ParameterBean" scope="request" />
        <jsp:setProperty name="paramBean" property="*" />

        <div class="grid-2">
            
            <!-- Parameters Entry Form -->
            <div class="card glass-card">
                <h2>Submit Client Feedback Parameters</h2>
                <p style="color: var(--text-muted); font-size: 0.8rem; margin-bottom: 20px;">
                    This form submits values which are mapped to the JavaBean automatically.
                </p>

                <form action="usebean.jsp" method="POST">
                    <div class="form-group">
                        <label for="clientName">Client Name</label>
                        <input type="text" id="clientName" name="clientName" placeholder="Enter your name" required>
                    </div>

                    <div class="form-group">
                        <label for="clientSystem">Operating System</label>
                        <select id="clientSystem" name="clientSystem" required>
                            <option value="Windows 11">Windows 11</option>
                            <option value="macOS Sequoia">macOS Sequoia</option>
                            <option value="Linux/Ubuntu">Linux/Ubuntu</option>
                            <option value="iOS/Android Mobile">iOS/Android Mobile</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="rating">Satisfaction Rating (1 - 5 Stars)</label>
                        <select id="rating" name="rating" required>
                            <option value="5">★★★★★ - Excellent</option>
                            <option value="4">★★★★☆ - Very Good</option>
                            <option value="3">★★★☆☆ - Average</option>
                            <option value="2">★★☆☆☆ - Poor</option>
                            <option value="1">★☆☆☆☆ - Terribile</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="clientFeedback">System Comments / Feedback</label>
                        <textarea id="clientFeedback" name="clientFeedback" rows="3" placeholder="How is the J2EE interface?" required></textarea>
                    </div>

                    <button type="submit" class="btn btn-primary btn-block">
                        Submit and Populate JavaBean
                    </button>
                </form>
            </div>

            <!-- Bean Display Results Panel -->
            <div class="card glass-card">
                <h2>Active Bean Inspection Status</h2>
                <p style="color: var(--text-muted); font-size: 0.8rem; margin-bottom: 20px;">
                    Outputs the JavaBean values using standard <code>&lt;jsp:getProperty&gt;</code> tags.
                </p>

                <!-- Check if the bean values are populated -->
                <%
                    boolean hasData = paramBean.getClientName() != null && !paramBean.getClientName().trim().isEmpty();
                %>

                <% if (!hasData) { %>
                    <div style="padding: 40px 20px; text-align: center; color: var(--text-secondary);">
                        <svg width="48" height="48" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" style="opacity: 0.4; margin-bottom: 15px; display: inline-block;">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"></path>
                        </svg>
                        <p>No feedback parameters loaded into request scope yet.</p>
                        <p style="font-size: 0.8rem; color: var(--text-muted); margin-top: 5px;">Fill out and submit the parameters form on the left to see the JSP binding in action.</p>
                    </div>
                <% } else { %>
                    <div style="background: rgba(0, 0, 0, 0.2); padding: 15px; border-radius: 8px; border-left: 3px solid var(--accent-success); margin-bottom: 20px; font-size: 0.85rem; color: var(--accent-success);">
                        <b>Success!</b> Bean properties were successfully set using introspection.
                    </div>

                    <div style="display: grid; gap: 15px;">
                        <div style="border-bottom: 1px solid rgba(255,255,255,0.05); padding-bottom: 10px;">
                            <span style="font-size: 0.8rem; color: var(--text-muted); display: block;">&lt;jsp:getProperty name="paramBean" property="clientName" /&gt;</span>
                            <span style="font-size: 1.05rem; font-weight: 600; color: var(--text-primary);"><jsp:getProperty name="paramBean" property="clientName" /></span>
                        </div>

                        <div style="border-bottom: 1px solid rgba(255,255,255,0.05); padding-bottom: 10px;">
                            <span style="font-size: 0.8rem; color: var(--text-muted); display: block;">&lt;jsp:getProperty name="paramBean" property="clientSystem" /&gt;</span>
                            <span style="font-size: 1.05rem; font-weight: 600; color: var(--text-primary);"><jsp:getProperty name="paramBean" property="clientSystem" /></span>
                        </div>

                        <div style="border-bottom: 1px solid rgba(255,255,255,0.05); padding-bottom: 10px;">
                            <span style="font-size: 0.8rem; color: var(--text-muted); display: block;">&lt;jsp:getProperty name="paramBean" property="rating" /&gt;</span>
                            <span style="font-size: 1.05rem; font-weight: 600; color: var(--accent-secondary);"><jsp:getProperty name="paramBean" property="rating" /> / 5 Stars</span>
                        </div>

                        <div style="padding-bottom: 10px;">
                            <span style="font-size: 0.8rem; color: var(--text-muted); display: block;">&lt;jsp:getProperty name="paramBean" property="clientFeedback" /&gt;</span>
                            <blockquote style="font-size: 0.95rem; font-style: italic; color: var(--text-secondary); margin-top: 5px; border-left: 2px solid var(--accent-primary); padding-left: 10px;">
                                "<jsp:getProperty name="paramBean" property="clientFeedback" />"
                            </blockquote>
                        </div>
                    </div>

                    <div style="background: rgba(0,0,0,0.3); border-radius: 8px; padding: 15px; margin-top: 15px; font-family: monospace; font-size: 0.78rem;">
                        <b>Bean toString() output:</b><br>
                        <span style="color: var(--text-muted); word-break: break-all;"><%= paramBean.toString() %></span>
                    </div>
                <% } %>
            </div>

        </div>

        <!-- Educational Card -->
        <div class="card glass-card" style="margin-top: 20px;">
            <h3>Introspection Mechanics in JSP</h3>
            <p style="color: var(--text-secondary); font-size: 0.92rem; line-height: 1.5; margin-top: 10px;">
                Using <code>&lt;jsp:setProperty name="bean" property="*" /&gt;</code> triggers the container to perform reflection. For each request parameter name, it matches it with the bean setter method (e.g., matching the form input <code>clientName</code> with the method <code>setClientName(String)</code>). This pattern eliminates standard scriptlet request parsing lines like <code>request.getParameter(...)</code>.
            </p>
        </div>

    </div>

    <script src="js/app.js"></script>
</body>
</html>
