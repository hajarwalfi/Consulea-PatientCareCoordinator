package com.consulea.servlet;

import com.consulea.entity.Patient;
import com.consulea.entity.User;
import com.consulea.entity.VitalSigns;
import com.consulea.service.NurseService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "NurseServlet", urlPatterns = {"/nurse/*"})
public class NurseServlet extends HttpServlet {

    private NurseService nurseService;

    @Override
    public void init() throws ServletException {
        nurseService = new NurseService();
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
        } else if (pathInfo.equals("/register-patient")) {
            request.getRequestDispatcher("/WEB-INF/views/nurse/register-patient.jsp").forward(request, response);
        } else if (pathInfo.equals("/patients-list")) {
            showPatientsList(request, response);
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

        if (pathInfo != null && pathInfo.equals("/register-patient")) {
            registerPatient(request, response);
        } else if (pathInfo != null && pathInfo.equals("/search-patient")) {
            searchPatient(request, response);
        } else if (pathInfo != null && pathInfo.equals("/add-vital-signs")) {
            addVitalSignsToExistingPatient(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Patient> todayPatients = nurseService.getTodayPatientsWithVitalSigns();
        
        // Créer une Map pour associer chaque patient à ses derniers signes vitaux
        java.util.Map<Long, VitalSigns> latestVitalSignsMap = new java.util.HashMap<>();
        for (Patient patient : todayPatients) {
            VitalSigns latestVitalSigns = nurseService.getLatestVitalSigns(patient);
            latestVitalSignsMap.put(patient.getId(), latestVitalSigns);
        }
        
        request.setAttribute("todayPatients", todayPatients);
        request.setAttribute("latestVitalSignsMap", latestVitalSignsMap);
        request.getRequestDispatcher("/WEB-INF/views/nurse/dashboard.jsp").forward(request, response);
    }

    private void showPatientsList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Patient> patients = nurseService.getTodayPatientsWithVitalSigns();
        
        // Créer une Map pour associer chaque patient à ses derniers signes vitaux
        java.util.Map<Long, VitalSigns> latestVitalSignsMap = new java.util.HashMap<>();
        for (Patient patient : patients) {
            VitalSigns latestVitalSigns = nurseService.getLatestVitalSigns(patient);
            latestVitalSignsMap.put(patient.getId(), latestVitalSigns);
        }
        
        request.setAttribute("patients", patients);
        request.setAttribute("latestVitalSignsMap", latestVitalSignsMap);
        request.getRequestDispatcher("/WEB-INF/views/nurse/patients-list.jsp").forward(request, response);
    }

    private void registerPatient(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String lastName = request.getParameter("lastName");
            String firstName = request.getParameter("firstName");
            String birthDateStr = request.getParameter("birthDate");
            String ssn = request.getParameter("socialSecurityNumber");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String medicalHistory = request.getParameter("medicalHistory");
            String currentTreatments = request.getParameter("currentTreatments");
            String allergies = request.getParameter("allergies");

            String bloodPressure = request.getParameter("bloodPressure");
            String heartRateStr = request.getParameter("heartRate");
            String temperatureStr = request.getParameter("temperature");
            String respiratoryRateStr = request.getParameter("respiratoryRate");
            String weightStr = request.getParameter("weight");
            String heightStr = request.getParameter("height");
            String oxygenSaturationStr = request.getParameter("oxygenSaturation");
            String observations = request.getParameter("observations");

            LocalDate birthDate = birthDateStr != null && !birthDateStr.isEmpty()
                    ? LocalDate.parse(birthDateStr) : null;
            Integer heartRate = heartRateStr != null && !heartRateStr.isEmpty()
                    ? Integer.parseInt(heartRateStr) : null;
            Double temperature = temperatureStr != null && !temperatureStr.isEmpty()
                    ? Double.parseDouble(temperatureStr) : null;
            Integer respiratoryRate = respiratoryRateStr != null && !respiratoryRateStr.isEmpty()
                    ? Integer.parseInt(respiratoryRateStr) : null;
            Double weight = weightStr != null && !weightStr.isEmpty()
                    ? Double.parseDouble(weightStr) : null;
            Double height = heightStr != null && !heightStr.isEmpty()
                    ? Double.parseDouble(heightStr) : null;
            Integer oxygenSaturation = oxygenSaturationStr != null && !oxygenSaturationStr.isEmpty()
                    ? Integer.parseInt(oxygenSaturationStr) : null;

            User nurse = (User) request.getSession().getAttribute("user");

            Patient patient = nurseService.registerPatientWithVitalSigns(
                    lastName, firstName, birthDate, ssn, phone, address,
                    medicalHistory, currentTreatments, allergies,
                    nurse, bloodPressure, heartRate, temperature, respiratoryRate,
                    weight, height, oxygenSaturation, observations
            );

            request.getSession().setAttribute("success",
                    "Patient " + patient.getFullName() + " enregistré avec succès");
            response.sendRedirect(request.getContextPath() + "/nurse/dashboard");

        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors de l'enregistrement: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/nurse/register-patient.jsp").forward(request, response);
        }
    }

