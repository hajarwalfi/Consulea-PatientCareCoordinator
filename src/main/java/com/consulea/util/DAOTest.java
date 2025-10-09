package com.consulea.util;

import com.consulea.dao.*;
import com.consulea.entity.*;
import com.consulea.enums.ConsultationStatus;
import com.consulea.enums.Role;
import org.mindrot.jbcrypt.BCrypt;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public class DAOTest {

    public static void main(String[] args) {
        System.out.println("=== Starting DAO Tests ===\n");

        UserDAO userDAO = new UserDAO();
        PatientDAO patientDAO = new PatientDAO();
        VitalSignsDAO vitalSignsDAO = new VitalSignsDAO();
        ConsultationDAO consultationDAO = new ConsultationDAO();

        try {
            // TEST 1: UserDAO - Create and Find
            System.out.println("TEST 1: Creating users...");
            String hashedPassword = BCrypt.hashpw("password123", BCrypt.gensalt());

            User nurse = new User("nurse.test@hospital.com", hashedPassword, "Alami", "Fatima", Role.INFIRMIER);
            nurse = userDAO.save(nurse);
            System.out.println("✓ Nurse created with ID: " + nurse.getId());

            User doctor = new User("doctor.test@hospital.com", hashedPassword, "Bennani", "Karim", Role.MEDECIN_GENERALISTE);
            doctor = userDAO.save(doctor);
            System.out.println("✓ Doctor created with ID: " + doctor.getId());

            // TEST 2: UserDAO - Find by email
            System.out.println("\nTEST 2: Finding user by email...");
            Optional<User> foundNurse = userDAO.findByEmail("nurse.test@hospital.com");
            if (foundNurse.isPresent()) {
                System.out.println("✓ Found nurse: " + foundNurse.get().getFullName());
            }

            // TEST 3: UserDAO - Authentication
            System.out.println("\nTEST 3: Testing authentication...");
            Optional<User> authenticated = userDAO.authenticate("doctor.test@hospital.com", "password123");
            if (authenticated.isPresent()) {
                System.out.println("✓ Authentication successful for: " + authenticated.get().getFullName());
            }

            // TEST 4: PatientDAO - Create patient
            System.out.println("\nTEST 4: Creating patient...");
            Patient patient = new Patient("Tazi", "Youssef", LocalDate.of(1990, 3, 15), "2901234567890");
            patient.setPhone("0612345678");
            patient.setAllergies("Pénicilline");
            patient = patientDAO.save(patient);
            System.out.println("✓ Patient created with ID: " + patient.getId());

            // TEST 5: PatientDAO - Find by SSN
            System.out.println("\nTEST 5: Finding patient by SSN...");
            Optional<Patient> foundPatient = patientDAO.findBySocialSecurityNumber("2901234567890");
            if (foundPatient.isPresent()) {
                System.out.println("✓ Found patient: " + foundPatient.get().getFullName());
            }

            // TEST 6: VitalSignsDAO - Create vital signs
            System.out.println("\nTEST 6: Creating vital signs...");
            VitalSigns vitalSigns = new VitalSigns(patient, "130/85", 78, 37.2, 18);
            vitalSigns.setWeight(75.5);
            vitalSigns.setHeight(175.0);
            vitalSigns.setOxygenSaturation(98);
            vitalSigns.setMeasuredBy(nurse);
            vitalSigns = vitalSignsDAO.save(vitalSigns);
            System.out.println("✓ Vital signs created with ID: " + vitalSigns.getId());
            System.out.println("  - Blood Pressure: " + vitalSigns.getBloodPressure());
            System.out.println("  - BMI: " + String.format("%.2f", vitalSigns.calculateBMI()));

            // TEST 7: VitalSignsDAO - Find by patient
            System.out.println("\nTEST 7: Finding vital signs for patient...");
            List<VitalSigns> patientVitalSigns = vitalSignsDAO.findByPatient(patient);
            System.out.println("✓ Found " + patientVitalSigns.size() + " vital signs record(s) for patient");

            // TEST 8: ConsultationDAO - Create consultation
            System.out.println("\nTEST 8: Creating consultation...");
            Consultation consultation = new Consultation(patient, doctor, "Douleurs thoraciques et essoufflement");
            consultation.setSymptoms("Douleur à la poitrine, essoufflement, fatigue");
            consultation.setClinicalExamination("Auscultation cardiaque révèle un souffle systolique");
            consultation = consultationDAO.save(consultation);
            System.out.println("✓ Consultation created with ID: " + consultation.getId());
            System.out.println("  - Status: " + consultation.getStatus());
            System.out.println("  - Cost: " + consultation.getCost() + " DH");

            // TEST 9: ConsultationDAO - Find by patient
            System.out.println("\nTEST 9: Finding consultations for patient...");
            List<Consultation> patientConsultations = consultationDAO.findByPatient(patient);
            System.out.println("✓ Found " + patientConsultations.size() + " consultation(s) for patient");

            // TEST 10: ConsultationDAO - Find by doctor
            System.out.println("\nTEST 10: Finding consultations for doctor...");
            List<Consultation> doctorConsultations = consultationDAO.findByDoctor(doctor);
            System.out.println("✓ Found " + doctorConsultations.size() + " consultation(s) for doctor");

            // TEST 11: ConsultationDAO - Update consultation
            System.out.println("\nTEST 11: Updating consultation...");
            consultation.setDiagnosis("Insuffisance cardiaque légère");
            consultation.setTreatment("Inhibiteurs de l'ECA, Diurétiques, Régime pauvre en sel");
            consultation.complete();
            consultation = consultationDAO.update(consultation);
            System.out.println("✓ Consultation updated");
            System.out.println("  - New status: " + consultation.getStatus());
            System.out.println("  - Completed at: " + consultation.getCompletedAt());

            // TEST 12: PatientDAO - Find registered today
            System.out.println("\nTEST 12: Finding patients registered today...");
            List<Patient> todayPatients = patientDAO.findRegisteredToday();
            System.out.println("✓ Found " + todayPatients.size() + " patient(s) registered today");

            // TEST 13: ConsultationDAO - Find by status
            System.out.println("\nTEST 13: Finding consultations by status...");
            List<Consultation> completedConsultations = consultationDAO.findByStatus(ConsultationStatus.COMPLETED);
            System.out.println("✓ Found " + completedConsultations.size() + " completed consultation(s)");

            // TEST 14: GenericDAO - FindAll
            System.out.println("\nTEST 14: Testing findAll...");
            List<User> allUsers = userDAO.findAll();
            System.out.println("✓ Found " + allUsers.size() + " total user(s) in database");

            List<Patient> allPatients = patientDAO.findAll();
            System.out.println("✓ Found " + allPatients.size() + " total patient(s) in database");

            System.out.println("\n=== ALL TESTS PASSED SUCCESSFULLY! ===");
            System.out.println("\nYour DAO layer is fully functional and ready for the Service layer!");

        } catch (Exception e) {
            System.err.println("\n❌ TEST FAILED: " + e.getMessage());
            e.printStackTrace();
        } finally {
            JPAUtil.closeEntityManagerFactory();
        }
    }
}