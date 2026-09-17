<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.skindisease.model.Student" %>
<%
    List<Student> listStudent = (List<Student>) request.getAttribute("listStudent");
    Student editStudent = (Student) request.getAttribute("student");
    Boolean usingMockObj = (Boolean) request.getAttribute("usingMock");
    boolean usingMock = (usingMockObj != null && usingMockObj);
    String dbError = (String) request.getAttribute("dbError");
    
    // Check session
    String username = (String) session.getAttribute("sessionUser");
    boolean isLoggedIn = (username != null);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Records (Q6) | DermAnalysis</title>
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
                <li><a href="StudentServlet?action=list" class="active">Student Database (Q6)</a></li>
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
            <h1 class="glow-text">Student Records Database</h1>
            <p class="subtitle">Assignment Q6: Connecting to DB using JDBC, fetching and altering records (SELECT, INSERT, UPDATE, DELETE)</p>
        </header>

        <!-- Status Alerts -->
        <% if (usingMock) { %>
            <div class="alert alert-warning">
                <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"></path>
                </svg>
                <div>
                    <b>Resilient Mock Sandbox Active:</b> Could not reach Oracle database. 
                    <%= dbError != null ? "Error: " + dbError : "" %>
                    <br><span style="font-size: 0.82rem; opacity: 0.8;">The application is running in-memory for testing purposes. Changes will persist until application restarts.</span>
                </div>
            </div>
        <% } else { %>
            <div class="alert alert-success">
                <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"></path>
                </svg>
                <div>
                    <b>Oracle Database Connected:</b> Student transactions are writing directly to the Oracle <code>STUDENT</code> table via JDBC.
                </div>
            </div>
        <% } %>

        <div class="dashboard-layout">
            
            <!-- Side Form (Insert / Update) -->
            <div class="card glass-card">
                <h2><%= editStudent != null ? "Edit Student Details" : "Register New Student" %></h2>
                <p style="color: var(--text-muted); font-size: 0.8rem; margin-bottom: 20px;">
                    Saves to the <code>STUDENT</code> database table.
                </p>
                
                <form action="StudentServlet" method="POST">
                    <input type="hidden" name="action" value="<%= editStudent != null ? "update" : "insert" %>">
                    <% if (editStudent != null) { %>
                        <input type="hidden" name="id" value="<%= editStudent.getId() %>">
                    <% } %>

                    <div class="form-group">
                        <label for="name">Full Name</label>
                        <input type="text" id="name" name="name" value="<%= editStudent != null ? editStudent.getName() : "" %>" placeholder="Enter student name" required>
                    </div>

                    <div class="form-group">
                        <label for="email">Email Address</label>
                        <input type="email" id="email" name="email" value="<%= editStudent != null ? editStudent.getEmail() : "" %>" placeholder="username@university.edu" required>
                    </div>

                    <div class="form-group">
                        <label for="department">Academic Department</label>
                        <select id="department" name="department" required>
                            <option value="" disabled <%= editStudent == null ? "selected" : "" %>>Choose department...</option>
                            <option value="Computer Science" <%= editStudent != null && "Computer Science".equals(editStudent.getDepartment()) ? "selected" : "" %>>Computer Science</option>
                            <option value="Information Technology" <%= editStudent != null && "Information Technology".equals(editStudent.getDepartment()) ? "selected" : "" %>>Information Technology</option>
                            <option value="Electronics" <%= editStudent != null && "Electronics".equals(editStudent.getDepartment()) ? "selected" : "" %>>Electronics</option>
                            <option value="Mechanical Engineering" <%= editStudent != null && "Mechanical Engineering".equals(editStudent.getDepartment()) ? "selected" : "" %>>Mechanical Engineering</option>
                            <option value="Electrical Engineering" <%= editStudent != null && "Electrical Engineering".equals(editStudent.getDepartment()) ? "selected" : "" %>>Electrical Engineering</option>
                        </select>
                    </div>

                    <button type="submit" class="btn btn-primary btn-block mb-20">
                        <%= editStudent != null ? "Update Record" : "Add Student Record" %>
                    </button>
                    
                    <% if (editStudent != null) { %>
                        <a href="StudentServlet?action=list" class="btn btn-secondary btn-block block">Cancel Editing</a>
                    <% } %>
                </form>
            </div>

            <!-- List Panel (Select) -->
            <div class="card glass-card">
                <h2>All Student Records</h2>
                <p style="color: var(--text-muted); font-size: 0.8rem; margin-bottom: 20px;">
                    Executes a <code>SELECT * FROM STUDENT ORDER BY id ASC</code> query.
                </p>
                
                <div class="table-wrapper">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Department</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (listStudent == null || listStudent.isEmpty()) { %>
                                <tr>
                                    <td colspan="5" class="text-center" style="padding: 30px;">
                                        No student records found. Insert a record to begin!
                                    </td>
                                </tr>
                            <% } else {
                                for (Student s : listStudent) { %>
                                    <tr>
                                        <td><span class="text-highlight"><%= s.getId() %></span></td>
                                        <td><b><%= s.getName() %></b></td>
                                        <td><%= s.getEmail() %></td>
                                        <td>
                                            <span class="badge badge-info"><%= s.getDepartment() %></span>
                                        </td>
                                        <td>
                                            <div class="flex gap-10">
                                                <a href="StudentServlet?action=showEditForm&action=edit&id=<%= s.getId() %>" class="btn btn-secondary btn-sm">Edit</a>
                                                <a href="StudentServlet?action=delete&id=<%= s.getId() %>" 
                                                   class="btn btn-danger btn-sm btn-delete-confirm" 
                                                   data-name="<%= s.getName() %>">Delete</a>
                                            </div>
                                        </td>
                                    </tr>
                            <%  }
                               } %>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>

    </div>

    <script src="js/app.js"></script>
</body>
</html>
