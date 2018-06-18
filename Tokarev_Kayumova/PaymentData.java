package mypackage;

import javax.servlet.ServletConfig;
import java.sql.*;
import java.util.Properties;

import static java.lang.Class.forName;

public class PaymentData {
    protected static Connection conn;

    public static void init() {
        try {
            forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        String dbUrl = "localhost:1433";
        String databaseName = "PaymentData_test";
        String username = "millioner";
        String password = "millioner";

        Properties info = new Properties();
        info.put("user", username);
        info.put("password", password);
        info.put("databaseName", databaseName);

        try {
            conn = DriverManager.getConnection("jdbc:sqlserver://" + dbUrl, info);
        } catch (SQLException ex) {
            System.out.println("SQLException: " + ex.getMessage());
            System.out.println("SQLState: " + ex.getSQLState());
            System.out.println("VendorError: " + ex.getErrorCode());
        }
    }

    public static void destroy() {
        try {
            if (conn != null && !conn.isClosed())
                conn.close();
        } catch (SQLException ex) {
            System.out.println("SQLException: " + ex.getMessage());
            System.out.println("SQLState: " + ex.getSQLState());
            System.out.println("VendorError: " + ex.getErrorCode());
        }
    }

    public static void insert_one_by_one_with_trigger(int N) {
        try (PreparedStatement stmt = conn.prepareStatement(
                "INSERT INTO Payment " +
                        "(Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number) " +
                        "VALUES (" +
                        "NEWID()," +
                        "100," +
                        "'F0F25486-F0E2-4C0A-99D3-068508D13EAF'," +
                        "'28186996-5b5b-7729-455f-1885b89fc8fc'," +
                        "'test payment'," +
                        "'test payment'," +
                        "'2010-10-10 10:10:10'," +
                        "'2a450567-2f77-6b37-ff4b-16e575b61049'," +
                        "'303CAA32-6C00-5A68-054C-16E575B61049'," +
                        "NULL," +
                        "NULL," +
                        "'2010-10-10 10:10:10'," +
                        "'111'," +
                        "0," +
                        "'111')"
        )) {
            for (int i = 0; i < N; ++i) {
                stmt.executeUpdate();
            }
        } catch (SQLException ex) {
            System.out.println("SQLException: " + ex.getMessage());
            System.out.println("SQLState: " + ex.getSQLState());
            System.out.println("VendorError: " + ex.getErrorCode());
        }
    }

    public static void insert_one_by_one_without_trigger(int N) {
        try (PreparedStatement stmt = conn.prepareStatement(
                "INSERT INTO Payment " +
                        "(Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number) " +
                        "VALUES (" +
                        "NEWID()," +
                        "100," +
                        "'F0F25486-F0E2-4C0A-99D3-068508D13EAF'," +
                        "'28186996-5b5b-7729-455f-1885b89fc8fc'," +
                        "'test payment'," +
                        "'test payment'," +
                        "'2010-10-10 10:10:10'," +
                        "'2a450567-2f77-6b37-ff4b-16e575b61049'," +
                        "'303CAA32-6C00-5A68-054C-16E575B61049'," +
                        "NULL," +
                        "NULL," +
                        "'2010-10-10 10:10:10'," +
                        "'111'," +
                        "0," +
                        "'111')"
        )) {
            Statement stmt2 = conn.createStatement();
            stmt2.execute("DISABLE TRIGGER T_Payment_AI ON Payment");
            for (int i = 0; i < N-1; ++i) {
                stmt.executeUpdate();
            }
            stmt2.execute("ENABLE TRIGGER T_Payment_AI ON Payment");
            stmt.executeUpdate();
        } catch (SQLException ex) {
            System.out.println("SQLException: " + ex.getMessage());
            System.out.println("SQLState: " + ex.getSQLState());
            System.out.println("VendorError: " + ex.getErrorCode());
        }
    }

    public static void insert_batch_with_trigger(int N) {
        try (Statement stmt = conn.createStatement()) {
            for (int i = 0; i < N; ++i)
                stmt.addBatch("INSERT INTO Payment " +
                        "(Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number) " +
                        "VALUES (" +
                        "NEWID()," +
                        "100," +
                        "'F0F25486-F0E2-4C0A-99D3-068508D13EAF'," +
                        "'28186996-5b5b-7729-455f-1885b89fc8fc'," +
                        "'test payment'," +
                        "'test payment'," +
                        "'2010-10-10 10:10:10'," +
                        "'2a450567-2f77-6b37-ff4b-16e575b61049'," +
                        "'303CAA32-6C00-5A68-054C-16E575B61049'," +
                        "NULL," +
                        "NULL," +
                        "'2010-10-10 10:10:10'," +
                        "'111'," +
                        "0," +
                        "'111')");
            stmt.executeBatch();
        } catch (SQLException ex) {
            System.out.println("SQLException: " + ex.getMessage());
            System.out.println("SQLState: " + ex.getSQLState());
            System.out.println("VendorError: " + ex.getErrorCode());
        }
    }

    public static void insert_batch_without_trigger(int N) {
        try (Statement stmt = conn.createStatement()) {
            Statement stmt2 = conn.createStatement();
            stmt2.execute("DISABLE TRIGGER T_Payment_AI ON Payment");
            for (int i = 0; i < N-1; ++i)
                stmt.addBatch("INSERT INTO Payment " +
                        "(Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number) " +
                        "VALUES (" +
                        "NEWID()," +
                        "100," +
                        "'F0F25486-F0E2-4C0A-99D3-068508D13EAF'," +
                        "'28186996-5b5b-7729-455f-1885b89fc8fc'," +
                        "'test payment'," +
                        "'test payment'," +
                        "'2010-10-10 10:10:10'," +
                        "'2a450567-2f77-6b37-ff4b-16e575b61049'," +
                        "'303CAA32-6C00-5A68-054C-16E575B61049'," +
                        "NULL," +
                        "NULL," +
                        "'2010-10-10 10:10:10'," +
                        "'111'," +
                        "0," +
                        "'111')");
            stmt.executeBatch();
            stmt2.execute("ENABLE TRIGGER T_Payment_AI ON Payment");
            stmt.execute("INSERT INTO Payment " +
                    "(Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number) " +
                    "VALUES (" +
                    "NEWID()," +
                    "100," +
                    "'F0F25486-F0E2-4C0A-99D3-068508D13EAF'," +
                    "'28186996-5b5b-7729-455f-1885b89fc8fc'," +
                    "'test payment'," +
                    "'test payment'," +
                    "'2010-10-10 10:10:10'," +
                    "'2a450567-2f77-6b37-ff4b-16e575b61049'," +
                    "'303CAA32-6C00-5A68-054C-16E575B61049'," +
                    "NULL," +
                    "NULL," +
                    "'2010-10-10 10:10:10'," +
                    "'111'," +
                    "0," +
                    "'111')");
        } catch (SQLException ex) {
            System.out.println("SQLException: " + ex.getMessage());
            System.out.println("SQLState: " + ex.getSQLState());
            System.out.println("VendorError: " + ex.getErrorCode());
        }
    }

    public static void main(String[] args) {
        init();

        long startTime = System.nanoTime();
        insert_one_by_one_with_trigger(1000);
        long endTime   = System.nanoTime();
        long totalTime = endTime - startTime;
        System.out.println(String.format("1 by 1 with trigger: %s", totalTime));

        startTime = System.nanoTime();
        insert_batch_with_trigger(1000);
        endTime   = System.nanoTime();
        totalTime = endTime - startTime;
        System.out.println(String.format("Batch with trigger: %s", totalTime));

        startTime = System.nanoTime();
        insert_one_by_one_without_trigger(1000);
        endTime   = System.nanoTime();
        totalTime = endTime - startTime;
        System.out.println(String.format("1 by 1 without trigger: %s", totalTime));

        startTime = System.nanoTime();
        insert_batch_without_trigger(1000);
        endTime   = System.nanoTime();
        totalTime = endTime - startTime;
        System.out.println(String.format("Batch without trigger: %s", totalTime));

        destroy();
    }
}
