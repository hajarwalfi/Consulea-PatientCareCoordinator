package com.consulea.dao;

import com.consulea.entity.MedicalAct;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

import java.util.List;

public class MedicalActDAO extends GenericDAO<MedicalAct> {

    public MedicalActDAO() {
        super(MedicalAct.class);
    }

    public List<MedicalAct> findAll() {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<MedicalAct> query = em.createQuery(
                    "SELECT m FROM MedicalAct m ORDER BY m.name", MedicalAct.class
            );
            return query.getResultList();
        } finally {
            em.close();
        }
    }
}