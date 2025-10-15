package com.consulea.util;

import com.consulea.entity.Consultation;
import com.consulea.entity.Patient;
import com.consulea.entity.User;
import com.consulea.entity.VitalSigns;
import com.consulea.enums.Role;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;

import java.time.LocalDate;

public class DatabaseTest {

    public static void main(String[] args) {

        EntityManager em = null;
        EntityTransaction tx = null;

        try {
            em = JPAUtil.getEntityManager();
            tx = em.getTransaction();
            tx.begin();


            User testNurse = new User(
                    "nurse@hospital.com",
                    "temporaryPassword123",
                    "Dupont",
                    "Jean",
                    Role.INFIRMIER
            );
            em.persist(testNurse);

            User testDoctor = new User(
                    "doctor@hospital.com",
                    "doctorPassword123",
                    "Bernard",
                    "Marie",
                    Role.MEDECIN_GENERALISTE
            );
            em.persist(testDoctor);

            Patient testPatient = new Patient(
                    "Martin",
                    "Sophie",
                    LocalDate.of(1985, 5, 15),
                    "1234567890123"
            );
            em.persist(testPatient);

            VitalSigns testVitalSigns = new VitalSigns(
                    testPatient,
                    "120/80",
                    75,
                    36.8,
                    16
            );
            testVitalSigns.setMeasuredBy(testNurse);
            em.persist(testVitalSigns);

            Consultation testConsultation = new Consultation(
                    testPatient,
                    testDoctor,
                    "Douleurs abdominales depuis 2 jours"
            );
            testConsultation.setSymptoms("Fièvre, nausées, douleur dans le quadrant inférieur droit");
            testConsultation.setClinicalExamination("Abdomen sensible à la palpation, défense musculaire");
            em.persist(testConsultation);

            tx.commit();

        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            // Error during test
        } finally {
            if (em != null) {
                em.close();
            }
            JPAUtil.closeEntityManagerFactory();
        }
    }
}