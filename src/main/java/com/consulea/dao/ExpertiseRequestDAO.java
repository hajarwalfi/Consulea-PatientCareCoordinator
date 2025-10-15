package com.consulea.dao;

import com.consulea.entity.ExpertiseRequest;
import com.consulea.entity.Specialist;
import com.consulea.entity.User;
import com.consulea.enums.ExpertiseStatus;
import com.consulea.enums.Priority;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

import java.util.List;
import java.util.Optional;

public class ExpertiseRequestDAO extends GenericDAO<ExpertiseRequest> {

    public ExpertiseRequestDAO() {
        super(ExpertiseRequest.class);
    }

    public List<ExpertiseRequest> findBySpecialist(Specialist specialist) {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT DISTINCT er FROM ExpertiseRequest er " +
                         "LEFT JOIN FETCH er.consultation c " +
                         "LEFT JOIN FETCH c.patient " +
                         "LEFT JOIN FETCH er.requestingDoctor " +
                         "WHERE er.specialist = :specialist " +
                         "ORDER BY er.createdAt DESC";
            TypedQuery<ExpertiseRequest> query = em.createQuery(jpql, ExpertiseRequest.class);
            query.setParameter("specialist", specialist);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public List<ExpertiseRequest> findBySpecialistAndStatus(Specialist specialist, ExpertiseStatus status) {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT DISTINCT er FROM ExpertiseRequest er " +
                         "LEFT JOIN FETCH er.consultation c " +
                         "LEFT JOIN FETCH c.patient " +
                         "LEFT JOIN FETCH er.requestingDoctor " +
                         "WHERE er.specialist = :specialist AND er.status = :status " +
                         "ORDER BY er.createdAt DESC";
            TypedQuery<ExpertiseRequest> query = em.createQuery(jpql, ExpertiseRequest.class);
            query.setParameter("specialist", specialist);
            query.setParameter("status", status);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public List<ExpertiseRequest> findBySpecialistAndPriority(Specialist specialist, Priority priority) {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT DISTINCT er FROM ExpertiseRequest er " +
                         "LEFT JOIN FETCH er.consultation c " +
                         "LEFT JOIN FETCH c.patient " +
                         "LEFT JOIN FETCH er.requestingDoctor " +
                         "WHERE er.specialist = :specialist AND er.priority = :priority " +
                         "ORDER BY er.createdAt DESC";
            TypedQuery<ExpertiseRequest> query = em.createQuery(jpql, ExpertiseRequest.class);
            query.setParameter("specialist", specialist);
            query.setParameter("priority", priority);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public List<ExpertiseRequest> findByRequestingDoctor(User requestingDoctor) {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT DISTINCT er FROM ExpertiseRequest er " +
                         "LEFT JOIN FETCH er.consultation c " +
                         "LEFT JOIN FETCH c.patient " +
                         "LEFT JOIN FETCH er.specialist s " +
                         "LEFT JOIN FETCH s.user " +
                         "WHERE er.requestingDoctor = :requestingDoctor " +
                         "ORDER BY er.createdAt DESC";
            TypedQuery<ExpertiseRequest> query = em.createQuery(jpql, ExpertiseRequest.class);
            query.setParameter("requestingDoctor", requestingDoctor);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public Optional<ExpertiseRequest> findByConsultationId(Long consultationId) {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT DISTINCT er FROM ExpertiseRequest er " +
                         "LEFT JOIN FETCH er.consultation c " +
                         "LEFT JOIN FETCH c.patient " +
                         "LEFT JOIN FETCH er.specialist s " +
                         "LEFT JOIN FETCH s.user " +
                         "LEFT JOIN FETCH er.requestingDoctor rd " +
                         "WHERE er.consultation.id = :consultationId";
            TypedQuery<ExpertiseRequest> query = em.createQuery(jpql, ExpertiseRequest.class);
            query.setParameter("consultationId", consultationId);
            List<ExpertiseRequest> results = query.getResultList();
            return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
        } finally {
            em.close();
        }
    }

    public List<ExpertiseRequest> findPendingBySpecialistOrderByPriority(Specialist specialist) {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT er FROM ExpertiseRequest er " +
                         "LEFT JOIN FETCH er.consultation c " +
                         "LEFT JOIN FETCH c.patient " +
                         "LEFT JOIN FETCH er.requestingDoctor " +
                         "WHERE er.specialist = :specialist AND er.status = :status " +
                         "ORDER BY er.createdAt ASC";
            TypedQuery<ExpertiseRequest> query = em.createQuery(jpql, ExpertiseRequest.class);
            query.setParameter("specialist", specialist);
            query.setParameter("status", ExpertiseStatus.EN_ATTENTE);
            
            List<ExpertiseRequest> results = query.getResultList();
            
            return results.stream()
                    .sorted((r1, r2) -> {
                        int priority1 = getPriorityOrder(r1.getPriority());
                        int priority2 = getPriorityOrder(r2.getPriority());
                        
                        int priorityCompare = Integer.compare(priority1, priority2);
                        if (priorityCompare != 0) return priorityCompare;
                        
                        return r1.getCreatedAt().compareTo(r2.getCreatedAt());
                    })
                    .collect(java.util.stream.Collectors.toList());
        } finally {
            em.close();
        }
    }
    
    private int getPriorityOrder(Priority priority) {
        switch (priority) {
            case URGENTE: return 1;
            case NORMALE: return 2;
            case NON_URGENTE: return 3;
            default: return 4;
        }
    }
}