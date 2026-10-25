
<%@ page import="com.crickethub.dto.User" %>
<%
    User user = (User) session.getAttribute("user");

    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    if (!"USER".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String contextPath = request.getContextPath();
    String username = user.getUsername();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Dashboard | CricketHub</title>

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
            font-family: Arial, Helvetica, sans-serif;
        }

        .dashboard-card {
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .dashboard-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 28px rgba(11, 23, 38, 0.10);
        }
    </style>
</head>

<body class="min-h-screen bg-pitch-canvas text-pitch-navy">

    <!-- Header -->
    <header class="border-b border-slate-200 bg-white">
        <div class="mx-auto flex max-w-7xl items-center justify-between px-5 py-4 sm:px-8">

            <!-- CricketHub Logo -->
            <a href="<%= contextPath %>/userDashboard.jsp"
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

                <span class="text-xl font-bold tracking-tight text-pitch-navy">
                    CricketHub
                </span>

            </a>

            <!-- User Info and Logout -->
            <div class="flex items-center gap-3 sm:gap-5">

                <div class="hidden text-right sm:block">
                    <p class="text-sm font-semibold text-pitch-navy">
                        <%= username %>
                    </p>
                    <p class="text-xs text-slate-500">
                        Cricket Enthusiast
                    </p>
                </div>

                <form action="<%= contextPath %>/logout" method="post">
                    <button type="submit"
                            class="rounded-lg border border-slate-300 px-4 py-2 text-sm font-semibold text-slate-700 transition hover:border-red-300 hover:bg-red-50 hover:text-red-600">
                        Logout
                    </button>
                </form>

            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="mx-auto max-w-7xl px-5 py-8 sm:px-8 sm:py-10">

        <!-- Welcome Banner -->
        <section class="relative overflow-hidden rounded-2xl bg-pitch-navy p-7 text-white shadow-sm sm:p-10">

            <div class="relative z-10 max-w-2xl">

                <span class="inline-flex items-center rounded-full border border-white/20 bg-white/10 px-3 py-1 text-xs font-semibold tracking-wide text-pitch-lime">
                    USER DASHBOARD
                </span>

                <h1 class="mt-5 text-3xl font-bold tracking-tight sm:text-4xl">
                    Welcome back, <%= username %>!
                </h1>

                <p class="mt-3 max-w-xl text-sm leading-6 text-slate-300 sm:text-base">
                    Explore tournaments, discover teams and players, follow match results,
                    and stay connected with everything happening on CricketHub.
                </p>

                <div class="mt-6 flex flex-wrap gap-3">

                    <a href="<%= contextPath %>/tournaments"
                       class="inline-flex items-center rounded-lg bg-pitch-lime px-5 py-3 text-sm font-bold text-pitch-navy transition hover:bg-lime-300">
                        Explore Tournaments
                        <span class="ml-2" aria-hidden="true">&rarr;</span>
                    </a>

                    <a href="<%= contextPath %>/matches"
                       class="inline-flex items-center rounded-lg border border-white/25 px-5 py-3 text-sm font-semibold text-white transition hover:bg-white/10">
                        View Matches
                    </a>

                </div>
            </div>

            <!-- Decorative Cricket Ball -->
            <div class="pointer-events-none absolute -right-12 -top-16 hidden h-64 w-64 rounded-full border border-white/10 sm:block"></div>
            <div class="pointer-events-none absolute -right-4 -top-8 hidden h-48 w-48 rounded-full border border-pitch-lime/20 sm:block"></div>
            <div class="pointer-events-none absolute right-10 top-10 hidden h-28 w-28 rounded-full border border-white/10 sm:block"></div>

        </section>

        <!-- Section Heading -->
        <section class="mt-10">

            <div class="mb-6 flex flex-wrap items-end justify-between gap-3">

                <div>
                    <h2 class="text-2xl font-bold tracking-tight text-pitch-navy">
                        Explore CricketHub
                    </h2>

                    <p class="mt-1 text-sm text-slate-500">
                        Everything you need to follow your cricket tournaments.
                    </p>
                </div>

                <span class="rounded-full bg-white px-3 py-1.5 text-xs font-semibold text-pitch-green ring-1 ring-slate-200">
                    Read-only access
                </span>

            </div>

            <!-- Dashboard Cards -->
            <div class="grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-3">

                <!-- Tournaments -->
                <a href="<%= contextPath %>/tournaments"
                   class="dashboard-card group rounded-2xl border border-slate-200 bg-white p-6 no-underline">

                    <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-lime-50 text-2xl">
                        &#127942;
                    </div>

                    <h3 class="mt-5 text-lg font-bold text-pitch-navy">
                        Tournaments
                    </h3>

                    <p class="mt-2 text-sm leading-6 text-slate-500">
                        Discover cricket tournaments and check their details and current status.
                    </p>

                    <div class="mt-5 flex items-center justify-between">
                        <span class="text-sm font-semibold text-pitch-green">
                            Explore tournaments
                        </span>
                        <span class="text-lg text-pitch-green transition group-hover:translate-x-1" aria-hidden="true">
                            &rarr;
                        </span>
                    </div>

                </a>

                <!-- Teams -->
                <a href="<%= contextPath %>/teams"
                   class="dashboard-card group rounded-2xl border border-slate-200 bg-white p-6 no-underline">

                    <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-blue-50 text-2xl">
                        &#128101;
                    </div>

                    <h3 class="mt-5 text-lg font-bold text-pitch-navy">
                        Teams
                    </h3>

                    <p class="mt-2 text-sm leading-6 text-slate-500">
                        Browse participating cricket teams and learn about their captains.
                    </p>

                    <div class="mt-5 flex items-center justify-between">
                        <span class="text-sm font-semibold text-pitch-green">
                            View teams
                        </span>
                        <span class="text-lg text-pitch-green transition group-hover:translate-x-1" aria-hidden="true">
                            &rarr;
                        </span>
                    </div>

                </a>

                <!-- Players -->
                <a href="<%= contextPath %>/players"
                   class="dashboard-card group rounded-2xl border border-slate-200 bg-white p-6 no-underline">

                    <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-purple-50 text-2xl">
                        &#127951;
                    </div>

                    <h3 class="mt-5 text-lg font-bold text-pitch-navy">
                        Players
                    </h3>

                    <p class="mt-2 text-sm leading-6 text-slate-500">
                        Explore player profiles and see which teams they represent.
                    </p>

                    <div class="mt-5 flex items-center justify-between">
                        <span class="text-sm font-semibold text-pitch-green">
                            Discover players
                        </span>
                        <span class="text-lg text-pitch-green transition group-hover:translate-x-1" aria-hidden="true">
                            &rarr;
                        </span>
                    </div>

                </a>

                <!-- Matches -->
                <a href="<%= contextPath %>/matches"
                   class="dashboard-card group rounded-2xl border border-slate-200 bg-white p-6 no-underline">

                    <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-orange-50 text-2xl">
                        &#127919;
                    </div>

                    <h3 class="mt-5 text-lg font-bold text-pitch-navy">
                        Matches
                    </h3>

                    <p class="mt-2 text-sm leading-6 text-slate-500">
                        Follow scheduled matches, check scores, and see completed match results.
                    </p>

                    <div class="mt-5 flex items-center justify-between">
                        <span class="text-sm font-semibold text-pitch-green">
                            View matches
                        </span>
                        <span class="text-lg text-pitch-green transition group-hover:translate-x-1" aria-hidden="true">
                            &rarr;
                        </span>
                    </div>

                </a>

                <!-- Points Table -->
                <a href="<%= contextPath %>/pointsTable"
                   class="dashboard-card group rounded-2xl border border-slate-200 bg-white p-6 no-underline">

                    <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-emerald-50 text-2xl">
                        &#128202;
                    </div>

                    <h3 class="mt-5 text-lg font-bold text-pitch-navy">
                        Points Table
                    </h3>

                    <p class="mt-2 text-sm leading-6 text-slate-500">
                        Check team standings, match performance, and tournament progress.
                    </p>

                    <div class="mt-5 flex items-center justify-between">
                        <span class="text-sm font-semibold text-pitch-green">
                            View standings
                        </span>
                        <span class="text-lg text-pitch-green transition group-hover:translate-x-1" aria-hidden="true">
                            &rarr;
                        </span>
                    </div>

                </a>

            </div>
        </section>

        <!-- Information Banner -->
        <section class="mt-8 rounded-2xl border border-green-100 bg-green-50 p-5 sm:p-6">

            <div class="flex items-start gap-4">

                <div class="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-white text-xl shadow-sm">
                    &#10003;
                </div>

                <div>
                    <h3 class="font-bold text-pitch-green">
                        Stay updated with CricketHub
                    </h3>

                    <p class="mt-1 text-sm leading-6 text-slate-600">
                        You can browse tournaments, teams, players, matches, and points tables.
                        Editing and management features are reserved for authorized administrators
                        and captains.
                    </p>
                </div>

            </div>

        </section>

        <!-- Footer -->
        <footer class="mt-10 border-t border-slate-200 py-6 text-center">

            <p class="text-sm text-slate-500">
                &copy; <%= java.time.Year.now().getValue() %> CricketHub.
                Built for the love of cricket.
            </p>

        </footer>

    </main>

</body>
</html>
