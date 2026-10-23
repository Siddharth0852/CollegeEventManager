<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.college.model.Event, com.college.model.User" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Event> events = (List<Event>) request.getAttribute("events");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Campus Events & Seminars</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-dark bg-dark px-4">
        <span class="navbar-brand">College Event Portal</span>
        <div class="text-white">
            Welcome, <strong><%= currentUser.getName() %></strong> (<%= currentUser.getRole() %>) | 
            <a href="auth" class="btn btn-outline-light btn-sm ms-2">Logout</a>
        </div>
    </nav>

    <div class="container my-4">
        <% if ("success".equals(request.getParameter("status"))) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                Registration for the event was successful!
            </div>
        <% } %>

        <% if ("ADMIN".equals(currentUser.getRole())) { %>
            <div class="card mb-4 shadow-sm">
                <div class="card-header bg-primary text-white">Add New Seminar / Event</div>
                <div class="card-body">
                    <form action="events" method="post" class="row g-3">
                        <input type="hidden" name="action" value="create">
                        <div class="col-md-6">
                            <label class="form-label">Event Title</label>
                            <input type="text" name="title" class="form-control" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Date</label>
                            <input type="date" name="event_date" class="form-control" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Capacity</label>
                            <input type="number" name="capacity" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Venue</label>
                            <input type="text" name="venue" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Description</label>
                            <input type="text" name="description" class="form-control">
                        </div>
                        <div class="col-12">
                            <button type="submit" class="btn btn-primary">Publish Event</button>
                        </div>
                    </form>
                </div>
            </div>
        <% } %>

        <h4 class="mb-3">Upcoming Events</h4>
        <div class="table-responsive shadow-sm">
            <table class="table table-bordered table-striped align-middle">
                <thead class="table-dark">
                    <tr>
                        <th>Title</th>
                        <th>Description</th>
                        <th>Date</th>
                        <th>Venue</th>
                        <th>Capacity</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                <% if (events != null && !events.isEmpty()) { 
                    for (Event ev : events) { %>
                    <tr>
                        <td><strong><%= ev.getTitle() %></strong></td>
                        <td><%= ev.getDescription() %></td>
                        <td><%= ev.getEventDate() %></td>
                        <td><%= ev.getVenue() %></td>
                        <td><%= ev.getCapacity() %> seats</td>
                        <td>
                            <% if ("STUDENT".equals(currentUser.getRole())) { %>
                                <form action="events" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="book">
                                    <input type="hidden" name="eventId" value="<%= ev.getId() %>">
                                    <button type="submit" class="btn btn-sm btn-success">Register</button>
                                </form>
                            <% } else { %>
                                <span class="badge bg-secondary">Admin View</span>
                            <% } %>
                        </td>
                    </tr>
                <%  } 
                   } else { %>
                    <tr>
                        <td colspan="6" class="text-center">No upcoming events found.</td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>