
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.crickethub.dto.User" %>

<%
    User loggedInUser = (User) session.getAttribute("user");

    if (loggedInUser != null) {
        if ("CAPTAIN".equalsIgnoreCase(loggedInUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/captainDashboard.jsp");
            return;
        } else {
            response.sendRedirect(request.getContextPath() + "/userDashboard.jsp");
            return;
        }
    }

    if (session.getAttribute("admin") != null) {
        response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
        return;
    }

    String error = (String) request.getAttribute("Error_in_register");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account | CricketHub</title>

    <script src="https://cdn.tailwindcss.com"></script>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
          rel="stylesheet">

    <style>
        body {
            font-family: 'Inter', sans-serif;
        }

        .cricket-bg {
            background:
                linear-gradient(rgba(8, 25, 42, 0.82), rgba(8, 25, 42, 0.92)),
                url('https://images.unsplash.com/photo-1540747913346-19e32dc3e97e?auto=format&fit=crop&w=1800&q=85');
            background-size: cover;
            background-position: center;
        }
    </style>
</head>

<body class="min-h-screen bg-slate-50">

    <div class="min-h-screen grid lg:grid-cols-2">

        <!-- Left cricket branding section -->
        <section class="cricket-bg hidden lg:flex flex-col justify-between p-12 xl:p-16 text-white">

            <a href="<%= request.getContextPath() %>/login.jsp"
               class="flex items-center gap-3 w-fit">
                <div class="h-12 w-12 rounded-2xl bg-green-500 flex items-center justify-center text-2xl shadow-lg">
                    🏏
                </div>
                <div>
                    <h1 class="text-2xl font-extrabold tracking-tight">CricketHub</h1>
                    <p class="text-sm text-slate-300">Your game. Your community.</p>
                </div>
            </a>

            <div class="max-w-xl">
                <p class="text-green-400 font-bold uppercase tracking-[0.25em] text-sm mb-5">
                    Join the community
                </p>

                <h2 class="text-4xl xl:text-5xl font-extrabold leading-tight">
                    Every match has a story.
                    <span class="text-green-400">Be part of yours.</span>
                </h2>

                <p class="mt-6 text-lg leading-8 text-slate-300">
                    Explore tournaments, follow teams, and keep track of
                    the action with your CricketHub account.
                </p>

                <div class="mt-8 flex flex-wrap gap-3 text-sm">
                    <span class="rounded-full border border-white/20 bg-white/10 px-4 py-2">
                        🏆 Tournaments
                    </span>
                    <span class="rounded-full border border-white/20 bg-white/10 px-4 py-2">
                        🏏 Teams & Matches
                    </span>
                    <span class="rounded-full border border-white/20 bg-white/10 px-4 py-2">
                        📊 Points Table
                    </span>
                </div>
            </div>

            <p class="text-sm text-slate-400">
                © <%= java.time.Year.now().getValue() %> CricketHub
            </p>
        </section>

        <!-- Registration form section -->
        <section class="flex items-center justify-center px-5 py-10 sm:px-10">

            <div class="w-full max-w-md">

                <a href="<%= request.getContextPath() %>/login.jsp"
                   class="inline-flex items-center gap-2 text-sm font-semibold text-slate-500 hover:text-green-700 mb-8">
                    <span>←</span> Back to login
                </a>

                <div class="mb-8">
                    <div class="lg:hidden flex items-center gap-3 mb-8">
                        <div class="h-11 w-11 rounded-xl bg-green-700 flex items-center justify-center text-xl">
                            🏏
                        </div>
                        <span class="text-xl font-extrabold text-slate-900">CricketHub</span>
                    </div>

                    <p class="text-sm font-bold uppercase tracking-widest text-green-700">
                        Get started for free
                    </p>

                    <h2 class="mt-2 text-3xl font-extrabold tracking-tight text-slate-900">
                        Create your account
                    </h2>

                    <p class="mt-3 text-slate-500">
                        Sign up to follow your favourite cricket tournaments.
                    </p>
                </div>

                <% if (error != null) { %>
                    <div role="alert"
                         class="mb-6 rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">
                        <%= error.replace("&", "&amp;")
                                 .replace("<", "&lt;")
                                 .replace(">", "&gt;")
                                 .replace("\"", "&quot;")
                                 .replace("'", "&#x27;") %>
                    </div>
                <% } %>

                <form action="<%= request.getContextPath() %>/register"
                      method="post"
                      class="space-y-5">

                    <div>
                        <label for="username"
                               class="mb-2 block text-sm font-semibold text-slate-700">
                            Username
                        </label>

                        <input type="text"
                               id="username"
                               name="username"
                               maxlength="50"
                               autocomplete="username"
                               placeholder="Choose a username"
                               required
                               class="w-full rounded-xl border border-slate-300 bg-white px-4 py-3.5 text-slate-900 outline-none transition focus:border-green-600 focus:ring-4 focus:ring-green-100">
                    </div>

                    <div>
                        <label for="email"
                               class="mb-2 block text-sm font-semibold text-slate-700">
                            Email address
                        </label>

                        <input type="email"
                               id="email"
                               name="email"
                               maxlength="255"
                               autocomplete="email"
                               placeholder="you@example.com"
                               required
                               class="w-full rounded-xl border border-slate-300 bg-white px-4 py-3.5 text-slate-900 outline-none transition focus:border-green-600 focus:ring-4 focus:ring-green-100">
                    </div>

                    <div>
                        <label for="password"
                               class="mb-2 block text-sm font-semibold text-slate-700">
                            Password
                        </label>

                        <div class="relative">
                            <input type="password"
                                   id="password"
                                   name="password"
                                   maxlength="255"
                                   autocomplete="new-password"
                                   placeholder="Create a password"
                                   required
                                   class="w-full rounded-xl border border-slate-300 bg-white px-4 py-3.5 pr-20 text-slate-900 outline-none transition focus:border-green-600 focus:ring-4 focus:ring-green-100">

                            <button type="button"
                                    onclick="togglePassword('password', this)"
                                    class="absolute inset-y-0 right-4 text-sm font-semibold text-slate-500 hover:text-green-700">
                                Show
                            </button>
                        </div>
                    </div>

                    <div>
                        <label for="confirmPassword"
                               class="mb-2 block text-sm font-semibold text-slate-700">
                            Confirm password
                        </label>

                        <input type="password"
                               id="confirmPassword"
                               name="confirmPassword"
                               maxlength="255"
                               autocomplete="new-password"
                               placeholder="Enter your password again"
                               required
                               class="w-full rounded-xl border border-slate-300 bg-white px-4 py-3.5 text-slate-900 outline-none transition focus:border-green-600 focus:ring-4 focus:ring-green-100">
                    </div>

                    <button type="submit"
                            class="w-full rounded-xl bg-green-700 px-5 py-3.5 font-bold text-white shadow-lg shadow-green-700/20 transition hover:bg-green-800 focus:outline-none focus:ring-4 focus:ring-green-200">
                        Create account
                        <span class="ml-2">→</span>
                    </button>

                    <p class="text-center text-sm text-slate-500">
                        Already have an account?
                        <a href="<%= request.getContextPath() %>/login.jsp"
                           class="font-bold text-green-700 hover:text-green-800">
                            Sign in
                        </a>
                    </p>

                </form>

                <p class="mt-8 text-center text-xs leading-5 text-slate-400">
                    Registration creates a normal User account.
                    Captain accounts are managed by the administrator.
                </p>

            </div>
        </section>

    </div>

    <script>
        function togglePassword(fieldId, button) {
            const field = document.getElementById(fieldId);

            if (field.type === "password") {
                field.type = "text";
                button.textContent = "Hide";
            } else {
                field.type = "password";
                button.textContent = "Show";
            }
        }
    </script>

</body>
</html>
