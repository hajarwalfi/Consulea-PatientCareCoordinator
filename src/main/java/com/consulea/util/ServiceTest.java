package com.consulea.util;

import com.consulea.entity.Consultation;
import com.consulea.entity.Patient;
import com.consulea.entity.User;
import com.consulea.entity.VitalSigns;
import com.consulea.enums.Role;
import com.consulea.service.AuthenticationService;
import com.consulea.service.DoctorService;
import com.consulea.service.NurseService;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public class ServiceTest {

    public static void main(String[] args) {
        System.out.println("=== Starting Service Layer Tests ===\n");

        AuthenticationService authService = new AuthenticationService();
        NurseService nurseService = new NurseService();
        DoctorService doctorService = new DoctorService();

        try {
            System.out.println("TEST 1: Register and login nurse...");
            User nurse = authService.register("test.nurse@hospital.com", "password123",
                    "Idrissi", "Amina", Role.INFIRMIER);
            System.out.println("✓ Nurse registered: " + nurse.getFullName());

            Optional<User> loggedInNurse = authService.login("test.nurse@hospital.com", "password123");
            if (loggedInNurse.isPresent()) {
                System.out.println("✓ Nurse logged in successfully");
            }

            System.out.println("\nTEST 2: Register and login doctor...");
            User doctor = authService.register("test.doctor@hospital.com", "password123",
                    "Zahiri", "Omar", Role.MEDECIN_GENERALISTE);
            System.out.println("✓ Doctor registered: " + doctor.getFullName());

            System.out.println("\nTEST 3: Register patient with vital signs...");
            Patient patient = nurseService.registerPatientWithVitalSigns(
                    "El Amrani", "Fatima", LocalDate.of(1988, 7, 20),
                    "8807201234567", "0661234567", "12 Rue Mohammed V, Casablanca",
                    "Hypertension", "Lisinopril 10mg", "Aucune",
                    nurse, "140/90", 82, 36.9, 16, 68.0, 165.0, 97,
                    "Patient appears stable"
            );
            System.out.println("✓ Patient registered: " + patient.getFullName());
            System.out.println("  - SSN: " + patient.getSocialSecurityNumber());

            System.out.println("\nTEST 4: Get today's patients...");
            List<Patient> todayPatients = nurseService.getTodayPatients();
            System.out.println("✓ Found " + todayPatients.size() + " patient(s) registered today");

            System.out.println("\nTEST 5: Get patient vital signs...");
            List<VitalSigns> vitalSignsList = nurseService.getPatientVitalSigns(patient);
            System.out.println("✓ Found " + vitalSignsList.size() + " vital signs record(s)");
            if (!vitalSignsList.isEmpty()) {
                VitalSigns vs = vitalSignsList.get(0);
                System.out.println("  - BP: " + vs.getBloodPressure());
                System.out.println("  - BMI: " + String.format("%.2f", vs.calculateBMI()));
            }

            System.out.println("\nTEST 6: Create consultation...");
            Consultation consultation = doctorService.createConsultation(
                    patient, doctor,
                    "Maux de tête persistants et vision floue",
                    "Céphalées depuis 3 jours, nausées, vision trouble",
                    "Tension élevée, réflexes normaux"
            );
            System.out.println("✓ Consultation created with ID: " + consultation.getId());
            System.out.println("  - Status: " + consultation.getStatus());
            System.out.println("  - Cost: " + consultation.getCost() + " DH");

            System.out.println("\nTEST 7: Update consultation with diagnosis...");
            consultation = doctorService.updateConsultationDiagnosisTreatment(
                    consultation.getId(),
                    "Hypertension artérielle non contrôlée",
                    "Augmenter Lisinopril à 20mg, ajouter Amlodipine 5mg"
            );
            System.out.println("✓ Consultation updated");
            System.out.println("  - Diagnosis: " + consultation.getDiagnosis());

            System.out.println("\nTEST 8: Complete consultation...");
            consultation = doctorService.completeConsultation(
                    consultation.getId(),
                    consultation.getDiagnosis(),
                    consultation.getTreatment()
            );
            System.out.println("✓ Consultation completed");
            System.out.println("  - Status: " + consultation.getStatus());
            System.out.println("  - Completed at: " + consultation.getCompletedAt());

            System.out.println("\nTEST 9: Get doctor's consultations...");
            List<Consultation> doctorConsultations = doctorService.getDoctorConsultations(doctor);
            System.out.println("✓ Doctor has " + doctorConsultations.size() + " consultation(s)");

            System.out.println("\n=== ALL SERVICE TESTS PASSED! ===");
            System.out.println("\nYour Service layer is ready for Servlets and JSP!");

        } catch (Exception e) {
            System.err.println("\n❌ TEST FAILED: " + e.getMessage());
            e.printStackTrace();
        } finally {
            JPAUtil.closeEntityManagerFactory();
        }
    }
}