package com.book.dao;

import java.sql.*;

public class ReturnDAO {
    private String jdbcURL = "jdbc:mysql://localhost:3306/librarydb?useSSL=false&serverTimezone=UTC";
    private String jdbcUsername = "root";
    private String jdbcPassword = "";

    protected Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
    }

    // Tukar return type kepada boolean supaya Servlet boleh buat check 'if (isUpdated)'
    public boolean processReturn(int borrowId, int bookId, double fine) {
        String updateBorrow = "UPDATE borrow_records SET status = 'Returned' WHERE borrow_id = ?";
        String updateBook = "UPDATE books SET status = 'Available' WHERE id = ?";
        
        // Pastikan table return_records wujud dalam DB anda
        String insertReturn = "INSERT INTO return_records (borrow_id, return_date, fine_amount) VALUES (?, CURDATE(), ?)";

        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false); // Mulakan transaksi

            try (PreparedStatement ps1 = conn.prepareStatement(updateBorrow);
                 PreparedStatement ps2 = conn.prepareStatement(updateBook);
                 PreparedStatement ps3 = conn.prepareStatement(insertReturn)) {
                
                // 1. Kemaskini status rekod pinjaman
                ps1.setInt(1, borrowId);
                int row1 = ps1.executeUpdate();

                // 2. Kemaskini status buku supaya boleh dipinjam orang lain
                ps2.setInt(1, bookId);
                int row2 = ps2.executeUpdate();

                // 3. Simpan rekod pemulangan dan denda
                ps3.setInt(1, borrowId);
                ps3.setDouble(2, fine);
                ps3.executeUpdate();

                // Pastikan sekurang-kurangnya rekod pinjaman dan buku berjaya dikemaskini
                if (row1 > 0 && row2 > 0) {
                    conn.commit();
                    return true; // Berjaya! Servlet akan teruskan ke resit
                } else {
                    conn.rollback();
                    return false;
                }
                
            } catch (SQLException e) {
                if (conn != null) conn.rollback();
                e.printStackTrace();
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }
}