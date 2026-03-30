package com.book.servlet;

import com.book.dao.BorrowDAO;
import com.book.dao.ReturnDAO;
import com.book.model.Borrow;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/ReturnServlet")
public class ReturnServlet extends HttpServlet {
    private ReturnDAO returnDao = new ReturnDAO();
    private BorrowDAO borrowDao = new BorrowDAO();

    // 1. Method GET: Digunakan untuk paparkan senarai buku yang belum dipulangkan
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Ambil data dari database melalui BorrowDAO
        List<Borrow> active = borrowDao.getAllActiveBorrows();
        
        // Simpan dalam attribute untuk digunakan oleh returnBook.jsp
        request.setAttribute("activeBorrows", active);
        
        // Forward ke halaman senarai pemulangan
        request.getRequestDispatcher("returnBook.jsp").forward(request, response);
    }

    // 2. Method POST: Digunakan apabila butang "Process Return" ditekan
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Ambil data dari form
            String borrowIdStr = request.getParameter("borrowId");
            String bookIdStr = request.getParameter("bookId");
            String fineStr = request.getParameter("fineAmount");
            
            // Data untuk resit
            String userId = request.getParameter("userId");
            String userName = request.getParameter("userName");
            String userEmail = request.getParameter("userEmail");
            String title = request.getParameter("bookTitle");

            // Semak jika data kritikal null untuk elakkan ralat trim()
            if (borrowIdStr == null || bookIdStr == null || fineStr == null) {
                response.sendRedirect("ReturnServlet?message=Error: Missing required data");
                return;
            }

            int borrowId = Integer.parseInt(borrowIdStr.trim());
            int bookId = Integer.parseInt(bookIdStr.trim());
            double fine = Double.parseDouble(fineStr.trim());

            // Update Database melalui ReturnDAO
            boolean isUpdated = returnDao.processReturn(borrowId, bookId, fine);

            if (isUpdated) {
                // Set attributes untuk dipaparkan di returnReceipt.jsp
                request.setAttribute("r_borrowId", borrowId);
                request.setAttribute("r_userId", userId);
                request.setAttribute("r_userName", userName);
                request.setAttribute("r_userEmail", userEmail);
                request.setAttribute("r_title", title);
                request.setAttribute("r_fine", String.format("%.2f", fine));
                
                request.getRequestDispatcher("returnReceipt.jsp").forward(request, response);
            } else {
                response.sendRedirect("ReturnServlet?message=Failed to update database record.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ReturnServlet?message=Error: " + e.getMessage());
        }
    }
}