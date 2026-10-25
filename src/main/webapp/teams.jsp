
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.crickethub.dto.Team" %>
<%@ page import="com.crickethub.dto.Tournament" %>
<%@ page import="com.crickethub.dto.User" %>
<%@ page import="com.crickethub.dto.Admin" %>

<%
    List<Team> teams =
        (List<Team>) request.getAttribute("teams");

    List<Tournament> tournaments =
        (List<Tournament>) request.getAttribute("tournaments");

    boolean isAdmin =
        Boolean.TRUE.equals(request.getAttribute("isAdmin"));

    String error =
        (String) request.getAttribute("Error_in_team");

    String contextPath = request.getContextPath();

    String dashboardLink = "login.jsp";

    Object adminObj = session.getAttribute("admin");
    Object userObj = session.getAttribute("user");

    if (adminObj instanceof Admin) {
        dashboardLink = "dashboard.jsp";
    } else if (userObj instanceof User) {
        User loggedUser = (User) userObj;

        if ("CAPTAIN".equalsIgnoreCase(loggedUser.getRole())) {
            dashboardLink = "captainDashboard.jsp";
        } else if ("USER".equalsIgnoreCase(loggedUser.getRole())) {
            dashboardLink = "userDashboard.jsp";
        }
    }

    int teamCount = teams != null ? teams.size() : 0;
    int tournamentCount = tournaments != null ? tournaments.size() : 0;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Teams | CricketHub</title>

    <script src="https://cdn.tailwindcss.com"></script>

    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        'pitch-navy': '#0B1726',
                        'pitch-lime': '#B8F36B',
                        'pitch-green': '#246C35',
                        'pitch-canvas': '#F3F6F4'
                    }
                }
            }
        }
    </script>

    <style>
        body {
            font-family: Inter, "Segoe UI", Arial, sans-serif;
        }

        .soft-shadow {
            box-shadow: 0 4px 18px rgba(11, 23, 38, 0.05);
        }

        .table-row {
            transition: background-color 0.2s ease;
        }

        .table-row:hover {
            background-color: #f3f8f1;
        }

        .input-field {
            width: 100%;
            box-sizing: border-box;
            border: 1px solid #cbd5e1;
            border-radius: 10px;
            background: #f8fafc;
            padding: 12px 14px;
            color: #0B1726;
            font-size: 14px;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s,
                        background-color 0.2s;
        }

        .input-field:focus {
            border-color: #246C35;
            background: #ffffff;
            box-shadow: 0 0 0 3px rgba(36, 108, 53, 0.12);
        }

        .action-button {
            transition: background-color 0.2s, transform 0.2s;
        }

        .action-button:hover {
            transform: translateY(-1px);
        }
    </style>
</head>

