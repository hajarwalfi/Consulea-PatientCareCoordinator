package com.consulea.servlet;

import com.consulea.entity.User;
import com.consulea.service.AuthenticationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private AuthenticationService authService;

    @Override
    public void init() throws ServletException {
        authService = new AuthenticationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            redirectToDashboard(user, request, response);
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            Optional<User> userOpt = authService.login(email, password);

            if (userOpt.isPresent()) {
                User user = userOpt.get();

                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("userId", user.getId());
                session.setAttribute("userName", user.getFullName());
                session.setAttribute("userRole", user.getRole().toString());

                redirectToDashboard(user, request, response);
            } else {
                request.setAttribute("error", "Email ou mot de passe incorrect");
                request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors de la connexion: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        }
    }

    private void redirectToDashboard(User user, HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        switch (user.getRole()) {
            case INFIRMIER:
                response.sendRedirect(request.getContextPath() + "/nurse/dashboard");
                break;
            case MEDECIN_GENERALISTE:
                response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
                break;
            case MEDECIN_SPECIALISTE:
                response.sendRedirect(request.getContextPath() + "/specialist/dashboard");
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/login");
                break;
        }
    }
}