package com.book.servlet; // Pastikan package name ni betul ikut folder Hani

import com.book.dao.BorrowDAO;
import java.io.IOException;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Panggil DAO
        BorrowDAO dao = new BorrowDAO();
        
        // 2. Ambil data statistik
        Map<String, Integer> stats = dao.getDashboardStats();
        
        // 3. Simpan data dalam request attribute
        request.setAttribute("stats", stats);
        
        // 4. Forward ke fail JSP yang ada chart tu (Kalau fail Hani nama index.jsp, tukar sini)
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}