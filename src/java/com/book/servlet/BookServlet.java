package com.book.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.book.dao.BookDAO;
import com.book.model.Book;
import java.io.IOException;
import java.util.List;
import javax.servlet.RequestDispatcher;

@WebServlet("/BookServlet")
public class BookServlet extends HttpServlet {

    private BookDAO dao;

    public void init() {
        dao = new BookDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String search = request.getParameter("search");
        List<Book> list;

        if (search != null && !search.isEmpty()) {
            list = dao.searchBooks(search);
        } else {
            list = dao.getAllBooks();
        }

        request.setAttribute("list", list);
        RequestDispatcher rd = request.getRequestDispatcher("CRUDpage.jsp");
        rd.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String idStr = request.getParameter("id");
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String priceStr = request.getParameter("price");

        try {
            // 1. Validation: Cek ID untuk Update/Delete
            if (("update".equals(action) || "delete".equals(action)) && (idStr == null || idStr.trim().isEmpty())) {
                request.setAttribute("error", "Please select a book from the table first!");
                doGet(request, response);
                return;
            }

            // 2. Process Actions
            if ("insert".equals(action)) {
                // Validation Harga
                double price = Double.parseDouble(priceStr);
                if (price <= 0) {
                    request.setAttribute("error", "Price must be greater than zero.");
                    doGet(request, response);
                    return;
                }
                
                Book b = new Book(title, author, price);
                dao.insertBook(b);

            } else if ("update".equals(action)) {
                int id = Integer.parseInt(idStr);
                double price = Double.parseDouble(priceStr);
                
                Book b = new Book(id, title, author, price, null);
                dao.updateBook(b);

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(idStr);
                dao.deleteBook(id);
            }

            // Sukses? Redirect ke GET supaya list refresh
            response.sendRedirect("BookServlet");

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid numeric value for Price or ID.");
            doGet(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An unexpected error occurred: " + e.getMessage());
            doGet(request, response);
        }
    }
}