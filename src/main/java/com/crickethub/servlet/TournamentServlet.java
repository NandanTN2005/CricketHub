
package com.crickethub.servlet;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

import com.crickethub.dao.impl.TournamentDAOImpl;
import com.crickethub.dto.Admin;
import com.crickethub.dto.Tournament;
import com.crickethub.dto.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/tournaments")
public class TournamentServlet extends HttpServlet {

    private boolean isAdmin(HttpServletRequest req) {
        HttpSession session = req.getSession(false);

        return session != null
                && session.getAttribute("admin") instanceof Admin;
    }

    private boolean isLoggedIn(HttpServletRequest req) {
        HttpSession session = req.getSession(false);

        if (session == null) {
            return false;
        }

        if (session.getAttribute("admin") instanceof Admin) {
            return true;
        }

        Object obj = session.getAttribute("user");

        if (obj instanceof User) {
            User user = (User) obj;

            return "CAPTAIN".equals(user.getRole())
                    || "USER".equals(user.getRole());
        }

        return false;
    }

    // All authenticated roles can view tournaments.
    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isLoggedIn(req)) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        TournamentDAOImpl tdao = new TournamentDAOImpl();

        req.setAttribute("tournaments", tdao.getAllTournaments());
        req.setAttribute("isAdmin", isAdmin(req));

        req.getRequestDispatcher("/tournaments.jsp")
                .forward(req, resp);
    }

    // Only Admin can add tournaments.
    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req)) {
            resp.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Only admins can add tournaments.");
            return;
        }

        req.setCharacterEncoding("UTF-8");

        TournamentDAOImpl tdao = new TournamentDAOImpl();

        String name = req.getParameter("name");
        String venue = req.getParameter("venue");
        String date = req.getParameter("startDate");

        String errorMessage = null;

        if (name == null || name.isBlank()
                || venue == null || venue.isBlank()
                || date == null || date.isBlank()) {

            errorMessage = "Please fill all the fields.";

        } else if (name.trim().length() > 100
                || venue.trim().length() > 150) {

            errorMessage =
                    "Tournament name must not exceed 100 characters and venue must not exceed 150 characters.";

        } else {
            try {
                LocalDate startDate = LocalDate.parse(date);

                Tournament tournament = new Tournament(
                        name.trim(),
                        venue.trim(),
                        startDate
                );

                boolean result = tdao.addTournament(tournament);

                if (result) {
                    resp.sendRedirect(
                            req.getContextPath() + "/tournaments");
                    return;
                }

                errorMessage = "Unable to add tournament.";

            } catch (DateTimeParseException e) {
                errorMessage = "Please enter a valid tournament date.";
            }
        }

        // Reload data and display any error.
        req.setAttribute("Error_in_tournament", errorMessage);
        req.setAttribute("tournaments", tdao.getAllTournaments());
        req.setAttribute("isAdmin", true);

        req.getRequestDispatcher("/tournaments.jsp")
                .forward(req, resp);
    }
}
