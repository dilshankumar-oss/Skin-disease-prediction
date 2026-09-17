<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.skindisease.model.Todo" %>
<%
    List<Todo> listTodo = (List<Todo>) request.getAttribute("listTodo");
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
    <title>To-Do List (Q7) | DermAnalysis</title>
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
            <h1 class="glow-text">Task Manager & To-Do List</h1>
            <p class="subtitle">Assignment Q7: Case Study on developing a To-Do List Application using Servlets and JDBC</p>
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
                    <b>Oracle Database Connected:</b> Task records are writing directly to the Oracle <code>TODO</code> table via JDBC.
                </div>
            </div>
        <% } %>

        <div class="dashboard-layout">
            
            <!-- Side Form (Insert) -->
            <div class="card glass-card">
                <h2>Add New Task</h2>
                <p style="color: var(--text-muted); font-size: 0.8rem; margin-bottom: 20px;">
                    Insert a new task into the To-Do list.
                </p>
                
                <form action="TodoServlet" method="POST">
                    <input type="hidden" name="action" value="insert">

                    <div class="form-group">
                        <label for="task">Task Description</label>
                        <input type="text" id="task" name="task" placeholder="Enter what needs to be done..." required>
                    </div>

                    <div class="form-group">
                        <label for="status">Initial Status</label>
                        <select id="status" name="status" required>
                            <option value="Pending" selected>Pending</option>
                            <option value="Completed">Completed</option>
                        </select>
                    </div>

                    <button type="submit" class="btn btn-primary btn-block mb-20">
                        Create Task
                    </button>
                </form>
            </div>

            <!-- List Panel (Select) -->
            <div class="card glass-card">
                <h2>Your Tasks</h2>
                <p style="color: var(--text-muted); font-size: 0.8rem; margin-bottom: 20px;">
                    Executes a <code>SELECT * FROM TODO ORDER BY id ASC</code> query.
                </p>
                
                <div class="table-wrapper">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Task Description</th>
                                <th>Status</th>
                                <th>Created At</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (listTodo == null || listTodo.isEmpty()) { %>
                                <tr>
                                    <td colspan="5" class="text-center" style="padding: 30px;">
                                        No tasks found. Create a task to get started!
                                    </td>
                                </tr>
                            <% } else {
                                for (Todo t : listTodo) { %>
                                    <tr>
                                        <td><span class="text-highlight"><%= t.getId() %></span></td>
                                        <td>
                                            <b style="<%= "Completed".equalsIgnoreCase(t.getStatus()) ? "text-decoration: line-through; opacity: 0.6;" : "" %>">
                                                <%= t.getTask() %>
                                            </b>
                                        </td>
                                        <td>
                                            <% if ("Completed".equalsIgnoreCase(t.getStatus())) { %>
                                                <span class="badge badge-success">Completed</span>
                                            <% } else { %>
                                                <span class="badge badge-warning">Pending</span>
                                            <% } %>
                                        </td>
                                        <td style="font-size: 0.82rem; color: var(--text-muted);">
                                            <%= t.getCreatedAt() != null ? t.getCreatedAt().toString().substring(0, 19) : "N/A" %>
                                        </td>
                                        <td>
                                            <div class="flex gap-10">
                                                <a href="TodoServlet?action=toggle&id=<%= t.getId() %>&status=<%= t.getStatus() %>" 
                                                   class="btn btn-secondary btn-sm" style="min-width: 80px;">
                                                    <%= "Completed".equalsIgnoreCase(t.getStatus()) ? "Reopen" : "Complete" %>
                                                </a>
                                                <a href="TodoServlet?action=delete&id=<%= t.getId() %>" 
                                                   class="btn btn-danger btn-sm">Delete</a>
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
