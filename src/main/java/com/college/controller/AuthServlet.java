package com.college.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.college.dao.EventDAO;
import com.college.model.User;

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {
    private EventDAO dao = new EventDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("login".equals(action)) {
            String email = request.getParameter("email");
            String pass = request.getParameter("password");
            User user = dao.authenticate(email, pass);

            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("currentUser", user);
                response.sendRedirect("events?action=list");
            } else {
                request.setAttribute("error", "Invalid credentials. Try again.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } else if ("register".equals(action)) {
            User newUser = new User();
            newUser.setName(request.getParameter("name"));
            newUser.setEmail(request.getParameter("email"));
            newUser.setPassword(request.getParameter("password"));

            if (dao.registerUser(newUser)) {
                response.sendRedirect("login.jsp?registered=true");
            } else {
                request.setAttribute("error", "Email already exists or registration failed.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect("login.jsp");
    }
}