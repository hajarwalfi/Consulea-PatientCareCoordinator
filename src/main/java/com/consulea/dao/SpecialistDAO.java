package com.consulea.dao;

import com.consulea.entity.Specialist;
import com.consulea.entity.User;
import com.consulea.enums.Specialty;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

import java.util.List;
import java.util.Optional;

public class SpecialistDAO extends GenericDAO<Specialist> {

    public SpecialistDAO() {
        super(Specialist.class);
    }

    public Optional<Specialist> findByUser(User user) {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT s FROM Specialist s WHERE s.user = :user";
            TypedQuery<Specialist> query = em.createQuery(jpql, Specialist.class);
            query.setParameter("user", user);
            List<Specialist> results = query.getResultList();
            return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
        } finally {
            em.close();
        }
    }

    public List<Specialist> findBySpecialty(Specialty specialty) {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT DISTINCT s FROM Specialist s LEFT JOIN FETCH s.user WHERE s.specialty = :specialty ORDER BY s.consultationFee ASC";
            TypedQuery<Specialist> query = em.createQuery(jpql, Specialist.class);
            query.setParameter("specialty", specialty);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public List<Specialist> findAllWithUser() {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT DISTINCT s FROM Specialist s LEFT JOIN FETCH s.user ORDER BY s.specialty, s.consultationFee ASC";
            TypedQuery<Specialist> query = em.createQuery(jpql, Specialist.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public List<Specialist> findBySpecialtyOrderByFee(Specialty specialty) {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT DISTINCT s FROM Specialist s LEFT JOIN FETCH s.user WHERE s.specialty = :specialty ORDER BY s.consultationFee ASC";
            TypedQuery<Specialist> query = em.createQuery(jpql, Specialist.class);
            query.setParameter("specialty", specialty);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
}