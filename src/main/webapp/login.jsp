<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>College Events - Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light d-flex align-items-center" style="height: 100vh;">
    <div class="container" style="max-width: 420px;">
        <div class="card shadow-sm p-4">
            <h4 class="text-center mb-3">Event Portal Login</h4>
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger py-2"><%= request.getAttribute("error") %></div>
            <% } %>
            <% if ("true".equals(request.getParameter("registered"))) { %>
                <div class="alert alert-success py-2">Account created! Please log in.</div>
            <% } %>
            <form action="auth" method="post">
                <input type="hidden" name="action" value="login">
                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="email" name="email" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Password</label>
                    <input type="password" name="password" class="form-control" required>
                </div>
                <button type="submit" class="btn btn-primary w-100">Log In</button>
            </form>
            <div class="text-center mt-3">
                <a href="register.jsp" class="small">New student? Register here</a>
            </div>
        </div>
    </div>
</body>
</html>