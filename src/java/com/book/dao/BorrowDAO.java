package com.book.dao;

import com.book.model.Book;
import com.book.model.Borrow;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

public class BorrowDAO {
    private String jdbcURL = "jdbc:mysql://localhost:3306/librarydb?useSSL=false&serverTimezone=UTC";
    private String jdbcUsername = "root";
    private String jdbcPassword = "";

    protected Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
        } catch (Exception e) { e.printStackTrace(); }
        return conn;
    }

// Ambil statistik untuk Dashboard (Real-life Version)
public Map<String, Integer> getDashboardStats() {
    Map<String, Integer> stats = new HashMap<>();
    
 
    String sql = "SELECT " +
                 "(SELECT COUNT(*) FROM books) as total, " +
                 "(SELECT COUNT(*) FROM borrow_records WHERE status = 'Active') as borrowed, " + 
                 "(SELECT COUNT(*) FROM books WHERE status = 'Available') as available, " +
                 "(SELECT COUNT(*) FROM borrow_records WHERE status = 'Active' AND due_date < CURDATE()) as overdue";
                 
    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        if (rs.next()) {
            stats.put("total", rs.getInt("total"));
            stats.put("borrowed", rs.getInt("borrowed"));
            stats.put("available", rs.getInt("available"));
            stats.put("overdue", rs.getInt("overdue"));
        }
    } catch (Exception e) { 
        e.printStackTrace(); 
    }
    return stats;
}

    public List<Book> getAvailableBooks() {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT * FROM books WHERE status = 'Available'";
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Book(rs.getInt("id"), rs.getString("title"), rs.getString("author"), rs.getDouble("price"), rs.getString("status")));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Borrow> getAllActiveBorrows() {
        List<Borrow> list = new ArrayList<>();
        String sql = "SELECT br.*, b.title FROM borrow_records br JOIN books b ON br.book_id = b.id WHERE br.status = 'Active'";
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Borrow(rs.getInt("borrow_id"), rs.getInt("book_id"), rs.getString("title"), rs.getString("user_id"),
                    rs.getString("user_name"), rs.getString("user_email"), rs.getDate("borrow_date"), rs.getDate("due_date"), rs.getString("status")));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean borrowBook(int bookId, String userId, String userName, String userEmail, String dueDate) {
        String insertSQL = "INSERT INTO borrow_records (book_id, user_id, user_name, user_email, borrow_date, due_date, status) VALUES (?, ?, ?, ?, CURDATE(), ?, 'Active')";
        String updateBookSQL = "UPDATE books SET status = 'Borrowed' WHERE id = ?";
        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps1 = conn.prepareStatement(insertSQL)) {
                ps1.setInt(1, bookId); ps1.setString(2, userId); ps1.setString(3, userName); ps1.setString(4, userEmail); ps1.setString(5, dueDate);
                ps1.executeUpdate();
            }
            try (PreparedStatement ps2 = conn.prepareStatement(updateBookSQL)) {
                ps2.setInt(1, bookId); ps2.executeUpdate();
            }
            conn.commit();
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }
}