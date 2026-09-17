<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.skindisease.model.AnalysisRecord" %>
<%
    List<AnalysisRecord> listRecords = (List<AnalysisRecord>) request.getAttribute("listRecords");
    AnalysisRecord editRecord = (AnalysisRecord) request.getAttribute("record");
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
    <title>Skin Disease Analysis Panel | DermAnalysis</title>
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
                <li><a href="AnalysisServlet?action=list" class="active">Disease Analysis</a></li>
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
            <h1 class="glow-text">Dermatological Diagnosis Center</h1>
            <p class="subtitle">Evaluate patient symptom profiles and run inference models (SELECT, INSERT, UPDATE, DELETE)</p>
        </header>

        <!-- Database Connection Warning -->
        <% if (usingMock) { %>
            <div class="alert alert-warning">
                <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"></path>
                </svg>
                <div>
                    <b>Resilient Mock Sandbox Active:</b> Database connection could not be established. 
                    <%= dbError != null ? "Error: " + dbError : "" %>
                    <br><span style="font-size: 0.82rem; opacity: 0.8;">Diagnostic logs are saved in-memory and simulated locally. Perfect for system demonstration!</span>
                </div>
            </div>
        <% } %>

        <div class="dashboard-layout">
            
            <!-- Side Form: Evaluate Symptoms -->
            <div class="card glass-card">
                <h2><%= editRecord != null ? "Edit Evaluation Details" : "Evaluate New Patient" %></h2>
                <p style="color: var(--text-muted); font-size: 0.8rem; margin-bottom: 20px;">
                    Fill symptoms to run rule-based diagnostic analysis.
                </p>
                
                <form action="AnalysisServlet" method="POST">
                    <input type="hidden" name="action" value="<%= editRecord != null ? "update" : "insert" %>">
                    <% if (editRecord != null) { %>
                        <input type="hidden" name="id" value="<%= editRecord.getId() %>">
                    <% } %>

                    <div class="form-group">
                        <label for="patientName">Patient Name</label>
                        <input type="text" id="patientName" name="patientName" value="<%= editRecord != null ? editRecord.getPatientName() : "" %>" placeholder="Enter patient name" required>
                    </div>

                    <div class="form-group">
                        <label for="age">Patient Age</label>
                        <input type="number" id="age" name="age" value="<%= editRecord != null ? editRecord.getAge() : "" %>" placeholder="Enter age" min="0" max="150" required>
                    </div>

                    <!-- Symptoms Switches -->
                    <div class="form-group">
                        <label>Symptom Matrix</label>
                        
                        <div class="switch-container">
                            <span>Redness (Erythema)</span>
                            <label class="switch">
                                <input type="checkbox" name="symptomRedness" value="Yes" <%= editRecord != null && "Yes".equals(editRecord.getSymptomRedness()) ? "checked" : "" %>>
                                <span class="slider"></span>
                            </label>
                        </div>

                        <div class="switch-container">
                            <span>Itchiness (Pruritus)</span>
                            <label class="switch">
                                <input type="checkbox" name="symptomItchy" value="Yes" <%= editRecord != null && "Yes".equals(editRecord.getSymptomItchy()) ? "checked" : "" %>>
                                <span class="slider"></span>
                            </label>
                        </div>

                        <div class="switch-container">
                            <span>Scaling / Flaking</span>
                            <label class="switch">
                                <input type="checkbox" name="symptomScaling" value="Yes" <%= editRecord != null && "Yes".equals(editRecord.getSymptomScaling()) ? "checked" : "" %>>
                                <span class="slider"></span>
                            </label>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="duration">Symptom Duration (Days)</label>
                        <input type="number" id="duration" name="duration" value="<%= editRecord != null ? editRecord.getDuration() : "" %>" placeholder="e.g. 5 days" min="1" required>
                    </div>

                    <div class="form-group">
                        <label for="notes">Evaluation Notes</label>
                        <textarea id="notes" name="notes" placeholder="Include patch patterns, potential allergen contacts or clinical notes..." rows="3"><%= editRecord != null ? editRecord.getNotes() : "" %></textarea>
                    </div>

                    <button type="submit" class="btn btn-primary btn-block mb-20">
                        <%= editRecord != null ? "Update Diagnosis Record" : "Run Diagnostic Analysis" %>
                    </button>
                    
                    <% if (editRecord != null) { %>
                        <a href="AnalysisServlet?action=list" class="btn btn-secondary btn-block block">Cancel Editing</a>
                    <% } %>
                </form>
            </div>

            <!-- List Panel (Diagnosis Reports) -->
            <div class="card glass-card">
                <h2>Clinical Diagnostic Records</h2>
                <p style="color: var(--text-muted); font-size: 0.8rem; margin-bottom: 20px;">
                    History of symptom evaluations and diagnostics (SELECT query).
                </p>
                
                <div class="table-wrapper">
                    <table>
                        <thead>
                            <tr>
                                <th>Patient ID</th>
                                <th>Name & Age</th>
                                <th>Symptom Profile</th>
                                <th>Inferred Diagnosis</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (listRecords == null || listRecords.isEmpty()) { %>
                                <tr>
                                    <td colspan="5" class="text-center" style="padding: 35px;">
                                        No clinical records found. Submit the left form to analyze condition!
                                    </td>
                                </tr>
                            <% } else {
                                for (AnalysisRecord r : listRecords) { %>
                                    <tr>
                                        <td><span class="text-highlight">#<%= r.getId() %></span></td>
                                        <td>
                                            <b><%= r.getPatientName() %></b><br>
                                            <span style="font-size: 0.8rem; color: var(--text-muted);"><%= r.getAge() %> years old • <%= r.getDuration() %> days</span>
                                        </td>
                                        <td>
                                            <div style="display: flex; flex-direction: column; gap: 4px;">
                                                <span class="badge <%= "Yes".equals(r.getSymptomRedness()) ? "badge-danger" : "badge-secondary" %>" style="text-align:center; font-size:0.7rem;">
                                                    Redness: <%= r.getSymptomRedness() %>
                                                </span>
                                                <span class="badge <%= "Yes".equals(r.getSymptomItchy()) ? "badge-warning" : "badge-secondary" %>" style="text-align:center; font-size:0.7rem;">
                                                    Itchy: <%= r.getSymptomItchy() %>
                                                </span>
                                                <span class="badge <%= "Yes".equals(r.getSymptomScaling()) ? "badge-info" : "badge-secondary" %>" style="text-align:center; font-size:0.7rem;">
                                                    Scaling: <%= r.getSymptomScaling() %>
                                                </span>
                                            </div>
                                        </td>
                                        <td>
                                            <b style="color: #ffffff;"><%= r.getDiagnosis() %></b>
                                            <% if (r.getNotes() != null && !r.getNotes().trim().isEmpty()) { %>
                                                <p style="font-size: 0.78rem; color: var(--text-secondary); margin-top: 5px; font-style: italic; max-width: 250px;">
                                                    "<%= r.getNotes() %>"
                                                </p>
                                            <% } %>
                                        </td>
                                        <td>
                                            <div style="display: flex; flex-direction: column; gap: 8px;">
                                                <a href="AnalysisServlet?action=edit&id=<%= r.getId() %>" class="btn btn-secondary btn-sm block">Edit</a>
                                                <a href="AnalysisServlet?action=delete&id=<%= r.getId() %>" 
                                                   class="btn btn-danger btn-sm btn-delete-confirm block" 
                                                   data-name="<%= r.getPatientName() %>">Delete</a>
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
