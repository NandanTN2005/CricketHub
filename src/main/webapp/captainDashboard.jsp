
<%@ page import="com.crickethub.dto.User" %>
<%
    User user = (User) session.getAttribute("user");

    if (user == null || !"CAPTAIN".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String contextPath = request.getContextPath();
    String username = user.getUsername();
    String initial = (username != null && !username.isEmpty())
            ? username.substring(0, 1).toUpperCase()
            : "C";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Captain Dashboard | CricketHub</title>

    <script src="https://cdn.tailwindcss.com"></script>

    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        pitch: {
                            navy: '#0B1726',
                            panel: '#122236',
                            lime: '#B8F36B',
                            green: '#246C35',
                            canvas: '#F5F7F6'
                        }
                    },
                    boxShadow: {
                        premium: '0 8px 24px rgba(15, 23, 42, 0.05)'
                    }
                }
            }
        }
    </script>

    <style>
        body {
            font-family: Inter, ui-sans-serif, system-ui, -apple-system,
                         BlinkMacSystemFont, "Segoe UI", sans-serif;
        }

        .dashboard-card {
            transition: transform 0.2s ease, box-shadow 0.2s ease,
                        border-color 0.2s ease;
        }

        .dashboard-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 16px 32px rgba(15, 23, 42, 0.10);
            border-color: #B8DDA1;
        }

        .dashboard-card:focus-visible,
        a:focus-visible,
        button:focus-visible {
            outline: 3px solid #65A30D;
            outline-offset: 4px;
        }

        @media (prefers-reduced-motion: reduce) {
            *,
            *::before,
            *::after {
                transition-duration: 0.01ms !important;
                animation-duration: 0.01ms !important;
            }
        }
    </style>
</head>

