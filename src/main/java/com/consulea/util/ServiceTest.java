package com.consulea.util;

import com.consulea.entity.Consultation;
import com.consulea.entity.Patient;
import com.consulea.entity.User;
import com.consulea.entity.VitalSigns;
import com.consulea.entity.Specialist;
import com.consulea.entity.MedicalAct;
import com.consulea.dao.MedicalActDAO;
import com.consulea.enums.Role;
import com.consulea.enums.Specialty;
import com.consulea.service.AuthenticationService;
import com.consulea.service.DoctorService;
import com.consulea.service.NurseService;
import com.consulea.service.SpecialistService;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public class ServiceTest {

    public static void main(String[] args) {

        AuthenticationService authService = new AuthenticationService();
        NurseService nurseService = new NurseService();
        DoctorService doctorService = new DoctorService();
        SpecialistService specialistService = new SpecialistService();

        try {
            User nurse = authService.register("test.nurse@hospital.com", "password123",
                    "Idrissi", "Amina", Role.INFIRMIER);

            authService.login("test.nurse@hospital.com", "password123");

            User doctor = authService.register("test.doctor@hospital.com", "password123",
                    "Zahiri", "Omar", Role.MEDECIN_GENERALISTE);

            Patient patient = nurseService.registerPatientWithVitalSigns(
                    "El Amrani", "Fatima", LocalDate.of(1988, 7, 20),
                    "8807201234567", "0661234567", "12 Rue Mohammed V, Casablanca",
                    "Hypertension", "Lisinopril 10mg", "Aucune",
                    nurse, "140/90", 82, 36.9, 16, 68.0, 165.0, 97,
                    "Patient appears stable"
            );

            nurseService.getTodayPatients();

            nurseService.getPatientVitalSigns(patient);

            Consultation consultation = doctorService.createConsultation(
                    patient, doctor,
                    "Maux de tête persistants et vision floue",
                    "Céphalées depuis 3 jours, nausées, vision trouble",
                    "Tension élevée, réflexes normaux"
            );

            consultation = doctorService.completeConsultation(
                    consultation.getId(),
                    "Hypertension artérielle non contrôlée",
                    "Augmenter Lisinopril à 20mg, ajouter Amlodipine 5mg"
            );

            doctorService.getDoctorConsultations(doctor);

            User specialistUser = authService.register("test.specialist@hospital.com", "password123",
                    "Benali", "Rachid", Role.MEDECIN_SPECIALISTE);

            specialistService.createOrUpdateSpecialistProfile(
                    specialistUser, Specialty.CARDIOLOGIE, 300.0);

            authService.login("test.specialist@hospital.com", "password123");

            createAdditionalSpecialists(authService, specialistService);
            createSampleMedicalActs();

        } catch (Exception e) {
            // Test failed
        } finally {
            JPAUtil.closeEntityManagerFactory();
        }
    }

    private static void createAdditionalSpecialists(AuthenticationService authService, 
                                                   SpecialistService specialistService) {
        try {
            User dermatoUser = authService.register("dermato.specialist@hospital.com", "password123",
                    "Alami", "Sofia", Role.MEDECIN_SPECIALISTE);
            specialistService.createOrUpdateSpecialistProfile(
                    dermatoUser, Specialty.DERMATOLOGIE, 250.0);

            User neuroUser = authService.register("neuro.specialist@hospital.com", "password123",
                    "Tazi", "Youssef", Role.MEDECIN_SPECIALISTE);
            specialistService.createOrUpdateSpecialistProfile(
                    neuroUser, Specialty.NEUROLOGIE, 400.0);

            User gastroUser = authService.register("gastro.specialist@hospital.com", "password123",
                    "Fassi", "Laila", Role.MEDECIN_SPECIALISTE);
            specialistService.createOrUpdateSpecialistProfile(
                    gastroUser, Specialty.GASTRO_ENTEROLOGIE, 350.0);

            User pneumoUser = authService.register("pneumo.specialist@hospital.com", "password123",
                    "Chraibi", "Ahmed", Role.MEDECIN_SPECIALISTE);
            specialistService.createOrUpdateSpecialistProfile(
                    pneumoUser, Specialty.PNEUMOLOGIE, 320.0);

        } catch (Exception e) {
            // Some specialists could not be created
        }
    }

    private static void createSampleMedicalActs() {
        MedicalActDAO medicalActDAO = new MedicalActDAO();
        try {
            if (!medicalActDAO.findAll().isEmpty()) {
                return;
            }

            MedicalAct[] medicalActs = {
                new MedicalAct("Radiographie", 80.0),
                new MedicalAct("Échographie", 120.0),
                new MedicalAct("IRM", 800.0),
                new MedicalAct("Électrocardiogramme", 50.0),
                new MedicalAct("Laser dermatologique", 200.0),
                new MedicalAct("Fond d'œil", 60.0),
                new MedicalAct("Analyse de sang", 40.0),
                new MedicalAct("Analyse d'urine", 25.0)
            };

            for (MedicalAct act : medicalActs) {
                medicalActDAO.save(act);
            }

        } catch (Exception e) {
            // Medical acts could not be created
        }
    }
}