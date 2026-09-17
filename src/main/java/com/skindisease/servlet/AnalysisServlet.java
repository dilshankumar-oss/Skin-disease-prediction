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
import com.skindisease.model.AnalysisRecord;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet handling CRUD operations for Skin Disease Analysis records.
 */
@WebServlet("/AnalysisServlet")
public class AnalysisServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Resilient mock memory list if DB is down
    private static final List<AnalysisRecord> mockRecords = new ArrayList<>();
    private static int mockIdCounter = 1;

    static {
        mockRecords.add(new AnalysisRecord(mockIdCounter++, "Alice Miller (Demo)", 28, "Yes", "Yes", "No", 5, 
            "Contact Dermatitis", "Localized red itchy patch on left arm. Likely laundry detergent."));
        mockRecords.add(new AnalysisRecord(mockIdCounter++, "David Clark (Demo)", 45, "Yes", "No", "Yes", 30, 
            "Plaque Psoriasis", "Thick silvery scales on knees and elbows. Advised dermatological cream."));
        mockRecords.add(new AnalysisRecord(mockIdCounter++, "Emma Watson (Demo)", 19, "No", "Yes", "No", 2, 
            "Hives (Urticaria)", "Sudden onset of itchy bumps. Antihistamine recommended."));
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
                    deleteRecord(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "list":
default:
                    listRecords(request, response);
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
                    insertRecord(request, response);
                    break;
                case "update":
                    updateRecord(request, response);
                    break;
                default:
                    listRecords(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void listRecords(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException, ServletException {
        
        List<AnalysisRecord> listRecords = new ArrayList<>();
        boolean usingMock = false;
        String dbError = null;

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT id, patient_name, age, symptom_redness, symptom_itchy, symptom_scaling, duration, diagnosis, notes FROM DISEASE_ANALYSIS ORDER BY id ASC";
            Statement statement = conn.createStatement();
            ResultSet resultSet = statement.executeQuery(sql);

            while (resultSet.next()) {
                int id = resultSet.getInt("id");
                String patientName = resultSet.getString("patient_name");
                int age = resultSet.getInt("age");
                String symptomRedness = resultSet.getString("symptom_redness");
                String symptomItchy = resultSet.getString("symptom_itchy");
                String symptomScaling = resultSet.getString("symptom_scaling");
                int duration = resultSet.getInt("duration");
                String diagnosis = resultSet.getString("diagnosis");
                String notes = resultSet.getString("notes");
                
                listRecords.add(new AnalysisRecord(id, patientName, age, symptomRedness, symptomItchy, 
                    symptomScaling, duration, diagnosis, notes));
            }
            DBConnection.close(conn, statement, resultSet);
        } catch (Exception e) {
            e.printStackTrace();
            dbError = e.getMessage();
            listRecords = new ArrayList<>(mockRecords);
            usingMock = true;
        }

        request.setAttribute("listRecords", listRecords);
        request.setAttribute("usingMock", usingMock);
        request.setAttribute("dbError", dbError);
        request.getRequestDispatcher("/analysis.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        AnalysisRecord existingRecord = null;
        boolean usingMock = false;

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT id, patient_name, age, symptom_redness, symptom_itchy, symptom_scaling, duration, diagnosis, notes FROM DISEASE_ANALYSIS WHERE id = ?";
            PreparedStatement statement = conn.prepareStatement(sql);
            statement.setInt(1, id);
            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                String patientName = resultSet.getString("patient_name");
                int age = resultSet.getInt("age");
                String symptomRedness = resultSet.getString("symptom_redness");
                String symptomItchy = resultSet.getString("symptom_itchy");
                String symptomScaling = resultSet.getString("symptom_scaling");
                int duration = resultSet.getInt("duration");
                String diagnosis = resultSet.getString("diagnosis");
                String notes = resultSet.getString("notes");
                
                existingRecord = new AnalysisRecord(id, patientName, age, symptomRedness, symptomItchy, 
                    symptomScaling, duration, diagnosis, notes);
            }
            DBConnection.close(conn, statement, resultSet);
        } catch (Exception e) {
            e.printStackTrace();
            usingMock = true;
            for (AnalysisRecord r : mockRecords) {
                if (r.getId() == id) {
                    existingRecord = r;
                    break;
                }
            }
        }

        request.setAttribute("record", existingRecord);
        request.setAttribute("usingMock", usingMock);
        
        // Reload list for layout
        listRecords(request, response);
    }

    private void insertRecord(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        String patientName = request.getParameter("patientName");
        int age = Integer.parseInt(request.getParameter("age"));
        String symptomRedness = request.getParameter("symptomRedness") != null ? "Yes" : "No";
        String symptomItchy = request.getParameter("symptomItchy") != null ? "Yes" : "No";
        String symptomScaling = request.getParameter("symptomScaling") != null ? "Yes" : "No";
        int duration = Integer.parseInt(request.getParameter("duration"));
        String notes = request.getParameter("notes");

        // Rule-based diagnostic simulator
        String diagnosis = evaluateSkinCondition(symptomRedness, symptomItchy, symptomScaling, duration);

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "INSERT INTO DISEASE_ANALYSIS (patient_name, age, symptom_redness, symptom_itchy, symptom_scaling, duration, diagnosis, notes) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement statement = conn.prepareStatement(sql);
            statement.setString(1, patientName);
            statement.setInt(2, age);
            statement.setString(3, symptomRedness);
            statement.setString(4, symptomItchy);
            statement.setString(5, symptomScaling);
            statement.setInt(6, duration);
            statement.setString(7, diagnosis);
            statement.setString(8, notes);
            statement.executeUpdate();
            statement.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            // DB fail fallback
            mockRecords.add(new AnalysisRecord(mockIdCounter++, patientName + " (Demo)", age, 
                symptomRedness, symptomItchy, symptomScaling, duration, diagnosis, notes));
        }
        response.sendRedirect("AnalysisServlet?action=list");
    }

    private void updateRecord(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        String patientName = request.getParameter("patientName");
        int age = Integer.parseInt(request.getParameter("age"));
        String symptomRedness = request.getParameter("symptomRedness") != null ? "Yes" : "No";
        String symptomItchy = request.getParameter("symptomItchy") != null ? "Yes" : "No";
        String symptomScaling = request.getParameter("symptomScaling") != null ? "Yes" : "No";
        int duration = Integer.parseInt(request.getParameter("duration"));
        String notes = request.getParameter("notes");

        // Rule-based diagnosis
        String diagnosis = evaluateSkinCondition(symptomRedness, symptomItchy, symptomScaling, duration);

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "UPDATE DISEASE_ANALYSIS SET patient_name = ?, age = ?, symptom_redness = ?, symptom_itchy = ?, symptom_scaling = ?, duration = ?, diagnosis = ?, notes = ? WHERE id = ?";
            PreparedStatement statement = conn.prepareStatement(sql);
            statement.setString(1, patientName);
            statement.setInt(2, age);
            statement.setString(3, symptomRedness);
            statement.setString(4, symptomItchy);
            statement.setString(5, symptomScaling);
            statement.setInt(6, duration);
            statement.setString(7, diagnosis);
            statement.setString(8, notes);
            statement.setInt(9, id);
            statement.executeUpdate();
            statement.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            // DB fail fallback
            for (AnalysisRecord r : mockRecords) {
                if (r.getId() == id) {
                    r.setPatientName(patientName);
                    r.setAge(age);
                    r.setSymptomRedness(symptomRedness);
                    r.setSymptomItchy(symptomItchy);
                    r.setSymptomScaling(symptomScaling);
                    r.setDuration(duration);
                    r.setDiagnosis(diagnosis);
                    r.setNotes(notes);
                    break;
                }
            }
        }
        response.sendRedirect("AnalysisServlet?action=list");
    }

    private void deleteRecord(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "DELETE FROM DISEASE_ANALYSIS WHERE id = ?";
            PreparedStatement statement = conn.prepareStatement(sql);
            statement.setInt(1, id);
            statement.executeUpdate();
            statement.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            // DB fail fallback
            mockRecords.removeIf(r -> r.getId() == id);
        }
        response.sendRedirect("AnalysisServlet?action=list");
    }

    /**
     * Rule-based diagnostic classifier simulating medical analysis logic.
     */
    private String evaluateSkinCondition(String redness, String itchy, String scaling, int duration) {
        boolean r = "Yes".equals(redness);
        boolean i = "Yes".equals(itchy);
        boolean s = "Yes".equals(scaling);

        if (r && i && s) {
            return (duration > 14) ? "Chronic Plaque Psoriasis" : "Severe Atopic Eczema";
        } else if (r && i && !s) {
            return (duration > 7) ? "Contact Dermatitis (Allergic/Irritant)" : "Acute Urticaria (Hives)";
        } else if (r && !i && s) {
            return "Seborrheic Dermatitis";
        } else if (!r && i && !s) {
            return "Mild Pruritus / Early Stage Allergies";
        } else if (!r && !i && s) {
            return "Xerosis Cutis (Dry Skin)";
        } else if (r && !i && !s) {
            return (duration < 3) ? "Sunburn / Thermal Erythema" : "Rosacea / Erythematotelangiectatic Rosacea";
        } else {
            return "Indeterminate Dermatological Profile (Consult Doctor)";
        }
    }
}
