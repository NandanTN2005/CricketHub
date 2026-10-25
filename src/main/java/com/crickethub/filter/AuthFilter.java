
package com.crickethub.filter;

import java.io.IOException;

import com.crickethub.dto.Admin;
import com.crickethub.dto.User;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter(urlPatterns = {
    "/dashboard.jsp",
    "/dashboard",
    "/tournaments",
    "/teams",
    "/matches",
    "/standings",
    "/pointsTable"
})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(
            jakarta.servlet.ServletRequest request,
            jakarta.servlet.ServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req =
                (HttpServletRequest) request;

        HttpServletResponse resp =
                (HttpServletResponse) response;

        HttpSession session = req.getSession(false);

        boolean isAdmin = session != null
                && session.getAttribute("admin") instanceof Admin;

        boolean isUser = false;

        if (session != null
                && session.getAttribute("user") instanceof User) {

            User user = (User) session.getAttribute("user");

            isUser = "USER".equals(user.getRole())
                    || "CAPTAIN".equals(user.getRole());
        }

        if (isAdmin || isUser) {
            // A logged-in admin, user, or captain can continue.
            chain.doFilter(request, response);
        } else {
            // No valid logged-in session.
            resp.sendRedirect(
                    req.getContextPath() + "/login.jsp");
        }
    }
}
