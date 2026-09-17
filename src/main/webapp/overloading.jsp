<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String shape = request.getParameter("shape");
    Double areaResult = null;
    String calculationDetails = null;
    String error = null;

    // Inputs
    String radiusStr = request.getParameter("radius");
    String lengthStr = request.getParameter("length");
    String widthStr = request.getParameter("width");

    if (shape != null) {
        try {
            if ("circle".equals(shape)) {
                if (radiusStr != null && !radiusStr.trim().isEmpty()) {
                    double r = Double.parseDouble(radiusStr);
                    if (r < 0) {
                        error = "Radius cannot be negative.";
                    } else {
                        // Call overloaded method 1
                        areaResult = calculateArea(r);
                        calculationDetails = "Area = π × r² = 3.14159 × " + r + "²";
                    }
                } else {
                    error = "Please enter a radius.";
                }
            } else if ("rectangle".equals(shape)) {
                if (lengthStr != null && !lengthStr.trim().isEmpty() && widthStr != null && !widthStr.trim().isEmpty()) {
                    double l = Double.parseDouble(lengthStr);
                    double w = Double.parseDouble(widthStr);
                    if (l < 0 || w < 0) {
                        error = "Length and Width cannot be negative.";
                    } else {
                        // Call overloaded method 2
                        areaResult = calculateArea(l, w);
                        calculationDetails = "Area = Length × Width = " + l + " × " + w;
                    }
                } else {
                    error = "Please enter both length and width.";
                }
            }
        } catch (NumberFormatException e) {
            error = "Invalid inputs. Please enter valid decimal values.";
        }
    }

    // Session state check for nav
    String username = (String) session.getAttribute("sessionUser");
    boolean isLoggedIn = (username != null);
%>
<%!
    /**
     * Overloaded Method 1: Calculates area of a circle.
     */
    public double calculateArea(double radius) {
        return Math.PI * radius * radius;
    }

    /**
     * Overloaded Method 2: Calculates area of a rectangle.
     */
    public double calculateArea(double length, double width) {
        return length * width;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JSP Overloading (Q9) | DermAnalysis</title>
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
            <h1 class="glow-text">Method Overloading in JSP</h1>
            <p class="subtitle">Assignment Q9: Create JSP program to implement Overloading in JSP</p>
        </header>

        <div class="grid-2">
            
            <!-- Circle Form Card -->
            <div class="card glass-card hover-glow">
                <h2>Circle Area (Method Signature 1)</h2>
                <p style="color: var(--text-secondary); margin-bottom: 20px; font-size: 0.9rem;">
                    Calls the overloaded method signature: <br><code>double calculateArea(double radius)</code>
                </p>

                <form action="overloading.jsp" method="GET">
                    <input type="hidden" name="shape" value="circle">
                    
                    <div class="form-group">
                        <label for="radius">Radius (r)</label>
                        <input type="number" id="radius" name="radius" step="any" min="0" placeholder="e.g. 7.5" required>
                    </div>

                    <button type="submit" class="btn btn-primary btn-block">
                        Calculate Circle Area
                    </button>
                </form>
            </div>

            <!-- Rectangle Form Card -->
            <div class="card glass-card hover-glow">
                <h2>Rectangle Area (Method Signature 2)</h2>
                <p style="color: var(--text-secondary); margin-bottom: 20px; font-size: 0.9rem;">
                    Calls the overloaded method signature: <br><code>double calculateArea(double length, double width)</code>
                </p>

                <form action="overloading.jsp" method="GET">
                    <input type="hidden" name="shape" value="rectangle">
                    
                    <div class="form-group">
                        <label for="length">Length</label>
                        <input type="number" id="length" name="length" step="any" min="0" placeholder="e.g. 10.0" required>
                    </div>

                    <div class="form-group">
                        <label for="width">Width</label>
                        <input type="number" id="width" name="width" step="any" min="0" placeholder="e.g. 5.5" required>
                    </div>

                    <button type="submit" class="btn btn-primary btn-block">
                        Calculate Rectangle Area
                    </button>
                </form>
            </div>

        </div>

        <% if (error != null) { %>
            <div class="badge badge-danger" style="margin: 20px auto; max-width: 600px; display: block; padding: 12px; border-radius: 8px; text-align: center;">
                <%= error %>
            </div>
        <% } else if (areaResult != null) { %>
            <div class="card glass-card" style="margin: 20px auto; max-width: 600px; text-align: center;">
                <h2>Calculation Results</h2>
                <div class="badge badge-success" style="margin-top: 15px; display: block; padding: 20px; border-radius: 8px; font-size: 1.15rem;">
                    Calculated Area: <span style="font-family: monospace; font-weight: 700;"><%= String.format("%.4f", areaResult) %></span>
                </div>
                <p style="margin-top: 15px; font-family: monospace; color: var(--text-secondary); font-size: 0.9rem;">
                    <%= calculationDetails %>
                </p>
            </div>
        <% } %>

        <!-- Explanation Card -->
        <div class="card glass-card" style="margin-top: 20px;">
            <h3>Java Compilation Concept: Compile-Time Polymorphism</h3>
            <p style="color: var(--text-secondary); font-size: 0.92rem; line-height: 1.5; margin-top: 10px;">
                Method overloading allows a class to have multiple methods having the same name, if their parameter lists are different (either by type, number, or order of parameters). At compile-time, the Java compiler matches the method call with the appropriate signature:
            </p>
            <div style="background: rgba(0, 0, 0, 0.3); padding: 15px; border-radius: 8px; font-family: monospace; font-size: 0.8rem; margin-top: 15px; color: #a5d6ff; border: 1px solid rgba(255, 255, 255, 0.05); overflow-x: auto;">
                <span style="color: #8b949e;">// Compiled Method Signatures inside Servlet</span><br>
                <span style="color: #ff7b72;">public double</span> <span style="color: #d2a8ff;">calculateArea</span>(<span style="color: #ff7b72;">double</span> radius) { ... } <span style="color: #8b949e;">// Signature 1</span><br>
                <span style="color: #ff7b72;">public double</span> <span style="color: #d2a8ff;">calculateArea</span>(<span style="color: #ff7b72;">double</span> length, <span style="color: #ff7b72;">double</span> width) { ... } <span style="color: #8b949e;">// Signature 2</span>
            </div>
        </div>

    </div>

    <script src="js/app.js"></script>
</body>
</html>
