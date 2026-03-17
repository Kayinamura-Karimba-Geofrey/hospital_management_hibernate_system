import java.sql.*;

public class SchemaVerifier {
    public static void main(String[] args) {
        String url = "jdbc:postgresql://localhost:5432/hospital_db";
        String user = "postgres";
        String password = "123";

        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            DatabaseMetaData metaData = conn.getMetaData();
            ResultSet rs = metaData.getColumns(null, null, "appointments", null);
            
            System.out.println("--- Appointments Table Columns ---");
            while (rs.next()) {
                String name = rs.getString("COLUMN_NAME");
                String type = rs.getString("TYPE_NAME");
                System.out.println("Column: " + name + " | Type: " + type);
            }
            System.out.println("--- End ---");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
