package com.book.model;
import java.sql.Date;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public class Borrow {
    private int borrowId;
    private int bookId;
    private String bookTitle;
    private String userId;
    private String userName;
    private String userEmail;
    private Date borrowDate;
    private Date dueDate;
    private String status;

    // Constructor 
    public Borrow(int borrowId, int bookId, String bookTitle, String userId, 
                  String userName, String userEmail, Date borrowDate, Date dueDate, String status) {
        this.borrowId = borrowId;
        this.bookId = bookId;
        this.bookTitle = bookTitle;
        this.userId = userId;
        this.userName = userName;
        this.userEmail = userEmail;
        this.borrowDate = borrowDate;
        this.dueDate = dueDate;
        this.status = status;
    }

    // Getters
    public int getBorrowId() { return borrowId; }
    public int getBookId() { return bookId; }
    public String getBookTitle() { return bookTitle; }
    public String getUserId() { return userId; }
    public String getUserName() { return userName; }
    public String getUserEmail() { return userEmail; }
    public Date getBorrowDate() { return borrowDate; }
    public Date getDueDate() { return dueDate; }
    public String getStatus() { return status; }
    


    // PENGIRAAN DENDA 
    public double calculateFine() {
        if (dueDate == null) return 0.0;

        // Ambil tarikh hari ini (Date sahaja tanpa masa)
        LocalDate today = LocalDate.now();
        
        // Tukar java.sql.Date ke java.time.LocalDate
        LocalDate due = dueDate.toLocalDate();

        // Jika hari ini melepasi tarikh tamat
        if (today.isAfter(due)) {
            
            // Kira beza hari secara tepat
            long daysLate = ChronoUnit.DAYS.between(due, today);
            
           //rm2 sehari
            return daysLate * 2.00; 
        }
        
        return 0.0;
    }
}