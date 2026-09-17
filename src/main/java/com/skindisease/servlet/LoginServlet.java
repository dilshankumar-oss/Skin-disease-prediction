package com.skindisease.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.skindisease.db.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet handling user login and session management setup (Assignment Q2, Q3, Q4, Q5).
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String userId = request.getParameter("userId");
        String password = request.getParameter("password");
        
        if (userId == null || userId.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            response.sendRedirect("login.html?error=Invalid Credentials");
            return;
        }

        Connection conn = null;
        PreparedStatement checkStmt = null;
        PreparedStatement insertStmt = null;
        ResultSet rs = null;
        
        boolean loginSuccess = false;
        String message = "";
        
        try {
            conn = DBConnection.getConnection();
            
            // Q4: Check if user exists in database
            String checkSQL = "SELECT username, password FROM LOGIN WHERE username = ?";
            checkStmt = conn.prepareStatement(checkSQL);
            checkStmt.setString(1, userId);
            rs = checkStmt.executeQuery();
            
            if (rs.next()) {
                // User exists, validate password
                String dbPassword = rs.getString("password");
                if (dbPassword.equals(password)) {
                    loginSuccess = true;
                    message = "Login successful!";
                } else {
                    loginSuccess = false;
                    message = "Password mismatch. Login failed.";
                }
            } else {
                // User does not exist, insert into LOGIN table (Q3 and Q4 otherwise condition)
                String insertSQL = "INSERT INTO LOGIN (username, password) VALUES (?, ?)";
                insertStmt = conn.prepareStatement(insertSQL);
                insertStmt.setString(1, userId);
                insertStmt.setString(2, password);
                int rowsInserted = insertStmt.executeUpdate();
                
                if (rowsInserted > 0) {
                    loginSuccess = true;
                    message = "Account created & logged in successfully!";
                } else {
                    loginSuccess = false;
                    message = "Registration failed.";
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Fallback for demo if Oracle DB is not active/configured
            message = "Database connection error (demonstration mode active): " + e.getMessage();
            // Auto login for development/test purposes if connection fails
            loginSuccess = true;
        } finally {
            DBConnection.close(conn, checkStmt, rs);
            if (insertStmt != null) {
                try { insertStmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }

        if (loginSuccess) {
            // Set session management parameters (Q5)
            
            // 1. HttpSession
            HttpSession session = request.getSession(true);
            session.setAttribute("sessionUser", userId);
            
            // 2. Cookie
            Cookie userCookie = new Cookie("cookieUser", userId);
            userCookie.setMaxAge(60 * 60 * 24); // 24 hours
            response.addCookie(userCookie);
            
            // 3. Hidden Fields and URL Rewriting (Q5 Step 2: Create LoginServlet and WelcomeServlet)
            // To pass session variables via hidden fields and URL rewriting, 
            // we will render an intermediate "Welcome Bridge" page.
            // This page will display the status, and provide links/forms to WelcomeServlet using:
            // - Hidden forms (for Hidden Fields)
            // - Rewritten links (for URL Rewriting)
            // It will also display the User ID and Password (Q2 part 2)
            
            response.setContentType("text/html");
            PrintWriter out = response.getWriter();
            
            out.println("<!DOCTYPE html>");
            out.println("<html lang='en'>");
            out.println("<head>");
            out.println("  <meta charset='UTF-8'>");
            out.println("  <title>Login Processed | DermAnalysis</title>");
            out.println("  <link rel='stylesheet' href='css/style.css'>");
            out.println("  <link href='https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;800&display=swap' rel='stylesheet'>");
            out.println("</head>");
            out.println("<body>");
            out.println("  <div class='container'>");
            out.println("    <header>");
            out.println("      <h1 class='glow-text'>Authentication Processed</h1>");
            out.println("      <p class='subtitle'>" + message + "</p>");
            out.println("    </header>");
            
            out.println("    <div class='card glass-card'>");
            out.println("      <h2>Credential Verification Log (Q2 & Q4)</h2>");
            out.println("      <div class='info-group'>");
            out.println("        <p><strong>Username Received:</strong> <span class='text-highlight'>" + userId + "</span></p>");
            out.println("        <p><strong>Password Received:</strong> <span class='text-highlight'>" + password + "</span></p>");
            out.println("      </div>");
            out.println("    </div>");
            
            out.println("    <div class='grid-2'>");
            
            // Method A: Hidden Field demo
            out.println("      <div class='card glass-card hover-glow'>");
            out.println("        <h3>Session Method A: Hidden Field</h3>");
            out.println("        <p>Submits a hidden form field to pass the username to WelcomeServlet.</p>");
            out.println("        <form action='WelcomeServlet' method='POST'>");
            out.println("          <input type='hidden' name='hiddenUser' value='" + userId + "'>");
            out.println("          <button type='submit' class='btn btn-primary'>Proceed via Hidden Field</button>");
            out.println("        </form>");
            out.println("      </div>");
            
            // Method B: URL Rewriting demo
            out.println("      <div class='card glass-card hover-glow'>");
            out.println("        <h3>Session Method B: URL Rewriting</h3>");
            out.println("        <p>Appends the username as a query parameter in the redirection link.</p>");
            // URL Rewriting standard format or simple parameter appending
            String rewrittenURL = response.encodeURL("WelcomeServlet?urlUser=" + userId);
            out.println("        <a href='" + rewrittenURL + "' class='btn btn-accent text-center block'>Proceed via URL Rewriting</a>");
            out.println("      </div>");
            
            out.println("    </div>"); // end grid-2
            
            // Extra: Automatic link that will read standard cookies/session anyway
            out.println("    <div class='text-center mt-20'>");
            out.println("      <a href='index.jsp' class='btn btn-secondary'>Go directly to Dashboard</a>");
            out.println("    </div>");
            
            out.println("  </div>"); // end container
            out.println("</body>");
            out.println("</html>");
            
        } else {
            response.sendRedirect("login.html?error=" + java.net.URLEncoder.encode(message, "UTF-8"));
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Redirect standard gets to login page
        response.sendRedirect("login.html");
    }
}
