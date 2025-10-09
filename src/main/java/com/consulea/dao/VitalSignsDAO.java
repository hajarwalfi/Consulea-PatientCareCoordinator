package com.consulea.dao;

import com.consulea.entity.Patient;
import com.consulea.entity.VitalSigns;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

import java.util.List;

public class VitalSignsDAO extends GenericDAO<VitalSigns> {

    public VitalSignsDAO() {
        super(VitalSigns.class);
    }

    public List<VitalSigns> findByPatient(Patient patient) {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT v FROM VitalSigns v WHERE v.patient = :patient ORDER BY v.measuredAt DESC";
            TypedQuery<VitalSigns> query = em.createQuery(jpql, VitalSigns.class);
            query.setParameter("patient", patient);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public List<VitalSigns> findByPatientId(Long patientId) {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT v FROM VitalSigns v WHERE v.patient.id = :patientId ORDER BY v.measuredAt DESC";
            TypedQuery<VitalSigns> query = em.createQuery(jpql, VitalSigns.class);
            query.setParameter("patientId", patientId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
}