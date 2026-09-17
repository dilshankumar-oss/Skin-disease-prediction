<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String numStr = request.getParameter("num");
    Long result = null;
    Integer number = null;
    String error = null;

    if (numStr != null && !numStr.trim().isEmpty()) {
        try {
            number = Integer.parseInt(numStr);
            if (number < 0) {
                error = "Factorial is not defined for negative numbers.";
            } else if (number > 20) {
                // Factorial > 20 exceeds the limits of standard 64-bit signed integer (long)
                error = "Please enter a number between 0 and 20 to prevent numeric overflow.";
            } else {
                result = calculateFactorial(number);
            }
        } catch (NumberFormatException e) {
            error = "Invalid input. Please enter a valid integer.";
        }
    }
    
    // Session state check for nav
    String username = (String) session.getAttribute("sessionUser");
    boolean isLoggedIn = (username != null);
%>
<%! 
    /**
     * Recursive method to calculate the factorial of a number.
     * Defined using a JSP declaration tag.
     */
    public long calculateFactorial(int n) {
        if (n <= 1) {
            return 1;
        }
        return n * calculateFactorial(n - 1);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JSP Factorial (Q8) | DermAnalysis</title>
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
            <h1 class="glow-text">Factorial Calculator</h1>
            <p class="subtitle">Assignment Q8: Create JSP program to find the factorial of any given number using a function</p>
        </header>

        <div style="max-width: 600px; margin: 0 auto;">
            
            <div class="card glass-card">
                <h2>Calculate Factorial</h2>
                <p style="color: var(--text-secondary); margin-bottom: 20px; font-size: 0.9rem;">
                    This program utilizes a JSP declaration block <code>&lt;%! ... %&gt;</code> to define a recursive Java function on the compiled servlet. Enter a number to compute.
                </p>

                <form action="factorial.jsp" method="GET">
                    <div class="form-group">
                        <label for="num">Enter an Integer (0 - 20)</label>
                        <input type="number" id="num" name="num" min="0" max="20" value="<%= number != null ? number : "" %>" placeholder="e.g. 5" required>
                    </div>

                    <button type="submit" class="btn btn-primary btn-block">
                        Compute Factorial
                    </button>
                </form>

                <% if (error != null) { %>
                    <div class="badge badge-danger" style="margin-top: 20px; display: block; padding: 12px; border-radius: 8px; text-align: center;">
                        <%= error %>
                    </div>
                <% } else if (result != null) { %>
                    <div class="badge badge-success" style="margin-top: 20px; display: block; padding: 20px; border-radius: 8px; text-align: center; font-size: 1.1rem;">
                        Result: <span style="font-family: monospace; font-weight: 700; letter-spacing: 0.5px;"><%= number %>! = <%= result %></span>
                    </div>
                    
                    <div style="background: rgba(0, 0, 0, 0.2); margin-top: 20px; padding: 15px; border-radius: 8px; border-left: 3px solid var(--accent-success); font-family: monospace; font-size: 0.8rem; color: var(--text-secondary);">
                        <b>Code execution block:</b><br>
                        <%
                            StringBuilder calcSteps = new StringBuilder();
                            for (int i = number; i >= 1; i--) {
                                calcSteps.append(i);
                                if (i > 1) calcSteps.append(" × ");
                            }
                            if (number == 0) calcSteps.append("1 (by definition)");
                        %>
                        <%= number %>! = <%= calcSteps.toString() %> = <%= result %>
                    </div>
                <% } %>
            </div>

            <!-- JSP Code Explanation Card -->
            <div class="card glass-card hover-glow" style="margin-top: 20px;">
                <h3>Under the Hood: JSP Declarations</h3>
                <p style="color: var(--text-secondary); font-size: 0.88rem; line-height: 1.5; margin-top: 10px;">
                    JSP declarations are defined using <code>&lt;%! ... %&gt;</code> syntax. Elements defined here become member variables and methods of the compiled Servlet class, rather than local inside the <code>_jspService()</code> method.
                </p>
                <div style="background: rgba(0, 0, 0, 0.3); padding: 12px; border-radius: 8px; font-family: monospace; font-size: 0.78rem; margin-top: 15px; color: #a5d6ff; border: 1px solid rgba(255, 255, 255, 0.05);">
                    <span style="color: #ff7b72;">&lt;%!</span> <br>
                    &nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #ff7b72;">public long</span> <span style="color: #d2a8ff;">calculateFactorial</span>(<span style="color: #ff7b72;">int</span> n) {<br>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #ff7b72;">if</span> (n &lt;= <span style="color: #79c0ff;">1</span>) <span style="color: #ff7b72;">return</span> <span style="color: #79c0ff;">1</span>;<br>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="color: #ff7b72;">return</span> n * <span style="color: #d2a8ff;">calculateFactorial</span>(n - <span style="color: #79c0ff;">1</span>);<br>
                    &nbsp;&nbsp;&nbsp;&nbsp;}<br>
                    <span style="color: #ff7b72;">%&gt;</span>
                </div>
            </div>

        </div>

    </div>

    <script src="js/app.js"></script>
</body>
</html>
