package com.skindisease.db;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

/**
 * Database utility class with dual support for Oracle Database and 
 * embedded H2 Database fallback (Oracle mode) with auto-schema initialization.
 */
public class DBConnection {

    private static String oracleDriver = "oracle.jdbc.OracleDriver";
    private static String oracleUrl = "jdbc:oracle:thin:@localhost:1521:xe";
    private static String oracleUser = "system";
    private static String oraclePass = "admin";

    private static String h2Driver = "org.h2.Driver";
    private static String h2Url = "jdbc:h2:file:./skindiseasedb;MODE=Oracle;AUTO_SERVER=TRUE;DB_CLOSE_DELAY=-1";
    private static String h2User = "sa";
    private static String h2Pass = "";

    private static boolean useH2Fallback = false;
    private static boolean h2Initialized = false;
    private static String activeStatusMessage = "";

    static {
        // Load properties if available
        try (InputStream in = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (in != null) {
                Properties props = new Properties();
                props.load(in);
                oracleDriver = props.getProperty("db.driver", oracleDriver);
                oracleUrl = props.getProperty("db.url", oracleUrl);
                oracleUser = props.getProperty("db.username", oracleUser);
                oraclePass = props.getProperty("db.password", oraclePass);
            }
        } catch (Exception e) {
            System.err.println("[DBConnection] Info: db.properties loading fallback to defaults.");
        }

        // Pre-load available drivers
        try {
            Class.forName(oracleDriver);
        } catch (ClassNotFoundException e) {
            System.out.println("[DBConnection] Oracle Driver not found in classpath.");
        }
        try {
            Class.forName(h2Driver);
        } catch (ClassNotFoundException e) {
            System.out.println("[DBConnection] H2 Driver not found in classpath.");
        }
    }

    /**
     * Obtains a Connection. First attempts Oracle DB; if Oracle is unavailable,
     * seamlessly falls back to Embedded H2 Database (Oracle compatibility mode)
     * and automatically creates tables if needed.
     */
    public synchronized static Connection getConnection() throws SQLException {
        if (!useH2Fallback) {
            try {
                // Set short login timeout for Oracle probe
                DriverManager.setLoginTimeout(3);
                Connection conn = DriverManager.getConnection(oracleUrl, oracleUser, oraclePass);
                activeStatusMessage = "Connected to local Oracle Database.";
                return conn;
            } catch (SQLException e) {
                System.out.println("[DBConnection] Local Oracle DB not reachable (Port 1521). Switching to embedded H2 Database...");
                useH2Fallback = true;
            }
        }

        // H2 Fallback Connection
        Connection h2Conn = DriverManager.getConnection(h2Url, h2User, h2Pass);
        activeStatusMessage = "Connected to Embedded H2 Database (Oracle Mode). Auto-Setup Active.";

        if (!h2Initialized) {
            initializeH2Schema(h2Conn);
            h2Initialized = true;
        }

        return h2Conn;
    }

