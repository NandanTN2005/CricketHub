
package com.crickethub.servlet;

import java.io.IOException;
import java.util.List;

import com.crickethub.dao.impl.PointsTableDAOImpl;
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

@WebServlet("/pointsTable")
public class PointsTableServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

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

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {

        // Only authenticated users can view the points table.
        if (!isLoggedIn(req)) {
            resp.sendRedirect(
                    req.getContextPath() + "/login.jsp");
            return;
        }

        TournamentDAOImpl tournamentDAO =
                new TournamentDAOImpl();

        List<Tournament> tournaments =
                tournamentDAO.getAllTournaments();

        req.setAttribute("tournaments", tournaments);

        String tournamentId = req.getParameter("tournamentId");

        if (tournamentId != null && !tournamentId.isBlank()) {
            try {
                int id = Integer.parseInt(tournamentId);

                if (id <= 0) {
                    throw new NumberFormatException();
                }

                boolean tournamentExists = false;

                if (tournaments != null) {
                    for (Tournament tournament : tournaments) {
                        if (tournament.getId() == id) {
                            tournamentExists = true;
                            break;
                        }
                    }
                }

                if (tournamentExists) {
                    PointsTableDAOImpl pointsDAO =
                            new PointsTableDAOImpl();

                    req.setAttribute(
                            "pointsTable",
                            pointsDAO.getPointsTableByTournament(id));

                    req.setAttribute("selectedTournamentId", id);

                } else {
                    req.setAttribute(
                            "Error_in_pointsTable",
                            "Please select a valid tournament.");
                }

            } catch (NumberFormatException e) {
                req.setAttribute(
                        "Error_in_pointsTable",
                        "Invalid tournament selected.");
            }
        }

        req.getRequestDispatcher("/pointsTable.jsp")
                .forward(req, resp);
    }
}
