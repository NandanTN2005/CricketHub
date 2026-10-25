
package com.crickethub.servlet;

import java.io.IOException;

import com.crickethub.dao.impl.UserDAOImpl;
import com.crickethub.dto.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class Register extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");

        // Check empty fields
        if (username == null || username.trim().isEmpty()
                || email == null || email.trim().isEmpty()
                || password == null || password.isEmpty()
                || confirmPassword == null || confirmPassword.isEmpty()) {

            showError(req, resp, "Please fill in all fields.");
            return;
        }

        username = username.trim();
        email = email.trim();

        // Validate username length
        if (username.length() > 50) {
            showError(req, resp, "Username must not exceed 50 characters.");
            return;
        }

        // Validate email length
        if (email.length() > 255) {
            showError(req, resp, "Email must not exceed 255 characters.");
            return;
        }

        // Basic email validation
        if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            showError(req, resp, "Please enter a valid email address.");
            return;
        }

        // Validate password length
        if (password.length() > 255) {
            showError(req, resp, "Password must not exceed 255 characters.");
            return;
        }

        // Check password confirmation
        if (!password.equals(confirmPassword)) {
            showError(req, resp, "Passwords do not match.");
            return;
        }

        // Create normal user account
        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(password);
        user.setRole("USER");
        user.setTeamId(null);

        UserDAOImpl userDAO = new UserDAOImpl();

        boolean registered = userDAO.register(user);

        if (registered) {
            resp.sendRedirect(
                req.getContextPath()
                + "/login.jsp?registered=success"
            );
        } else {
            showError(req, resp,
                "Username or email already exists, or registration failed.");
        }
    }

    private void showError(HttpServletRequest req,
                           HttpServletResponse resp,
                           String message)
            throws ServletException, IOException {

        req.setAttribute("Error_in_register", message);
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }
}