<body class="min-h-screen bg-pitch-canvas text-slate-800 antialiased">

    <!-- NAVIGATION -->
    <header class="bg-pitch-navy text-white">
        <div class="mx-auto flex max-w-7xl items-center justify-between gap-4 px-5 py-4 sm:px-8">

            <a href="<%= contextPath %>/captainDashboard.jsp"
               class="flex min-w-0 items-center gap-3 rounded-lg">

                <div class="flex h-11 w-11 shrink-0 items-center justify-center rounded-xl bg-pitch-lime text-pitch-navy">
                    <svg xmlns="http://www.w3.org/2000/svg"
                         width="27" height="27" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor"
                         stroke-width="1.8" stroke-linecap="round"
                         stroke-linejoin="round" aria-hidden="true">
                        <path d="M14.5 4.5 19.5 9.5"/>
                        <path d="M16.5 2.5 21.5 7.5"/>
                        <path d="M3 21l5.5-1.5L21 7l-4-4L4.5 16.5 3 21z"/>
                        <path d="m12 5 7 7"/>
                    </svg>
                </div>

                <div class="min-w-0">
                    <h1 class="text-xl font-extrabold tracking-tight sm:text-2xl">
                        Cricket<span class="text-pitch-lime">Hub</span>
                    </h1>
                    <p class="hidden text-xs tracking-widest text-slate-400 sm:block">
                        CAPTAIN WORKSPACE
                    </p>
                </div>
            </a>

            <div class="flex shrink-0 items-center gap-3 sm:gap-5">

                <div class="hidden items-center gap-3 sm:flex">
                    <div class="flex h-10 w-10 items-center justify-center rounded-full border border-white/10 bg-white/10 font-bold text-pitch-lime">
                        <%= initial %>
                    </div>

                    <div>
                        <p class="text-xs text-slate-400">Team Captain</p>
                        <p class="max-w-40 truncate text-sm font-semibold">
                            <%= username == null ? "Captain" : username %>
                        </p>
                    </div>
                </div>

                <form action="<%= contextPath %>/logout" method="post">
                    <button type="submit"
                            class="rounded-lg border border-slate-600 px-3 py-2 text-sm font-semibold text-slate-200 transition hover:border-red-400 hover:bg-red-500/10 hover:text-red-300 sm:px-4">
                        Logout
                    </button>
                </form>

            </div>
        </div>
    </header>

    <!-- MAIN CONTENT -->
    <main class="mx-auto max-w-7xl px-5 py-8 sm:px-8 sm:py-10">

        <!-- WELCOME BANNER -->
        <section class="relative overflow-hidden rounded-2xl bg-pitch-navy shadow-premium">

            <div class="pointer-events-none absolute -right-12 -top-24 h-64 w-64 rounded-full border border-white/10"></div>
            <div class="pointer-events-none absolute -right-2 -top-14 h-44 w-44 rounded-full border border-white/10"></div>
            <div class="pointer-events-none absolute -bottom-20 right-36 h-40 w-40 rounded-full bg-green-400/10 blur-2xl"></div>

            <div class="relative z-10 flex flex-col justify-between gap-8 p-6 sm:p-10 md:flex-row md:items-center">

                <div class="max-w-2xl">

                    <div class="mb-5 inline-flex items-center gap-2 rounded-full border border-pitch-lime/20 bg-pitch-lime/10 px-3 py-1.5">
                        <span class="h-2 w-2 rounded-full bg-pitch-lime"></span>
                        <span class="text-xs font-bold tracking-wider text-pitch-lime">
                            CAPTAIN CONTROL CENTER
                        </span>
                    </div>

                    <h2 class="text-3xl font-extrabold leading-tight tracking-tight text-white sm:text-4xl lg:text-5xl">
                        Lead your team,
                        <br class="sm:hidden">
                        <span class="text-pitch-lime"><%= username == null ? "Captain" : username %>.</span>
                    </h2>

                    <p class="mt-4 max-w-xl text-sm leading-7 text-slate-300 sm:text-base">
                        Manage your squad, explore tournaments, follow fixtures
                        and keep track of your team's performance.
                    </p>

                    <div class="mt-6 flex flex-wrap items-center gap-3">

                        <div class="inline-flex items-center gap-2 rounded-lg border border-white/10 bg-white/5 px-4 py-2.5">
                            <svg xmlns="http://www.w3.org/2000/svg"
                                 width="18" height="18" viewBox="0 0 24 24"
                                 fill="none" stroke="#B8F36B"
                                 stroke-width="1.8" stroke-linecap="round"
                                 stroke-linejoin="round" aria-hidden="true">
                                <path d="M16 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                                <circle cx="10" cy="7" r="4"/>
                                <path d="M20 21v-2a4 4 0 0 0-3-3.87"/>
                            </svg>

                            <span class="text-sm text-slate-200">
                                Team ID:
                                <strong class="text-pitch-lime">
                                    <%= user.getTeamId() == null ? "Not assigned" : user.getTeamId() %>
                                </strong>
                            </span>
                        </div>

                        <div class="inline-flex items-center gap-2 text-sm text-slate-300">
                            <span class="h-2 w-2 rounded-full bg-pitch-lime"></span>
                            Captain access verified
                        </div>

                    </div>
                </div>

                <div class="hidden h-36 w-36 shrink-0 items-center justify-center rounded-full border border-white/10 bg-white/5 md:flex lg:h-44 lg:w-44">
                    <svg xmlns="http://www.w3.org/2000/svg"
                         width="85" height="85" viewBox="0 0 24 24"
                         fill="none" stroke="#B8F36B"
                         stroke-width="1.1" stroke-linecap="round"
                         stroke-linejoin="round" aria-hidden="true">
                        <path d="M8 21h8"/>
                        <path d="M12 17v4"/>
                        <path d="M7 4h10v5a5 5 0 0 1-10 0V4z"/>
                        <path d="M7 6H4v2a4 4 0 0 0 4 4"/>
                        <path d="M17 6h3v2a4 4 0 0 1-4 4"/>
                    </svg>
                </div>

            </div>
        </section>

        <!-- SECTION HEADING -->
        <section class="mb-6 mt-10 flex flex-col justify-between gap-3 sm:flex-row sm:items-end">

            <div>
                <p class="text-xs font-bold uppercase tracking-widest text-pitch-green">
                    YOUR TEAM
                </p>

                <h2 class="mt-2 text-2xl font-extrabold tracking-tight text-slate-900 sm:text-3xl">
                    Captain's Workspace
                </h2>

                <p class="mt-2 text-sm leading-6 text-slate-500">
                    Your tools for managing the squad and following the tournament.
                </p>
            </div>

            <div class="inline-flex w-fit items-center gap-2 rounded-lg border border-slate-200 bg-white px-3 py-2 text-xs font-medium text-slate-600">
                <span class="h-2 w-2 rounded-full bg-green-500"></span>
                Team ID: <%= user.getTeamId() == null ? "Not assigned" : user.getTeamId() %>
            </div>

        </section>

        <!-- DASHBOARD CARDS -->
        <section class="grid grid-cols-1 items-stretch gap-5 sm:grid-cols-2 xl:grid-cols-3">

            <!-- TEAM PLAYERS -->
            <a href="<%= contextPath %>/players"
               class="dashboard-card group flex h-full flex-col rounded-2xl border border-green-200 bg-white p-6 shadow-premium">

                <div class="flex items-start justify-between">
                    <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-green-50 text-pitch-green">
                        <svg xmlns="http://www.w3.org/2000/svg"
                             width="25" height="25" viewBox="0 0 24 24"
                             fill="none" stroke="currentColor"
                             stroke-width="1.7" stroke-linecap="round"
                             stroke-linejoin="round" aria-hidden="true">
                            <path d="M16 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                            <circle cx="10" cy="7" r="4"/>
                            <path d="M20 21v-2a4 4 0 0 0-3-3.87"/>
                            <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
                        </svg>
                    </div>

                    <span class="rounded-full bg-green-50 px-2.5 py-1 text-xs font-bold text-pitch-green">
                        YOUR SQUAD
                    </span>
                </div>

                <h3 class="mt-6 text-lg font-bold text-slate-900">Manage Team Players</h3>

                <p class="mt-2 flex-1 text-sm leading-6 text-slate-500">
                    Maintain your team's player profiles, jersey numbers and playing roles.
                </p>

                <div class="mt-5 flex items-center justify-between border-t border-slate-100 pt-4">
                    <span class="text-sm font-bold text-pitch-green">Manage squad</span>
                    <span class="text-pitch-green transition group-hover:translate-x-1" aria-hidden="true">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M5 12h14"/>
                            <path d="m12 5 7 7-7 7"/>
                        </svg>
                    </span>
                </div>
            </a>

            <!-- TOURNAMENTS -->
            <a href="<%= contextPath %>/tournaments"
               class="dashboard-card group flex h-full flex-col rounded-2xl border border-slate-200/80 bg-white p-6 shadow-premium">

                <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-amber-50 text-amber-700">
                    <svg xmlns="http://www.w3.org/2000/svg"
                         width="25" height="25" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor"
                         stroke-width="1.7" stroke-linecap="round"
                         stroke-linejoin="round" aria-hidden="true">
                        <path d="M8 21h8"/>
                        <path d="M12 17v4"/>
                        <path d="M7 4h10v5a5 5 0 0 1-10 0V4z"/>
                        <path d="M7 6H4v2a4 4 0 0 0 4 4"/>
                        <path d="M17 6h3v2a4 4 0 0 1-4 4"/>
                    </svg>
                </div>

                <h3 class="mt-6 text-lg font-bold text-slate-900">Tournaments</h3>

                <p class="mt-2 flex-1 text-sm leading-6 text-slate-500">
                    Explore available tournaments and review their details.
                </p>

                <div class="mt-5 flex items-center justify-between border-t border-slate-100 pt-4">
                    <span class="text-sm font-bold text-pitch-green">View tournaments</span>
                    <span class="text-pitch-green transition group-hover:translate-x-1" aria-hidden="true">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M5 12h14"/>
                            <path d="m12 5 7 7-7 7"/>
                        </svg>
                    </span>
                </div>
            </a>

            <!-- TEAMS -->
            <a href="<%= contextPath %>/teams"
               class="dashboard-card group flex h-full flex-col rounded-2xl border border-slate-200/80 bg-white p-6 shadow-premium">

                <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-blue-50 text-blue-700">
                    <svg xmlns="http://www.w3.org/2000/svg"
                         width="25" height="25" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor"
                         stroke-width="1.7" stroke-linecap="round"
                         stroke-linejoin="round" aria-hidden="true">
                        <path d="M12 22s8-4 8-11V5l-8-3-8 3v6c0 7 8 11 8 11z"/>
                        <path d="m9 12 2 2 4-4"/>
                    </svg>
                </div>

                <h3 class="mt-6 text-lg font-bold text-slate-900">Teams</h3>

                <p class="mt-2 flex-1 text-sm leading-6 text-slate-500">
                    View participating teams and their available details.
                </p>

                <div class="mt-5 flex items-center justify-between border-t border-slate-100 pt-4">
                    <span class="text-sm font-bold text-pitch-green">Explore teams</span>
                    <span class="text-pitch-green transition group-hover:translate-x-1" aria-hidden="true">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M5 12h14"/>
                            <path d="m12 5 7 7-7 7"/>
                        </svg>
                    </span>
                </div>
            </a>

            <!-- MATCHES -->
            <a href="<%= contextPath %>/matches"
               class="dashboard-card group flex h-full flex-col rounded-2xl border border-slate-200/80 bg-white p-6 shadow-premium">

                <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-purple-50 text-purple-700">
                    <svg xmlns="http://www.w3.org/2000/svg"
                         width="25" height="25" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor"
                         stroke-width="1.7" stroke-linecap="round"
                         stroke-linejoin="round" aria-hidden="true">
                        <rect x="3" y="4" width="18" height="16" rx="2"/>
                        <path d="M16 2v4M8 2v4M3 10h18"/>
                        <path d="m9 14 2 2 4-4"/>
                    </svg>
                </div>

                <h3 class="mt-6 text-lg font-bold text-slate-900">Matches</h3>

                <p class="mt-2 flex-1 text-sm leading-6 text-slate-500">
                    Check upcoming fixtures, match schedules and recorded results.
                </p>

                <div class="mt-5 flex items-center justify-between border-t border-slate-100 pt-4">
                    <span class="text-sm font-bold text-pitch-green">View matches</span>
                    <span class="text-pitch-green transition group-hover:translate-x-1" aria-hidden="true">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M5 12h14"/>
                            <path d="m12 5 7 7-7 7"/>
                        </svg>
                    </span>
                </div>
            </a>

            <!-- POINTS TABLE -->
            <a href="<%= contextPath %>/pointsTable"
               class="dashboard-card group flex h-full flex-col rounded-2xl border border-slate-200/80 bg-white p-6 shadow-premium">

                <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-lime-50 text-pitch-green">
                    <svg xmlns="http://www.w3.org/2000/svg"
                         width="25" height="25" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor"
                         stroke-width="1.7" stroke-linecap="round"
                         stroke-linejoin="round" aria-hidden="true">
                        <path d="M3 3v18h18"/>
                        <path d="M18 17V9"/>
                        <path d="M13 17V5"/>
                        <path d="M8 17v-3"/>
                    </svg>
                </div>

                <h3 class="mt-6 text-lg font-bold text-slate-900">Points Table</h3>

                <p class="mt-2 flex-1 text-sm leading-6 text-slate-500">
                    Follow tournament standings and see how teams are performing.
                </p>

                <div class="mt-5 flex items-center justify-between border-t border-slate-100 pt-4">
                    <span class="text-sm font-bold text-pitch-green">View standings</span>
                    <span class="text-pitch-green transition group-hover:translate-x-1" aria-hidden="true">
                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M5 12h14"/>
                            <path d="m12 5 7 7-7 7"/>
                        </svg>
                    </span>
                </div>
            </a>

        </section>

        <!-- CAPTAIN NOTE -->
        <section class="mt-8 flex flex-col gap-4 rounded-2xl border border-green-100 bg-green-50/80 p-5 sm:flex-row sm:items-center sm:justify-between sm:px-6">

            <div class="flex items-start gap-3">
                <div class="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-white text-pitch-green shadow-sm">
                    <svg xmlns="http://www.w3.org/2000/svg"
                         width="22" height="22" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor"
                         stroke-width="1.8" stroke-linecap="round"
                         stroke-linejoin="round" aria-hidden="true">
                        <path d="M12 2 15 8l7 1-5 5 1 7-6-3-6 3 1-7-5-5 7-1z"/>
                    </svg>
                </div>

                <div>
                    <h3 class="font-bold text-slate-800">
                        Great teams play together
                    </h3>
                    <p class="mt-1 text-sm leading-6 text-slate-600">
                        Keep your squad organized and stay up to date with every match.
                    </p>
                </div>
            </div>

            <span class="shrink-0 text-xs font-semibold tracking-wide text-pitch-green">
                TEAM ID: <%= user.getTeamId() == null ? "NOT ASSIGNED" : user.getTeamId() %>
            </span>
        </section>

        <!-- FOOTER -->
        <footer class="mt-12 border-t border-slate-200 py-6 text-center">
            <p class="text-sm font-semibold text-slate-500">
                CricketHub
                <span class="mx-1 text-slate-300">|</span>
                Tournament Management System
            </p>

            <p class="mt-2 text-xs text-slate-400">
                &copy; 2026 CricketHub. Built for cricket lovers.
            </p>
        </footer>

    </main>

</body>
</html>
