import org.flywaydb.core.Flyway;

public class RepairDB {
    public static void main(String[] args) {
        try {
            Flyway flyway = Flyway.configure()
                .dataSource("jdbc:postgresql://localhost:5432/hospital_db", "postgres", "123")
                .baselineOnMigrate(true)
                .load();
            flyway.repair();
            flyway.migrate();
            System.out.println("Flyway repair and migrate executed successfully.");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
