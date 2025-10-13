package com.consulea.dao;

import com.consulea.entity.Consultation;
import com.consulea.entity.Patient;
import com.consulea.entity.User;
import com.consulea.enums.ConsultationStatus;
import com.consulea.enums.PatientStatus;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

import java.util.List;

public class ConsultationDAO extends GenericDAO<Consultation> {

    public ConsultationDAO() {
        super(Consultation.class);
    }

    public List<Consultation> findByPatient(Patient patient) {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT c FROM Consultation c WHERE c.patient = :patient ORDER BY c.createdAt DESC";
            TypedQuery<Consultation> query = em.createQuery(jpql, Consultation.class);
            query.setParameter("patient", patient);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public List<Consultation> findByDoctor(User doctor) {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT DISTINCT c FROM Consultation c LEFT JOIN FETCH c.patient WHERE c.doctor = :doctor ORDER BY c.createdAt DESC";
            TypedQuery<Consultation> query = em.createQuery(jpql, Consultation.class);
            query.setParameter("doctor", doctor);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public List<Consultation> findByStatus(ConsultationStatus status) {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT DISTINCT c FROM Consultation c LEFT JOIN FETCH c.patient WHERE c.status = :status ORDER BY c.createdAt DESC";

            TypedQuery<Consultation> query = em.createQuery(jpql, Consultation.class);
            query.setParameter("status", status);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    public List<Consultation> findInProgress() {
        return findByStatus(ConsultationStatus.IN_PROGRESS);
    }

    public List<Consultation> findWaitingForSpecialist() {
        return findByStatus(ConsultationStatus.WAITING_FOR_SPECIALIST_OPINION);
    }

    public List<Consultation> findCompleted() {
        return findByStatus(ConsultationStatus.COMPLETED);
    }

    public List<Consultation> findByDoctorAndStatus(User doctor, ConsultationStatus status) {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT DISTINCT c FROM Consultation c LEFT JOIN FETCH c.patient WHERE c.doctor = :doctor AND c.status = :status ORDER BY c.createdAt DESC";
            TypedQuery<Consultation> query = em.createQuery(jpql, Consultation.class);
            query.setParameter("doctor", doctor);
            query.setParameter("status", status);
            return query.getResultList();
        } finally {
            em.close();
        }
    }


    public List<Consultation> findInProgressByDoctor(User doctor) {
        return findByDoctorAndStatus(doctor, ConsultationStatus.IN_PROGRESS);
    }

    public List<Consultation> findWaitingForSpecialistByDoctor(User doctor) {
        return findByDoctorAndStatus(doctor, ConsultationStatus.WAITING_FOR_SPECIALIST_OPINION);
    }

    public List<Consultation> findCompletedByDoctor(User doctor) {
        return findByDoctorAndStatus(doctor, ConsultationStatus.COMPLETED);
    }

}