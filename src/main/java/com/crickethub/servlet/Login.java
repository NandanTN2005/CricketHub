
package com.crickethub.servlet;

import java.io.IOException;

import com.crickethub.dao.impl.AdminDAOImpl;
import com.crickethub.dao.impl.UserDAOImpl;
import com.crickethub.dto.Admin;
import com.crickethub.dto.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class Login extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String role = req.getParameter("role");

        if (username == null || username.trim().isEmpty()
                || password == null || password.isEmpty()
                || role == null || role.trim().isEmpty()) {

            showError(req, resp, "Please enter all login details.");
            return;
        }

        username = username.trim();
        role = role.trim().toUpperCase();

        // Only these three roles are allowed
        if (!role.equals("ADMIN")
                && !role.equals("CAPTAIN")
                && !role.equals("USER")) {

            showError(req, resp, "Please select a valid login role.");
            return;
        }

        // ADMIN login: check only the admins table
        if (role.equals("ADMIN")) {

            Admin admin = new AdminDAOImpl().login(
                    new Admin(username, password));

            if (admin != null) {
                HttpSession oldSession = req.getSession(false);

                if (oldSession != null) {
                    oldSession.invalidate();
                }

                HttpSession session = req.getSession(true);
                session.setAttribute("admin", admin);
                session.setMaxInactiveInterval(20 * 60);

                resp.sendRedirect(
                    req.getContextPath() + "/dashboard.jsp");
                return;
            }

            showError(req, resp,
                    "Invalid Admin username or password.");
            return;
        }

        // CAPTAIN and USER login: check only the users table
        User user = new UserDAOImpl().login(
                new User(username, password));

        if (user == null) {
            showError(req, resp, "Invalid username or password.");
            return;
        }

        String actualRole = user.getRole();

        // Selected role must match the role stored in MySQL
        if (actualRole == null || !actualRole.equalsIgnoreCase(role)) {
            showError(req, resp,
                    "Role mismatch. Please select the correct login role.");
            return;
        }

        HttpSession oldSession = req.getSession(false);

        if (oldSession != null) {
            oldSession.invalidate();
        }

        HttpSession session = req.getSession(true);
        session.setAttribute("user", user);
        session.setMaxInactiveInterval(20 * 60);

        if (role.equals("CAPTAIN")) {
            resp.sendRedirect(
                req.getContextPath() + "/captainDashboard.jsp");
        } else {
            resp.sendRedirect(
                req.getContextPath() + "/userDashboard.jsp");
        }
    }

    private void showError(HttpServletRequest req,
                           HttpServletResponse resp,
                           String message)
            throws ServletException, IOException {

        req.setAttribute("Error_in_login", message);
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }
}
