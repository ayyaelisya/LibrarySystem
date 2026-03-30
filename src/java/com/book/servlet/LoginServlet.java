package com.book.servlet;

import com.book.dao.UserDAO;
import javax.servlet.annotation.WebServlet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        HttpSession session = request.getSession();

        // HANYA SEMAK DATABASE
        boolean valid = userDAO.validateUser(username, password);
        
        if (valid) {
            session.setAttribute("username", username);
            session.setAttribute("role", "staff");
            response.sendRedirect(request.getContextPath() + "/DashboardServlet");
        } else {
            request.setAttribute("errorMessage", "Invalid Admin credentials.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}