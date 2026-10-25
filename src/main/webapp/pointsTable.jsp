<%@ page import="java.util.List" %>
<%@ page import="com.crickethub.dto.Tournament" %>
<%@ page import="com.crickethub.dto.PointsTable" %>
<%@ page import="com.crickethub.dto.User" %>
<%@ page import="com.crickethub.dto.Admin" %>

<%
    List<Tournament> tournaments =
        (List<Tournament>) request.getAttribute("tournaments");

    List<PointsTable> pointsTable =
        (List<PointsTable>) request.getAttribute("pointsTable");

    Integer selectedTournamentId =
        (Integer) request.getAttribute("selectedTournamentId");

    String dashboardPage = "login.jsp";

    if (session.getAttribute("admin") instanceof Admin) {
        dashboardPage = "dashboard.jsp";
    } else if (session.getAttribute("user") instanceof User) {
        User user = (User) session.getAttribute("user");

        if ("CAPTAIN".equalsIgnoreCase(user.getRole())) {
            dashboardPage = "captainDashboard.jsp";
        } else if ("USER".equalsIgnoreCase(user.getRole())) {
            dashboardPage = "userDashboard.jsp";
        }
    }

    String error =
        (String) request.getAttribute("Error_in_pointsTable");

    String contextPath = request.getContextPath();

    int teamCount = pointsTable != null ? pointsTable.size() : 0;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>CricketHub | Points Table</title>

    <script src="https://cdn.tailwindcss.com"></script>

    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        cricket: {
                            navy: '#0B1726',
                            green: '#246C35',
                            lime: '#B8F36B',
                            canvas: '#F3F6F4'
                        }
                    }
                }
            }
        }
    </script>

    <style>
        body {
            font-family: Arial, Helvetica, sans-serif;
        }

        .card-shadow {
            box-shadow: 0 8px 28px rgba(11, 23, 38, 0.06);
        }

        .table-row {
            transition: background-color 0.2s ease;
        }

        .table-row:hover {
            background-color: #F3F6F4;
        }

        .custom-select {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='18' height='18' viewBox='0 0 24 24' fill='none' stroke='%2364748b' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpath d='m6 9 6 6 6-6'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 14px center;
        }

        @media (max-width: 640px) {
            .mobile-table {
                min-width: 650px;
            }
        }
    </style>
</head>

