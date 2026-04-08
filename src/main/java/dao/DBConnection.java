package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Utility class for obtaining a JDBC connection to the MySQL database.
 * Update DB_URL, DB_USER, DB_PASSWORD before running.
 */
public class DBConnection {

    private static final String DB_URL  = "jdbc:mysql://localhost:3306/smartcity_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "Sau123@#%";   // <-- change to your MySQL password

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC Driver not found: " + e.getMessage(), e);
        }
    }

    /**
     * Returns a new database connection.
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
    }

    private DBConnection() {}   // prevent instantiation
}
