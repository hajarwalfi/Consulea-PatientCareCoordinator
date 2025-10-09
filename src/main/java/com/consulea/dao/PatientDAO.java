package com.consulea.dao;

import com.consulea.entity.Patient;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public class PatientDAO extends GenericDAO<Patient> {

    public PatientDAO() {
        super(Patient.class);
    }

    public Optional<Patient> findBySocialSecurityNumber(String ssn) {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT p FROM Patient p WHERE p.socialSecurityNumber = :ssn";
            TypedQuery<Patient> query = em.createQuery(jpql, Patient.class);
            query.setParameter("ssn", ssn);
            return Optional.ofNullable(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        } finally {
            em.close();
        }
    }

    public List<Patient> findRegisteredToday() {
        EntityManager em = getEntityManager();
        try {
            LocalDateTime startOfDay = LocalDateTime.now().withHour(0).withMinute(0).withSecond(0);
            LocalDateTime endOfDay = LocalDateTime.now().withHour(23).withMinute(59).withSecond(59);

            String jpql = "SELECT p FROM Patient p WHERE p.registeredAt BETWEEN :start AND :end ORDER BY p.registeredAt ASC";
            TypedQuery<Patient> query = em.createQuery(jpql, Patient.class);
            query.setParameter("start", startOfDay);
            query.setParameter("end", endOfDay);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public boolean existsBySocialSecurityNumber(String ssn) {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT COUNT(p) FROM Patient p WHERE p.socialSecurityNumber = :ssn";
            TypedQuery<Long> query = em.createQuery(jpql, Long.class);
            query.setParameter("ssn", ssn);
            return query.getSingleResult() > 0;
        } finally {
            em.close();
        }
    }
}