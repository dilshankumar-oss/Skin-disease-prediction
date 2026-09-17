<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.skindisease.db.DBConnection" %>
<%@ page import="com.skindisease.model.Student" %>
<%
    String action = request.getParameter("directAction");
    String error = null;
    String success = null;

    // 1. Handle Login Form Submission
    if ("login".equalsIgnoreCase(action)) {
        String user = request.getParameter("username");
        String pass = request.getParameter("password");
        
        if (user != null && pass != null) {
            boolean valid = false;
            
            // Validate credentials against LOGIN table
            try {
                Connection conn = DBConnection.getConnection();
                String sql = "SELECT * FROM LOGIN WHERE username = ? AND password = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, user);
                stmt.setString(2, pass);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    valid = true;
                }
                DBConnection.close(conn, stmt, rs);
            } catch (Exception e) {
                e.printStackTrace();
                // Fallback credential check for mock environment
                if ("admin".equals(user) && "admin123".equals(pass)) {
                    valid = true;
                } else {
                    error = "Database offline and credentials did not match fallback (admin/admin123).";
                }
            }
            
            if (valid) {
                session.setAttribute("studentDirectAuth", user);
                success = "Logged in successfully!";
            } else if (error == null) {
                error = "Invalid username or password.";
            }
        }
    }

    // 2. Handle Logout
    if ("logout".equalsIgnoreCase(action)) {
        session.removeAttribute("studentDirectAuth");
        success = "Logged out successfully.";
    }

    // 3. Handle Direct JDBC Student Insert
    String isAuth = (String) session.getAttribute("studentDirectAuth");
    if (isAuth != null && "insertStudent".equalsIgnoreCase(action)) {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String dep = request.getParameter("department");
        
        if (name != null && email != null && dep != null) {
            try {
                Connection conn = DBConnection.getConnection();
                String sql = "INSERT INTO STUDENT (name, email, department) VALUES (?, ?, ?)";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, name);
                stmt.setString(2, email);
                stmt.setString(3, dep);
                int rows = stmt.executeUpdate();
                stmt.close();
                conn.close();
                if (rows > 0) {
                    success = "Successfully inserted student '" + name + "' into STUDENT table via JSP JDBC!";
                }
            } catch (Exception e) {
                e.printStackTrace();
                error = "Failed to insert into Oracle database: " + e.getMessage() + ". (Note: JDBC actions run within JSP scriptlets).";
            }
        }
    }

    // General session state check for nav
    String usernameNav = (String) session.getAttribute("sessionUser");
    boolean isLoggedInNav = (usernameNav != null);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JSP Direct Insert (Q12) | DermAnalysis</title>
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
                <% if (isLoggedInNav) { %>
                    <li><a href="WelcomeServlet">Session Compare (Q5)</a></li>
                    <li><a href="login.html" class="text-highlight">Switch User</a></li>
                <% } else { %>
                    <li><a href="login.html" class="text-highlight">Login / Signup</a></li>
                <% } %>
            </ul>
        </nav>

        <header>
            <h1 class="glow-text">JSP Direct Database Insertion</h1>
            <p class="subtitle">Assignment Q12: Create login page and insert values using JSP program into student's table</p>
        </header>

        <!-- Status Alerts -->
        <% if (error != null) { %>
            <div class="alert alert-danger" style="margin-bottom: 20px;">
                <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                </svg>
                <div><b>Error:</b> <%= error %></div>
            </div>
        <% } %>

        <% if (success != null) { %>
            <div class="alert alert-success" style="margin-bottom: 20px;">
                <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"></path>
                </svg>
                <div><b>Success:</b> <%= success %></div>
            </div>
        <% } %>

        <div style="max-width: 600px; margin: 0 auto;">
            
            <% if (isAuth == null) { %>
                
                <!-- LOGIN FORM -->
                <div class="card glass-card">
                    <h2>Authentication Gateway</h2>
                    <p style="color: var(--text-muted); font-size: 0.8rem; margin-bottom: 20px;">
                        Credentials validated directly against the <code>LOGIN</code> table in Oracle using inline JSP database queries. (Try username: <b>admin</b>, password: <b>admin123</b>).
                    </p>

                    <form action="student-direct-insert.jsp" method="POST">
                        <input type="hidden" name="directAction" value="login">

                        <div class="form-group">
                            <label for="username">Username</label>
                            <input type="text" id="username" name="username" placeholder="Enter database username" required>
                        </div>

                        <div class="form-group">
                            <label for="password">Password</label>
                            <input type="password" id="password" name="password" placeholder="Enter database password" required>
                        </div>

                        <button type="submit" class="btn btn-primary btn-block">
                            Log In via JSP
                        </button>
                    </form>
                </div>

            <% } else { %>
                
                <!-- STUDENT DIRECT INSERT FORM -->
                <div class="card glass-card">
                    <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid rgba(255,255,255,0.05); padding-bottom: 15px; margin-bottom: 20px;">
                        <div>
                            <h2>Insert Student Record</h2>
                            <span style="font-size: 0.8rem; color: var(--accent-success);">Authenticated: <%= isAuth %></span>
                        </div>
                        <a href="student-direct-insert.jsp?directAction=logout" class="btn btn-danger btn-sm" style="padding: 6px 12px;">Log Out</a>
                    </div>
                    
                    <p style="color: var(--text-muted); font-size: 0.8rem; margin-bottom: 20px;">
                        Inserts records directly into the <code>STUDENT</code> table using inline JSP database operations (no Servlets).
                    </p>

                    <form action="student-direct-insert.jsp" method="POST">
                        <input type="hidden" name="directAction" value="insertStudent">

                        <div class="form-group">
                            <label for="name">Student Full Name</label>
                            <input type="text" id="name" name="name" placeholder="e.g. Charlie Brown" required>
                        </div>

                        <div class="form-group">
                            <label for="email">Student Email Address</label>
                            <input type="email" id="email" name="email" placeholder="charlie@university.edu" required>
                        </div>

                        <div class="form-group">
                            <label for="department">Academic Department</label>
                            <select id="department" name="department" required>
                                <option value="Computer Science" selected>Computer Science</option>
                                <option value="Information Technology">Information Technology</option>
                                <option value="Electronics">Electronics</option>
                                <option value="Mechanical Engineering">Mechanical Engineering</option>
                            </select>
                        </div>

                        <button type="submit" class="btn btn-primary btn-block">
                            Insert Record via JSP JDBC
                        </button>
                    </form>
                </div>

            <% } %>

            <!-- Educational Card -->
            <div class="card glass-card hover-glow" style="margin-top: 20px;">
                <h3>Direct Database Operations in JSP</h3>
                <p style="color: var(--text-secondary); font-size: 0.88rem; line-height: 1.5; margin-top: 10px;">
                    While Model-View-Controller (MVC) pattern delegates database execution to Servlets, JSP files are capable of executing JDBC directly using Java scriptlets. This is useful for simple scripts, but generally avoided in enterprise design due to lack of separation of concerns.
                </p>
                <div style="background: rgba(0, 0, 0, 0.3); padding: 12px; border-radius: 8px; font-family: monospace; font-size: 0.78rem; margin-top: 15px; color: #a5d6ff; border: 1px solid rgba(255, 255, 255, 0.05); overflow-x: auto;">
                    <span style="color: #ff7b72;">&lt;%</span><br>
                    &nbsp;&nbsp;&nbsp;&nbsp;Connection conn = DBConnection.getConnection();<br>
                    &nbsp;&nbsp;&nbsp;&nbsp;String sql = <span style="color: #a5d6ff;">"INSERT INTO STUDENT ..."</span>;<br>
                    &nbsp;&nbsp;&nbsp;&nbsp;PreparedStatement stmt = conn.prepareStatement(sql);<br>
                    &nbsp;&nbsp;&nbsp;&nbsp;stmt.executeUpdate();<br>
                    <span style="color: #ff7b72;">%&gt;</span>
                </div>
            </div>

        </div>

    </div>

    <script src="js/app.js"></script>
</body>
</html>
