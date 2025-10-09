package com.consulea.dao;

import com.consulea.entity.ConsultationMedicalAct;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

import java.util.List;

public class ConsultationMedicalActDAO extends GenericDAO<ConsultationMedicalAct> {

    public ConsultationMedicalActDAO() {
        super(ConsultationMedicalAct.class);
    }

    public List<ConsultationMedicalAct> findByConsultationId(Long consultationId) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<ConsultationMedicalAct> query = em.createQuery(
                    "SELECT cma FROM ConsultationMedicalAct cma WHERE cma.consultation.id = :consultationId",
                    ConsultationMedicalAct.class
            );
            query.setParameter("consultationId", consultationId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
}