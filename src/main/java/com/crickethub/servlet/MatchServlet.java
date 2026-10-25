
package com.crickethub.servlet;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.List;

import com.crickethub.dao.impl.MatchDAOImpl;
import com.crickethub.dao.impl.TeamDAOImpl;
import com.crickethub.dao.impl.TournamentDAOImpl;
import com.crickethub.dto.Admin;
import com.crickethub.dto.Match;
import com.crickethub.dto.Team;
import com.crickethub.dto.Tournament;
import com.crickethub.dto.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/matches")
public class MatchServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private MatchDAOImpl matchDAO;
    private TeamDAOImpl teamDAO;
    private TournamentDAOImpl tournamentDAO;

    @Override
    public void init() {
        matchDAO = new MatchDAOImpl();
        teamDAO = new TeamDAOImpl();
        tournamentDAO = new TournamentDAOImpl();
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        return session != null
                && session.getAttribute("admin") instanceof Admin;
    }

    private boolean isLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

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
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        if (!isLoggedIn(request)) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        loadPageData(request);

        request.setAttribute("isAdmin", isAdmin(request));

        request.getRequestDispatcher("/matches.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // Only Admin can schedule matches or change results.
        if (!isAdmin(request)) {
            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Only admins can manage matches.");
            return;
        }

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        try {
            if ("scheduleMatch".equals(action)) {
                scheduleMatch(request);

            } else if ("updateScore".equals(action)) {
                updateScore(request);

            } else if ("markTie".equals(action)) {
                markTie(request);

            } else if ("noResult".equals(action)) {
                updateStatus(request, "NO_RESULT");

            } else if ("cancelMatch".equals(action)) {
                updateStatus(request, "CANCELLED");

            } else {
                throw new IllegalArgumentException(
                        "Invalid match action.");
            }

        } catch (IllegalArgumentException
                 | DateTimeParseException e) {

            request.setAttribute("errorMessage", e.getMessage());

            loadPageData(request);
            request.setAttribute("isAdmin", true);

            request.getRequestDispatcher("/matches.jsp")
                    .forward(request, response);
            return;
        }

        response.sendRedirect(
                request.getContextPath() + "/matches");
    }

    private int getIntegerParameter(HttpServletRequest request,
                                    String parameterName) {

        String value = request.getParameter(parameterName);

        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException(
                    "Please provide " + parameterName + ".");
        }

        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(
                    "Invalid value for " + parameterName + ".");
        }
    }

    private void scheduleMatch(HttpServletRequest request) {

        int tournamentId =
                getIntegerParameter(request, "tournamentId");

        int team1Id =
                getIntegerParameter(request, "team1Id");

        int team2Id =
                getIntegerParameter(request, "team2Id");

        String dateString = request.getParameter("matchDate");

        if (tournamentId <= 0 || team1Id <= 0 || team2Id <= 0) {
            throw new IllegalArgumentException(
                    "Please select a valid tournament and both teams.");
        }

        if (team1Id == team2Id) {
            throw new IllegalArgumentException(
                    "Please select two different teams.");
        }

        if (dateString == null || dateString.isBlank()) {
            throw new IllegalArgumentException(
                    "Please select a match date and time.");
        }

        // Check that the selected tournament exists.
        List<Tournament> tournaments =
                tournamentDAO.getAllTournaments();

        boolean tournamentExists = false;

        if (tournaments != null) {
            for (Tournament tournament : tournaments) {
                if (tournament.getId() == tournamentId) {
                    tournamentExists = true;
                    break;
                }
            }
        }

        if (!tournamentExists) {
            throw new IllegalArgumentException(
                    "Selected tournament does not exist.");
        }

        // Both teams must belong to the selected tournament.
        List<Team> teams = teamDAO.getAllTeams();

        boolean team1Belongs = false;
        boolean team2Belongs = false;

        if (teams != null) {
            for (Team team : teams) {
                if (team.getId() == team1Id
                        && team.getTournamentId() == tournamentId) {
                    team1Belongs = true;
                }

                if (team.getId() == team2Id
                        && team.getTournamentId() == tournamentId) {
                    team2Belongs = true;
                }
            }
        }

        if (!team1Belongs || !team2Belongs) {
            throw new IllegalArgumentException(
                    "Both teams must belong to the selected tournament.");
        }

        LocalDateTime matchDate =
                LocalDateTime.parse(dateString);

        if (matchDate.isBefore(LocalDateTime.now())) {
            throw new IllegalArgumentException(
                    "Match date and time cannot be in the past.");
        }

        Match match = new Match(
                tournamentId,
                team1Id,
                team2Id,
                matchDate
        );

        if (matchDAO.isDuplicateMatch(match)) {
            throw new IllegalArgumentException(
                    "This match is already scheduled.");
        }

        matchDAO.addMatch(match);
    }

    private void updateScore(HttpServletRequest request) {

        int matchId = getIntegerParameter(request, "matchId");
        int team1Runs = getIntegerParameter(request, "team1Runs");
        int team2Runs = getIntegerParameter(request, "team2Runs");
        int winnerTeamId =
                getIntegerParameter(request, "winnerTeamId");

        Match match = getScheduledMatch(matchId);

        if (team1Runs < 0 || team2Runs < 0) {
            throw new IllegalArgumentException(
                    "Scores cannot be negative.");
        }

        if (team1Runs == team2Runs) {
            throw new IllegalArgumentException(
                    "Equal scores should be recorded using Mark Tie.");
        }

        if (winnerTeamId != match.getTeam1Id()
                && winnerTeamId != match.getTeam2Id()) {
            throw new IllegalArgumentException(
                    "Winner must be one of the teams in this match.");
        }

        if ((winnerTeamId == match.getTeam1Id()
                && team1Runs < team2Runs)
                || (winnerTeamId == match.getTeam2Id()
                && team2Runs < team1Runs)) {
            throw new IllegalArgumentException(
                    "The winning team must have the higher score.");
        }

        match.setTeam1Runs(team1Runs);
        match.setTeam2Runs(team2Runs);
        match.setWinnerTeamId(winnerTeamId);
        match.setStatus("COMPLETED");

        matchDAO.updateMatch(match);
    }

    private void markTie(HttpServletRequest request) {

        int matchId = getIntegerParameter(request, "matchId");
        int team1Runs = getIntegerParameter(request, "team1Runs");
        int team2Runs = getIntegerParameter(request, "team2Runs");

        Match match = getScheduledMatch(matchId);

        if (team1Runs < 0 || team2Runs < 0) {
            throw new IllegalArgumentException(
                    "Scores cannot be negative.");
        }

        if (team1Runs != team2Runs) {
            throw new IllegalArgumentException(
                    "Both teams must have equal scores for a tie.");
        }

        match.setTeam1Runs(team1Runs);
        match.setTeam2Runs(team2Runs);
        match.setWinnerTeamId(null);
        match.setStatus("TIED");

        matchDAO.updateMatch(match);
    }

    private void updateStatus(HttpServletRequest request,
                              String status) {

        int matchId = getIntegerParameter(request, "matchId");

        Match match = getScheduledMatch(matchId);

        match.setTeam1Runs(null);
        match.setTeam2Runs(null);
        match.setWinnerTeamId(null);
        match.setStatus(status);

        matchDAO.updateMatch(match);
    }

    private Match getScheduledMatch(int matchId) {

        if (matchId <= 0) {
            throw new IllegalArgumentException(
                    "Invalid match ID.");
        }

        Match match = matchDAO.getMatchById(matchId);

        if (match == null) {
            throw new IllegalArgumentException(
                    "Match not found.");
        }

        if (!"SCHEDULED".equals(match.getStatus())) {
            throw new IllegalArgumentException(
                    "Only scheduled matches can be updated.");
        }

        return match;
    }

    private void loadPageData(HttpServletRequest request) {

        request.setAttribute("matches", matchDAO.getAllMatches());
        request.setAttribute("teams", teamDAO.getAllTeams());
        request.setAttribute(
                "tournaments", tournamentDAO.getAllTournaments());
    }
}