<body class="min-h-screen bg-pitch-canvas text-pitch-navy">

    <!-- Navigation -->
    <nav class="sticky top-0 z-20 border-b border-slate-200 bg-white/95 backdrop-blur">
        <div class="mx-auto flex max-w-7xl items-center justify-between gap-4 px-5 py-4 lg:px-8">

            <!-- Clean CricketHub Logo -->
            <a href="<%= contextPath %>/<%= dashboardLink %>"
               class="flex items-center gap-3 no-underline">

                <div class="flex h-11 w-11 items-center justify-center rounded-xl bg-pitch-lime">

                    <svg xmlns="http://www.w3.org/2000/svg"
                         viewBox="0 0 24 24"
                         fill="none"
                         stroke="currentColor"
                         stroke-width="1.8"
                         stroke-linecap="round"
                         stroke-linejoin="round"
                         class="h-7 w-7 text-pitch-navy"
                         aria-hidden="true">
                        <path d="M4 20L20 4"/>
                        <path d="M7 17L17 7"/>
                        <path d="M3 15L9 21"/>
                        <path d="M15 3L21 9"/>
                    </svg>

                </div>

                <div>
                    <h1 class="text-xl font-extrabold tracking-tight text-pitch-navy">
                        CricketHub
                    </h1>

                    <p class="mt-0.5 text-xs font-medium text-slate-500">
                        Tournament Management
                    </p>
                </div>

            </a>

            <!-- Dashboard Link -->
            <a href="<%= contextPath %>/<%= dashboardLink %>"
               class="inline-flex items-center gap-2 rounded-xl border border-slate-200 bg-white px-4 py-2.5 text-sm font-semibold text-slate-700 transition hover:border-green-200 hover:bg-green-50 hover:text-pitch-green">

                <span aria-hidden="true">&larr;</span>
                <span class="hidden sm:inline">Back to Dashboard</span>
                <span class="sm:hidden">Dashboard</span>

            </a>

        </div>
    </nav>

    <main class="mx-auto max-w-7xl px-5 py-8 lg:px-8 lg:py-10">

        <!-- Page Heading -->
        <section class="mb-8 flex flex-col justify-between gap-5 sm:flex-row sm:items-end">

            <div>
                <div class="mb-3 inline-flex items-center gap-2 rounded-full border border-green-100 bg-green-50 px-3 py-1.5 text-xs font-bold uppercase tracking-wider text-pitch-green">
                    <span class="h-2 w-2 rounded-full bg-pitch-green"></span>
                    CricketHub Management
                </div>

                <h2 class="text-3xl font-extrabold tracking-tight text-pitch-navy md:text-4xl">
                    Teams
                </h2>

                <p class="mt-3 max-w-xl text-sm leading-6 text-slate-500 md:text-base">
                    Explore cricket teams, discover their captains, and view their
                    tournament participation in one place.
                </p>
            </div>

            <div class="text-sm text-slate-500">
                <span class="font-medium text-slate-700">Home</span>
                <span class="mx-2">/</span>
                <span class="font-semibold text-pitch-green">Teams</span>
            </div>

        </section>

        <!-- Summary Cards -->
        <section class="mb-8 grid grid-cols-1 gap-5 sm:grid-cols-2">

            <!-- Registered Teams -->
            <div class="soft-shadow rounded-2xl border border-slate-200 bg-white p-6">

                <div class="flex items-start justify-between gap-4">

                    <div>
                        <p class="text-sm font-semibold text-slate-500">
                            Registered Teams
                        </p>

                        <h3 class="mt-3 text-4xl font-extrabold tracking-tight text-pitch-navy">
                            <%= teamCount %>
                        </h3>

                        <p class="mt-2 text-sm text-slate-500">
                            Teams listed in this view
                        </p>
                    </div>

                    <div class="flex h-14 w-14 shrink-0 items-center justify-center rounded-2xl bg-green-50 text-pitch-green">
                        <svg xmlns="http://www.w3.org/2000/svg"
                             viewBox="0 0 24 24"
                             fill="none"
                             stroke="currentColor"
                             stroke-width="1.7"
                             stroke-linecap="round"
                             stroke-linejoin="round"
                             class="h-7 w-7"
                             aria-hidden="true">
                            <circle cx="12" cy="12" r="9"/>
                            <path d="M8 4.5l8 15"/>
                            <path d="M4.5 8l15 8"/>
                            <path d="M4 12h16"/>
                        </svg>
                    </div>

                </div>

                <div class="mt-5 h-1.5 overflow-hidden rounded-full bg-slate-100">
                    <div class="h-full w-full rounded-full bg-pitch-green"></div>
                </div>

            </div>

            <!-- Available Tournaments -->
            <div class="soft-shadow rounded-2xl border border-slate-200 bg-white p-6">

                <div class="flex items-start justify-between gap-4">

                    <div>
                        <p class="text-sm font-semibold text-slate-500">
                            Available Tournaments
                        </p>

                        <h3 class="mt-3 text-4xl font-extrabold tracking-tight text-pitch-navy">
                            <%= tournamentCount %>
                        </h3>

                        <p class="mt-2 text-sm text-slate-500">
                            Tournaments available for team assignment
                        </p>
                    </div>

                    <div class="flex h-14 w-14 shrink-0 items-center justify-center rounded-2xl bg-lime-50 text-pitch-green">
                        <svg xmlns="http://www.w3.org/2000/svg"
                             viewBox="0 0 24 24"
                             fill="none"
                             stroke="currentColor"
                             stroke-width="1.7"
                             stroke-linecap="round"
                             stroke-linejoin="round"
                             class="h-7 w-7"
                             aria-hidden="true">
                            <path d="M8 21h8"/>
                            <path d="M12 17v4"/>
                            <path d="M7 4H4v3a5 5 0 0 0 5 5"/>
                            <path d="M17 4h3v3a5 5 0 0 1-5 5"/>
                            <path d="M7 3h10v8a5 5 0 0 1-10 0z"/>
                        </svg>
                    </div>

                </div>

                <div class="mt-5 h-1.5 overflow-hidden rounded-full bg-slate-100">
                    <div class="h-full w-full rounded-full bg-pitch-lime"></div>
                </div>

            </div>

        </section>

        <!-- Error Message -->
        <% if (error != null && !error.trim().isEmpty()) { %>

            <div class="mb-6 flex items-start gap-3 rounded-xl border border-red-200 bg-red-50 px-5 py-4 text-sm text-red-700"
                 role="alert">

                <span class="font-bold" aria-hidden="true">!</span>

                <p><%= error %></p>

            </div>

        <% } %>

        <!-- Add Team Form: Admin Only -->
        <% if (isAdmin) { %>

            <section class="soft-shadow mb-8 overflow-hidden rounded-2xl border border-slate-200 bg-white">

                <div class="border-b border-slate-200 px-6 py-5 md:px-8">

                    <div class="flex items-center gap-3">

                        <div class="flex h-11 w-11 items-center justify-center rounded-xl bg-pitch-lime text-2xl font-bold text-pitch-navy">
                            +
                        </div>

                        <div>
                            <h3 class="text-lg font-bold text-pitch-navy">
                                Register a New Team
                            </h3>

                            <p class="mt-1 text-sm text-slate-500">
                                Enter the team details below.
                            </p>
                        </div>

                    </div>

                </div>

                <form action="<%= contextPath %>/teams"
                      method="post"
                      class="grid grid-cols-1 gap-5 p-6 md:grid-cols-2 md:p-8">

                    <div>
                        <label for="teamName"
                               class="mb-2 block text-sm font-semibold text-slate-700">
                            Team Name
                        </label>

                        <input type="text"
                               id="teamName"
                               name="teamName"
                               placeholder="e.g. Royal Challengers"
                               maxlength="100"
                               required
                               class="input-field">
                    </div>

                    <div>
                        <label for="captain"
                               class="mb-2 block text-sm font-semibold text-slate-700">
                            Captain Name
                        </label>

                        <input type="text"
                               id="captain"
                               name="captain"
                               placeholder="Enter captain's name"
                               maxlength="100"
                               required
                               class="input-field">
                    </div>

                    <div class="md:col-span-2">

                        <label for="tournamentId"
                               class="mb-2 block text-sm font-semibold text-slate-700">
                            Assign Tournament
                        </label>

                        <select id="tournamentId"
                                name="tournamentId"
                                required
                                class="input-field">

                            <option value="">Choose a tournament</option>

                            <% if (tournaments != null) {
                                for (Tournament tournament : tournaments) { %>

                                    <option value="<%= tournament.getId() %>">
                                        <%= tournament.getName() %>
                                    </option>

                            <%  }
                               } %>

                        </select>

                        <% if (tournamentCount == 0) { %>
                            <p class="mt-2 text-xs text-amber-700">
                                No tournaments are available. Create a tournament before registering a team.
                            </p>
                        <% } %>

                    </div>

                    <div class="flex flex-wrap items-center justify-between gap-3 border-t border-slate-100 pt-5 md:col-span-2">

                        <p class="text-xs leading-5 text-slate-500">
                            Make sure the tournament has already been registered.
                        </p>

                        <button type="submit"
                                <%= tournamentCount == 0 ? "disabled" : "" %>
                                class="action-button inline-flex items-center justify-center gap-2 rounded-xl bg-pitch-green px-6 py-3 text-sm font-bold text-white shadow-sm transition hover:bg-green-800 focus:outline-none focus:ring-4 focus:ring-green-200 disabled:cursor-not-allowed disabled:opacity-50">

                            <span aria-hidden="true">+</span>
                            Register Team

                        </button>

                    </div>

                </form>

            </section>

        <% } %>

        <!-- Registered Teams -->
        <section class="soft-shadow overflow-hidden rounded-2xl border border-slate-200 bg-white">

            <div class="flex flex-col justify-between gap-4 border-b border-slate-200 px-6 py-5 sm:flex-row sm:items-center md:px-8">

                <div>
                    <h3 class="text-lg font-bold text-pitch-navy">
                        Registered Teams
                    </h3>

                    <p class="mt-1 text-sm text-slate-500">
                        Team directory and captain information
                    </p>
                </div>

                <span class="inline-flex w-fit items-center gap-2 rounded-full border border-green-100 bg-green-50 px-3.5 py-2 text-sm font-bold text-pitch-green">

                    <span class="h-2 w-2 rounded-full bg-pitch-green"></span>

                    <%= teamCount %> Teams

                </span>

            </div>

            <% if (teams != null && !teams.isEmpty()) { %>

                <div class="overflow-x-auto">

                    <table class="w-full min-w-[650px] text-left">

                        <thead class="border-b border-slate-200 bg-slate-50">

                            <tr>

                                <th scope="col"
                                    class="px-6 py-4 text-xs font-bold uppercase tracking-wider text-slate-500 md:px-8">
                                    Team
                                </th>

                                <th scope="col"
                                    class="px-6 py-4 text-xs font-bold uppercase tracking-wider text-slate-500">
                                    Team ID
                                </th>

                                <th scope="col"
                                    class="px-6 py-4 text-xs font-bold uppercase tracking-wider text-slate-500">
                                    Tournament ID
                                </th>

                                <th scope="col"
                                    class="px-6 py-4 text-xs font-bold uppercase tracking-wider text-slate-500">
                                    Captain
                                </th>

                            </tr>

                        </thead>

                        <tbody class="divide-y divide-slate-100">

                            <% for (Team team : teams) { %>

                                <tr class="table-row">

                                    <!-- Team -->
                                    <td class="px-6 py-4 md:px-8">

                                        <div class="flex items-center gap-3">

                                            <div class="flex h-11 w-11 shrink-0 items-center justify-center rounded-xl border border-green-100 bg-green-50 text-pitch-green">

                                                <svg xmlns="http://www.w3.org/2000/svg"
                                                     viewBox="0 0 24 24"
                                                     fill="none"
                                                     stroke="currentColor"
                                                     stroke-width="1.7"
                                                     stroke-linecap="round"
                                                     stroke-linejoin="round"
                                                     class="h-6 w-6"
                                                     aria-hidden="true">
                                                    <circle cx="12" cy="12" r="9"/>
                                                    <path d="M8 4.5l8 15"/>
                                                    <path d="M4.5 8l15 8"/>
                                                    <path d="M4 12h16"/>
                                                </svg>

                                            </div>

                                            <div>
                                                <p class="font-bold text-pitch-navy">
                                                    <%= team.getTeamName() %>
                                                </p>

                                                <p class="mt-1 text-xs text-slate-400">
                                                    Cricket Team
                                                </p>
                                            </div>

                                        </div>

                                    </td>

                                    <!-- Team ID -->
                                    <td class="px-6 py-4">

                                        <span class="inline-flex rounded-lg bg-slate-100 px-3 py-1.5 text-xs font-bold text-slate-600">
                                            #<%= team.getId() %>
                                        </span>

                                    </td>

                                    <!-- Tournament ID -->
                                    <td class="px-6 py-4">

                                        <span class="inline-flex rounded-lg bg-green-50 px-3 py-1.5 text-xs font-bold text-pitch-green">
                                            #<%= team.getTournamentId() %>
                                        </span>

                                    </td>

                                    <!-- Captain -->
                                    <td class="px-6 py-4">

                                        <div class="flex items-center gap-2.5">

                                            <div class="flex h-8 w-8 items-center justify-center rounded-full bg-slate-100 text-xs font-bold text-slate-600">
                                                C
                                            </div>

                                            <span class="text-sm font-medium text-slate-700">
                                                <%= team.getCaptain() %>
                                            </span>

                                        </div>

                                    </td>

                                </tr>

                            <% } %>

                        </tbody>

                    </table>

                </div>

            <% } else { %>

                <div class="px-6 py-16 text-center md:px-8">

                    <div class="mx-auto mb-5 flex h-20 w-20 items-center justify-center rounded-3xl bg-green-50 text-pitch-green">

                        <svg xmlns="http://www.w3.org/2000/svg"
                             viewBox="0 0 24 24"
                             fill="none"
                             stroke="currentColor"
                             stroke-width="1.7"
                             stroke-linecap="round"
                             stroke-linejoin="round"
                             class="h-10 w-10"
                             aria-hidden="true">
                            <circle cx="12" cy="12" r="9"/>
                            <path d="M8 4.5l8 15"/>
                            <path d="M4.5 8l15 8"/>
                            <path d="M4 12h16"/>
                        </svg>

                    </div>

                    <h4 class="text-xl font-bold text-pitch-navy">
                        No Teams Yet
                    </h4>

                    <p class="mx-auto mt-2 max-w-sm text-sm leading-6 text-slate-500">

                        <% if (isAdmin) { %>
                            Register your first cricket team using the form above.
                        <% } else { %>
                            Registered teams will appear here once they are added.
                        <% } %>

                    </p>

                </div>

            <% } %>

            <div class="border-t border-slate-200 bg-slate-50 px-6 py-4 md:px-8">
                <p class="text-xs text-slate-500">
                    CricketHub &middot; Team Management
                </p>
            </div>

        </section>

        <!-- Footer -->
        <footer class="mt-8 flex flex-col items-center justify-between gap-2 border-t border-slate-200 py-6 text-center text-xs text-slate-400 sm:flex-row sm:text-left">

            <p>
                &copy; 2026 CricketHub. Cricket Tournament Management System.
            </p>

            <p>
                Built for the love of cricket.
            </p>

        </footer>

    </main>

</body>
</html>
