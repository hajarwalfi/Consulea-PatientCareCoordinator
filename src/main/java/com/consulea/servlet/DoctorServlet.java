package com.consulea.servlet;

import com.consulea.entity.*;
import com.consulea.service.DoctorService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "DoctorServlet", urlPatterns = {"/doctor/*"})
public class DoctorServlet extends HttpServlet {

    private DoctorService doctorService;

    @Override
    public void init() throws ServletException {
        doctorService = new DoctorService();
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
        } else if (pathInfo.equals("/create-consultation")) {
            showCreateConsultationForm(request, response);
        } else if (pathInfo.startsWith("/view-consultation/")) {
            viewConsultation(request, response);
        } else if (pathInfo.equals("/waiting-patients")) {
            showWaitingPatients(request, response);
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

        if (pathInfo != null && pathInfo.equals("/create-consultation")) {
            createConsultation(request, response);
        } else if (pathInfo != null && pathInfo.equals("/complete-consultation")) {
            completeConsultation(request, response);
        } else if (pathInfo != null && pathInfo.equals("/request-specialist")) {
            requestSpecialist(request, response);
        }else if (pathInfo != null && pathInfo.equals("/add-medical-act")) {
            addMedicalAct(request, response);
        }
        else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }

    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User doctor = (User) request.getSession().getAttribute("user");

        List<Consultation> inProgressConsultations = doctorService.getConsultationsInProgress();
        List<Consultation> waitingForSpecialist = doctorService.getConsultationsWaitingForSpecialist();
        List<Consultation> myConsultations = doctorService.getDoctorConsultations(doctor);

        request.setAttribute("inProgressConsultations", inProgressConsultations);
        request.setAttribute("waitingForSpecialist", waitingForSpecialist);
        request.setAttribute("myConsultations", myConsultations);

        request.getRequestDispatcher("/WEB-INF/views/doctor/dashboard.jsp").forward(request, response);
    }

    private void showWaitingPatients(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Patient> waitingPatients = doctorService.getWaitingPatients();
        request.setAttribute("waitingPatients", waitingPatients);
        request.getRequestDispatcher("/WEB-INF/views/doctor/waiting-patients.jsp").forward(request, response);
    }

    private void showCreateConsultationForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String patientIdStr = request.getParameter("patientId");

        if (patientIdStr != null && !patientIdStr.isEmpty()) {
            try {
                Long patientId = Long.parseLong(patientIdStr);
                Optional<Patient> patientOpt = doctorService.getPatientById(patientId);

                if (patientOpt.isPresent()) {
                    Patient patient = patientOpt.get();
                    List<VitalSigns> vitalSignsList = doctorService.getPatientVitalSigns(patientId);

                    request.setAttribute("patient", patient);
                    request.setAttribute("vitalSignsList", vitalSignsList);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID patient invalide");
            }
        }

        request.getRequestDispatcher("/WEB-INF/views/doctor/create-consultation.jsp").forward(request, response);
    }

    private void createConsultation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Long patientId = Long.parseLong(request.getParameter("patientId"));
            String chiefComplaint = request.getParameter("chiefComplaint");
            String symptoms = request.getParameter("symptoms");
            String clinicalExamination = request.getParameter("clinicalExamination");

            Optional<Patient> patientOpt = doctorService.getPatientById(patientId);

            if (patientOpt.isEmpty()) {
                request.setAttribute("error", "Patient non trouvé");
                request.getRequestDispatcher("/WEB-INF/views/doctor/create-consultation.jsp").forward(request, response);
                return;
            }

            User doctor = (User) request.getSession().getAttribute("user");

            Consultation consultation = doctorService.createConsultation(
                    patientOpt.get(), doctor, chiefComplaint, symptoms, clinicalExamination
            );

            request.getSession().setAttribute("success",
                    "Consultation créée avec succès pour " + patientOpt.get().getFullName());
            response.sendRedirect(request.getContextPath() + "/doctor/view-consultation/" + consultation.getId());

        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors de la création de la consultation: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/doctor/create-consultation.jsp").forward(request, response);
        }
    }

    private void viewConsultation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        String consultationIdStr = pathInfo.substring(pathInfo.lastIndexOf('/') + 1);

        try {
            Long consultationId = Long.parseLong(consultationIdStr);
            Optional<Consultation> consultationOpt = doctorService.getConsultationById(consultationId);

            if (consultationOpt.isPresent()) {
                Consultation consultation = consultationOpt.get();
                List<VitalSigns> vitalSignsList = doctorService.getPatientVitalSigns(consultation.getPatient().getId());

                request.setAttribute("consultation", consultation);
                request.setAttribute("vitalSignsList", vitalSignsList);
                List<MedicalAct> availableMedicalActs = doctorService.getAllMedicalActs();
                List<ConsultationMedicalAct> consultationMedicalActs = doctorService.getConsultationMedicalActs(consultationId);

                request.setAttribute("availableMedicalActs", availableMedicalActs);
                request.setAttribute("consultationMedicalActs", consultationMedicalActs);
                request.getRequestDispatcher("/WEB-INF/views/doctor/view-consultation.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Consultation non trouvée");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID consultation invalide");
        }
    }

    private void completeConsultation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Long consultationId = Long.parseLong(request.getParameter("consultationId"));
            String diagnosis = request.getParameter("diagnosis");
            String treatment = request.getParameter("treatment");

            Consultation consultation = doctorService.completeConsultation(consultationId, diagnosis, treatment);

            request.getSession().setAttribute("success", "Consultation clôturée avec succès");
            response.sendRedirect(request.getContextPath() + "/doctor/view-consultation/" + consultation.getId());

        } catch (Exception e) {
            request.setAttribute("error", "Erreur: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
        }
    }

    private void requestSpecialist(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Long consultationId = Long.parseLong(request.getParameter("consultationId"));

            Consultation consultation = doctorService.requestSpecialistOpinion(consultationId);

            request.getSession().setAttribute("success",
                    "Demande d'avis spécialiste envoyée avec succès");
            response.sendRedirect(request.getContextPath() + "/doctor/view-consultation/" + consultation.getId());

        } catch (Exception e) {
            request.setAttribute("error", "Erreur: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
        }
    }

    private void addMedicalAct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Long consultationId = Long.parseLong(request.getParameter("consultationId"));
            Long medicalActId = Long.parseLong(request.getParameter("medicalActId"));

            doctorService.addMedicalActToConsultation(consultationId, medicalActId);

            request.getSession().setAttribute("success", "Acte médical ajouté avec succès");
            response.sendRedirect(request.getContextPath() + "/doctor/view-consultation/" + consultationId);

        } catch (Exception e) {
            request.setAttribute("error", "Erreur: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
        }
    }
}