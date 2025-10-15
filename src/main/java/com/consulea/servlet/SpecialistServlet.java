package com.consulea.servlet;

import com.consulea.entity.ExpertiseRequest;
import com.consulea.entity.Specialist;
import com.consulea.entity.TimeSlot;
import com.consulea.entity.User;
import com.consulea.enums.ExpertiseStatus;
import com.consulea.enums.Priority;
import com.consulea.enums.Specialty;
import com.consulea.service.SpecialistService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@WebServlet(name = "SpecialistServlet", urlPatterns = {"/specialist/*"})
public class SpecialistServlet extends HttpServlet {

    private SpecialistService specialistService;

    @Override
    public void init() throws ServletException {
        specialistService = new SpecialistService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/dashboard")) {
            showDashboard(request, response);
        } else if (pathInfo.equals("/profile")) {
            showProfile(request, response);
        } else if (pathInfo.equals("/expertise-requests")) {
            showExpertiseRequests(request, response);
        } else if (pathInfo.startsWith("/expertise-request/")) {
            viewExpertiseRequest(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String pathInfo = request.getPathInfo();

        if (pathInfo != null && pathInfo.equals("/update-profile")) {
            updateProfile(request, response);
        } else if (pathInfo != null && pathInfo.equals("/respond-expertise")) {
            respondToExpertise(request, response);
        } else if (pathInfo != null && pathInfo.equals("/update-time-slots")) {
            updateTimeSlots(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        Optional<Specialist> specialistOpt = specialistService.getSpecialistByUser(user);

        if (specialistOpt.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/specialist/profile");
            return;
        }

        Specialist specialist = specialistOpt.get();
        
        List<ExpertiseRequest> pendingRequests = specialistService.getPendingExpertiseRequests(specialist);
        List<ExpertiseRequest> completedRequests = specialistService.getExpertiseRequestsByStatus(specialist, ExpertiseStatus.TERMINEE);
        
        List<TimeSlot> availableSlots = specialistService.getAvailableTimeSlots(specialist);
        List<TimeSlot> bookedSlots = specialistService.getBookedTimeSlots(specialist);

        Map<String, Object> statistics = specialistService.getSpecialistStatistics(specialist);

        request.setAttribute("specialist", specialist);
        request.setAttribute("pendingRequests", pendingRequests);
        request.setAttribute("completedRequests", completedRequests);
        request.setAttribute("availableSlots", availableSlots);
        request.setAttribute("bookedSlots", bookedSlots);
        request.setAttribute("statistics", statistics);

        request.getRequestDispatcher("/WEB-INF/views/specialist/dashboard.jsp").forward(request, response);
    }

    private void showProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        Optional<Specialist> specialistOpt = specialistService.getSpecialistByUser(user);

        if (specialistOpt.isPresent()) {
            request.setAttribute("specialist", specialistOpt.get());
        }

        request.setAttribute("specialties", Specialty.values());

        request.getRequestDispatcher("/WEB-INF/views/specialist/profile.jsp").forward(request, response);
    }

    private void showExpertiseRequests(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        Optional<Specialist> specialistOpt = specialistService.getSpecialistByUser(user);

        if (specialistOpt.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/specialist/profile");
            return;
        }

        Specialist specialist = specialistOpt.get();
        
        String statusParam = request.getParameter("status");
        String priorityParam = request.getParameter("priority");
        
        ExpertiseStatus statusFilter = null;
        Priority priorityFilter = null;
        
        try {
            if (statusParam != null && !statusParam.isEmpty()) {
                statusFilter = ExpertiseStatus.valueOf(statusParam);
            }
            if (priorityParam != null && !priorityParam.isEmpty()) {
                priorityFilter = Priority.valueOf(priorityParam);
            }
        } catch (IllegalArgumentException e) {
        }

        List<ExpertiseRequest> expertiseRequests;
        if (statusFilter != null || priorityFilter != null) {
            expertiseRequests = specialistService.filterExpertisesByStatusAndPriority(specialist, statusFilter, priorityFilter);
        } else {
            expertiseRequests = specialistService.getSpecialistExpertiseRequests(specialist);
        }

        request.setAttribute("specialist", specialist);
        request.setAttribute("expertiseRequests", expertiseRequests);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("priorityFilter", priorityFilter);
        request.setAttribute("expertiseStatuses", ExpertiseStatus.values());
        request.setAttribute("priorities", Priority.values());

        request.getRequestDispatcher("/WEB-INF/views/specialist/expertise-requests.jsp").forward(request, response);
    }

    private void viewExpertiseRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        String requestIdStr = pathInfo.substring(pathInfo.lastIndexOf('/') + 1);

        try {
            Long requestId = Long.parseLong(requestIdStr);
            Optional<ExpertiseRequest> expertiseOpt = specialistService.getExpertiseRequestById(requestId);

            if (expertiseOpt.isPresent()) {
                ExpertiseRequest expertiseRequest = expertiseOpt.get();
                
                User user = (User) request.getSession().getAttribute("user");
                Optional<Specialist> specialistOpt = specialistService.getSpecialistByUser(user);
                
                if (specialistOpt.isPresent() && 
                    expertiseRequest.getSpecialist().getId().equals(specialistOpt.get().getId())) {
                    
                    request.setAttribute("expertiseRequest", expertiseRequest);
                    request.getRequestDispatcher("/WEB-INF/views/specialist/view-expertise-request.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN);
                }
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Demande d'expertise non trouvée");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de demande invalide");
        }
    }



    private void updateProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            User user = (User) request.getSession().getAttribute("user");
            String specialtyStr = request.getParameter("specialty");
            String consultationFeeStr = request.getParameter("consultationFee");

            Specialty specialty = Specialty.valueOf(specialtyStr);
            Double consultationFee = Double.parseDouble(consultationFeeStr);

            if (consultationFee < 0) {
                request.setAttribute("error", "Le tarif ne peut pas être négatif");
                showProfile(request, response);
                return;
            }

            specialistService.createOrUpdateSpecialistProfile(user, specialty, consultationFee);

            request.getSession().setAttribute("success", "Profil mis à jour avec succès");
            response.sendRedirect(request.getContextPath() + "/specialist/dashboard");

        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors de la mise à jour du profil: " + e.getMessage());
            showProfile(request, response);
        }
    }

    private void respondToExpertise(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Long requestId = Long.parseLong(request.getParameter("requestId"));
            String specialistResponse = request.getParameter("specialistResponse");
            String recommendations = request.getParameter("recommendations");

            if (specialistResponse == null || specialistResponse.trim().isEmpty()) {
                request.setAttribute("error", "La réponse du spécialiste est obligatoire");
                viewExpertiseRequest(request, response);
                return;
            }

            ExpertiseRequest updatedRequest = specialistService.respondToExpertise(requestId, 
                    specialistResponse.trim(), recommendations != null ? recommendations.trim() : null);

            request.getSession().setAttribute("success", "Réponse envoyée avec succès");
            response.sendRedirect(request.getContextPath() + "/specialist/expertise-request/" + updatedRequest.getId());

        } catch (Exception e) {
            request.setAttribute("error", "Erreur: " + e.getMessage());
            viewExpertiseRequest(request, response);
        }
    }

    private void updateTimeSlots(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            User user = (User) request.getSession().getAttribute("user");
            Optional<Specialist> specialistOpt = specialistService.getSpecialistByUser(user);

            if (specialistOpt.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/specialist/profile");
                return;
            }

            Specialist specialist = specialistOpt.get();

            String slotDate = request.getParameter("slotDate");
            String startTime = request.getParameter("startTime");
            String endTime = request.getParameter("endTime");

            if (slotDate == null || slotDate.trim().isEmpty()) {
                request.setAttribute("error", "Veuillez sélectionner une date");
                showProfile(request, response);
                return;
            }

            if (startTime == null || endTime == null || startTime.isEmpty() || endTime.isEmpty()) {
                request.setAttribute("error", "Veuillez renseigner les heures de début et de fin");
                showProfile(request, response);
                return;
            }

            specialistService.updateTimeSlots(specialist, slotDate, startTime, endTime);

            request.getSession().setAttribute("success", "Créneaux horaires mis à jour avec succès");
            response.sendRedirect(request.getContextPath() + "/specialist/profile");

        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors de la mise à jour des créneaux: " + e.getMessage());
            showProfile(request, response);
        }
    }
}