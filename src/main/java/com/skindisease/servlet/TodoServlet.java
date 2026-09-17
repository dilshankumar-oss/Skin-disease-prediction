package com.skindisease.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.skindisease.db.DBConnection;
import com.skindisease.model.Todo;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet handling CRUD operations for To-Do tasks (Assignment Q7).
 */
@WebServlet("/TodoServlet")
public class TodoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Resilient fallback list in case Oracle DB is not active or configured
    private static final List<Todo> mockTodos = new ArrayList<>();
    private static int mockIdCounter = 1;

    static {
        mockTodos.add(new Todo(mockIdCounter++, "Set up Oracle Database tables (Demo)", "Completed", new Timestamp(System.currentTimeMillis())));
        mockTodos.add(new Todo(mockIdCounter++, "Configure Tomcat connection pool (Demo)", "Completed", new Timestamp(System.currentTimeMillis())));
        mockTodos.add(new Todo(mockIdCounter++, "Review J2EE Servlet lifecycle (Demo)", "Pending", new Timestamp(System.currentTimeMillis())));
        mockTodos.add(new Todo(mockIdCounter++, "Implement Custom Tag libraries (Demo)", "Pending", new Timestamp(System.currentTimeMillis())));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "delete":
                    deleteTodo(request, response);
                    break;
                case "toggle":
                    toggleTodo(request, response);
                    break;
                case "list":
                default:
                    listTodos(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "insert":
                    insertTodo(request, response);
                    break;
                default:
                    listTodos(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void listTodos(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException, ServletException {
        
        List<Todo> listTodo = new ArrayList<>();
        boolean usingMock = false;
        String dbError = null;

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT id, task, status, created_at FROM TODO ORDER BY id ASC";
            Statement statement = conn.createStatement();
            ResultSet resultSet = statement.executeQuery(sql);

            while (resultSet.next()) {
                int id = resultSet.getInt("id");
                String task = resultSet.getString("task");
                String status = resultSet.getString("status");
                Timestamp createdAt = resultSet.getTimestamp("created_at");
                listTodo.add(new Todo(id, task, status, createdAt));
            }
            DBConnection.close(conn, statement, resultSet);
        } catch (Exception e) {
            e.printStackTrace();
            dbError = e.getMessage();
            listTodo = new ArrayList<>(mockTodos);
            usingMock = true;
        }

        request.setAttribute("listTodo", listTodo);
        request.setAttribute("usingMock", usingMock);
        request.setAttribute("dbError", dbError);
        request.getRequestDispatcher("/todo.jsp").forward(request, response);
    }

    private void insertTodo(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        String task = request.getParameter("task");
        String status = request.getParameter("status");
        if (status == null || status.trim().isEmpty()) {
            status = "Pending";
        }

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "INSERT INTO TODO (task, status) VALUES (?, ?)";
            PreparedStatement statement = conn.prepareStatement(sql);
            statement.setString(1, task);
            statement.setString(2, status);
            statement.executeUpdate();
            statement.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            // DB fail fallback
            mockTodos.add(new Todo(mockIdCounter++, task, status, new Timestamp(System.currentTimeMillis())));
        }
        response.sendRedirect("TodoServlet?action=list");
    }

    private void toggleTodo(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        String currentStatus = request.getParameter("status");
        String newStatus = "Completed".equalsIgnoreCase(currentStatus) ? "Pending" : "Completed";

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "UPDATE TODO SET status = ? WHERE id = ?";
            PreparedStatement statement = conn.prepareStatement(sql);
            statement.setString(1, newStatus);
            statement.setInt(2, id);
            statement.executeUpdate();
            statement.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            // DB fail fallback
            for (Todo t : mockTodos) {
                if (t.getId() == id) {
                    t.setStatus(newStatus);
                    break;
                }
            }
        }
        response.sendRedirect("TodoServlet?action=list");
    }

    private void deleteTodo(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "DELETE FROM TODO WHERE id = ?";
            PreparedStatement statement = conn.prepareStatement(sql);
            statement.setInt(1, id);
            statement.executeUpdate();
            statement.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            // DB fail fallback
            mockTodos.removeIf(t -> t.getId() == id);
        }
        response.sendRedirect("TodoServlet?action=list");
    }
}
