
package com.crickethub.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.crickethub.dao.PlayerDAO;
import com.crickethub.dao.TeamDAO;
import com.crickethub.dao.impl.PlayerDAOImpl;
import com.crickethub.dao.impl.TeamDAOImpl;
import com.crickethub.dto.Admin;
import com.crickethub.dto.Player;
import com.crickethub.dto.Team;
import com.crickethub.dto.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/players")
public class PlayerServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private PlayerDAO playerDAO;
    private TeamDAO teamDAO;

    @Override
    public void init() throws ServletException {
        playerDAO = new PlayerDAOImpl();
        teamDAO = new TeamDAOImpl();
    }

    private boolean isAdmin(HttpServletRequest req) {
        HttpSession session = req.getSession(false);

        return session != null
                && session.getAttribute("admin") instanceof Admin;
    }

    private User getLoggedInUser(HttpServletRequest req) {
        HttpSession session = req.getSession(false);

        if (session == null) {
            return null;
        }

        Object obj = session.getAttribute("user");

        if (obj instanceof User) {
            return (User) obj;
        }

        return null;
    }

    private User getCaptain(HttpServletRequest req) {
        User user = getLoggedInUser(req);

        if (user != null
                && "CAPTAIN".equals(user.getRole())
                && user.getTeamId() != null) {
            return user;
        }

        return null;
    }

    private boolean isNormalUser(HttpServletRequest req) {
        User user = getLoggedInUser(req);

        return user != null && "USER".equals(user.getRole());
    }

    private boolean isLoggedIn(HttpServletRequest req) {
        return isAdmin(req)
                || getCaptain(req) != null
                || isNormalUser(req);
    }

    private boolean canManagePlayers(HttpServletRequest req) {
        return isAdmin(req) || getCaptain(req) != null;
    }

    private int getPositiveId(String value) {
        if (value == null || value.trim().isEmpty()) {
            throw new IllegalArgumentException("ID is required.");
        }

        try {
            int id = Integer.parseInt(value.trim());

            if (id <= 0) {
                throw new IllegalArgumentException(
                        "ID must be positive.");
            }

            return id;

        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(
                    "ID must be a valid number.");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isLoggedIn(req)) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        try {
            boolean admin = isAdmin(req);
            User captain = getCaptain(req);
            boolean viewer = isNormalUser(req);

            List<Team> teams;

            if (admin || viewer) {
                // Admins and normal users can select any team.
                teams = teamDAO.getAllTeams();

                if (teams == null) {
                    teams = new ArrayList<>();
                }

            } else {
                // Captains can access only their own team.
                teams = new ArrayList<>();

                Team captainTeam =
                        teamDAO.getTeamById(captain.getTeamId());

                if (captainTeam == null) {
                    resp.sendError(
                            HttpServletResponse.SC_NOT_FOUND,
                            "Your team was not found.");
                    return;
                }

                teams.add(captainTeam);
            }

            req.setAttribute("teams", teams);
            req.setAttribute("isAdmin", admin);
            req.setAttribute("isCaptain", captain != null);
            req.setAttribute("isViewer", viewer);
            req.setAttribute("canManagePlayers",
                    canManagePlayers(req));

            String teamIdValue = req.getParameter("teamId");
            int teamId;

            if (admin || viewer) {

                // Show the team selector until a team is selected.
                if (teamIdValue == null
                        || teamIdValue.trim().isEmpty()) {

                    req.getRequestDispatcher("/players.jsp")
                            .forward(req, resp);
                    return;
                }

                teamId = getPositiveId(teamIdValue);

            } else {

                // Always use the captain's team from the session.
                teamId = captain.getTeamId();

                if (teamIdValue != null
                        && !teamIdValue.trim().isEmpty()
                        && getPositiveId(teamIdValue) != teamId) {

                    resp.sendError(
                            HttpServletResponse.SC_FORBIDDEN,
                            "You can access only your own team's players.");
                    return;
                }
            }

            Team selectedTeam = teamDAO.getTeamById(teamId);

            if (selectedTeam == null) {
                resp.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "Team not found.");
                return;
            }

            List<Player> players =
                    playerDAO.getPlayersByTeam(teamId);

            req.setAttribute("players", players);
            req.setAttribute("teamId", teamId);
            req.setAttribute("selectedTeam", selectedTeam);

            req.getRequestDispatcher("/players.jsp")
                    .forward(req, resp);

        } catch (IllegalArgumentException e) {
            resp.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Please provide a valid team ID.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        if (!isLoggedIn(req)) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // Normal users are strictly read-only.
        if (!canManagePlayers(req)) {
            resp.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "You are not allowed to modify players.");
            return;
        }

        String action = req.getParameter("action");

        try {
            boolean admin = isAdmin(req);
            User captain = getCaptain(req);

            int teamId;

            if (admin) {

                teamId = getPositiveId(
                        req.getParameter("teamId"));

            } else {

                // Never trust a captain's submitted team ID.
                teamId = captain.getTeamId();

                String submittedTeamId =
                        req.getParameter("teamId");

                if (submittedTeamId != null
                        && !submittedTeamId.trim().isEmpty()
                        && getPositiveId(submittedTeamId) != teamId) {

                    resp.sendError(
                            HttpServletResponse.SC_FORBIDDEN,
                            "You can manage only your own team's players.");
                    return;
                }
            }

            Team selectedTeam = teamDAO.getTeamById(teamId);

            if (selectedTeam == null) {
                resp.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Selected team does not exist.");
                return;
            }

            boolean success;

            if ("add".equals(action)) {

                Player player = getPlayerFromForm(req, teamId);

                // The 15-player limit applies to captains.
                if (!admin) {

                    int playerCount =
                            playerDAO.getPlayerCountByTeam(teamId);

                    if (playerCount == -1) {
                        resp.sendError(
                                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                                "Unable to check the team squad size.");
                        return;
                    }

                    if (playerCount >= 15) {
                        resp.sendError(
                                HttpServletResponse.SC_BAD_REQUEST,
                                "A team can have a maximum of 15 players.");
                        return;
                    }
                }

                success = playerDAO.addPlayer(player);

            } else if ("update".equals(action)) {

                int id = getPositiveId(req.getParameter("id"));

                Player player = getPlayerFromForm(req, teamId);
                player.setId(id);

                // DAO checks both player ID and team ID.
                success = playerDAO.updatePlayer(player);

            } else if ("delete".equals(action)) {

                int id = getPositiveId(req.getParameter("id"));

                if (admin) {
                    success = playerDAO.deletePlayer(id);
                } else {
                    success = playerDAO.deletePlayer(id, teamId);
                }

            } else {

                resp.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Invalid player action.");
                return;
            }

            if (!success) {
                resp.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Player operation failed. Check the details "
                        + "and database connection.");
                return;
            }

            resp.sendRedirect(req.getContextPath()
                    + "/players?teamId=" + teamId);

        } catch (IllegalArgumentException e) {
            resp.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid input. Check the player and team details.");
        }
    }

    private Player getPlayerFromForm(
            HttpServletRequest req, int teamId) {

        String playerName = req.getParameter("playerName");
        String jerseyValue = req.getParameter("jerseyNumber");
        String playingRole = req.getParameter("playingRole");

        if (playerName == null || playerName.trim().isEmpty()) {
            throw new IllegalArgumentException(
                    "Player name is required.");
        }

        playerName = playerName.trim();

        if (playerName.length() > 100) {
            throw new IllegalArgumentException(
                    "Player name is too long.");
        }

        Integer jerseyNumber = null;

        if (jerseyValue != null
                && !jerseyValue.trim().isEmpty()) {

            try {
                jerseyNumber = Integer.parseInt(
                        jerseyValue.trim());

            } catch (NumberFormatException e) {
                throw new IllegalArgumentException(
                        "Jersey number must be a valid integer.");
            }

            if (jerseyNumber < 1 || jerseyNumber > 99) {
                throw new IllegalArgumentException(
                        "Jersey number must be between 1 and 99.");
            }
        }

        if (playingRole != null) {
            playingRole = playingRole.trim();
        }

        if (playingRole == null
                || !(playingRole.equals("Batsman")
                || playingRole.equals("Bowler")
                || playingRole.equals("All-rounder")
                || playingRole.equals("Wicketkeeper"))) {

            throw new IllegalArgumentException(
                    "Invalid playing role.");
        }

        return new Player(
                teamId, playerName, jerseyNumber, playingRole);
    }
}
