```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.crickethub.dto.Player" %>
<%@ page import="com.crickethub.dto.Team" %>
<%@ page import="com.crickethub.dto.User" %>
<%@ page import="com.crickethub.dto.Admin" %>

<%!
    private String escapeHtml(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#x27;");
    }
%>

<%
    boolean isAdmin = session.getAttribute("admin") instanceof Admin;

    User loggedInUser = null;
    Object userObject = session.getAttribute("user");

    if (userObject instanceof User) {
        loggedInUser = (User) userObject;
    }

    boolean isCaptain = loggedInUser != null
            && "CAPTAIN".equalsIgnoreCase(loggedInUser.getRole())
            && loggedInUser.getTeamId() != null;

    boolean isViewer = loggedInUser != null
            && "USER".equalsIgnoreCase(loggedInUser.getRole());

    boolean canManagePlayers = isAdmin || isCaptain;

    if (!isAdmin && !isCaptain && !isViewer) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String contextPath = request.getContextPath();

    Object selectedTeamObject = request.getAttribute("teamId");

    String selectedTeamId = selectedTeamObject == null
            ? "" : selectedTeamObject.toString();

    /*
     * If a captain opens /players without a team selected,
     * load the players page for their assigned team.
     */
    if (isCaptain && selectedTeamId.isEmpty()) {
        response.sendRedirect(contextPath + "/players?teamId="
                + loggedInUser.getTeamId());
        return;
    }

    List<Team> teams =
            (List<Team>) request.getAttribute("teams");

    List<Player> players =
            (List<Player>) request.getAttribute("players");

    Team selectedTeam =
            (Team) request.getAttribute("selectedTeam");

    String dashboardUrl = contextPath
            + (isAdmin ? "/dashboard.jsp"
            : isCaptain ? "/captainDashboard.jsp"
            : "/userDashboard.jsp");

    String displayName = isAdmin
            ? ((Admin) session.getAttribute("admin")).getUsername()
            : loggedInUser.getUsername();

    String roleLabel = isAdmin
            ? "Admin" : isCaptain ? "Captain" : "User";

    int playerCount = players == null ? 0 : players.size();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Players | CricketHub</title>

    <script src="https://cdn.tailwindcss.com"></script>

    <style>
        body {
            font-family: Inter, ui-sans-serif, system-ui, sans-serif;
        }

        .soft-shadow {
            box-shadow: 0 8px 30px rgba(15, 23, 42, 0.045);
        }

        .table-row:hover {
            background-color: #f8fafc;
        }

        .brand-gradient {
            background: linear-gradient(135deg, #14532d, #15803d);
        }
    </style>
</head>

<body class="min-h-screen bg-slate-50 text-slate-800">

    <!-- Navigation -->
    <nav class="sticky top-0 z-20 border-b border-slate-200 bg-white/95 backdrop-blur">
        <div class="mx-auto flex max-w-7xl flex-wrap items-center justify-between gap-4 px-5 py-4 lg:px-8">

            <a href="<%= dashboardUrl %>" class="flex items-center gap-3">

                <!-- Clean inline SVG CricketHub logo -->
                <div class="brand-gradient flex h-12 w-12 items-center justify-center rounded-2xl shadow-sm">
                    <svg xmlns="http://www.w3.org/2000/svg"
                         viewBox="0 0 48 48"
                         width="32"
                         height="32"
                         fill="none"
                         aria-label="CricketHub logo"
                         role="img">

                        <circle cx="24" cy="24" r="22" fill="#166534"/>

                        <path d="M12 34 L28 12"
                              stroke="#FFFFFF"
                              stroke-width="5"
                              stroke-linecap="round"/>

                        <path d="M17 36 L33 14"
                              stroke="#D9F99D"
                              stroke-width="5"
                              stroke-linecap="round"/>

                        <path d="M8 36 H40"
                              stroke="#D9F99D"
                              stroke-width="2.5"
                              stroke-linecap="round"/>

                        <circle cx="34" cy="34" r="5" fill="#BEF264"/>
                    </svg>
                </div>

                <div>
                    <h1 class="text-xl font-extrabold tracking-tight text-blue-950">
                        CricketHub
                    </h1>
                    <p class="text-xs font-medium text-slate-500">
                        Tournament Management
                    </p>
                </div>
            </a>

            <div class="flex flex-wrap items-center gap-2 text-sm sm:gap-3">

                <div class="hidden text-right sm:block">
                    <p class="font-semibold text-blue-950">
                        <%= escapeHtml(displayName) %>
                    </p>
                    <p class="text-xs text-slate-500">
                        <%= roleLabel %>
                    </p>
                </div>

                <% if (isAdmin) { %>
                    <a href="<%= contextPath %>/tournaments"
                       class="rounded-lg px-3 py-2 font-medium text-slate-600 transition hover:bg-slate-100">
                        Tournaments
                    </a>

                    <a href="<%= contextPath %>/teams"
                       class="rounded-lg px-3 py-2 font-medium text-slate-600 transition hover:bg-slate-100">
                        Teams
                    </a>

                    <a href="<%= contextPath %>/matches"
                       class="rounded-lg px-3 py-2 font-medium text-slate-600 transition hover:bg-slate-100">
                        Matches
                    </a>
                <% } %>

                <a href="<%= dashboardUrl %>"
                   class="rounded-xl border border-slate-200 px-3 py-2.5 font-semibold text-slate-700 transition hover:bg-slate-50 sm:px-4">
                    Dashboard
                </a>

                <form action="<%= contextPath %>/logout" method="post">
                    <button type="submit"
                            class="rounded-xl bg-red-50 px-3 py-2.5 font-semibold text-red-700 transition hover:bg-red-100 sm:px-4">
                        Logout
                    </button>
                </form>
            </div>
        </div>
    </nav>

    <main class="mx-auto max-w-7xl px-5 py-8 lg:px-8 lg:py-10">

        <!-- Page Heading -->
        <section class="mb-8 flex flex-col justify-between gap-5 sm:flex-row sm:items-end">

            <div>
                <div class="mb-3 inline-flex items-center gap-2 rounded-full border border-lime-200 bg-lime-50 px-3 py-1.5 text-xs font-bold uppercase tracking-wider text-green-800">
                    <span class="h-2 w-2 rounded-full bg-lime-500"></span>
                    CricketHub Management
                </div>

                <h2 class="text-3xl font-extrabold tracking-tight text-blue-950 md:text-4xl">
                    <%= canManagePlayers ? "Player Management" : "Players Directory" %>
                </h2>

                <p class="mt-2 max-w-xl text-sm leading-6 text-slate-500 md:text-base">
                    <% if (isAdmin) { %>
                        Manage players across teams, update player details and maintain your squads.
                    <% } else if (isCaptain) { %>
                        Manage your squad and keep your team's player information up to date.
                    <% } else { %>
                        Browse teams and explore player names, jersey numbers and playing roles.
                    <% } %>
                </p>
            </div>

            <div class="text-sm text-slate-500">
                <a href="<%= dashboardUrl %>"
                   class="font-medium text-slate-600 hover:text-green-700">
                    Home
                </a>
                <span class="mx-2">/</span>
                <span class="font-semibold text-green-700">Players</span>
            </div>
        </section>

        <!-- Summary Cards -->
        <section class="mb-8 grid grid-cols-1 gap-5 sm:grid-cols-2">

            <div class="soft-shadow rounded-2xl border border-slate-200 bg-white p-6">
                <div class="flex items-start justify-between gap-4">
                    <div>
                        <p class="text-sm font-semibold text-slate-500">
                            Players in Current View
                        </p>

                        <h3 class="mt-3 text-4xl font-extrabold tracking-tight text-blue-950">
                            <%= playerCount %>
                        </h3>

                        <p class="mt-2 text-sm text-slate-500">
                            <% if (selectedTeamId.isEmpty()) { %>
                                Select a team to view its players.
                            <% } else { %>
                                Players registered for this team.
                            <% } %>
                        </p>
                    </div>

                    <div class="flex h-14 w-14 shrink-0 items-center justify-center rounded-2xl bg-lime-100 text-green-800">
                        <svg viewBox="0 0 24 24" width="30" height="30"
                             fill="none" stroke="currentColor"
                             stroke-width="1.8" aria-hidden="true">
                            <path d="M7 20L17 4M11 21L21 5"
                                  stroke-linecap="round"/>
                            <path d="M4 20H21" stroke-linecap="round"/>
                        </svg>
                    </div>
                </div>

                <div class="mt-5 h-1.5 overflow-hidden rounded-full bg-slate-100">
                    <div class="h-full w-full rounded-full bg-lime-500"></div>
                </div>
            </div>

            <div class="soft-shadow rounded-2xl border border-slate-200 bg-white p-6">
                <div class="flex items-start justify-between gap-4">
                    <div>
                        <p class="text-sm font-semibold text-slate-500">
                            Current Team
                        </p>

                        <h3 class="mt-3 break-words text-2xl font-extrabold tracking-tight text-blue-950">
                            <% if (selectedTeam != null) { %>
                                <%= escapeHtml(selectedTeam.getTeamName()) %>
                            <% } else if (isCaptain) { %>
                                Your Squad
                            <% } else { %>
                                Not Selected
                            <% } %>
                        </h3>

                        <p class="mt-2 text-sm text-slate-500">
                            <% if (!selectedTeamId.isEmpty()) { %>
                                Team ID: #<%= escapeHtml(selectedTeamId) %>
                            <% } else { %>
                                Choose a team to see its details.
                            <% } %>
                        </p>
                    </div>

                    <div class="flex h-14 w-14 shrink-0 items-center justify-center rounded-2xl bg-blue-50 text-blue-800">
                        <svg viewBox="0 0 24 24" width="30" height="30"
                             fill="none" stroke="currentColor"
                             stroke-width="1.8" aria-hidden="true">
                            <path d="M8 21h8M12 17v4M5 4h14l2 5H3l2-5Z"
                                  stroke-linejoin="round"/>
                            <path d="M5 9v3a7 7 0 0 0 14 0V9"
                                  stroke-linecap="round"/>
                        </svg>
                    </div>
                </div>

                <div class="mt-5 h-1.5 overflow-hidden rounded-full bg-slate-100">
                    <div class="h-full w-full rounded-full bg-blue-700"></div>
                </div>
            </div>
        </section>

        <!-- Team Selection -->
        <section class="soft-shadow mb-8 overflow-hidden rounded-2xl border border-slate-200 bg-white">

            <div class="border-b border-slate-200 px-6 py-5 md:px-8">
                <div class="flex items-center gap-3">
                    <div class="flex h-11 w-11 items-center justify-center rounded-xl bg-blue-50 text-blue-800">
                        <svg viewBox="0 0 24 24" width="25" height="25"
                             fill="none" stroke="currentColor"
                             stroke-width="1.8" aria-hidden="true">
                            <circle cx="9" cy="8" r="3"/>
                            <path d="M3 20v-2a6 6 0 0 1 12 0v2M16 5a3 3 0 0 1 0 6M18 14a5 5 0 0 1 3 4v2"
                                  stroke-linecap="round"/>
                        </svg>
                    </div>

                    <div>
                        <h3 class="text-lg font-bold text-blue-950">
                            <%= isCaptain ? "Your Team" : "Select a Team" %>
                        </h3>

                        <p class="mt-1 text-sm text-slate-500">
                            <% if (isAdmin) { %>
                                Choose a team to manage or view its players.
                            <% } else if (isCaptain) { %>
                                You can manage players belonging to your assigned team.
                            <% } else { %>
                                Select a team to view its player details.
                            <% } %>
                        </p>
                    </div>
                </div>
            </div>

            <div class="p-6 md:p-8">

                <% if (isAdmin || isViewer) { %>

                    <form action="<%= contextPath %>/players"
                          method="get"
                          class="flex flex-col gap-4 sm:flex-row sm:items-end">

                        <div class="flex-1">
                            <label for="teamId"
                                   class="mb-2 block text-sm font-semibold text-slate-700">
                                Team
                            </label>

                            <select id="teamId"
                                    name="teamId"
                                    required
                                    class="w-full rounded-xl border border-slate-300 bg-slate-50 px-4 py-3 text-sm outline-none transition focus:border-lime-500 focus:bg-white focus:ring-4 focus:ring-lime-100">

                                <option value="">Choose a team</option>

                                <% if (teams != null) {
                                    for (Team team : teams) {
                                        String optionTeamId = String.valueOf(team.getId());
                                %>
                                    <option value="<%= escapeHtml(optionTeamId) %>"
                                        <%= optionTeamId.equals(selectedTeamId) ? "selected" : "" %>>
                                        <%= escapeHtml(team.getTeamName()) %>
                                    </option>
                                <%  }
                                   } %>
                            </select>
                        </div>

                        <button type="submit"
                                class="rounded-xl bg-green-700 px-6 py-3 text-sm font-bold text-white transition hover:bg-green-800 focus:outline-none focus:ring-4 focus:ring-lime-200">
                            View Players &rarr;
                        </button>
                    </form>

                <% } else { %>

                    <div class="flex flex-wrap items-center justify-between gap-4">
                        <div>
                            <p class="text-sm text-slate-500">Assigned Team ID</p>
                            <p class="mt-1 text-xl font-bold text-blue-950">
                                #<%= loggedInUser.getTeamId() %>
                            </p>
                        </div>

                        <% if (selectedTeam != null) { %>
                            <span class="rounded-full bg-lime-50 px-4 py-2 text-sm font-semibold text-green-800">
                                <%= escapeHtml(selectedTeam.getTeamName()) %>
                            </span>
                        <% } %>
                    </div>

                <% } %>
            </div>
        </section>

        <% if (!selectedTeamId.isEmpty()) { %>

            <!-- Add Player Form: Admin and Captain -->
            <% if (canManagePlayers) { %>

                <section class="soft-shadow mb-8 overflow-hidden rounded-2xl border border-slate-200 bg-white">

                    <div class="border-b border-slate-200 px-6 py-5 md:px-8">
                        <div class="flex items-center gap-3">
                            <div class="flex h-11 w-11 items-center justify-center rounded-xl bg-lime-100 text-green-800">
                                <svg viewBox="0 0 24 24" width="24" height="24"
                                     fill="none" stroke="currentColor"
                                     stroke-width="2" aria-hidden="true">
                                    <path d="M12 5v14M5 12h14"
                                          stroke-linecap="round"/>
                                </svg>
                            </div>

                            <div>
                                <h3 class="text-lg font-bold text-blue-950">
                                    Register a New Player
                                </h3>
                                <p class="mt-1 text-sm text-slate-500">
                                    Enter the player's details below.
                                </p>
                            </div>
                        </div>
                    </div>

                    <form action="<%= contextPath %>/players"
                          method="post"
                          class="grid grid-cols-1 gap-5 p-6 md:grid-cols-2 md:p-8">

                        <input type="hidden" name="action" value="add">

                        <input type="hidden" name="teamId"
                               value="<%= escapeHtml(selectedTeamId) %>">

                        <div>
                            <label for="playerName"
                                   class="mb-2 block text-sm font-semibold text-slate-700">
                                Player Name
                            </label>

                            <input type="text"
                                   id="playerName"
                                   name="playerName"
                                   maxlength="100"
                                   required
                                   placeholder="Enter player name"
                                   class="w-full rounded-xl border border-slate-300 bg-slate-50 px-4 py-3 text-sm outline-none transition placeholder:text-slate-400 focus:border-lime-500 focus:bg-white focus:ring-4 focus:ring-lime-100">
                        </div>

                        <div>
                            <label for="jerseyNumber"
                                   class="mb-2 block text-sm font-semibold text-slate-700">
                                Jersey Number
                            </label>

                            <input type="number"
                                   id="jerseyNumber"
                                   name="jerseyNumber"
                                   min="1"
                                   max="99"
                                   placeholder="Optional"
                                   class="w-full rounded-xl border border-slate-300 bg-slate-50 px-4 py-3 text-sm outline-none transition focus:border-lime-500 focus:bg-white focus:ring-4 focus:ring-lime-100">
                        </div>

                        <div>
                            <label for="playingRole"
                                   class="mb-2 block text-sm font-semibold text-slate-700">
                                Playing Role
                            </label>

                            <select id="playingRole"
                                    name="playingRole"
                                    required
                                    class="w-full rounded-xl border border-slate-300 bg-slate-50 px-4 py-3 text-sm outline-none transition focus:border-lime-500 focus:bg-white focus:ring-4 focus:ring-lime-100">

                                <option value="">Select playing role</option>
                                <option value="Batsman">Batsman</option>
                                <option value="Bowler">Bowler</option>
                                <option value="All-rounder">All-rounder</option>
                                <option value="Wicketkeeper">Wicketkeeper</option>
                            </select>
                        </div>

                        <div class="flex items-end">
                            <button type="submit"
                                    class="w-full rounded-xl bg-green-700 px-6 py-3 text-sm font-bold text-white transition hover:bg-green-800 focus:outline-none focus:ring-4 focus:ring-lime-200 md:w-auto">
                                + Add Player
                            </button>
                        </div>

                        <% if (isCaptain) { %>
                            <p class="text-xs leading-5 text-slate-500 md:col-span-2">
                                Squad limit: up to 15 players for your team.
                            </p>
                        <% } %>
                    </form>
                </section>

            <% } %>

            <!-- Player Directory -->
            <section class="soft-shadow overflow-hidden rounded-2xl border border-slate-200 bg-white">

                <div class="flex flex-col justify-between gap-4 border-b border-slate-200 px-6 py-5 sm:flex-row sm:items-center md:px-8">
                    <div>
                        <h3 class="text-lg font-bold text-blue-950">
                            Team Players
                        </h3>

                        <p class="mt-1 text-sm text-slate-500">
                            <% if (selectedTeam != null) { %>
                                Squad details for <%= escapeHtml(selectedTeam.getTeamName()) %>
                            <% } else { %>
                                Player details for the selected team
                            <% } %>
                        </p>
                    </div>

                    <span class="inline-flex w-fit items-center gap-2 rounded-full bg-lime-50 px-3.5 py-2 text-sm font-bold text-green-800">
                        <span class="h-2 w-2 rounded-full bg-lime-500"></span>
                        <%= playerCount %> Players
                    </span>
                </div>

                <% if (players == null || players.isEmpty()) { %>

                    <div class="px-6 py-16 text-center md:px-8">
                        <div class="mx-auto mb-5 flex h-20 w-20 items-center justify-center rounded-3xl bg-lime-50 text-green-800">
                            <svg viewBox="0 0 24 24" width="42" height="42"
                                 fill="none" stroke="currentColor"
                                 stroke-width="1.5" aria-hidden="true">
                                <path d="M7 20L17 4M11 21L21 5"
                                      stroke-linecap="round"/>
                                <path d="M4 20H21" stroke-linecap="round"/>
                            </svg>
                        </div>

                        <h4 class="text-xl font-bold text-blue-950">
                            No Players Yet
                        </h4>

                        <p class="mx-auto mt-2 max-w-sm text-sm leading-6 text-slate-500">
                            <% if (canManagePlayers) { %>
                                This team has no registered players. Use the form above to add the first player.
                            <% } else { %>
                                No player details are available for this team yet.
                            <% } %>
                        </p>
                    </div>

                <% } else { %>

                    <div class="overflow-x-auto">
                        <table class="w-full min-w-[700px] text-left">

                            <thead class="bg-slate-50">
                                <tr class="border-b border-slate-200">
                                    <th class="px-5 py-4 text-xs font-bold uppercase tracking-wider text-slate-500 md:px-8">
                                        Player
                                    </th>

                                    <th class="px-5 py-4 text-xs font-bold uppercase tracking-wider text-slate-500">
                                        Jersey No.
                                    </th>

                                    <th class="px-5 py-4 text-xs font-bold uppercase tracking-wider text-slate-500">
                                        Playing Role
                                    </th>

                                    <% if (canManagePlayers) { %>
                                        <th class="px-5 py-4 text-xs font-bold uppercase tracking-wider text-slate-500">
                                            Actions
                                        </th>
                                    <% } %>
                                </tr>
                            </thead>

                            <tbody class="divide-y divide-slate-100">

                                <% for (Player player : players) {
                                    String updateFormId = "updatePlayer" + player.getId();

                                    String playerRole = player.getPlayingRole() == null
                                            ? "" : player.getPlayingRole();
                                %>

                                    <tr class="table-row align-top transition">

                                        <td class="px-5 py-4 md:px-8">
                                            <div class="flex items-center gap-3">
                                                <div class="flex h-11 w-11 shrink-0 items-center justify-center rounded-xl border border-lime-100 bg-lime-50 text-green-800">
                                                    <svg viewBox="0 0 24 24" width="23" height="23"
                                                         fill="none" stroke="currentColor"
                                                         stroke-width="1.7" aria-hidden="true">
                                                        <path d="M7 20L17 4M11 21L21 5"
                                                              stroke-linecap="round"/>
                                                        <path d="M4 20H21" stroke-linecap="round"/>
                                                    </svg>
                                                </div>

                                                <div>
                                                    <p class="font-bold text-blue-950">
                                                        <% if (canManagePlayers) { %>
                                                            <input form="<%= updateFormId %>"
                                                                   type="text"
                                                                   name="playerName"
                                                                   maxlength="100"
                                                                   required
                                                                   value="<%= escapeHtml(player.getPlayerName()) %>"
                                                                   class="w-44 rounded-lg border border-slate-300 bg-white px-3 py-2 text-sm outline-none focus:border-lime-500 focus:ring-2 focus:ring-lime-100">
                                                        <% } else { %>
                                                            <%= escapeHtml(player.getPlayerName()) %>
                                                        <% } %>
                                                    </p>

                                                    <p class="mt-1 text-xs text-slate-400">
                                                        Player ID: #<%= player.getId() %>
                                                    </p>
                                                </div>
                                            </div>
                                        </td>

                                        <td class="px-5 py-4">
                                            <% if (canManagePlayers) { %>
                                                <input form="<%= updateFormId %>"
                                                       type="number"
                                                       name="jerseyNumber"
                                                       min="1"
                                                       max="99"
                                                       value="<%= player.getJerseyNumber() == null ? "" : player.getJerseyNumber() %>"
                                                       placeholder="Optional"
                                                       class="w-24 rounded-lg border border-slate-300 bg-white px-3 py-2 text-sm outline-none focus:border-lime-500 focus:ring-2 focus:ring-lime-100">
                                            <% } else { %>
                                                <span class="inline-flex rounded-lg bg-slate-100 px-3 py-1.5 text-sm font-semibold text-slate-700">
                                                    <%= player.getJerseyNumber() == null ? "—" : player.getJerseyNumber() %>
                                                </span>
                                            <% } %>
                                        </td>

                                        <td class="px-5 py-4">
                                            <% if (canManagePlayers) { %>
                                                <select form="<%= updateFormId %>"
                                                        name="playingRole"
                                                        required
                                                        class="w-36 rounded-lg border border-slate-300 bg-white px-3 py-2 text-sm outline-none focus:border-lime-500 focus:ring-2 focus:ring-lime-100">

                                                    <option value="Batsman"
                                                        <%= "Batsman".equals(playerRole) ? "selected" : "" %>>
                                                        Batsman
                                                    </option>

                                                    <option value="Bowler"
                                                        <%= "Bowler".equals(playerRole) ? "selected" : "" %>>
                                                        Bowler
                                                    </option>

                                                    <option value="All-rounder"
                                                        <%= "All-rounder".equals(playerRole) ? "selected" : "" %>>
                                                        All-rounder
                                                    </option>

                                                    <option value="Wicketkeeper"
                                                        <%= "Wicketkeeper".equals(playerRole) ? "selected" : "" %>>
                                                        Wicketkeeper
                                                    </option>
                                                </select>
                                            <% } else { %>

                                                <%
                                                    String roleColor = "bg-slate-100 text-slate-700";

                                                    if ("Batsman".equals(playerRole)) {
                                                        roleColor = "bg-blue-50 text-blue-700";
                                                    } else if ("Bowler".equals(playerRole)) {
                                                        roleColor = "bg-lime-50 text-green-800";
                                                    } else if ("All-rounder".equals(playerRole)) {
                                                        roleColor = "bg-purple-50 text-purple-700";
                                                    } else if ("Wicketkeeper".equals(playerRole)) {
                                                        roleColor = "bg-amber-50 text-amber-700";
                                                    }
                                                %>

                                                <span class="inline-flex rounded-full px-3 py-1.5 text-xs font-bold <%= roleColor %>">
                                                    <%= escapeHtml(playerRole.isEmpty() ? "Not specified" : playerRole) %>
                                                </span>
                                            <% } %>
                                        </td>

                                        <% if (canManagePlayers) { %>

                                            <td class="px-5 py-4">
                                                <div class="flex flex-wrap items-center gap-2">

                                                    <!-- Update form -->
                                                    <form id="<%= updateFormId %>"
                                                          action="<%= contextPath %>/players"
                                                          method="post">

                                                        <input type="hidden" name="action" value="update">

                                                        <input type="hidden" name="id"
                                                               value="<%= player.getId() %>">

                                                        <input type="hidden" name="teamId"
                                                               value="<%= escapeHtml(selectedTeamId) %>">

                                                        <button type="submit"
                                                                class="rounded-lg bg-green-700 px-3 py-2 text-xs font-bold text-white transition hover:bg-green-800 focus:outline-none focus:ring-2 focus:ring-lime-200">
                                                            Save
                                                        </button>
                                                    </form>

                                                    <!-- Delete form -->
                                                    <form action="<%= contextPath %>/players"
                                                          method="post"
                                                          onsubmit="return confirm('Are you sure you want to delete this player?');">

                                                        <input type="hidden" name="action" value="delete">

                                                        <input type="hidden" name="id"
                                                               value="<%= player.getId() %>">

                                                        <input type="hidden" name="teamId"
                                                               value="<%= escapeHtml(selectedTeamId) %>">

                                                        <button type="submit"
                                                                class="rounded-lg border border-red-200 bg-red-50 px-3 py-2 text-xs font-bold text-red-700 transition hover:bg-red-100 focus:outline-none focus:ring-2 focus:ring-red-100">
                                                            Delete
                                                        </button>
                                                    </form>
                                                </div>
                                            </td>

                                        <% } %>
                                    </tr>

                                <% } %>

                            </tbody>
                        </table>
                    </div>

                    <% if (canManagePlayers) { %>
                        <div class="border-t border-slate-200 bg-slate-50 px-6 py-4">
                            <p class="text-xs leading-5 text-slate-500">
                                Edit the player details in a row and click <strong>Save</strong> to update that player.
                            </p>
                        </div>
                    <% } %>

                <% } %>

            </section>

        <% } else { %>

            <!-- No team selected -->
            <section class="soft-shadow rounded-2xl border border-slate-200 bg-white px-6 py-16 text-center md:px-8">
                <div class="mx-auto mb-5 flex h-20 w-20 items-center justify-center rounded-3xl bg-lime-50 text-green-800">
                    <svg viewBox="0 0 24 24" width="42" height="42"
                         fill="none" stroke="currentColor"
                         stroke-width="1.5" aria-hidden="true">
                        <path d="M7 20L17 4M11 21L21 5"
                              stroke-linecap="round"/>
                        <path d="M4 20H21" stroke-linecap="round"/>
                    </svg>
                </div>

                <h3 class="text-xl font-bold text-blue-950">
                    Choose a Team to Get Started
                </h3>

                <p class="mx-auto mt-2 max-w-md text-sm leading-6 text-slate-500">
                    Select a team above to see its players and their details.
                </p>
            </section>

        <% } %>

        <!-- Footer -->
        <footer class="mt-8 flex flex-col items-center justify-between gap-2 border-t border-slate-200 py-6 text-center text-xs text-slate-400 sm:flex-row sm:text-left">
            <p>&copy; 2026 CricketHub &middot; Cricket Tournament Management System</p>
            <p>Built for the love of cricket</p>
        </footer>

    </main>

</body>
</html>
```