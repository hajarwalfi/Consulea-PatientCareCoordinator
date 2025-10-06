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
        System.out.println("Starting database connection test...");

        EntityManager em = null;
        EntityTransaction tx = null;

        try {
            em = JPAUtil.getEntityManager();
            tx = em.getTransaction();
            tx.begin();

            System.out.println("Database connection successful!");
            System.out.println("Tables should be created in PostgreSQL now.");

            User testNurse = new User(
                    "nurse@hospital.com",
                    "temporaryPassword123",
                    "Dupont",
                    "Jean",
                    Role.INFIRMIER
            );
            em.persist(testNurse);
            System.out.println("Test nurse created with ID: " + testNurse.getId());

            User testDoctor = new User(
                    "doctor@hospital.com",
                    "doctorPassword123",
                    "Bernard",
                    "Marie",
                    Role.MEDECIN_GENERALISTE
            );
            em.persist(testDoctor);
            System.out.println("Test doctor created with ID: " + testDoctor.getId());

            Patient testPatient = new Patient(
                    "Martin",
                    "Sophie",
                    LocalDate.of(1985, 5, 15),
                    "1234567890123"
            );
            em.persist(testPatient);
            System.out.println("Test patient created with ID: " + testPatient.getId());

            VitalSigns testVitalSigns = new VitalSigns(
                    testPatient,
                    "120/80",
                    75,
                    36.8,
                    16
            );
            testVitalSigns.setMeasuredBy(testNurse);
            em.persist(testVitalSigns);
            System.out.println("Test vital signs created with ID: " + testVitalSigns.getId());

            Consultation testConsultation = new Consultation(
                    testPatient,
                    testDoctor,
                    "Douleurs abdominales depuis 2 jours"
            );
            testConsultation.setSymptoms("Fièvre, nausées, douleur dans le quadrant inférieur droit");
            testConsultation.setClinicalExamination("Abdomen sensible à la palpation, défense musculaire");
            em.persist(testConsultation);
            System.out.println("Test consultation created with ID: " + testConsultation.getId());

            tx.commit();
            System.out.println("\nTest completed successfully!");
            System.out.println("Check your PostgreSQL database 'Consulea' to see the tables and data.");

        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            System.err.println("Error during test: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (em != null) {
                em.close();
            }
            JPAUtil.closeEntityManagerFactory();
        }
    }
}