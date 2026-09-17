package com.skindisease.servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet that displays and compares the four session management techniques (Assignment Q5).
 */
@WebServlet("/WelcomeServlet")
public class WelcomeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Retrieve value from HttpSession
        HttpSession session = request.getSession(false);
        String httpSessionVal = (session != null) ? (String) session.getAttribute("sessionUser") : null;
        
        // 2. Retrieve value from Cookies
        String cookieVal = null;
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if ("cookieUser".equals(c.getName())) {
                    cookieVal = c.getValue();
                    break;
                }
            }
        }
        
        // 3. Retrieve value from Hidden Form Field
        String hiddenFieldVal = request.getParameter("hiddenUser");
        
        // 4. Retrieve value from URL Rewriting parameter
        String urlRewritingVal = request.getParameter("urlUser");
        
        // Put all retrieved values into request attributes for the JSP view
        request.setAttribute("httpSessionVal", httpSessionVal);
        request.setAttribute("cookieVal", cookieVal);
        request.setAttribute("hiddenFieldVal", hiddenFieldVal);
        request.setAttribute("urlRewritingVal", urlRewritingVal);
        
        // Forward request to session comparison dashboard JSP
        request.getRequestDispatcher("/session-compare.jsp").forward(request, response);
    }
}
