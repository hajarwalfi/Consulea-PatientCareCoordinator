package com.consulea.servlet;

import com.consulea.entity.*;
import com.consulea.enums.ConsultationStatus;
import com.consulea.service.DoctorService;
import com.consulea.enums.Specialty;
import com.consulea.enums.Priority;
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
            String consultationId = pathInfo.substring("/view-consultation/".length());
            response.sendRedirect(request.getContextPath() + "/doctor/create-consultation?consultationId=" + consultationId);
        } else if (pathInfo.equals("/waiting-patients")) {
            showWaitingPatients(request, response);
        } else if (pathInfo.equals("/my-consultations")) {
            showMyConsultations(request, response);
        } else if (pathInfo.equals("/consultations-in-progress")) {
            showConsultationsInProgress(request, response);
        } else if (pathInfo.equals("/consultations-waiting-specialist")) {
            showConsultationsWaitingSpecialist(request, response);
        } else if (pathInfo.equals("/consultations-completed")) {
            showConsultationsCompleted(request, response);
        } else if (pathInfo.equals("/request-expertise")) {
            showRequestExpertiseForm(request, response);
        } else if (pathInfo.equals("/search-specialists")) {
            searchSpecialists(request, response);
        } else if (pathInfo.equals("/api/specialists")) {
            getSpecialistsApi(request, response);
        } else if (pathInfo.equals("/api/time-slots")) {
            getTimeSlotsApi(request, response);
        } else if (pathInfo.startsWith("/specialist-slots/")) {
            showSpecialistTimeSlots(request, response);
        } else if (pathInfo.equals("/my-expertise-requests")) {
            showMyExpertiseRequests(request, response);
        } else if (pathInfo.equals("/debug-create-slots")) {
            debugCreateSlots(request, response);
        } else if (pathInfo.equals("/debug-specialist-slots")) {
            debugSpecialistSlots(request, response);
        } else if (pathInfo.equals("/debug-expertise-status")) {
            debugExpertiseStatus(request, response);
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
        } else if (pathInfo != null && pathInfo.equals("/create-expertise-request")) {
            createExpertiseRequest(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }

    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User doctor = (User) request.getSession().getAttribute("user");

        List<Patient> waitingPatients = doctorService.getWaitingPatients();
        
        List<Consultation> inProgressConsultations = doctorService.getDoctorConsultationsInProgress(doctor);
        List<Consultation> waitingForSpecialist = doctorService.getDoctorConsultationsWaitingForSpecialist(doctor);
        List<Consultation> completedConsultations = doctorService.getDoctorCompletedConsultations(doctor);


        List<ExpertiseRequest> completedExpertiseRequests = doctorService.getDoctorCompletedExpertiseRequests(doctor);
        List<ExpertiseRequest> pendingExpertiseRequests = doctorService.getDoctorPendingExpertiseRequests(doctor);

        request.setAttribute("waitingPatients", waitingPatients);
        request.setAttribute("inProgressConsultations", inProgressConsultations);
        request.setAttribute("waitingForSpecialist", waitingForSpecialist);
        request.setAttribute("completedConsultations", completedConsultations);
        request.setAttribute("completedExpertiseRequests", completedExpertiseRequests);
        request.setAttribute("pendingExpertiseRequests", pendingExpertiseRequests);

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
        String consultationIdStr = request.getParameter("consultationId");


        if (consultationIdStr != null && !consultationIdStr.isEmpty()) {
            try {
                Long consultationId = Long.parseLong(consultationIdStr);
                Optional<Consultation> consultationOpt = doctorService.getConsultationById(consultationId);

                if (consultationOpt.isPresent()) {
                    Consultation consultation = consultationOpt.get();
                    Patient patient = consultation.getPatient();
                    List<VitalSigns> vitalSignsList = doctorService.getPatientVitalSigns(patient.getId());
                    List<ConsultationMedicalAct> consultationMedicalActs = doctorService.getConsultationMedicalActs(consultationId);
                    

                    Optional<ExpertiseRequest> expertiseRequestOpt = doctorService.getExpertiseRequestsByConsultation(consultationId);
                    List<ExpertiseRequest> expertiseRequests = expertiseRequestOpt.map(List::of).orElse(List.of());

                    request.setAttribute("consultation", consultation);
                    request.setAttribute("patient", patient);
                    request.setAttribute("vitalSignsList", vitalSignsList);
                    request.setAttribute("consultationMedicalActs", consultationMedicalActs);
                    request.setAttribute("expertiseRequests", expertiseRequests);
                    request.setAttribute("mode", "edit");
                } else {
                    request.setAttribute("error", "Consultation non trouvée");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID consultation invalide");
            } catch (Exception e) {
                request.setAttribute("error", "Erreur lors du chargement de la consultation: " + e.getMessage());
            }
        }

        else if (patientIdStr != null && !patientIdStr.isEmpty()) {
            try {
                Long patientId = Long.parseLong(patientIdStr);
                Optional<Patient> patientOpt = doctorService.getPatientById(patientId);

                if (patientOpt.isPresent()) {
                    Patient patient = patientOpt.get();
                    List<VitalSigns> vitalSignsList = doctorService.getPatientVitalSigns(patientId);

                    request.setAttribute("patient", patient);
                    request.setAttribute("vitalSignsList", vitalSignsList);
                    request.setAttribute("mode", "create");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID patient invalide");
            }
        }


        List<MedicalAct> availableMedicalActs = doctorService.getAllMedicalActs();
        request.setAttribute("availableMedicalActs", availableMedicalActs);

        request.getRequestDispatcher("/WEB-INF/views/doctor/create-consultation.jsp").forward(request, response);
    }

    private void createConsultation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String consultationIdStr = request.getParameter("consultationId");
            Long patientId = Long.parseLong(request.getParameter("patientId"));
            String chiefComplaint = request.getParameter("chiefComplaint");
            String symptoms = request.getParameter("symptoms");
            String clinicalExamination = request.getParameter("clinicalExamination");
            String selectedMedicalActsJson = request.getParameter("selectedMedicalActs");
            String decision = request.getParameter("decision");
            String diagnosis = request.getParameter("diagnosis");
            String prescription = request.getParameter("prescription");

            Optional<Patient> patientOpt = doctorService.getPatientById(patientId);

            if (patientOpt.isEmpty()) {
                request.setAttribute("error", "Patient non trouvé");
                showCreateConsultationForm(request, response);
                return;
            }

            User doctor = (User) request.getSession().getAttribute("user");
            Consultation consultation;


            if (consultationIdStr != null && !consultationIdStr.trim().isEmpty()) {

                Long consultationId = Long.parseLong(consultationIdStr);
                Optional<Consultation> existingConsultationOpt = doctorService.getConsultationById(consultationId);
                
                if (existingConsultationOpt.isEmpty()) {
                    request.setAttribute("error", "Consultation non trouvée");
                    showCreateConsultationForm(request, response);
                    return;
                }
                
                consultation = existingConsultationOpt.get();
                

                if (!consultation.getDoctor().getId().equals(doctor.getId())) {
                    request.setAttribute("error", "Accès non autorisé à cette consultation");
                    showCreateConsultationForm(request, response);
                    return;
                }
                

                consultation.setChiefComplaint(chiefComplaint);
                consultation.setSymptoms(symptoms);
                consultation.setClinicalExamination(clinicalExamination);
                
            } else {

                consultation = doctorService.createConsultation(
                        patientOpt.get(), doctor, chiefComplaint, symptoms, clinicalExamination
                );
            }


            if (selectedMedicalActsJson != null && !selectedMedicalActsJson.trim().isEmpty()) {
                try {

                    selectedMedicalActsJson = selectedMedicalActsJson.trim();
                    if (selectedMedicalActsJson.startsWith("[") && selectedMedicalActsJson.endsWith("]")) {
                        selectedMedicalActsJson = selectedMedicalActsJson.substring(1, selectedMedicalActsJson.length() - 1);
                        if (!selectedMedicalActsJson.isEmpty()) {
                            String[] actIds = selectedMedicalActsJson.split(",");
                            for (String actIdStr : actIds) {
                                Long actId = Long.parseLong(actIdStr.trim());
                                doctorService.addMedicalActToConsultation(consultation.getId(), actId);
                            }
                        }
                    }
                } catch (Exception e) {
                    // Silently ignore parsing errors
                }
            }


            if ("complete".equals(decision)) {

                if (diagnosis != null && !diagnosis.trim().isEmpty()) {
                    consultation.setDiagnosis(diagnosis.trim());
                }
                if (prescription != null && !prescription.trim().isEmpty()) {
                    consultation.setTreatment(prescription.trim());
                }
                consultation.setStatus(ConsultationStatus.COMPLETED);
                doctorService.updateConsultation(consultation);
                
                request.getSession().setAttribute("success",
                        "Consultation terminée avec succès pour " + patientOpt.get().getFullName());
                response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
                
            } else if ("specialist".equals(decision)) {

                response.sendRedirect(request.getContextPath() + "/doctor/request-expertise?consultationId=" + consultation.getId());
                
            } else {


                if (consultationIdStr != null && !consultationIdStr.trim().isEmpty()) {
                    doctorService.updateConsultation(consultation);
                }
                
                request.getSession().setAttribute("success",
                        "Consultation enregistrée pour " + patientOpt.get().getFullName() + ". Vous pouvez continuer plus tard.");
                response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
            }

        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors de la création de la consultation: " + e.getMessage());
            showCreateConsultationForm(request, response);
        }
    }


    private void completeConsultation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Long consultationId = Long.parseLong(request.getParameter("consultationId"));
            String diagnosis = request.getParameter("diagnosis");
            String treatment = request.getParameter("treatment");
            String selectedMedicalActsJson = request.getParameter("selectedMedicalActs");



            if (selectedMedicalActsJson != null && !selectedMedicalActsJson.trim().isEmpty()) {
                try {
                    selectedMedicalActsJson = selectedMedicalActsJson.trim();
                    if (selectedMedicalActsJson.startsWith("[") && selectedMedicalActsJson.endsWith("]")) {
                        selectedMedicalActsJson = selectedMedicalActsJson.substring(1, selectedMedicalActsJson.length() - 1);
                        if (!selectedMedicalActsJson.isEmpty()) {
                            String[] actIds = selectedMedicalActsJson.split(",");
                            for (String actIdStr : actIds) {
                                Long actId = Long.parseLong(actIdStr.trim());
                                doctorService.addMedicalActToConsultation(consultationId, actId);
                            }
                        }
                    }
                } catch (Exception e) {
                    // Silently ignore medical acts errors
                }
            }

            Consultation consultation = doctorService.completeConsultation(consultationId, diagnosis, treatment);

            request.getSession().setAttribute("success", "Consultation clôturée avec succès");
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard");

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
            response.sendRedirect(request.getContextPath() + "/doctor/create-consultation?consultationId=" + consultationId);

        } catch (Exception e) {
            request.setAttribute("error", "Erreur: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
        }
    }

    private void showMyConsultations(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User doctor = (User) request.getSession().getAttribute("user");
        
        List<Consultation> myConsultations = doctorService.getDoctorConsultations(doctor);
        

        long inProgressCount = myConsultations.stream()
                .filter(c -> c.getStatus().toString().equals("IN_PROGRESS"))
                .count();
        long completedCount = myConsultations.stream()
                .filter(c -> c.getStatus().toString().equals("COMPLETED"))
                .count();
        long waitingSpecialistCount = myConsultations.stream()
                .filter(c -> c.getStatus().toString().equals("WAITING_FOR_SPECIALIST_OPINION"))
                .count();

        request.setAttribute("myConsultations", myConsultations);
        request.setAttribute("inProgressCount", inProgressCount);
        request.setAttribute("completedCount", completedCount);
        request.setAttribute("waitingSpecialistCount", waitingSpecialistCount);

        request.getRequestDispatcher("/WEB-INF/views/doctor/my-consultations.jsp").forward(request, response);
    }

    private void showConsultationsInProgress(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User doctor = (User) request.getSession().getAttribute("user");
        List<Consultation> inProgressConsultations = doctorService.getDoctorConsultationsInProgress(doctor);
        
        request.setAttribute("inProgressConsultations", inProgressConsultations);
        request.getRequestDispatcher("/WEB-INF/views/doctor/consultations-in-progress.jsp").forward(request, response);
    }

    private void showConsultationsWaitingSpecialist(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User doctor = (User) request.getSession().getAttribute("user");
        List<Consultation> waitingForSpecialist = doctorService.getDoctorConsultationsWaitingForSpecialist(doctor);
        
        request.setAttribute("waitingForSpecialist", waitingForSpecialist);
        request.getRequestDispatcher("/WEB-INF/views/doctor/consultations-waiting-specialist.jsp").forward(request, response);
    }

    private void showConsultationsCompleted(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User doctor = (User) request.getSession().getAttribute("user");
        List<Consultation> completedConsultations = doctorService.getDoctorCompletedConsultations(doctor);
        
        request.setAttribute("completedConsultations", completedConsultations);
        request.getRequestDispatcher("/WEB-INF/views/doctor/consultations-completed.jsp").forward(request, response);
    }

    private void showRequestExpertiseForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String consultationIdStr = request.getParameter("consultationId");
        
        if (consultationIdStr == null || consultationIdStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de consultation requis");
            return;
        }

        try {
            Long consultationId = Long.parseLong(consultationIdStr);
            Optional<Consultation> consultationOpt = doctorService.getConsultationById(consultationId);

            if (consultationOpt.isPresent()) {
                Consultation consultation = consultationOpt.get();
                

                User doctor = (User) request.getSession().getAttribute("user");
                if (!consultation.getDoctor().getId().equals(doctor.getId())) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }

                request.setAttribute("consultation", consultation);
                request.setAttribute("specialties", Specialty.values());
                request.setAttribute("priorities", Priority.values());
                request.getRequestDispatcher("/WEB-INF/views/doctor/request-expertise.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Consultation non trouvée");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de consultation invalide");
        }
    }

    private void searchSpecialists(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String specialtyStr = request.getParameter("specialty");
        String consultationIdStr = request.getParameter("consultationId");

        if (specialtyStr == null || specialtyStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Spécialité requise");
            return;
        }

        try {
            Specialty specialty = Specialty.valueOf(specialtyStr);
            List<Specialist> specialists = doctorService.findSpecialistsBySpecialty(specialty);

            request.setAttribute("specialists", specialists);
            request.setAttribute("selectedSpecialty", specialty);
            request.setAttribute("consultationId", consultationIdStr);
            request.getRequestDispatcher("/WEB-INF/views/doctor/specialists-list.jsp").forward(request, response);
        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Spécialité invalide");
        }
    }

    private void getSpecialistsApi(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String specialtyStr = request.getParameter("specialty");
        
        if (specialtyStr == null || specialtyStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Spécialité requise");
            return;
        }

        try {
            Specialty specialty = Specialty.valueOf(specialtyStr);
            List<Specialist> specialists = doctorService.findSpecialistsBySpecialty(specialty);


            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            StringBuilder jsonBuilder = new StringBuilder();
            jsonBuilder.append("[");
            
            for (int i = 0; i < specialists.size(); i++) {
                Specialist specialist = specialists.get(i);
                if (i > 0) jsonBuilder.append(",");
                
                jsonBuilder.append("{")
                    .append("\"id\":").append(specialist.getId()).append(",")
                    .append("\"name\":\"").append(escapeJson(specialist.getDisplayName())).append("\",")
                    .append("\"specialty\":\"").append(escapeJson(specialist.getSpecialty().getDisplayName())).append("\",")
                    .append("\"fee\":").append(specialist.getConsultationFee()).append(",")
                    .append("\"email\":\"").append(escapeJson(specialist.getUser().getEmail())).append("\",")
                    .append("\"available\":true")
                    .append("}");
            }
            
            jsonBuilder.append("]");
            
            response.getWriter().write(jsonBuilder.toString());
            
        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Spécialité invalide");
        }
    }
    
    private void getTimeSlotsApi(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String specialistIdStr = request.getParameter("specialistId");
        
        if (specialistIdStr == null || specialistIdStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID spécialiste requis");
            return;
        }

        try {
            Long specialistId = Long.parseLong(specialistIdStr);
            Optional<Specialist> specialistOpt = doctorService.getSpecialistById(specialistId);
            
            if (specialistOpt.isEmpty()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Spécialiste non trouvé");
                return;
            }
            
            Specialist specialist = specialistOpt.get();
            

            doctorService.createTimeSlotsForSpecialist(specialistId);
            
            List<TimeSlot> availableSlots = doctorService.getAvailableTimeSlots(specialist);


            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            StringBuilder jsonBuilder = new StringBuilder();
            jsonBuilder.append("[");
            
            for (int i = 0; i < availableSlots.size(); i++) {
                TimeSlot slot = availableSlots.get(i);
                if (i > 0) jsonBuilder.append(",");
                
                jsonBuilder.append("{")
                    .append("\"id\":").append(slot.getId()).append(",")
                    .append("\"timeRange\":\"").append(escapeJson(slot.getTimeSlotDisplay())).append("\",")
                    .append("\"isAvailable\":").append(slot.getIsAvailable()).append(",")
                    .append("\"isBooked\":").append(slot.isBooked())
                    .append("}");
            }
            
            jsonBuilder.append("]");
            
            response.getWriter().write(jsonBuilder.toString());
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID spécialiste invalide");
        }
    }
    
    private String escapeJson(String value) {
        if (value == null) return "";
        return value.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r")
                   .replace("\t", "\\t");
    }

    private void showSpecialistTimeSlots(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        String specialistIdStr = pathInfo.substring(pathInfo.lastIndexOf('/') + 1);
        String consultationIdStr = request.getParameter("consultationId");


        try {
            Long specialistId = Long.parseLong(specialistIdStr);
            Optional<Specialist> specialistOpt = doctorService.getSpecialistById(specialistId);

            if (specialistOpt.isPresent()) {
                Specialist specialist = specialistOpt.get();
                List<TimeSlot> availableSlots = doctorService.getAvailableTimeSlots(specialist);

                request.setAttribute("specialist", specialist);
                request.setAttribute("availableSlots", availableSlots);
                request.setAttribute("consultationId", consultationIdStr);
                request.setAttribute("priorities", Priority.values());
                request.getRequestDispatcher("/WEB-INF/views/doctor/specialist-time-slots.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Spécialiste non trouvé");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID spécialiste invalide");
        }
    }

    private void showMyExpertiseRequests(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User doctor = (User) request.getSession().getAttribute("user");
        List<ExpertiseRequest> expertiseRequests = doctorService.getDoctorCompletedExpertiseRequests(doctor);

        request.setAttribute("expertiseRequests", expertiseRequests);
        request.getRequestDispatcher("/WEB-INF/views/doctor/my-expertise-requests.jsp").forward(request, response);
    }

    private void createExpertiseRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            User requestingDoctor = (User) request.getSession().getAttribute("user");
            Long consultationId = Long.parseLong(request.getParameter("consultationId"));
            Long specialistId = Long.parseLong(request.getParameter("specialistId"));
            Long timeSlotId = Long.parseLong(request.getParameter("timeSlotId"));
            String question = request.getParameter("question");
            String clinicalData = request.getParameter("clinicalData");
            Priority priority = Priority.valueOf(request.getParameter("priority"));

            if (question == null || question.trim().isEmpty()) {
                request.setAttribute("error", "La question est obligatoire");
                showSpecialistTimeSlots(request, response);
                return;
            }

            ExpertiseRequest expertiseRequest = doctorService.createExpertiseRequest(
                consultationId, requestingDoctor, specialistId, timeSlotId, 
                question.trim(), clinicalData != null ? clinicalData.trim() : null, priority);

            request.getSession().setAttribute("success", 
                "Demande d'expertise créée avec succès. Le spécialiste a été notifié.");
            response.sendRedirect(request.getContextPath() + "/doctor/create-consultation?consultationId=" + consultationId);

        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors de la création de la demande: " + e.getMessage());
            showSpecialistTimeSlots(request, response);
        }
    }

    private void debugCreateSlots(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String specialistIdStr = request.getParameter("specialistId");
            if (specialistIdStr != null) {
                Long specialistId = Long.parseLong(specialistIdStr);
                doctorService.createTimeSlotsForSpecialist(specialistId);
                response.getWriter().write("Créneaux créés pour le spécialiste " + specialistId);
            } else {
                response.getWriter().write("Paramètre specialistId requis");
            }
        } catch (Exception e) {
            response.getWriter().write("Erreur: " + e.getMessage());
        }
    }

    private void debugSpecialistSlots(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html; charset=UTF-8");
        try {
            String specialistIdStr = request.getParameter("specialistId");
            if (specialistIdStr != null) {
                Long specialistId = Long.parseLong(specialistIdStr);
                Optional<Specialist> specialistOpt = doctorService.getSpecialistById(specialistId);
                
                response.getWriter().write("<html><body>");
                response.getWriter().write("<h1>Debug - Créneaux du Spécialiste</h1>");
                
                if (specialistOpt.isPresent()) {
                    Specialist specialist = specialistOpt.get();
                    response.getWriter().write("<h2>Spécialiste trouvé:</h2>");
                    response.getWriter().write("<p>ID: " + specialist.getId() + "</p>");
                    response.getWriter().write("<p>Nom: " + specialist.getDisplayName() + "</p>");
                    response.getWriter().write("<p>Spécialité: " + specialist.getSpecialty() + "</p>");
                    
                    List<TimeSlot> allSlots = doctorService.getAllTimeSlots(specialist);
                    response.getWriter().write("<h2>Tous les créneaux (" + allSlots.size() + "):</h2>");
                    for (TimeSlot slot : allSlots) {
                        response.getWriter().write("<p>ID=" + slot.getId() + 
                                                 ", Temps=" + slot.getTimeSlotDisplay() + 
                                                 ", Disponible=" + slot.getIsAvailable() + 
                                                 ", Réservé=" + (slot.getExpertiseRequest() != null) + "</p>");
                    }
                    
                    List<TimeSlot> availableSlots = doctorService.getAvailableTimeSlots(specialist);
                    response.getWriter().write("<h2>Créneaux disponibles (" + availableSlots.size() + "):</h2>");
                    for (TimeSlot slot : availableSlots) {
                        response.getWriter().write("<p>ID=" + slot.getId() + 
                                                 ", Temps=" + slot.getTimeSlotDisplay() + "</p>");
                    }
                } else {
                    response.getWriter().write("<p>Spécialiste non trouvé avec ID " + specialistId + "</p>");
                }
                
                response.getWriter().write("</body></html>");
            } else {
                response.getWriter().write("Paramètre specialistId requis");
            }
        } catch (Exception e) {
            response.getWriter().write("Erreur: " + e.getMessage());
        }
    }

    private void debugExpertiseStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html; charset=UTF-8");
        try {
            String consultationIdStr = request.getParameter("consultationId");
            if (consultationIdStr != null) {
                Long consultationId = Long.parseLong(consultationIdStr);
                Optional<ExpertiseRequest> expertiseOpt = doctorService.getExpertiseRequestByConsultation(consultationId);
                
                response.getWriter().write("<html><body>");
                response.getWriter().write("<h1>Debug - Statut Expertise</h1>");
                
                if (expertiseOpt.isPresent()) {
                    ExpertiseRequest expertise = expertiseOpt.get();
                    response.getWriter().write("<h2>Expertise trouvée:</h2>");
                    response.getWriter().write("<p>ID: " + expertise.getId() + "</p>");
                    response.getWriter().write("<p>Statut actuel: " + expertise.getStatus() + "</p>");
                    response.getWriter().write("<p>Status Display: " + expertise.getStatusDisplay() + "</p>");
                    response.getWriter().write("<p>Réponse spécialiste: " + (expertise.getSpecialistResponse() != null ? "OUI" : "NON") + "</p>");
                    response.getWriter().write("<p>Recommandations: " + (expertise.getRecommendations() != null ? "OUI" : "NON") + "</p>");
                    response.getWriter().write("<p>Date completion: " + expertise.getCompletedAt() + "</p>");
                } else {
                    response.getWriter().write("<p>Aucune expertise trouvée pour la consultation " + consultationId + "</p>");
                }
                
                response.getWriter().write("</body></html>");
            } else {
                response.getWriter().write("Paramètre consultationId requis");
            }
        } catch (Exception e) {
            response.getWriter().write("Erreur: " + e.getMessage());
        }
    }
}