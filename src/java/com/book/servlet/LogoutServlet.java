package com.book.servlet;

import javax.servlet.annotation.WebServlet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Ambil session sedia ada
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // 2. Hapus semua data dalam session (username, role, dll)
            session.invalidate(); 
        }
        
        // 3. Hantar user balik ke page login selepas session dibuang
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}