<body class="min-h-screen bg-cricket-canvas text-slate-800">

    <!-- Navigation -->
    <nav class="sticky top-0 z-50 border-b border-slate-200 bg-white">
        <div class="mx-auto flex max-w-7xl items-center justify-between px-4 py-4 sm:px-6 lg:px-8">

            <!-- Clean CricketHub Logo -->
            <a href="<%= contextPath + "/" + dashboardPage %>"
               class="flex items-center gap-3">

                <div class="flex h-11 w-11 items-center justify-center rounded-xl bg-cricket-navy">
                    <svg xmlns="http://www.w3.org/2000/svg"
                         viewBox="0 0 48 48"
                         class="h-8 w-8"
                         fill="none"
                         aria-hidden="true">

                        <circle cx="24" cy="24" r="22" fill="#B8F36B"/>

                        <path d="M17 11L22 9L34 33L29 36Z"
                              fill="#0B1726"/>

                        <path d="M17 11L13 13L25 37L29 36Z"
                              fill="#246C35"/>

                        <path d="M13 13L10 17L14 25L19 22Z"
                              fill="#0B1726"/>

                        <path d="M24 17L28 15"
                              stroke="#FFFFFF"
                              stroke-width="1.5"
                              stroke-linecap="round"/>

                        <path d="M28 25L32 23"
                              stroke="#FFFFFF"
                              stroke-width="1.5"
                              stroke-linecap="round"/>
                    </svg>
                </div>

                <div>
                    <h1 class="text-xl font-extrabold tracking-tight text-cricket-navy sm:text-2xl">
                        Cricket<span class="text-cricket-green">Hub</span>
                    </h1>
                    <p class="text-xs font-medium tracking-wide text-slate-500">
                        TOURNAMENT MANAGEMENT
                    </p>
                </div>
            </a>

            <a href="<%= contextPath + "/" + dashboardPage %>"
               class="inline-flex items-center gap-2 rounded-lg border border-slate-200 px-3 py-2 text-sm font-semibold text-cricket-navy transition hover:border-cricket-green hover:bg-slate-50 sm:px-4">

                <svg xmlns="http://www.w3.org/2000/svg"
                     class="h-4 w-4"
                     viewBox="0 0 24 24"
                     fill="none"
                     stroke="currentColor"
                     stroke-width="2"
                     aria-hidden="true">
                    <path d="m15 18-6-6 6-6"/>
                    <path d="M9 12h12"/>
                </svg>

                <span>Dashboard</span>
            </a>

        </div>
    </nav>

    <!-- Main Content -->
    <main class="mx-auto max-w-7xl px-4 py-8 sm:px-6 sm:py-10 lg:px-8">

        <!-- Page Heading -->
        <section class="mb-8">
            <div class="flex flex-col justify-between gap-4 sm:flex-row sm:items-end">

                <div>
                    <div class="mb-3 inline-flex items-center gap-2 rounded-full border border-green-100 bg-green-50 px-3 py-1.5">
                        <span class="h-2 w-2 rounded-full bg-cricket-green"></span>
                        <span class="text-xs font-bold uppercase tracking-wider text-cricket-green">
                            Tournament Statistics
                        </span>
                    </div>

                    <h2 class="text-3xl font-extrabold tracking-tight text-cricket-navy sm:text-4xl">
                        Points Table
                    </h2>

                    <p class="mt-2 max-w-2xl text-sm leading-6 text-slate-500 sm:text-base">
                        Follow team performances, match results, and standings throughout the tournament.
                    </p>
                </div>

                <div class="flex items-center gap-3 rounded-xl border border-slate-200 bg-white px-4 py-3 card-shadow">
                    <div class="flex h-10 w-10 items-center justify-center rounded-lg bg-lime-100">
                        <svg xmlns="http://www.w3.org/2000/svg"
                             class="h-5 w-5 text-cricket-green"
                             viewBox="0 0 24 24"
                             fill="none"
                             stroke="currentColor"
                             stroke-width="2"
                             aria-hidden="true">
                            <path d="M3 3v18h18"/>
                            <path d="m19 9-5 5-4-4-5 5"/>
                        </svg>
                    </div>

                    <div>
                        <p class="text-xs font-medium text-slate-500">
                            Teams Displayed
                        </p>
                        <p class="text-xl font-extrabold text-cricket-navy">
                            <%= teamCount %>
                        </p>
                    </div>
                </div>

            </div>
        </section>

        <!-- Tournament Selection Card -->
        <section class="mb-8 rounded-2xl border border-slate-200 bg-white p-5 card-shadow sm:p-7">

            <div class="mb-5 flex items-start gap-3">
                <div class="flex h-11 w-11 shrink-0 items-center justify-center rounded-xl bg-cricket-navy">
                    <svg xmlns="http://www.w3.org/2000/svg"
                         class="h-5 w-5 text-cricket-lime"
                         viewBox="0 0 24 24"
                         fill="none"
                         stroke="currentColor"
                         stroke-width="2"
                         aria-hidden="true">
                        <path d="M4 19V5"/>
                        <path d="M4 19h17"/>
                        <path d="M8 15V9"/>
                        <path d="M13 15V5"/>
                        <path d="M18 15v-4"/>
                    </svg>
                </div>

                <div>
                    <h3 class="text-lg font-bold text-cricket-navy">
                        Select Tournament
                    </h3>
                    <p class="mt-1 text-sm text-slate-500">
                        Choose a tournament to view its current team standings.
                    </p>
                </div>
            </div>

            <form action="<%= contextPath %>/pointsTable"
                  method="get"
                  class="flex flex-col gap-4 sm:flex-row sm:items-end">

                <div class="flex-1">
                    <label for="tournamentId"
                           class="mb-2 block text-sm font-semibold text-slate-700">
                        Tournament
                    </label>

                    <div class="relative">
                        <select name="tournamentId"
                                id="tournamentId"
                                required
                                class="custom-select w-full rounded-xl border border-slate-300 bg-white px-4 py-3 pr-11 text-sm text-slate-700 outline-none transition focus:border-cricket-green focus:ring-2 focus:ring-green-100">

                            <option value="">-- Select Tournament --</option>

                            <% if (tournaments != null) {
                                for (Tournament t : tournaments) { %>

                                    <option value="<%= t.getId() %>"
                                        <%= selectedTournamentId != null
                                            && selectedTournamentId.intValue() == t.getId()
                                            ? "selected" : "" %>>
                                        <%= t.getName() %>
                                    </option>

                            <%  }
                            } %>

                        </select>
                    </div>
                </div>

                <button type="submit"
                        class="inline-flex min-h-12 items-center justify-center gap-2 rounded-xl bg-cricket-green px-6 py-3 text-sm font-bold text-white transition hover:bg-cricket-navy focus:outline-none focus:ring-2 focus:ring-cricket-green focus:ring-offset-2">

                    <svg xmlns="http://www.w3.org/2000/svg"
                         class="h-4 w-4"
                         viewBox="0 0 24 24"
                         fill="none"
                         stroke="currentColor"
                         stroke-width="2"
                         aria-hidden="true">
                        <circle cx="11" cy="11" r="7"/>
                        <path d="m20 20-4-4"/>
                    </svg>

                    View Points Table
                </button>

            </form>
        </section>

        <!-- Error Message -->
        <% if (error != null) { %>
            <div class="mb-6 flex items-start gap-3 rounded-xl border border-red-200 bg-red-50 p-4 text-sm text-red-700"
                 role="alert">

                <svg xmlns="http://www.w3.org/2000/svg"
                     class="mt-0.5 h-5 w-5 shrink-0"
                     viewBox="0 0 24 24"
                     fill="none"
                     stroke="currentColor"
                     stroke-width="2"
                     aria-hidden="true">
                    <circle cx="12" cy="12" r="10"/>
                    <path d="M12 8v4"/>
                    <path d="M12 16h.01"/>
                </svg>

                <p><%= error %></p>
            </div>
        <% } %>

        <!-- Standings -->
        <% if (selectedTournamentId != null) { %>

            <section class="overflow-hidden rounded-2xl border border-slate-200 bg-white card-shadow">

                <div class="flex flex-col justify-between gap-3 border-b border-slate-200 px-5 py-5 sm:flex-row sm:items-center sm:px-7">

                    <div>
                        <h3 class="text-xl font-extrabold text-cricket-navy">
                            Tournament Standings
                        </h3>
                        <p class="mt-1 text-sm text-slate-500">
                            Team performance and points summary
                        </p>
                    </div>

                    <div class="inline-flex w-fit items-center gap-2 rounded-full bg-green-50 px-3 py-1.5 text-xs font-bold text-cricket-green">
                        <span class="h-2 w-2 rounded-full bg-cricket-green"></span>
                        <%= teamCount %> Teams
                    </div>

                </div>

                <% if (pointsTable != null && !pointsTable.isEmpty()) { %>

                    <div class="overflow-x-auto">
                        <table class="mobile-table w-full border-collapse text-left">

                            <thead class="bg-cricket-navy text-white">
                                <tr>
                                    <th class="px-5 py-4 text-xs font-bold uppercase tracking-wider sm:px-7">
                                        Position
                                    </th>
                                    <th class="px-5 py-4 text-xs font-bold uppercase tracking-wider">
                                        Team
                                    </th>
                                    <th class="px-5 py-4 text-center text-xs font-bold uppercase tracking-wider">
                                        Played
                                    </th>
                                    <th class="px-5 py-4 text-center text-xs font-bold uppercase tracking-wider">
                                        Won
                                    </th>
                                    <th class="px-5 py-4 text-center text-xs font-bold uppercase tracking-wider">
                                        Lost
                                    </th>
                                    <th class="px-5 py-4 text-center text-xs font-bold uppercase tracking-wider">
                                        Tied
                                    </th>
                                    <th class="px-5 py-4 text-center text-xs font-bold uppercase tracking-wider sm:px-7">
                                        Points
                                    </th>
                                </tr>
                            </thead>

                            <tbody class="divide-y divide-slate-100">

                                <%
                                    int position = 1;

                                    for (PointsTable pt : pointsTable) {
                                        int currentPosition = position++;
                                %>

                                    <tr class="table-row">

                                        <!-- Position -->
                                        <td class="whitespace-nowrap px-5 py-4 sm:px-7">
                                            <div class="flex h-9 w-9 items-center justify-center rounded-lg
                                                <%= currentPosition == 1
                                                    ? "bg-lime-100 text-cricket-green"
                                                    : "bg-slate-100 text-slate-600" %>
                                                text-sm font-extrabold">

                                                <%= currentPosition %>
                                            </div>
                                        </td>

                                        <!-- Team Name -->
                                        <td class="whitespace-nowrap px-5 py-4">
                                            <div class="flex items-center gap-3">

                                                <div class="flex h-10 w-10 items-center justify-center rounded-full bg-cricket-navy text-sm font-extrabold text-cricket-lime">
                                                    <%= pt.getTeamName() != null
                                                        && !pt.getTeamName().isEmpty()
                                                        ? pt.getTeamName().substring(0, 1).toUpperCase()
                                                        : "T" %>
                                                </div>

                                                <div>
                                                    <p class="font-bold text-cricket-navy">
                                                        <%= pt.getTeamName() %>
                                                    </p>

                                                    <% if (currentPosition == 1) { %>
                                                        <span class="mt-1 inline-block rounded-full bg-lime-100 px-2 py-0.5 text-xs font-bold text-cricket-green">
                                                            Top Position
                                                        </span>
                                                    <% } %>
                                                </div>

                                            </div>
                                        </td>

                                        <!-- Matches Played -->
                                        <td class="px-5 py-4 text-center text-sm font-semibold text-slate-700">
                                            <%= pt.getMatchesPlayed() %>
                                        </td>

                                        <!-- Won -->
                                        <td class="px-5 py-4 text-center">
                                            <span class="inline-flex min-w-8 items-center justify-center rounded-lg bg-green-50 px-2.5 py-1.5 text-sm font-bold text-cricket-green">
                                                <%= pt.getMatchesWon() %>
                                            </span>
                                        </td>

                                        <!-- Lost -->
                                        <td class="px-5 py-4 text-center text-sm font-semibold text-slate-600">
                                            <%= pt.getMatchesLost() %>
                                        </td>

                                        <!-- Tied -->
                                        <td class="px-5 py-4 text-center text-sm font-semibold text-slate-600">
                                            <%= pt.getMatchesTied() %>
                                        </td>

                                        <!-- Points -->
                                        <td class="whitespace-nowrap px-5 py-4 text-center sm:px-7">
                                            <span class="inline-flex min-w-12 items-center justify-center rounded-lg bg-cricket-navy px-3 py-2 text-base font-extrabold text-cricket-lime">
                                                <%= pt.getPoints() %>
                                            </span>
                                        </td>

                                    </tr>

                                <% } %>

                            </tbody>
                        </table>
                    </div>

                    <div class="border-t border-slate-100 bg-slate-50 px-5 py-4 sm:px-7">
                        <p class="text-xs leading-5 text-slate-500">
                            <span class="font-bold text-slate-700">Note:</span>
                            Team positions follow the order provided by your points-table servlet.
                        </p>
                    </div>

                <% } else { %>

                    <!-- Empty State -->
                    <div class="px-6 py-14 text-center sm:py-16">

                        <div class="mx-auto mb-5 flex h-16 w-16 items-center justify-center rounded-2xl bg-slate-100">
                            <svg xmlns="http://www.w3.org/2000/svg"
                                 class="h-8 w-8 text-slate-400"
                                 viewBox="0 0 24 24"
                                 fill="none"
                                 stroke="currentColor"
                                 stroke-width="1.7"
                                 aria-hidden="true">
                                <path d="M4 19V5"/>
                                <path d="M4 19h17"/>
                                <path d="M8 15V9"/>
                                <path d="M13 15V5"/>
                                <path d="M18 15v-4"/>
                            </svg>
                        </div>

                        <h4 class="text-lg font-bold text-cricket-navy">
                            No Standings Available
                        </h4>

                        <p class="mx-auto mt-2 max-w-md text-sm leading-6 text-slate-500">
                            No teams were found for this tournament. Register teams and record match results to populate the points table.
                        </p>

                    </div>

                <% } %>

            </section>

        <% } else { %>

            <!-- Initial State -->
            <section class="rounded-2xl border border-slate-200 bg-white px-6 py-14 text-center card-shadow sm:py-16">

                <div class="mx-auto mb-5 flex h-16 w-16 items-center justify-center rounded-2xl bg-lime-100">
                    <svg xmlns="http://www.w3.org/2000/svg"
                         class="h-8 w-8 text-cricket-green"
                         viewBox="0 0 24 24"
                         fill="none"
                         stroke="currentColor"
                         stroke-width="1.8"
                         aria-hidden="true">
                        <path d="M4 19V5"/>
                        <path d="M4 19h17"/>
                        <path d="M8 15V9"/>
                        <path d="M13 15V5"/>
                        <path d="M18 15v-4"/>
                    </svg>
                </div>

                <h3 class="text-xl font-extrabold text-cricket-navy">
                    Ready to View the Standings?
                </h3>

                <p class="mx-auto mt-2 max-w-md text-sm leading-6 text-slate-500">
                    Select a tournament above and click "View Points Table" to see how each team is performing.
                </p>

            </section>

        <% } %>

        <!-- Footer -->
        <footer class="mt-8 flex flex-col items-center justify-between gap-2 border-t border-slate-200 py-5 text-center sm:flex-row sm:text-left">

            <p class="text-sm font-semibold text-slate-500">
                Cricket<span class="text-cricket-green">Hub</span>
                <span class="font-normal">— Tournament Management System</span>
            </p>

            <p class="text-xs text-slate-400">
                Play hard. Track every run.
            </p>

        </footer>

    </main>

</body>
</html>