    private void searchPatient(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String ssn = request.getParameter("socialSecurityNumber");

        if (ssn == null || ssn.trim().isEmpty()) {
            request.setAttribute("error", "Veuillez entrer un numéro de sécurité sociale");
            request.getRequestDispatcher("/WEB-INF/views/nurse/register-patient.jsp").forward(request, response);
            return;
        }

        Optional<Patient> patientOpt = nurseService.findPatientBySocialSecurityNumber(ssn);

        if (patientOpt.isPresent()) {
            Patient patient = patientOpt.get();
            List<VitalSigns> vitalSignsList = nurseService.getPatientVitalSigns(patient);
            request.setAttribute("patient", patient);
            request.setAttribute("vitalSignsList", vitalSignsList);
            request.setAttribute("existingPatient", true);
        } else {
            request.setAttribute("message", "Nouveau patient - veuillez remplir le formulaire");
            request.setAttribute("socialSecurityNumber", ssn);
        }

        request.getRequestDispatcher("/WEB-INF/views/nurse/register-patient.jsp").forward(request, response);
    }

    private void addVitalSignsToExistingPatient(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Long patientId = Long.parseLong(request.getParameter("patientId"));
            String bloodPressure = request.getParameter("bloodPressure");
            String heartRateStr = request.getParameter("heartRate");
            String temperatureStr = request.getParameter("temperature");
            String respiratoryRateStr = request.getParameter("respiratoryRate");
            String weightStr = request.getParameter("weight");
            String heightStr = request.getParameter("height");
            String oxygenSaturationStr = request.getParameter("oxygenSaturation");
            String observations = request.getParameter("observations");

            Integer heartRate = heartRateStr != null && !heartRateStr.isEmpty()
                    ? Integer.parseInt(heartRateStr) : null;
            Double temperature = temperatureStr != null && !temperatureStr.isEmpty()
                    ? Double.parseDouble(temperatureStr) : null;
            Integer respiratoryRate = respiratoryRateStr != null && !respiratoryRateStr.isEmpty()
                    ? Integer.parseInt(respiratoryRateStr) : null;
            Double weight = weightStr != null && !weightStr.isEmpty()
                    ? Double.parseDouble(weightStr) : null;
            Double height = heightStr != null && !heightStr.isEmpty()
                    ? Double.parseDouble(heightStr) : null;
            Integer oxygenSaturation = oxygenSaturationStr != null && !oxygenSaturationStr.isEmpty()
                    ? Integer.parseInt(oxygenSaturationStr) : null;

            Optional<Patient> patientOpt = nurseService.findPatientById(patientId);
            if (patientOpt.isEmpty()) {
                request.setAttribute("error", "Patient non trouvé");
                request.getRequestDispatcher("/WEB-INF/views/nurse/register-patient.jsp").forward(request, response);
                return;
            }

            Patient patient = patientOpt.get();
            User nurse = (User) request.getSession().getAttribute("user");

            nurseService.updateVitalSigns(patient, nurse, bloodPressure, heartRate, temperature,
                    respiratoryRate, weight, height, oxygenSaturation, observations);

            request.getSession().setAttribute("success",
                    "Signes vitaux mis à jour pour " + patient.getFullName());
            response.sendRedirect(request.getContextPath() + "/nurse/dashboard");

        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors de l'ajout des signes vitaux: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/nurse/register-patient.jsp").forward(request, response);
        }
    }
}