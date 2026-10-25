
package com.crickethub.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionFactory {

    public static Connection getCon() {
        Connection con = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            String url = "jdbc:mysql://localhost:3306/crickethub";
            String username = "root";
            String password = System.getenv("CRICKETHUB_DB_PASSWORD");

            if (password == null || password.isEmpty()) {
                throw new IllegalStateException(
                    "Please set CRICKETHUB_DB_PASSWORD environment variable"
                );
            }

            con = DriverManager.getConnection(url, username, password);
        }
        catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        catch (SQLException e) {
            e.printStackTrace();
        }

        return con;
    }
}