    private synchronized static void initializeH2Schema(Connection conn) {
        try (Statement stmt = conn.createStatement()) {
            // Check if LOGIN table exists
            boolean tablesExist = false;
            try (ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM LOGIN")) {
                if (rs.next()) {
                    tablesExist = true;
                }
            } catch (SQLException e) {
                tablesExist = false;
            }

            if (!tablesExist) {
                System.out.println("[DBConnection] Initializing database tables in H2...");
                
                stmt.execute("CREATE TABLE IF NOT EXISTS LOGIN (username VARCHAR(50) PRIMARY KEY, password VARCHAR(50) NOT NULL)");
                stmt.execute("MERGE INTO LOGIN (username, password) KEY(username) VALUES ('admin', 'admin123')");
                stmt.execute("MERGE INTO LOGIN (username, password) KEY(username) VALUES ('doctor', 'derm123')");

                stmt.execute("CREATE TABLE IF NOT EXISTS STUDENT (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(100) NOT NULL, email VARCHAR(100) NOT NULL UNIQUE, department VARCHAR(50) NOT NULL)");
                stmt.execute("INSERT INTO STUDENT (name, email, department) SELECT 'John Doe', 'john.doe@university.edu', 'Computer Science' WHERE NOT EXISTS (SELECT 1 FROM STUDENT WHERE email='john.doe@university.edu')");
                stmt.execute("INSERT INTO STUDENT (name, email, department) SELECT 'Jane Smith', 'jane.smith@university.edu', 'Information Technology' WHERE NOT EXISTS (SELECT 1 FROM STUDENT WHERE email='jane.smith@university.edu')");
                stmt.execute("INSERT INTO STUDENT (name, email, department) SELECT 'Bob Johnson', 'bob.johnson@university.edu', 'Electronics' WHERE NOT EXISTS (SELECT 1 FROM STUDENT WHERE email='bob.johnson@university.edu')");

                stmt.execute("CREATE TABLE IF NOT EXISTS DISEASE_ANALYSIS (" +
                        "id INT AUTO_INCREMENT PRIMARY KEY, " +
                        "patient_name VARCHAR(100) NOT NULL, " +
                        "age INT NOT NULL, " +
                        "symptom_redness VARCHAR(10), " +
                        "symptom_itchy VARCHAR(10), " +
                        "symptom_scaling VARCHAR(10), " +
                        "duration INT NOT NULL, " +
                        "diagnosis VARCHAR(150) NOT NULL, " +
                        "notes VARCHAR(1000))");
                
                stmt.execute("INSERT INTO DISEASE_ANALYSIS (patient_name, age, symptom_redness, symptom_itchy, symptom_scaling, duration, diagnosis, notes) " +
                        "SELECT 'Alice Miller', 28, 'Yes', 'Yes', 'No', 5, 'Contact Dermatitis', 'Patient shows localized redness and itching.' WHERE NOT EXISTS (SELECT 1 FROM DISEASE_ANALYSIS WHERE patient_name='Alice Miller')");
                stmt.execute("INSERT INTO DISEASE_ANALYSIS (patient_name, age, symptom_redness, symptom_itchy, symptom_scaling, duration, diagnosis, notes) " +
                        "SELECT 'David Clark', 45, 'Yes', 'No', 'Yes', 30, 'Plaque Psoriasis', 'Chronic scaling and redness on elbows.' WHERE NOT EXISTS (SELECT 1 FROM DISEASE_ANALYSIS WHERE patient_name='David Clark')");

                stmt.execute("CREATE TABLE IF NOT EXISTS TODO (" +
                        "id INT AUTO_INCREMENT PRIMARY KEY, " +
                        "task VARCHAR(255) NOT NULL, " +
                        "status VARCHAR(50) DEFAULT 'Pending', " +
                        "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");

                stmt.execute("INSERT INTO TODO (task, status) SELECT 'Set up Database tables', 'Completed' WHERE NOT EXISTS (SELECT 1 FROM TODO WHERE task='Set up Database tables')");
                stmt.execute("INSERT INTO TODO (task, status) SELECT 'Configure Tomcat server', 'Completed' WHERE NOT EXISTS (SELECT 1 FROM TODO WHERE task='Configure Tomcat server')");
                stmt.execute("INSERT INTO TODO (task, status) SELECT 'Review J2EE Servlet lifecycle', 'Pending' WHERE NOT EXISTS (SELECT 1 FROM TODO WHERE task='Review J2EE Servlet lifecycle')");
                stmt.execute("INSERT INTO TODO (task, status) SELECT 'Implement Custom Tag libraries', 'Pending' WHERE NOT EXISTS (SELECT 1 FROM TODO WHERE task='Implement Custom Tag libraries')");

                System.out.println("[DBConnection] H2 Database initialization finished successfully!");
            }
        } catch (Exception e) {
            System.err.println("[DBConnection] Error initializing H2 Schema: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static boolean isDriverLoaded() {
        return true;
    }

    public static String getLoadStatusMessage() {
        return activeStatusMessage.isEmpty() ? "Database utility ready." : activeStatusMessage;
    }

    public static void close(Connection conn, Statement stmt, ResultSet rs) {
        if (rs != null) {
            try { rs.close(); } catch (SQLException e) { System.err.println("Error closing ResultSet: " + e.getMessage()); }
        }
        if (stmt != null) {
            try { stmt.close(); } catch (SQLException e) { System.err.println("Error closing Statement: " + e.getMessage()); }
        }
        if (conn != null) {
            try { conn.close(); } catch (SQLException e) { System.err.println("Error closing Connection: " + e.getMessage()); }
        }
    }
}

