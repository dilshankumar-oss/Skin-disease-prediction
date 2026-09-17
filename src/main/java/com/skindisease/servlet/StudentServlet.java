package com.skindisease.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.skindisease.db.DBConnection;
import com.skindisease.model.Student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet handling CRUD operations for Student records (Assignment Q6).
 */
@WebServlet("/StudentServlet")
public class StudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Resilient fallback list in case Oracle DB is not active or configured
    private static final List<Student> mockStudents = new ArrayList<>();
    private static int mockIdCounter = 1;

    static {
        mockStudents.add(new Student(mockIdCounter++, "John Doe (Demo)", "john.doe@university.edu", "Computer Science"));
        mockStudents.add(new Student(mockIdCounter++, "Jane Smith (Demo)", "jane.smith@university.edu", "Information Technology"));
        mockStudents.add(new Student(mockIdCounter++, "Bob Johnson (Demo)", "bob.johnson@university.edu", "Electronics"));
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
                    deleteStudent(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "list":
                default:
                    listStudents(request, response);
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
                    insertStudent(request, response);
                    break;
                case "update":
                    updateStudent(request, response);
                    break;
                default:
                    listStudents(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void listStudents(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException, ServletException {
        
        List<Student> listStudent = new ArrayList<>();
        boolean usingMock = false;
        String dbError = null;

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT id, name, email, department FROM STUDENT ORDER BY id ASC";
            Statement statement = conn.createStatement();
            ResultSet resultSet = statement.executeQuery(sql);

            while (resultSet.next()) {
                int id = resultSet.getInt("id");
                String name = resultSet.getString("name");
                String email = resultSet.getString("email");
                String department = resultSet.getString("department");
                listStudent.add(new Student(id, name, email, department));
            }
            DBConnection.close(conn, statement, resultSet);
        } catch (Exception e) {
            e.printStackTrace();
            dbError = e.getMessage();
            listStudent = new ArrayList<>(mockStudents);
            usingMock = true;
        }

        request.setAttribute("listStudent", listStudent);
        request.setAttribute("usingMock", usingMock);
        request.setAttribute("dbError", dbError);
        request.getRequestDispatcher("/students.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        Student existingStudent = null;
        boolean usingMock = false;

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT id, name, email, department FROM STUDENT WHERE id = ?";
            PreparedStatement statement = conn.prepareStatement(sql);
            statement.setInt(1, id);
            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                String name = resultSet.getString("name");
                String email = resultSet.getString("email");
                String department = resultSet.getString("department");
                existingStudent = new Student(id, name, email, department);
            }
            DBConnection.close(conn, statement, resultSet);
        } catch (Exception e) {
            e.printStackTrace();
            usingMock = true;
            for (Student s : mockStudents) {
                if (s.getId() == id) {
                    existingStudent = s;
                    break;
                }
            }
        }

        request.setAttribute("student", existingStudent);
        request.setAttribute("usingMock", usingMock);
        
        // Reload list as well for display side-by-side
        listStudents(request, response);
    }

    private void insertStudent(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String department = request.getParameter("department");

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "INSERT INTO STUDENT (name, email, department) VALUES (?, ?, ?)";
            PreparedStatement statement = conn.prepareStatement(sql);
            statement.setString(1, name);
            statement.setString(2, email);
            statement.setString(3, department);
            statement.executeUpdate();
            statement.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            // DB fail fallback
            mockStudents.add(new Student(mockIdCounter++, name + " (Demo)", email, department));
        }
        response.sendRedirect("StudentServlet?action=list");
    }

    private void updateStudent(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String department = request.getParameter("department");

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "UPDATE STUDENT SET name = ?, email = ?, department = ? WHERE id = ?";
            PreparedStatement statement = conn.prepareStatement(sql);
            statement.setString(1, name);
            statement.setString(2, email);
            statement.setString(3, department);
            statement.setInt(4, id);
            statement.executeUpdate();
            statement.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            // DB fail fallback
            for (Student s : mockStudents) {
                if (s.getId() == id) {
                    s.setName(name);
                    s.setEmail(email);
                    s.setDepartment(department);
                    break;
                }
            }
        }
        response.sendRedirect("StudentServlet?action=list");
    }

    private void deleteStudent(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "DELETE FROM STUDENT WHERE id = ?";
            PreparedStatement statement = conn.prepareStatement(sql);
            statement.setInt(1, id);
            statement.executeUpdate();
            statement.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            // DB fail fallback
            mockStudents.removeIf(s -> s.getId() == id);
        }
        response.sendRedirect("StudentServlet?action=list");
    }
}
