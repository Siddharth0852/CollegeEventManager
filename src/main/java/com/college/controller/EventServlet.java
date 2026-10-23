package com.college.controller;

import java.io.IOException;
import java.sql.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.college.dao.EventDAO;
import com.college.model.Event;
import com.college.model.User;

@WebServlet("/events")
public class EventServlet extends HttpServlet {
    private EventDAO dao = new EventDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null || "list".equals(action)) {
            List<Event> eventList = dao.getAllEvents();
            request.setAttribute("events", eventList);
            request.getRequestDispatcher("events.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("currentUser");
        String action = request.getParameter("action");

        if ("create".equals(action) && "ADMIN".equals(user.getRole())) {
            Event ev = new Event();
            ev.setTitle(request.getParameter("title"));
            ev.setDescription(request.getParameter("description"));
            ev.setEventDate(Date.valueOf(request.getParameter("event_date")));
            ev.setVenue(request.getParameter("venue"));
            ev.setCapacity(Integer.parseInt(request.getParameter("capacity")));

            dao.addEvent(ev);
            response.sendRedirect("events?action=list");
        } else if ("book".equals(action)) {
            int eventId = Integer.parseInt(request.getParameter("eventId"));
            dao.registerForEvent(user.getId(), eventId);
            response.sendRedirect("events?action=list&status=success");
        }
    }
}