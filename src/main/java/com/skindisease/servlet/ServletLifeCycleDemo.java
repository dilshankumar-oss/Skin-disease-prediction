package com.skindisease.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet Life Cycle demonstration (Assignment Q1).
 */
@WebServlet("/ServletLifeCycleDemo")
public class ServletLifeCycleDemo extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Static list to persist lifecycle logs across servlet invocations
    private static final List<String> lifecycleLogs = Collections.synchronizedList(new ArrayList<>());
    
    private int initCount = 0;
    private int serviceCount = 0;
    private int destroyCount = 0;

    /**
     * Called by the servlet container to indicate to a servlet that the servlet is being placed into service.
     */
    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        initCount++;
        String logEntry = new Date() + ": [init()] Servlet initialized. Count: " + initCount;
        lifecycleLogs.add(logEntry);
        System.out.println(logEntry);
    }

    /**
     * Called by the servlet container to allow the servlet to respond to a request.
     */
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        serviceCount++;
        String logEntry = new Date() + ": [service()] Request received (Service method invoked). Count: " + serviceCount;
        lifecycleLogs.add(logEntry);
        System.out.println(logEntry);
        
        // Let super.service delegate to doGet / doPost, or we handle it here
        super.service(request, response);
    }

    /**
     * Standard doGet implementation.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if ("clear".equalsIgnoreCase(action)) {
            lifecycleLogs.clear();
            response.sendRedirect("lifecycle.jsp");
            return;
        }

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<html>");
        out.println("<head><title>Servlet Life Cycle Log</title></head>");
        out.println("<body>");
        out.println("<h2>Servlet Life Cycle Count Summary</h2>");
        out.println("<p><b>init() count:</b> " + initCount + "</p>");
        out.println("<p><b>service() count:</b> " + serviceCount + "</p>");
        out.println("<p><b>destroy() count:</b> " + destroyCount + "</p>");
        out.println("<h3>Full Execution Log:</h3>");
        out.println("<ul>");
        synchronized (lifecycleLogs) {
            for (String log : lifecycleLogs) {
                out.println("<li>" + log + "</li>");
            }
        }
        out.println("</ul>");
        out.println("<p><a href='lifecycle.jsp'>Return to Dashboard</a></p>");
        out.println("</body>");
        out.println("</html>");
    }

    /**
     * Called by the servlet container to indicate to a servlet that the servlet is being taken out of service.
     */
    @Override
    public void destroy() {
        destroyCount++;
        String logEntry = new Date() + ": [destroy()] Servlet destroyed. Count: " + destroyCount;
        lifecycleLogs.add(logEntry);
        System.out.println(logEntry);
        super.destroy();
    }

    /**
     * Utility method to access the logs in JSP.
     */
    public static List<String> getLogs() {
        return new ArrayList<>(lifecycleLogs);
    }
}
