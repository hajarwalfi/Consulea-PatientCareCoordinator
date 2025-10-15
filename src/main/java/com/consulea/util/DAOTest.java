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

        UserDAO userDAO = new UserDAO();
        PatientDAO patientDAO = new PatientDAO();
        VitalSignsDAO vitalSignsDAO = new VitalSignsDAO();
        ConsultationDAO consultationDAO = new ConsultationDAO();

        try {
            String hashedPassword = BCrypt.hashpw("password123", BCrypt.gensalt());

            User nurse = new User("nurse.test@hospital.com", hashedPassword, "Alami", "Fatima", Role.INFIRMIER);
            nurse = userDAO.save(nurse);

            User doctor = new User("doctor.test@hospital.com", hashedPassword, "Bennani", "Karim", Role.MEDECIN_GENERALISTE);
            doctor = userDAO.save(doctor);

            userDAO.findByEmail("nurse.test@hospital.com");

            userDAO.authenticate("doctor.test@hospital.com", "password123");

            Patient patient = new Patient("Tazi", "Youssef", LocalDate.of(1990, 3, 15), "2901234567890");
            patient.setPhone("0612345678");
            patient.setAllergies("Pénicilline");
            patient = patientDAO.save(patient);

            patientDAO.findBySocialSecurityNumber("2901234567890");

            VitalSigns vitalSigns = new VitalSigns(patient, "130/85", 78, 37.2, 18);
            vitalSigns.setWeight(75.5);
            vitalSigns.setHeight(175.0);
            vitalSigns.setOxygenSaturation(98);
            vitalSigns.setMeasuredBy(nurse);
            vitalSigns = vitalSignsDAO.save(vitalSigns);

            vitalSignsDAO.findByPatient(patient);

            Consultation consultation = new Consultation(patient, doctor, "Douleurs thoraciques et essoufflement");
            consultation.setSymptoms("Douleur à la poitrine, essoufflement, fatigue");
            consultation.setClinicalExamination("Auscultation cardiaque révèle un souffle systolique");
            consultation = consultationDAO.save(consultation);

            consultationDAO.findByPatient(patient);

            consultationDAO.findByDoctor(doctor);

            consultation.setDiagnosis("Insuffisance cardiaque légère");
            consultation.setTreatment("Inhibiteurs de l'ECA, Diurétiques, Régime pauvre en sel");
            consultation.complete();
            consultation = consultationDAO.update(consultation);

            patientDAO.findRegisteredToday();

            consultationDAO.findByStatus(ConsultationStatus.COMPLETED);

            userDAO.findAll();
            patientDAO.findAll();

        } catch (Exception e) {
            // Test failed
        } finally {
            JPAUtil.closeEntityManagerFactory();
        }
    }
}