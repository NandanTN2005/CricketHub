 
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.crickethub.dto.Match" %>
<%@ page import="com.crickethub.dto.Team" %>
<%@ page import="com.crickethub.dto.Tournament" %>
<%@ page import="com.crickethub.dto.User" %>
<%@ page import="com.crickethub.dto.Admin" %>

<%!
    private String escapeHtml(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

<%
    boolean isAdmin = session.getAttribute("admin") instanceof Admin;

    User currentUser = null;
    Object userObject = session.getAttribute("user");

    if (userObject instanceof User) {
        currentUser = (User) userObject;
    }

    boolean isCaptain = currentUser != null
            && "CAPTAIN".equalsIgnoreCase(currentUser.getRole());

    boolean isUser = currentUser != null
            && "USER".equalsIgnoreCase(currentUser.getRole());

    if (!isAdmin && !isCaptain && !isUser) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String dashboardPage = isAdmin
            ? "dashboard.jsp"
            : isCaptain ? "captainDashboard.jsp" : "userDashboard.jsp";

    String contextPath = request.getContextPath();

    String displayName = isAdmin
            ? ((Admin) session.getAttribute("admin")).getUsername()
            : currentUser.getUsername();

    String roleLabel = isAdmin ? "Admin" : isCaptain ? "Captain" : "User";

    List<Match> matches = (List<Match>) request.getAttribute("matches");
    List<Team> teams = (List<Team>) request.getAttribute("teams");
    List<Tournament> tournaments =
            (List<Tournament>) request.getAttribute("tournaments");

    String errorMessage = (String) request.getAttribute("errorMessage");

    int matchCount = matches == null ? 0 : matches.size();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Matches | CricketHub</title>

    <script src="https://cdn.tailwindcss.com"></script>

    <style>
        body {
            font-family: Inter, ui-sans-serif, system-ui, -apple-system,
                         BlinkMacSystemFont, "Segoe UI", sans-serif;
        }

        .soft-shadow {
            box-shadow: 0 8px 30px rgba(15, 23, 42, 0.045);
        }

        .table-row:hover {
            background-color: #f8fafc;
        }

        .form-control {
            width: 100%;
            min-width: 0;
            border: 1px solid #dbe2e8;
            border-radius: 12px;
            background: #f8fafc;
            padding: 11px 13px;
            font-size: 14px;
            outline: none;
            transition: border-color .2s, box-shadow .2s, background .2s;
        }

        .form-control:focus {
            border-color: #246c35;
            background: white;
            box-shadow: 0 0 0 3px rgba(184, 243, 107, .35);
        }

        .btn-primary {
            border-radius: 12px;
            background: #246c35;
            color: white;
            padding: 11px 16px;
            font-size: 13px;
            font-weight: 700;
            transition: background .2s;
        }

        .btn-primary:hover {
            background: #195329;
        }

        .btn-secondary {
            border: 1px solid #dbe2e8;
            border-radius: 10px;
            background: white;
            padding: 9px 12px;
            font-size: 12px;
            font-weight: 700;
            color: #334155;
            transition: background .2s;
        }

        .btn-secondary:hover {
            background: #f1f5f9;
        }

        .btn-danger {
            border: 1px solid #fecaca;
            border-radius: 10px;
            background: #fff1f2;
            padding: 9px 12px;
            font-size: 12px;
            font-weight: 700;
            color: #b91c1c;
            transition: background .2s;
        }

        .btn-danger:hover {
            background: #ffe4e6;
        }

        .field-label {
            display: block;
            margin-bottom: 7px;
            font-size: 13px;
            font-weight: 700;
            color: #334155;
        }

        .status-pill {
            display: inline-flex;
            align-items: center;
            white-space: nowrap;
            border-radius: 999px;
            padding: 6px 10px;
            font-size: 11px;
            font-weight: 800;
            letter-spacing: .03em;
        }

        @media (max-width: 640px) {
            .page-main {
                padding-left: 16px;
                padding-right: 16px;
            }
        }
    </style>
</head>

<body class="min-h-screen bg-[#f3f6f4] text-slate-800">

<!-- Navigation -->
<nav class="sticky top-0 z-30 border-b border-slate-200 bg-white/95 backdrop-blur">
    <div class="mx-auto flex max-w-7xl flex-wrap items-center justify-between gap-4 px-5 py-4 lg:px-8">

        <a href="<%= contextPath %>/<%= dashboardPage %>"
           class="flex items-center gap-3">

            <!-- Clean inline cricket logo -->
            <div class="flex h-12 w-12 items-center justify-center rounded-2xl bg-[#0b1726]">
                <svg viewBox="0 0 48 48" width="34" height="34"
                     fill="none" xmlns="http://www.w3.org/2000/svg"
                     aria-label="CricketHub logo" role="img">
                    <path d="M12 35L28 9" stroke="#B8F36B"
                          stroke-width="5" stroke-linecap="round"/>
                    <path d="M20 39L36 13" stroke="white"
                          stroke-width="5" stroke-linecap="round"/>
                    <path d="M8 37L15 40" stroke="#B8F36B"
                          stroke-width="3" stroke-linecap="round"/>
                    <path d="M33 8L40 11" stroke="white"
                          stroke-width="3" stroke-linecap="round"/>
                    <circle cx="34" cy="34" r="5" fill="#B8F36B"/>
                </svg>
            </div>

            <div>
                <h1 class="text-xl font-extrabold tracking-tight text-[#0b1726]">
                    CricketHub
                </h1>
                <p class="text-xs font-medium text-slate-500">
                    Tournament Management
                </p>
            </div>
        </a>

        <div class="flex flex-wrap items-center gap-2 text-sm">
            <div class="hidden pr-2 text-right sm:block">
                <p class="font-bold text-[#0b1726]">
                    <%= escapeHtml(displayName) %>
                </p>
                <p class="text-xs text-slate-500"><%= roleLabel %></p>
            </div>

            <% if (isAdmin) { %>
                <a href="<%= contextPath %>/tournaments"
                   class="rounded-lg px-3 py-2 font-semibold text-slate-600 hover:bg-slate-100">
                    Tournaments
                </a>
                <a href="<%= contextPath %>/teams"
                   class="rounded-lg px-3 py-2 font-semibold text-slate-600 hover:bg-slate-100">
                    Teams
                </a>
                <a href="<%= contextPath %>/players"
                   class="rounded-lg px-3 py-2 font-semibold text-slate-600 hover:bg-slate-100">
                    Players
                </a>
            <% } %>

            <a href="<%= contextPath %>/<%= dashboardPage %>"
               class="rounded-xl border border-slate-200 px-4 py-2.5 font-semibold text-slate-700 hover:bg-slate-50">
                Dashboard
            </a>

            <form action="<%= contextPath %>/logout" method="post">
                <button type="submit"
                        class="rounded-xl bg-red-50 px-4 py-2.5 font-semibold text-red-700 hover:bg-red-100">
                    Logout
                </button>
            </form>
        </div>
    </div>
</nav>

<main class="page-main mx-auto max-w-7xl px-5 py-8 lg:px-8 lg:py-10">

    <!-- Page heading -->
    <section class="mb-8 flex flex-col justify-between gap-4 sm:flex-row sm:items-end">
        <div>
            <div class="mb-3 inline-flex items-center gap-2 rounded-full border border-green-200 bg-green-50 px-3 py-1.5 text-xs font-extrabold uppercase tracking-wider text-green-800">
                <span class="h-2 w-2 rounded-full bg-green-600"></span>
                CricketHub Management
            </div>

            <h2 class="text-3xl font-extrabold tracking-tight text-[#0b1726] md:text-4xl">
                <%= isAdmin ? "Match Management" : "Match Centre" %>
            </h2>

            <p class="mt-2 max-w-2xl text-sm leading-6 text-slate-500 md:text-base">
                <% if (isAdmin) { %>
                    Schedule fixtures, record match results, and manage your tournament matches.
                <% } else if (isCaptain) { %>
                    Follow upcoming fixtures, match scores, and results across the tournaments.
                <% } else { %>
                    Explore the fixtures, scores, and results from your cricket tournaments.
                <% } %>
            </p>
        </div>

        <div class="text-sm text-slate-500">
            <span class="font-medium text-slate-700">Home</span>
            <span class="mx-2">/</span>
            <span class="font-bold text-green-700">Matches</span>
        </div>
    </section>

    <!-- Error message -->
    <% if (errorMessage != null && !errorMessage.trim().isEmpty()) { %>
        <div role="alert"
             class="mb-6 flex items-start gap-3 rounded-2xl border border-red-200 bg-red-50 p-4 text-sm text-red-800">
            <span class="font-extrabold">!</span>
            <p><%= escapeHtml(errorMessage) %></p>
        </div>
    <% } %>

    <!-- Summary card -->
    <section class="mb-8 grid grid-cols-1 gap-5 sm:grid-cols-2">
        <div class="soft-shadow rounded-2xl border border-slate-200 bg-white p-6">
            <div class="flex items-start justify-between gap-4">
                <div>
                    <p class="text-sm font-semibold text-slate-500">Matches in Current View</p>
                    <h3 class="mt-3 text-4xl font-extrabold tracking-tight text-[#0b1726]">
                        <%= matchCount %>
                    </h3>
                    <p class="mt-2 text-sm text-slate-500">
                        Fixtures and results returned by the matches servlet.
                    </p>
                </div>
                <div class="flex h-14 w-14 items-center justify-center rounded-2xl bg-[#0b1726]">
                    <svg viewBox="0 0 48 48" width="34" height="34"
                         fill="none" xmlns="http://www.w3.org/2000/svg"
                         aria-hidden="true">
                        <circle cx="24" cy="24" r="15" stroke="#B8F36B" stroke-width="3"/>
                        <path d="M16 15L32 33M32 15L16 33"
                              stroke="white" stroke-width="2.5" stroke-linecap="round"/>
                    </svg>
                </div>
            </div>
            <div class="mt-5 h-1.5 overflow-hidden rounded-full bg-slate-100">
                <div class="h-full w-full rounded-full bg-[#B8F36B]"></div>
            </div>
        </div>

        <div class="soft-shadow rounded-2xl border border-slate-200 bg-white p-6">
            <div class="flex items-start justify-between gap-4">
                <div>
                    <p class="text-sm font-semibold text-slate-500">Your Access</p>
                    <h3 class="mt-3 text-2xl font-extrabold text-[#0b1726]">
                        <%= roleLabel %>
                    </h3>
                    <p class="mt-2 text-sm leading-5 text-slate-500">
                        <% if (isAdmin) { %>
                            You can schedule matches and record or update results.
                        <% } else if (isCaptain) { %>
                            You can view match schedules, scores, and results.
                        <% } else { %>
                            You have read-only access to match information.
                        <% } %>
                    </p>
                </div>
                <div class="flex h-14 w-14 items-center justify-center rounded-2xl bg-[#eff8e8]">
                    <svg viewBox="0 0 48 48" width="32" height="32"
                         fill="none" xmlns="http://www.w3.org/2000/svg"
                         aria-hidden="true">
                        <path d="M24 5L39 11V22C39 32 32 39 24 43C16 39 9 32 9 22V11L24 5Z"
                              stroke="#246C35" stroke-width="3" stroke-linejoin="round"/>
                        <path d="M17 24L22 29L32 18"
                              stroke="#246C35" stroke-width="3"
                              stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                </div>
            </div>
            <div class="mt-5 h-1.5 overflow-hidden rounded-full bg-slate-100">
                <div class="h-full w-full rounded-full bg-[#246c35]"></div>
            </div>
        </div>
    </section>

    <!-- Admin: Schedule match -->
    <% if (isAdmin) { %>
        <section class="soft-shadow mb-8 overflow-hidden rounded-2xl border border-slate-200 bg-white">

            <div class="border-b border-slate-200 px-6 py-5 md:px-8">
                <div class="flex items-center gap-3">
                    <div class="flex h-11 w-11 items-center justify-center rounded-xl bg-[#eff8e8]">
                        <svg viewBox="0 0 24 24" width="25" height="25"
                             fill="none" xmlns="http://www.w3.org/2000/svg"
                             aria-hidden="true">
                            <path d="M12 5V19M5 12H19"
                                  stroke="#246C35" stroke-width="2.5"
                                  stroke-linecap="round"/>
                        </svg>
                    </div>
                    <div>
                        <h3 class="text-lg font-extrabold text-[#0b1726]">
                            Schedule a Match
                        </h3>
                        <p class="mt-1 text-sm text-slate-500">
                            Select a tournament, choose two teams, and set the fixture date.
                        </p>
                    </div>
                </div>
            </div>

            <form action="<%= contextPath %>/matches"
                  method="post"
                  class="grid grid-cols-1 gap-5 p-6 md:grid-cols-2 md:p-8">

                <input type="hidden" name="action" value="scheduleMatch">

                <div class="md:col-span-2">
                    <label for="tournamentId" class="field-label">Tournament</label>
                    <select name="tournamentId" id="tournamentId"
                            class="form-control" required>
                        <option value="">Select Tournament</option>
                        <% if (tournaments != null) {
                            for (Tournament tournament : tournaments) { %>
                                <option value="<%= tournament.getId() %>">
                                    <%= escapeHtml(tournament.getName()) %>
                                </option>
                        <%  }
                        } %>
                    </select>
                </div>

                <div>
                    <label for="team1Id" class="field-label">Team 1</label>
                    <select name="team1Id" id="team1Id"
                            class="form-control" required disabled>
                        <option value="">Select Team 1</option>
                        <% if (teams != null) {
                            for (Team team : teams) { %>
                                <option value="<%= team.getId() %>"
                                        data-tournament-id="<%= team.getTournamentId() %>">
                                    <%= escapeHtml(team.getTeamName()) %>
                                </option>
                        <%  }
                        } %>
                    </select>
                </div>

                <div>
                    <label for="team2Id" class="field-label">Team 2</label>
                    <select name="team2Id" id="team2Id"
                            class="form-control" required disabled>
                        <option value="">Select Team 2</option>
                        <% if (teams != null) {
                            for (Team team : teams) { %>
                                <option value="<%= team.getId() %>"
                                        data-tournament-id="<%= team.getTournamentId() %>">
                                    <%= escapeHtml(team.getTeamName()) %>
                                </option>
                        <%  }
                        } %>
                    </select>
                </div>

                <div>
                    <label for="matchDate" class="field-label">Match Date and Time</label>
                    <input type="datetime-local" name="matchDate" id="matchDate"
                           class="form-control" required>
                    <p class="mt-2 text-xs text-slate-400">
                        Select the scheduled local date and time.
                    </p>
                </div>

                <div class="flex items-end">
                    <button type="submit" class="btn-primary w-full sm:w-auto">
                        Schedule Match
                        <span aria-hidden="true">→</span>
                    </button>
                </div>
            </form>
        </section>
    <% } %>

    <!-- Matches table -->
    <section class="soft-shadow overflow-hidden rounded-2xl border border-slate-200 bg-white">

        <div class="flex flex-col justify-between gap-4 border-b border-slate-200 px-6 py-5 sm:flex-row sm:items-center md:px-8">
            <div>
                <h3 class="text-lg font-extrabold text-[#0b1726]">All Matches</h3>
                <p class="mt-1 text-sm text-slate-500">
                    Browse fixtures, scores, winners, and match status.
                </p>
            </div>

            <span class="inline-flex w-fit items-center gap-2 rounded-full bg-green-50 px-3.5 py-2 text-sm font-extrabold text-green-800">
                <span class="h-2 w-2 rounded-full bg-green-600"></span>
                <%= matchCount %> Matches
            </span>
        </div>

        <% if (matches == null || matches.isEmpty()) { %>
            <div class="px-6 py-16 text-center md:px-8">
                <div class="mx-auto mb-5 flex h-20 w-20 items-center justify-center rounded-3xl bg-[#eff8e8]">
                    <svg viewBox="0 0 48 48" width="43" height="43"
                         fill="none" xmlns="http://www.w3.org/2000/svg"
                         aria-hidden="true">
                        <path d="M13 37L30 9" stroke="#246C35"
                              stroke-width="5" stroke-linecap="round"/>
                        <path d="M21 39L38 11" stroke="#0B1726"
                              stroke-width="5" stroke-linecap="round"/>
                        <circle cx="14" cy="13" r="5" fill="#B8F36B"/>
                    </svg>
                </div>
                <h4 class="text-xl font-extrabold text-[#0b1726]">No Matches Yet</h4>
                <p class="mx-auto mt-2 max-w-md text-sm leading-6 text-slate-500">
                    <% if (isAdmin) { %>
                        Schedule a match above to start building your tournament fixtures.
                    <% } else { %>
                        No match information is currently available. Please check again later.
                    <% } %>
                </p>
            </div>
        <% } else { %>

            <div class="overflow-x-auto">
                <table class="w-full min-w-[1050px] text-left">
                    <thead class="bg-slate-50">
                        <tr class="border-b border-slate-200">
                            <th class="px-5 py-4 text-xs font-extrabold uppercase tracking-wider text-slate-500">Match</th>
                            <th class="px-5 py-4 text-xs font-extrabold uppercase tracking-wider text-slate-500">Tournament</th>
                            <th class="px-5 py-4 text-xs font-extrabold uppercase tracking-wider text-slate-500">Fixture</th>
                            <th class="px-5 py-4 text-xs font-extrabold uppercase tracking-wider text-slate-500">Date &amp; Time</th>
                            <th class="px-5 py-4 text-xs font-extrabold uppercase tracking-wider text-slate-500">Score</th>
                            <th class="px-5 py-4 text-xs font-extrabold uppercase tracking-wider text-slate-500">Winner</th>
                            <th class="px-5 py-4 text-xs font-extrabold uppercase tracking-wider text-slate-500">Status</th>
                            <% if (isAdmin) { %>
                                <th class="px-5 py-4 text-xs font-extrabold uppercase tracking-wider text-slate-500">Actions</th>
                            <% } %>
                        </tr>
                    </thead>

                    <tbody class="divide-y divide-slate-100">
                    <% for (Match match : matches) {
                        String matchStatus = match.getStatus() == null
                                ? "" : match.getStatus();

                        String statusStyle = "bg-slate-100 text-slate-700";

                        if ("COMPLETED".equalsIgnoreCase(matchStatus)) {
                            statusStyle = "bg-green-100 text-green-800";
                        } else if ("SCHEDULED".equalsIgnoreCase(matchStatus)) {
                            statusStyle = "bg-blue-50 text-blue-700";
                        } else if ("CANCELLED".equalsIgnoreCase(matchStatus)) {
                            statusStyle = "bg-red-50 text-red-700";
                        } else if ("TIED".equalsIgnoreCase(matchStatus)
                                || "TIE".equalsIgnoreCase(matchStatus)) {
                            statusStyle = "bg-amber-50 text-amber-800";
                        } else if ("NO_RESULT".equalsIgnoreCase(matchStatus)
                                || "NO RESULT".equalsIgnoreCase(matchStatus)) {
                            statusStyle = "bg-slate-100 text-slate-600";
                        }
                    %>
                        <tr class="table-row align-top transition">
                            <td class="px-5 py-5">
                                <span class="inline-flex rounded-lg bg-slate-100 px-3 py-1.5 text-xs font-extrabold text-slate-700">
                                    #<%= match.getId() %>
                                </span>
                            </td>

                            <td class="px-5 py-5">
                                <span class="font-semibold text-slate-700">
                                    #<%= match.getTournamentId() %>
                                </span>
                            </td>

                            <td class="px-5 py-5">
                                <div class="min-w-[160px] space-y-2">
                                    <div class="font-bold text-[#0b1726]">
                                        <%= escapeHtml(match.getTeam1Name()) %>
                                    </div>
                                    <div class="text-xs font-bold uppercase tracking-wider text-slate-400">
                                        vs
                                    </div>
                                    <div class="font-bold text-[#0b1726]">
                                        <%= escapeHtml(match.getTeam2Name()) %>
                                    </div>
                                </div>
                            </td>

                            <td class="px-5 py-5">
                                <div class="whitespace-nowrap text-sm font-semibold text-slate-700">
                                    <%= match.getMatchDate() == null
                                            ? "—" : match.getMatchDate().toString().replace("T", " ") %>
                                </div>
                            </td>

                            <td class="px-5 py-5">
                                <div class="inline-flex min-w-[115px] flex-col gap-2 rounded-xl border border-slate-100 bg-slate-50 p-3">
                                    <div class="flex items-center justify-between gap-4">
                                        <span class="text-xs text-slate-500">Team 1</span>
                                        <span class="font-extrabold text-[#0b1726]">
                                            <%= match.getTeam1Runs() == null
                                                    ? "—" : match.getTeam1Runs() %>
                                        </span>
                                    </div>
                                    <div class="flex items-center justify-between gap-4">
                                        <span class="text-xs text-slate-500">Team 2</span>
                                        <span class="font-extrabold text-[#0b1726]">
                                            <%= match.getTeam2Runs() == null
                                                    ? "—" : match.getTeam2Runs() %>
                                        </span>
                                    </div>
                                </div>
                            </td>

                            <td class="px-5 py-5">
                                <span class="text-sm font-semibold text-slate-700">
                                    <%= match.getWinnerTeamName() == null
                                            || match.getWinnerTeamName().trim().isEmpty()
                                            ? "—" : escapeHtml(match.getWinnerTeamName()) %>
                                </span>
                            </td>

                            <td class="px-5 py-5">
                                <span class="status-pill <%= statusStyle %>">
                                    <%= escapeHtml(matchStatus.isEmpty()
                                            ? "UNKNOWN" : matchStatus.replace("_", " ")) %>
                                </span>
                            </td>

                            <% if (isAdmin) { %>
                                <td class="px-5 py-5">
                                    <div class="min-w-[245px] space-y-3">

                                        <% if ("SCHEDULED".equalsIgnoreCase(matchStatus)) { %>

                                            <!-- Save match result -->
                                            <form action="<%= contextPath %>/matches"
                                                  method="post"
                                                  class="space-y-2">
                                                <input type="hidden" name="action" value="updateScore">
                                                <input type="hidden" name="matchId" value="<%= match.getId() %>">

                                                <div class="grid grid-cols-2 gap-2">
                                                    <div>
                                                        <label class="mb-1 block text-xs font-semibold text-slate-500">
                                                            Team 1 runs
                                                        </label>
                                                        <input type="number" name="team1Runs"
                                                               min="0" required
                                                               class="form-control"
                                                               placeholder="Runs">
                                                    </div>
                                                    <div>
                                                        <label class="mb-1 block text-xs font-semibold text-slate-500">
                                                            Team 2 runs
                                                        </label>
                                                        <input type="number" name="team2Runs"
                                                               min="0" required
                                                               class="form-control"
                                                               placeholder="Runs">
                                                    </div>
                                                </div>

                                                <label class="field-label">Winner</label>
                                                <select name="winnerTeamId" required class="form-control">
                                                    <option value="">Select Winner</option>
                                                    <option value="<%= match.getTeam1Id() %>">
                                                        <%= escapeHtml(match.getTeam1Name()) %>
                                                    </option>
                                                    <option value="<%= match.getTeam2Id() %>">
                                                        <%= escapeHtml(match.getTeam2Name()) %>
                                                    </option>
                                                </select>

                                                <button type="submit" class="btn-primary w-full">
                                                    Save Result
                                                </button>
                                            </form>

                                            <!-- Mark tie -->
                                            <form action="<%= contextPath %>/matches"
                                                  method="post"
                                                  class="space-y-2 border-t border-slate-100 pt-3">
                                                <input type="hidden" name="action" value="markTie">
                                                <input type="hidden" name="matchId" value="<%= match.getId() %>">

                                                <p class="text-xs font-bold text-slate-600">Mark as tied</p>

                                                <div class="grid grid-cols-2 gap-2">
                                                    <input type="number" name="team1Runs" min="0"
                                                           required class="form-control"
                                                           placeholder="Team 1 runs">
                                                    <input type="number" name="team2Runs" min="0"
                                                           required class="form-control"
                                                           placeholder="Team 2 runs">
                                                </div>

                                                <button type="submit" class="btn-secondary w-full">
                                                    Mark Tie
                                                </button>
                                            </form>

                                            <!-- No result -->
                                            <form action="<%= contextPath %>/matches"
                                                  method="post"
                                                  onsubmit="return confirm('Mark this match as having no result?');">
                                                <input type="hidden" name="action" value="noResult">
                                                <input type="hidden" name="matchId" value="<%= match.getId() %>">
                                                <button type="submit" class="btn-secondary w-full">
                                                    No Result
                                                </button>
                                            </form>

                                            <!-- Cancel match -->
                                            <form action="<%= contextPath %>/matches"
                                                  method="post"
                                                  onsubmit="return confirm('Are you sure you want to cancel this match?');">
                                                <input type="hidden" name="action" value="cancelMatch">
                                                <input type="hidden" name="matchId" value="<%= match.getId() %>">
                                                <button type="submit" class="btn-danger w-full">
                                                    Cancel Match
                                                </button>
                                            </form>

                                        <% } else { %>
                                            <p class="text-xs font-medium text-slate-400">
                                                No further actions
                                            </p>
                                        <% } %>
                                    </div>
                                </td>
                            <% } %>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>

            <div class="border-t border-slate-200 bg-slate-50 px-6 py-4">
                <p class="text-xs leading-5 text-slate-500">
                    <% if (isAdmin) { %>
                        Only scheduled matches can be updated using the actions above.
                    <% } else { %>
                        Match information is displayed in read-only mode.
                    <% } %>
                    On smaller screens, swipe horizontally to view all columns.
                </p>
            </div>
        <% } %>
    </section>

    <!-- Footer -->
    <footer class="mt-8 flex flex-col items-center justify-between gap-2 border-t border-slate-200 py-6 text-center text-xs text-slate-400 sm:flex-row sm:text-left">
        <p>© 2026 CricketHub · Cricket Tournament Management System</p>
        <p>Built for the love of cricket</p>
    </footer>
</main>

<script>
    const tournamentSelect = document.getElementById("tournamentId");
    const team1Select = document.getElementById("team1Id");
    const team2Select = document.getElementById("team2Id");

    if (tournamentSelect && team1Select && team2Select) {

        function filterTeams() {
            const tournamentId = tournamentSelect.value;

            [team1Select, team2Select].forEach(function(select) {
                select.value = "";

                for (let i = 1; i < select.options.length; i++) {
                    const option = select.options[i];

                    option.hidden = !tournamentId
                        || option.dataset.tournamentId !== tournamentId;

                    option.disabled = false;
                }

                select.disabled = !tournamentId;
            });
        }

        function updateOpposingTeamOptions(changedSelect, otherSelect) {
            const selectedTeam = changedSelect.value;

            for (let i = 1; i < otherSelect.options.length; i++) {
                const option = otherSelect.options[i];

                option.disabled = option.value === selectedTeam;
            }

            if (otherSelect.value === selectedTeam) {
                otherSelect.value = "";
            }
        }

        tournamentSelect.addEventListener("change", filterTeams);

        team1Select.addEventListener("change", function() {
            updateOpposingTeamOptions(team1Select, team2Select);
        });

        team2Select.addEventListener("change", function() {
            updateOpposingTeamOptions(team2Select, team1Select);
        });

        filterTeams();
    }
</script>

</body>
</html>
