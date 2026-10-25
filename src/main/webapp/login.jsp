
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="com.crickethub.dto.Admin" %>
<%@ page import="com.crickethub.dto.User" %>

<%
    if (session.getAttribute("admin") instanceof Admin) {
        response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
        return;
    }

    User loggedInUser = (User) session.getAttribute("user");

    if (loggedInUser != null) {
        if ("CAPTAIN".equalsIgnoreCase(loggedInUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/captainDashboard.jsp");
            return;
        } else if ("USER".equalsIgnoreCase(loggedInUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/userDashboard.jsp");
            return;
        }
    }

    String error = (String) request.getAttribute("Error_in_login");
    String selectedRole = request.getParameter("role");

    if (selectedRole == null ||
        !(selectedRole.equals("ADMIN") ||
          selectedRole.equals("CAPTAIN") ||
          selectedRole.equals("USER"))) {
        selectedRole = "ADMIN";
    }

    String registered = request.getParameter("registered");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In | CricketHub</title>

    <script src="https://cdn.tailwindcss.com"></script>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
          rel="stylesheet">

    <style>
        * {
            font-family: 'Inter', sans-serif;
        }

        .stadium-panel {
            background:
                linear-gradient(
                    180deg,
                    rgba(5, 25, 42, 0.55) 0%,
                    rgba(5, 25, 42, 0.25) 40%,
                    rgba(2, 25, 17, 0.95) 100%
                ),
                url('https://images.unsplash.com/photo-1540747913346-19e32dc3e97e?auto=format&fit=crop&w=1800&q=85');

            background-size: cover;
            background-position: center;
        }

        .role-option input {
            position: absolute;
            opacity: 0;
            pointer-events: none;
        }

        .role-card {
            border: 1px solid #dbe4e8;
            transition: all 0.2s ease;
        }

        .role-option input:checked + .role-card {
            border: 2px solid #15803d;
            background: #ecfdf3;
            box-shadow: 0 0 0 2px rgba(21, 128, 61, 0.06);
        }

        .role-option input:focus-visible + .role-card {
            outline: 3px solid #86efac;
            outline-offset: 3px;
        }

        .role-option input:checked + .role-card .role-icon {
            background: #15803d;
            color: white;
        }

        .input-field:focus {
            outline: none;
            border-color: #15803d;
            box-shadow: 0 0 0 3px rgba(21, 128, 61, 0.10);
        }

        .signin-btn {
            background: linear-gradient(110deg, #15803d, #065f46);
            transition: all 0.2s ease;
        }

        .signin-btn:hover {
            box-shadow: 0 8px 20px rgba(6, 95, 70, 0.2);
            transform: translateY(-1px);
        }

        @media (max-width: 767px) {
            .stadium-panel {
                min-height: 330px;
                background-position: center 58%;
            }
        }
    </style>
</head>

<body class="min-h-screen bg-slate-100">

<div class="min-h-screen grid grid-cols-1 md:grid-cols-2">

    <!-- LEFT: CRICKET STADIUM HERO -->
    <section class="stadium-panel relative flex min-h-[340px] md:min-h-screen flex-col justify-between overflow-hidden px-7 py-8 sm:px-12 sm:py-10 lg:px-16">

        <div class="relative z-10">
            <a href="<%= request.getContextPath() %>/login.jsp"
               class="inline-flex items-center gap-3 text-white no-underline">

                <span class="flex h-12 w-12 items-center justify-center rounded-2xl bg-white/15 text-3xl backdrop-blur-sm">
                    🏏
                </span>

                <span>
                    <span class="block text-3xl font-extrabold tracking-tight sm:text-4xl">
                        Cricket<span class="text-emerald-400">Hub</span>
                    </span>
                    <span class="mt-1 block text-[10px] font-semibold tracking-[0.25em] text-slate-200 sm:text-xs">
                        TOURNAMENT MANAGEMENT
                    </span>
                </span>
            </a>
        </div>

        <div class="relative z-10 my-10 max-w-xl md:my-12">
            <span class="mb-5 inline-flex items-center gap-2 rounded-full border border-emerald-300/30 bg-emerald-300/10 px-4 py-2 text-xs font-semibold tracking-wide text-emerald-200 backdrop-blur-sm">
                <span class="h-2 w-2 rounded-full bg-emerald-400"></span>
                YOUR GAME. YOUR COMMUNITY.
            </span>

            <h1 class="text-4xl font-extrabold leading-tight tracking-tight text-white sm:text-5xl lg:text-6xl">
                Every match.<br>
                Every team.<br>
                <span class="text-emerald-400">One hub.</span>
            </h1>

            <p class="mt-6 max-w-md text-sm leading-7 text-slate-200 sm:text-base">
                Organize tournaments, manage your squad, follow match
                results and bring your cricket community together.
            </p>
        </div>

        <div class="relative z-10 grid grid-cols-2 gap-4 border-t border-white/20 pt-6 sm:grid-cols-4 sm:gap-3">

            <div class="text-center sm:text-left">
                <span class="text-2xl">🏆</span>
                <p class="mt-2 text-sm font-semibold text-white">Tournaments</p>
                <p class="mt-1 text-xs leading-5 text-slate-300">Organize competitions</p>
            </div>

            <div class="text-center sm:text-left">
                <span class="text-2xl">👥</span>
                <p class="mt-2 text-sm font-semibold text-white">Teams</p>
                <p class="mt-1 text-xs leading-5 text-slate-300">Build your squad</p>
            </div>

            <div class="text-center sm:text-left">
                <span class="text-2xl">🏏</span>
                <p class="mt-2 text-sm font-semibold text-white">Players</p>
                <p class="mt-1 text-xs leading-5 text-slate-300">Manage player details</p>
            </div>

            <div class="text-center sm:text-left">
                <span class="text-2xl">📅</span>
                <p class="mt-2 text-sm font-semibold text-white">Matches</p>
                <p class="mt-1 text-xs leading-5 text-slate-300">Follow fixtures and results</p>
            </div>

        </div>
    </section>

    <!-- RIGHT: LOGIN FORM -->
    <main class="flex min-h-screen items-center justify-center bg-slate-50 px-5 py-10 sm:px-10 lg:px-14">

        <div class="w-full max-w-lg">

            <div class="mb-8">
                <p class="text-sm font-bold uppercase tracking-[0.2em] text-emerald-700">
                    Welcome back
                </p>

                <h2 class="mt-3 text-3xl font-extrabold tracking-tight text-slate-900 sm:text-4xl">
                    Sign in to CricketHub
                </h2>

                <p class="mt-3 text-sm leading-6 text-slate-500 sm:text-base">
                    Choose your account type and enter your credentials
                    to continue to your dashboard.
                </p>
            </div>

            <% if ("success".equals(registered)) { %>
                <div role="status"
                     class="mb-6 rounded-xl border border-green-200 bg-green-50 p-4 text-sm font-medium text-green-800">
                    Account created successfully! Please sign in.
                </div>
            <% } %>

            <% if (error != null) { %>
                <div role="alert"
                     class="mb-6 flex items-start gap-3 rounded-xl border border-red-200 bg-red-50 p-4 text-sm text-red-700">

                    <span class="text-lg">⚠</span>

                    <div>
                        <p class="font-semibold">Unable to sign in</p>
                        <p class="mt-1"><%= error.replace("&", "&amp;")
                                                .replace("<", "&lt;")
                                                .replace(">", "&gt;")
                                                .replace("\"", "&quot;")
                                                .replace("'", "&#x27;") %></p>
                    </div>
                </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/login"
                  method="post"
                  autocomplete="on">

                <!-- ROLE SELECTION -->
                <fieldset>
                    <legend class="mb-3 text-sm font-semibold text-slate-800">
                        Sign in as
                    </legend>

                    <div class="grid grid-cols-3 gap-2 sm:gap-3">

                        <label class="role-option relative cursor-pointer">
                            <input type="radio" name="role" value="ADMIN"
                                   <%= "ADMIN".equals(selectedRole) ? "checked" : "" %>
                                   required>

                            <div class="role-card flex min-h-[126px] flex-col items-center justify-center rounded-2xl p-3 text-center">
                                <span class="role-icon flex h-11 w-11 items-center justify-center rounded-xl bg-slate-100 text-xl text-slate-700">🛡️</span>
                                <span class="mt-3 text-sm font-bold text-slate-900">Admin</span>
                                <span class="mt-1 text-[11px] leading-4 text-slate-500">Manage platform</span>
                            </div>
                        </label>

                        <label class="role-option relative cursor-pointer">
                            <input type="radio" name="role" value="CAPTAIN"
                                   <%= "CAPTAIN".equals(selectedRole) ? "checked" : "" %>
                                   required>

                            <div class="role-card flex min-h-[126px] flex-col items-center justify-center rounded-2xl p-3 text-center">
                                <span class="role-icon flex h-11 w-11 items-center justify-center rounded-xl bg-slate-100 text-xl text-slate-700">👥</span>
                                <span class="mt-3 text-sm font-bold text-slate-900">Captain</span>
                                <span class="mt-1 text-[11px] leading-4 text-slate-500">Manage your team</span>
                            </div>
                        </label>

                        <label class="role-option relative cursor-pointer">
                            <input type="radio" name="role" value="USER"
                                   <%= "USER".equals(selectedRole) ? "checked" : "" %>
                                   required>

                            <div class="role-card flex min-h-[126px] flex-col items-center justify-center rounded-2xl p-3 text-center">
                                <span class="role-icon flex h-11 w-11 items-center justify-center rounded-xl bg-slate-100 text-xl text-slate-700">👤</span>
                                <span class="mt-3 text-sm font-bold text-slate-900">User</span>
                                <span class="mt-1 text-[11px] leading-4 text-slate-500">View tournaments</span>
                            </div>
                        </label>

                    </div>
                </fieldset>

                <!-- USERNAME -->
                <div class="mt-6">
                    <label for="username"
                           class="mb-2 block text-sm font-semibold text-slate-800">
                        Username
                    </label>

                    <div class="relative">
                        <span class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-4 text-lg text-slate-400">♙</span>

                        <input id="username"
                               type="text"
                               name="username"
                               placeholder="Enter your username"
                               autocomplete="username"
                               required
                               class="input-field w-full rounded-xl border border-slate-200 bg-white py-3.5 pl-12 pr-4 text-sm text-slate-900 placeholder:text-slate-400">
                    </div>
                </div>

                <!-- PASSWORD -->
                <div class="mt-5">
                    <label for="password"
                           class="mb-2 block text-sm font-semibold text-slate-800">
                        Password
                    </label>

                    <div class="relative">
                        <span class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-4 text-lg text-slate-400">🔒</span>

                        <input id="password"
                               type="password"
                               name="password"
                               placeholder="Enter your password"
                               autocomplete="current-password"
                               required
                               class="input-field w-full rounded-xl border border-slate-200 bg-white py-3.5 pl-12 pr-16 text-sm text-slate-900 placeholder:text-slate-400">

                        <button type="button"
                                id="togglePassword"
                                aria-label="Show password"
                                aria-pressed="false"
                                class="absolute inset-y-0 right-0 px-4 text-xs font-semibold text-slate-500 hover:text-emerald-700">
                            Show
                        </button>
                    </div>
                </div>

                <!-- SIGN IN -->
                <button type="submit"
                        class="signin-btn mt-7 flex w-full items-center justify-center gap-3 rounded-xl px-5 py-4 text-sm font-bold text-white">
                    Sign in to CricketHub
                    <span aria-hidden="true">→</span>
                </button>

            </form>

            <!-- NEW REGISTRATION LINK -->
            <div class="mt-6 text-center text-sm text-slate-600">
                Don't have an account?
                <a href="<%= request.getContextPath() %>/register.jsp"
                   class="font-bold text-emerald-700 hover:text-emerald-800">
                    Create account
                </a>
            </div>

            <div class="my-6 flex items-center gap-4">
                <div class="h-px flex-1 bg-slate-200"></div>
                <span class="text-xs font-medium text-slate-400">SECURE ACCESS</span>
                <div class="h-px flex-1 bg-slate-200"></div>
            </div>

            <div class="flex items-center justify-center gap-2 text-center text-xs text-slate-500">
                <span class="text-emerald-700">✓</span>
                Role-based dashboards
                <span class="text-slate-300">•</span>
                CricketHub
            </div>

            <p class="mt-8 text-center text-xs leading-5 text-slate-400">
                © 2026 CricketHub. Built for the love of cricket.
            </p>

        </div>
    </main>
</div>

<script>
    const passwordInput = document.getElementById("password");
    const togglePassword = document.getElementById("togglePassword");

    togglePassword.addEventListener("click", function () {
        const isHidden = passwordInput.type === "password";

        passwordInput.type = isHidden ? "text" : "password";
        togglePassword.textContent = isHidden ? "Hide" : "Show";
        togglePassword.setAttribute("aria-pressed", String(isHidden));
        togglePassword.setAttribute(
            "aria-label",
            isHidden ? "Hide password" : "Show password"
        );
    });
</script>

</body>
</html>
