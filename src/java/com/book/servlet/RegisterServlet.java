package com.book.servlet;

import com.book.dao.UserDAO;
import javax.servlet.annotation.WebServlet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.regex.Pattern;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        
        if (session == null || !"superadmin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {

            request.setAttribute("errorMessage", "All fields are required.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        String passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&.#_\\-])[A-Za-z\\d@$!%*?&.#_\\-]{8,}$";

        if (!Pattern.matches(passwordRegex, password)) {
            request.setAttribute("errorMessage",
                    "Password must be at least 8 characters and include uppercase, lowercase, number, and special character.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        boolean registered = userDAO.registerUser(username, password);

        if (registered) {
            request.setAttribute("successMessage", "Registration successful!");
        } else {
            request.setAttribute("errorMessage", "Username already exists.");
        }

        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }
    
}