package com.ngo.util;

import java.sql.Connection;

public class DBTest {
    public static void main(String[] args) {
        Connection con = DBConnection.getConnection();
        if (con != null)
            System.out.println("✅ DB Connected Successfully");
        else
            System.out.println("DB Connection Failed");
    }
}
