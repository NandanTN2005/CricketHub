
<%@ page import="java.util.List" %>
<%@ page import="com.crickethub.dto.Tournament" %>
<%@ page import="com.crickethub.dto.User" %>
<%@ page import="com.crickethub.dto.Admin" %>

<%
    List<Tournament> tournaments =
        (List<Tournament>) request.getAttribute("tournaments");

    boolean isAdmin = session.getAttribute("admin") instanceof Admin;

    User loggedInUser = null;
    String dashboardPage = "login.jsp";

    if (isAdmin) {
        dashboardPage = "dashboard.jsp";
    } else if (session.getAttribute("user") instanceof User) {
        loggedInUser = (User) session.getAttribute("user");

        if ("CAPTAIN".equals(loggedInUser.getRole())) {
            dashboardPage = "captainDashboard.jsp";
        } else if ("USER".equals(loggedInUser.getRole())) {
            dashboardPage = "userDashboard.jsp";
        }
    }

    String contextPath = request.getContextPath();

    String error = (String) request.getAttribute("Error_in_tournament");
    int tournamentCount = tournaments == null ? 0 : tournaments.size();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>CricketHub | Tournaments</title>

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

        .input-field {
            width: 100%;
            box-sizing: border-box;
            padding: 12px 14px;
            background: #ffffff;
            border: 1px solid #cbd5e1;
            border-radius: 10px;
            color: #0B1726;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        .input-field:focus {
            border-color: #246C35;
            box-shadow: 0 0 0 3px rgba(36, 108, 53, 0.12);
        }

        input[type="date"] {
            color-scheme: light;
        }

        .card-shadow {
            box-shadow: 0 4px 18px rgba(11, 23, 38, 0.05);
        }

        .tournament-row {
            transition: background-color 0.2s;
        }

        .tournament-row:hover {
            background-color: #f3f8f1;
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

    <!-- Navigation Bar -->
    <nav class="border-b border-slate-200 bg-white">
        <div class="mx-auto flex max-w-7xl items-center justify-between gap-4 px-5 py-4 md:px-8">

            <!-- CricketHub Brand -->
            <a href="<%= contextPath %>/<%= dashboardPage %>"
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

                    <p class="mt-0.5 text-xs text-slate-500">
                        Tournament Management
                    </p>
                </div>

            </a>

            <!-- Dashboard Navigation -->
            <a href="<%= contextPath %>/<%= dashboardPage %>"
               class="inline-flex items-center gap-2 rounded-lg border border-slate-200 px-4 py-2.5 text-sm font-semibold text-slate-700 transition hover:border-pitch-green hover:bg-green-50 hover:text-pitch-green">

                <span aria-hidden="true">&larr;</span>
                <span class="hidden sm:inline">Back to Dashboard</span>
                <span class="sm:hidden">Dashboard</span>

            </a>

        </div>
    </nav>

    <main class="mx-auto max-w-7xl px-5 py-8 md:px-8 md:py-10">

        <!-- Page Heading -->
        <section class="mb-8">

            <div class="flex flex-col gap-5 md:flex-row md:items-end md:justify-between">

                <div>
                    <div class="mb-3 flex items-center gap-2">
                        <span class="h-2 w-2 rounded-full bg-pitch-green"></span>

                        <p class="text-sm font-bold uppercase tracking-widest text-pitch-green">
                            Competition Centre
                        </p>
                    </div>

                    <h2 class="text-3xl font-extrabold tracking-tight text-pitch-navy md:text-4xl">
                        Tournaments
                    </h2>

                    <p class="mt-3 max-w-xl leading-relaxed text-slate-500">
                        Discover cricket competitions, explore venues, and keep track
                        of tournament schedules and upcoming events.
                    </p>
                </div>

                <!-- Tournament Count -->
                <div class="flex items-center gap-4 rounded-2xl border border-slate-200 bg-white px-6 py-4 card-shadow">

                    <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-green-50 text-pitch-green">
                        <svg xmlns="http://www.w3.org/2000/svg"
                             viewBox="0 0 24 24"
                             fill="none"
                             stroke="currentColor"
                             stroke-width="1.8"
                             stroke-linecap="round"
                             stroke-linejoin="round"
                             class="h-6 w-6"
                             aria-hidden="true">
                            <path d="M8 21h8"/>
                            <path d="M12 17v4"/>
                            <path d="M7 4H4v3a5 5 0 0 0 5 5"/>
                            <path d="M17 4h3v3a5 5 0 0 1-5 5"/>
                            <path d="M7 3h10v8a5 5 0 0 1-10 0z"/>
                        </svg>
                    </div>

                    <div>
                        <p class="text-sm font-medium text-slate-500">
                            Total Tournaments
                        </p>

                        <p class="mt-0.5 text-3xl font-extrabold text-pitch-navy">
                            <%= tournamentCount %>
                        </p>
                    </div>

                </div>

            </div>

        </section>

        <!-- Error Message -->
        <% if (error != null && !error.trim().isEmpty()) { %>

            <div class="mb-6 rounded-xl border border-red-200 bg-red-50 px-5 py-4 text-red-700"
                 role="alert">

                <p class="mb-1 font-bold">
                    Unable to process tournament
                </p>

                <p class="text-sm">
                    <%= error %>
                </p>

            </div>

        <% } %>

        <!-- Create Tournament: Admin Only -->
        <% if (isAdmin) { %>

            <section class="mb-8 rounded-2xl border border-slate-200 bg-white p-6 card-shadow md:p-8">

                <div class="mb-7 flex items-start gap-4">

                    <div class="flex h-12 w-12 shrink-0 items-center justify-center rounded-xl bg-pitch-lime text-2xl font-bold text-pitch-navy">
                        +
                    </div>

                    <div>
                        <h3 class="text-xl font-bold text-pitch-navy">
                            Create a Tournament
                        </h3>

                        <p class="mt-1 text-sm text-slate-500">
                            Fill in the details to register a new cricket competition.
                        </p>
                    </div>

                </div>

                <form action="<%= contextPath %>/tournaments"
                      method="post"
                      class="grid grid-cols-1 gap-x-6 gap-y-5 md:grid-cols-2">

                    <div class="md:col-span-2">
                        <label for="name"
                               class="mb-2 block text-sm font-semibold text-slate-700">
                            Tournament Name
                        </label>

                        <input type="text"
                               id="name"
                               name="name"
                               class="input-field"
                               placeholder="e.g. CricketHub Premier League"
                               maxlength="100"
                               required>
                    </div>

                    <div>
                        <label for="venue"
                               class="mb-2 block text-sm font-semibold text-slate-700">
                            Venue
                        </label>

                        <input type="text"
                               id="venue"
                               name="venue"
                               class="input-field"
                               placeholder="Enter stadium or venue"
                               maxlength="150"
                               required>
                    </div>

                    <div>
                        <label for="startDate"
                               class="mb-2 block text-sm font-semibold text-slate-700">
                            Start Date
                        </label>

                        <input type="date"
                               id="startDate"
                               name="startDate"
                               class="input-field"
                               required>
                    </div>

                    <div class="flex justify-end pt-2 md:col-span-2">

                        <button type="submit"
                                class="action-button inline-flex w-full items-center justify-center gap-2 rounded-xl bg-pitch-green px-6 py-3 font-bold text-white hover:bg-green-800 focus:outline-none focus:ring-4 focus:ring-green-200 sm:w-auto">

                            <span aria-hidden="true">+</span>
                            Create Tournament

                        </button>

                    </div>

                </form>

            </section>

        <% } %>

        <!-- Existing Tournaments -->
        <section class="overflow-hidden rounded-2xl border border-slate-200 bg-white card-shadow">

            <div class="flex flex-col gap-4 border-b border-slate-200 px-6 py-6 sm:flex-row sm:items-center sm:justify-between md:px-8">

                <div>
                    <h3 class="text-xl font-bold text-pitch-navy">
                        Existing Tournaments
                    </h3>

                    <p class="mt-1 text-sm text-slate-500">
                        Browse registered cricket competitions.
                    </p>
                </div>

                <span class="inline-flex items-center gap-2 self-start rounded-full border border-green-100 bg-green-50 px-3.5 py-2 text-sm font-semibold text-pitch-green">

                    <span class="h-2 w-2 rounded-full bg-pitch-green"></span>

                    <%= tournamentCount %>
                    tournament(s)

                </span>

            </div>

            <div class="overflow-x-auto">

                <table class="w-full text-left">

                    <thead class="border-b border-slate-200 bg-slate-50">
                        <tr>

                            <th scope="col"
                                class="px-6 py-4 text-xs font-bold uppercase tracking-wider text-slate-500 md:px-8">
                                ID
                            </th>

                            <th scope="col"
                                class="px-6 py-4 text-xs font-bold uppercase tracking-wider text-slate-500">
                                Tournament Name
                            </th>

                            <th scope="col"
                                class="px-6 py-4 text-xs font-bold uppercase tracking-wider text-slate-500">
                                Venue
                            </th>

                            <th scope="col"
                                class="px-6 py-4 text-xs font-bold uppercase tracking-wider text-slate-500 md:px-8">
                                Start Date
                            </th>

                        </tr>
                    </thead>

                    <tbody class="divide-y divide-slate-100">

                        <% if (tournaments != null && !tournaments.isEmpty()) { %>

                            <% for (Tournament t : tournaments) { %>

                                <tr class="tournament-row">

                                    <!-- Tournament ID -->
                                    <td class="whitespace-nowrap px-6 py-5 md:px-8">
                                        <span class="text-sm font-semibold text-slate-500">
                                            #<%= t.getId() %>
                                        </span>
                                    </td>

                                    <!-- Tournament Name -->
                                    <td class="px-6 py-5">

                                        <div class="flex items-center gap-3">

                                            <div class="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-green-50 font-extrabold text-pitch-green">
                                                T
                                            </div>

                                            <div>
                                                <p class="font-bold text-pitch-navy">
                                                    <%= t.getName() %>
                                                </p>

                                                <p class="mt-1 text-xs text-slate-500">
                                                    Cricket Tournament
                                                </p>
                                            </div>

                                        </div>

                                    </td>

                                    <!-- Venue -->
                                    <td class="px-6 py-5">

                                        <div class="flex items-center gap-2 text-sm text-slate-600">

                                            <svg xmlns="http://www.w3.org/2000/svg"
                                                 viewBox="0 0 24 24"
                                                 fill="none"
                                                 stroke="currentColor"
                                                 stroke-width="1.8"
                                                 stroke-linecap="round"
                                                 stroke-linejoin="round"
                                                 class="h-4 w-4 shrink-0 text-pitch-green"
                                                 aria-hidden="true">
                                                <path d="M20 10c0 5-8 11-8 11S4 15 4 10a8 8 0 1 1 16 0z"/>
                                                <circle cx="12" cy="10" r="2.5"/>
                                            </svg>

                                            <%= t.getVenue() %>

                                        </div>

                                    </td>

                                    <!-- Start Date -->
                                    <td class="whitespace-nowrap px-6 py-5 md:px-8">

                                        <span class="inline-flex items-center rounded-lg border border-slate-200 bg-slate-100 px-3 py-2 text-sm font-medium text-slate-700">
                                            <%= t.getStartDate() %>
                                        </span>

                                    </td>

                                </tr>

                            <% } %>

                        <% } else { %>

                            <tr>
                                <td colspan="4" class="px-6 py-16 text-center">

                                    <div class="mx-auto mb-4 flex h-16 w-16 items-center justify-center rounded-2xl bg-green-50 text-pitch-green">

                                        <svg xmlns="http://www.w3.org/2000/svg"
                                             viewBox="0 0 24 24"
                                             fill="none"
                                             stroke="currentColor"
                                             stroke-width="1.6"
                                             stroke-linecap="round"
                                             stroke-linejoin="round"
                                             class="h-8 w-8"
                                             aria-hidden="true">
                                            <path d="M8 21h8"/>
                                            <path d="M12 17v4"/>
                                            <path d="M7 4H4v3a5 5 0 0 0 5 5"/>
                                            <path d="M17 4h3v3a5 5 0 0 1-5 5"/>
                                            <path d="M7 3h10v8a5 5 0 0 1-10 0z"/>
                                        </svg>

                                    </div>

                                    <h4 class="text-lg font-bold text-pitch-navy">
                                        No tournaments found
                                    </h4>

                                    <p class="mx-auto mt-2 max-w-md text-sm leading-relaxed text-slate-500">

                                        <% if (isAdmin) { %>
                                            Get started by creating your first tournament using the form above.
                                        <% } else { %>
                                            Tournament details will appear here when competitions are registered.
                                        <% } %>

                                    </p>

                                </td>
                            </tr>

                        <% } %>

                    </tbody>

                </table>

            </div>

            <div class="border-t border-slate-200 bg-slate-50 px-6 py-4 md:px-8">

                <p class="text-xs text-slate-500">
                    CricketHub &middot; Tournament Management
                </p>

            </div>

        </section>

        <!-- Footer -->
        <footer class="py-8 text-center">

            <p class="text-sm text-slate-500">
                <span class="font-semibold text-pitch-navy">CricketHub</span>
                &middot; Built for the love of cricket.
            </p>

        </footer>

    </main>

</body>
</html>
