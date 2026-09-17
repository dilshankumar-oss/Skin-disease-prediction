package com.skindisease.db;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

/**
 * Database utility class to handle Oracle JDBC database connections.
 */
public class DBConnection {

    private static String driver;
    private static String url;
    private static String username;
    private static String password;
    private static boolean driverLoaded = false;
    private static String loadMessage = "";

    static {
        try {
            // Load DB properties from classpath
            Properties props = new Properties();
            try (InputStream in = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
                if (in == null) {
                    throw new Exception("db.properties file not found in classpath. Falling back to default settings.");
                }
                props.load(in);
                driver = props.getProperty("db.driver", "oracle.jdbc.OracleDriver");
                url = props.getProperty("db.url", "jdbc:oracle:thin:@localhost:1521:xe");
                username = props.getProperty("db.username", "system");
                password = props.getProperty("db.password", "admin");
            } catch (Exception e) {
                System.err.println("Error reading db.properties: " + e.getMessage());
                // Set fallback values
                driver = "oracle.jdbc.OracleDriver";
                url = "jdbc:oracle:thin:@localhost:1521:xe";
                username = "system";
                password = "admin";
            }

            // Register driver
            Class.forName(driver);
            driverLoaded = true;
            loadMessage = "Oracle JDBC Driver successfully loaded.";
        } catch (ClassNotFoundException e) {
            loadMessage = "Failed to load Oracle JDBC Driver. Ensure ojdbc jar is in webapp/WEB-INF/lib. Error: " + e.getMessage();
            System.err.println(loadMessage);
        }
    }

    /**
     * Obtains a connection to the Oracle Database.
     * 
     * @return Database Connection object
     * @throws SQLException if connection fails
     */
    public static Connection getConnection() throws SQLException {
        if (!driverLoaded) {
            throw new SQLException("Oracle JDBC Driver is not loaded! Reason: " + loadMessage);
        }
        return DriverManager.getConnection(url, username, password);
    }

    /**
     * Checks if the JDBC driver is loaded properly.
     */
    public static boolean isDriverLoaded() {
        return driverLoaded;
    }

    /**
     * Gets driver loading status or error message.
     */
    public static String getLoadStatusMessage() {
        return loadMessage;
    }

    /**
     * Safely closes connection, statement, and result set.
     */
    public static void close(Connection conn, Statement stmt, ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                System.err.println("Error closing ResultSet: " + e.getMessage());
            }
        }
        if (stmt != null) {
            try {
                stmt.close();
            } catch (SQLException e) {
                System.err.println("Error closing Statement: " + e.getMessage());
            }
        }
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing Connection: " + e.getMessage());
            }
        }
    }
}
