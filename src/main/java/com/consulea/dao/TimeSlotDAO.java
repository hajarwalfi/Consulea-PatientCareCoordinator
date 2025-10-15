package com.consulea.dao;

import com.consulea.entity.Specialist;
import com.consulea.entity.TimeSlot;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

import java.time.LocalTime;
import java.time.LocalDate;
import java.util.List;

public class TimeSlotDAO extends GenericDAO<TimeSlot> {

    public TimeSlotDAO() {
        super(TimeSlot.class);
    }

    public List<TimeSlot> findBySpecialist(Specialist specialist) {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT ts FROM TimeSlot ts WHERE ts.specialist = :specialist ORDER BY ts.startTime ASC";
            TypedQuery<TimeSlot> query = em.createQuery(jpql, TimeSlot.class);
            query.setParameter("specialist", specialist);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public List<TimeSlot> findAvailableBySpecialist(Specialist specialist) {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT ts FROM TimeSlot ts WHERE ts.specialist = :specialist AND ts.isAvailable = true ORDER BY ts.startTime ASC";
            TypedQuery<TimeSlot> query = em.createQuery(jpql, TimeSlot.class);
            query.setParameter("specialist", specialist);
            List<TimeSlot> allSlots = query.getResultList();
            
            return allSlots.stream()
                .filter(ts -> ts.getExpertiseRequest() == null)
                .collect(java.util.stream.Collectors.toList());
        } finally {
            em.close();
        }
    }

    public List<TimeSlot> findBookedBySpecialist(Specialist specialist) {
        EntityManager em = getEntityManager();
        try {
            String jpql = "SELECT ts FROM TimeSlot ts WHERE ts.specialist = :specialist AND ts.expertiseRequest IS NOT NULL ORDER BY ts.startTime ASC";
            TypedQuery<TimeSlot> query = em.createQuery(jpql, TimeSlot.class);
            query.setParameter("specialist", specialist);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public void initializeDefaultTimeSlots(Specialist specialist) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();

            LocalDate startDate = LocalDate.now();
            LocalDate endDate = startDate.plusWeeks(2);
            
            LocalTime[] startTimes = {
                LocalTime.of(9, 0),
                LocalTime.of(9, 30),
                LocalTime.of(10, 0),
                LocalTime.of(10, 30),
                LocalTime.of(11, 0),
                LocalTime.of(11, 30)
            };

            for (LocalDate currentDate = startDate; !currentDate.isAfter(endDate); currentDate = currentDate.plusDays(1)) {
                if (currentDate.getDayOfWeek().getValue() <= 5) {
                    for (LocalTime startTime : startTimes) {
                        LocalTime endTime = startTime.plusMinutes(30);
                        TimeSlot timeSlot = new TimeSlot(specialist, currentDate, startTime, endTime);
                        em.persist(timeSlot);
                    }
                }
            }

            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }

    public void deleteAvailableSlotsBySpecialist(Specialist specialist) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            
            String jpql = "SELECT ts FROM TimeSlot ts WHERE ts.specialist = :specialist AND ts.isAvailable = true";
            List<TimeSlot> allSlots = em.createQuery(jpql, TimeSlot.class)
                    .setParameter("specialist", specialist)
                    .getResultList();
            
            int deletedCount = 0;
            for (TimeSlot slot : allSlots) {
                if (slot.getExpertiseRequest() == null) {
                    em.remove(slot);
                    deletedCount++;
                }
            }
            
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la suppression des créneaux: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }
}