package com.book.servlet;

import javax.servlet.annotation.WebServlet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/superLogin")
public class SuperLoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String user = request.getParameter("username");
        String pass = request.getParameter("password");
        HttpSession session = request.getSession();

        // SEMAKAN FIXED CREDENTIAL SAHAJA
        if ("superadmin".equals(user) && "SuperPassword123!".equals(pass)) {
            session.setAttribute("username", "Super Admin");
            session.setAttribute("role", "superadmin");
            response.sendRedirect(request.getContextPath() + "/register.jsp");
        } else {
            request.setAttribute("errorMessage", "Invalid Super Admin credentials.");
            request.getRequestDispatcher("/loginSuper.jsp").forward(request, response);
        }
    }
}