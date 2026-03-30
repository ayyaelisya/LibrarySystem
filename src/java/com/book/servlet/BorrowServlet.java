package com.book.servlet;

import com.book.dao.BorrowDAO;
import com.book.model.Book;
import com.book.model.Borrow;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/BorrowServlet")
public class BorrowServlet extends HttpServlet {
    private BorrowDAO borrowDao = new BorrowDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Ambil data terbaru untuk dipaparkan di table Borrow.jsp
        List<Book> available = borrowDao.getAvailableBooks();
        List<Borrow> active = borrowDao.getAllActiveBorrows();

        request.setAttribute("availableBooks", available);
        request.setAttribute("activeBorrows", active);
        
        request.getRequestDispatcher("Borrow.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        // 1. Ambil data dari form
        String userId = request.getParameter("userId");
        String userName = request.getParameter("userName");
        String userEmail = request.getParameter("userEmail");
        String bookIdStr = request.getParameter("bookId");
        String dueDate = request.getParameter("dueDate");

        try {
            // 2. VALIDATION: Pastikan semua field tidak kosong
            if (userId == null || userId.trim().isEmpty() || 
                userName == null || userName.trim().isEmpty() ||
                userEmail == null || userEmail.trim().isEmpty() ||
                bookIdStr == null || bookIdStr.isEmpty() || 
                dueDate == null || dueDate.isEmpty()) {
                
                request.setAttribute("error", "Please fill in all fields (User ID, Name, Email, Book, and Due Date)!");
                doGet(request, response); 
                return;
            }

            // 3. TUKAR DATA TYPE
            int bookId = Integer.parseInt(bookIdStr);

            // 4. PROSES PINJAMAN DI DAO (Hantar 5 parameter lengkap ke DB)
            boolean isSuccess = borrowDao.borrowBook(bookId, userId, userName, userEmail, dueDate);

            if (isSuccess) {
                // Jika berjaya, terus ke GET untuk refresh senarai rekod
                response.sendRedirect("BorrowServlet?status=success");
            } else {
                // Jika DAO return false (masalah SQL)
                request.setAttribute("error", "Database Error: Could not process the borrowing record.");
                doGet(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid Book ID selection.");
            doGet(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "System Error: " + e.getMessage());
            doGet(request, response);
        }
    }
}