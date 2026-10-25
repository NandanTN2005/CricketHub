
package com.crickethub.servlet;

import java.io.IOException;
import java.util.List;

import com.crickethub.dao.impl.TeamDAOImpl;
import com.crickethub.dao.impl.TournamentDAOImpl;
import com.crickethub.dto.Admin;
import com.crickethub.dto.Team;
import com.crickethub.dto.Tournament;
import com.crickethub.dto.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/teams")
public class TeamServlet extends HttpServlet {

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

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {

        // Admin, Captain and User can view teams.
        if (!isLoggedIn(req)) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        TeamDAOImpl teamdao = new TeamDAOImpl();
        TournamentDAOImpl tournamentdao = new TournamentDAOImpl();

        req.setAttribute("teams", teamdao.getAllTeams());
        req.setAttribute("tournaments",
                tournamentdao.getAllTournaments());
        req.setAttribute("isAdmin", isAdmin(req));

        req.getRequestDispatcher("/teams.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {

        // Only Admin can add teams.
        if (!isAdmin(req)) {
            resp.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Only admins can manage teams.");
            return;
        }

        req.setCharacterEncoding("UTF-8");

        TeamDAOImpl teamdao = new TeamDAOImpl();
        TournamentDAOImpl tournamentdao = new TournamentDAOImpl();

        String tournamentId = req.getParameter("tournamentId");
        String teamName = req.getParameter("teamName");
        String captain = req.getParameter("captain");

        String errorMessage = null;

        if (tournamentId == null || tournamentId.isBlank()
                || teamName == null || teamName.isBlank()
                || captain == null || captain.isBlank()) {

            errorMessage = "Please fill all fields.";

        } else if (teamName.trim().length() > 100
                || captain.trim().length() > 100) {

            errorMessage =
                    "Team name and captain name must not exceed 100 characters.";

        } else {
            try {
                int tid = Integer.parseInt(tournamentId);

                if (tid <= 0) {
                    throw new NumberFormatException();
                }

                // Confirm that the selected tournament exists.
                List<Tournament> tournaments =
                        tournamentdao.getAllTournaments();

                boolean tournamentExists = false;

                for (Tournament tournament : tournaments) {
                    if (tournament.getId() == tid) {
                        tournamentExists = true;
                        break;
                    }
                }

                if (!tournamentExists) {
                    errorMessage = "Invalid tournament selected.";
                } else {
                    Team team = new Team(
                            tid,
                            teamName.trim(),
                            captain.trim()
                    );

                    boolean result = teamdao.addTeam(team);

                    if (result) {
                        resp.sendRedirect(
                                req.getContextPath() + "/teams");
                        return;
                    }

                    errorMessage = "Unable to add team.";
                }

            } catch (NumberFormatException e) {
                errorMessage = "Invalid tournament selected.";
            }
        }

        // Reload data and show any error on teams.jsp.
        req.setAttribute("Error_in_team", errorMessage);
        req.setAttribute("teams", teamdao.getAllTeams());
        req.setAttribute("tournaments",
                tournamentdao.getAllTournaments());
        req.setAttribute("isAdmin", true);

        req.getRequestDispatcher("/teams.jsp")
                .forward(req, resp);
    }
}
