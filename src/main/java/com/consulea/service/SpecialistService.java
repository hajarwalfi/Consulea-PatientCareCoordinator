package com.consulea.service;

import com.consulea.dao.ExpertiseRequestDAO;
import com.consulea.dao.SpecialistDAO;
import com.consulea.dao.TimeSlotDAO;
import com.consulea.dao.ConsultationDAO;
import com.consulea.entity.ExpertiseRequest;
import com.consulea.entity.Specialist;
import com.consulea.entity.TimeSlot;
import com.consulea.entity.User;
import com.consulea.entity.Consultation;
import com.consulea.enums.ExpertiseStatus;
import com.consulea.enums.Priority;
import com.consulea.enums.Specialty;
import com.consulea.enums.ConsultationStatus;

import java.time.DayOfWeek;
import java.time.LocalTime;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

public class SpecialistService {

    private final SpecialistDAO specialistDAO;
    private final ExpertiseRequestDAO expertiseRequestDAO;
    private final TimeSlotDAO timeSlotDAO;
    private final ConsultationDAO consultationDAO;

    public SpecialistService() {
        this.specialistDAO = new SpecialistDAO();
        this.expertiseRequestDAO = new ExpertiseRequestDAO();
        this.timeSlotDAO = new TimeSlotDAO();
        this.consultationDAO = new ConsultationDAO();
    }

    public Specialist createOrUpdateSpecialistProfile(User user, Specialty specialty, Double consultationFee) {
        Optional<Specialist> existingSpecialist = specialistDAO.findByUser(user);
        
        if (existingSpecialist.isPresent()) {
            Specialist specialist = existingSpecialist.get();
            specialist.setSpecialty(specialty);
            specialist.setConsultationFee(consultationFee);
            return specialistDAO.update(specialist);
        } else {
            Specialist specialist = new Specialist(user, specialty, consultationFee);
            Specialist savedSpecialist = specialistDAO.save(specialist);
            
            timeSlotDAO.initializeDefaultTimeSlots(savedSpecialist);
            
            return savedSpecialist;
        }
    }

    public Optional<Specialist> getSpecialistByUser(User user) {
        return specialistDAO.findByUser(user);
    }

    public Optional<Specialist> getSpecialistById(Long specialistId) {
        return specialistDAO.findById(specialistId);
    }

    public List<TimeSlot> getSpecialistTimeSlots(Specialist specialist) {
        return timeSlotDAO.findBySpecialist(specialist);
    }

    public List<TimeSlot> getAvailableTimeSlots(Specialist specialist) {
        return timeSlotDAO.findAvailableBySpecialist(specialist);
    }

    public List<TimeSlot> getBookedTimeSlots(Specialist specialist) {
        return timeSlotDAO.findBookedBySpecialist(specialist);
    }

    public List<ExpertiseRequest> getSpecialistExpertiseRequests(Specialist specialist) {
        return expertiseRequestDAO.findBySpecialist(specialist);
    }

    public List<ExpertiseRequest> getExpertiseRequestsByStatus(Specialist specialist, ExpertiseStatus status) {
        return expertiseRequestDAO.findBySpecialistAndStatus(specialist, status);
    }

    public List<ExpertiseRequest> getPendingExpertiseRequests(Specialist specialist) {
        return expertiseRequestDAO.findPendingBySpecialistOrderByPriority(specialist);
    }

    public Optional<ExpertiseRequest> getExpertiseRequestById(Long requestId) {
        return expertiseRequestDAO.findById(requestId);
    }

    public ExpertiseRequest respondToExpertise(Long requestId, String response, String recommendations) {
        Optional<ExpertiseRequest> expertiseOpt = expertiseRequestDAO.findById(requestId);
        
        if (expertiseOpt.isEmpty()) {
            throw new IllegalArgumentException("Demande d'expertise non trouvée");
        }

        ExpertiseRequest expertise = expertiseOpt.get();
        expertise.complete(response, recommendations);
        
        Consultation consultation = expertise.getConsultation();
        consultation.setStatus(ConsultationStatus.IN_PROGRESS);
        consultationDAO.update(consultation);
        
        ExpertiseRequest updatedExpertise = expertiseRequestDAO.update(expertise);
        
        return updatedExpertise;
    }

    public List<Specialist> findSpecialistsBySpecialty(Specialty specialty) {
        return specialistDAO.findBySpecialtyOrderByFee(specialty);
    }

    public List<Specialist> getAllSpecialists() {
        return specialistDAO.findAllWithUser();
    }

    public List<Specialist> filterSpecialistsBySpecialtyAndMaxFee(Specialty specialty, Double maxFee) {
        return specialistDAO.findBySpecialty(specialty)
                .stream()
                .filter(specialist -> specialist.getConsultationFee() <= maxFee)
                .sorted((s1, s2) -> s1.getConsultationFee().compareTo(s2.getConsultationFee()))
                .collect(Collectors.toList());
    }

    public List<ExpertiseRequest> filterExpertisesByStatusAndPriority(Specialist specialist, 
                                                                      ExpertiseStatus status, 
                                                                      Priority priority) {
        return expertiseRequestDAO.findBySpecialist(specialist)
                .stream()
                .filter(request -> status == null || request.getStatus().equals(status))
                .filter(request -> priority == null || request.getPriority().equals(priority))
                .sorted((r1, r2) -> {
                    int priorityCompare = r1.getPriority().compareTo(r2.getPriority());
                    if (priorityCompare != 0) return priorityCompare;
                    return r1.getCreatedAt().compareTo(r2.getCreatedAt());
                })
                .collect(Collectors.toList());
    }

    public Map<String, Object> getSpecialistStatistics(Specialist specialist) {
        List<ExpertiseRequest> allRequests = expertiseRequestDAO.findBySpecialist(specialist);
        
        long totalRequests = allRequests.size();
        long completedRequests = allRequests.stream()
                .filter(ExpertiseRequest::isCompleted)
                .count();
        
        double totalRevenue = allRequests.stream()
                .filter(ExpertiseRequest::isCompleted)
                .mapToDouble(request -> specialist.getConsultationFee())
                .sum();
        
        Map<Priority, Long> requestsByPriority = allRequests.stream()
                .collect(Collectors.groupingBy(
                    ExpertiseRequest::getPriority,
                    Collectors.counting()
                ));

        return Map.of(
            "totalRequests", totalRequests,
            "completedRequests", completedRequests,
            "pendingRequests", totalRequests - completedRequests,
            "totalRevenue", totalRevenue,
            "requestsByPriority", requestsByPriority
        );
    }

    public Double calculateTotalConsultationCost(List<ExpertiseRequest> expertiseRequests) {
        return expertiseRequests.stream()
                .filter(ExpertiseRequest::isCompleted)
                .mapToDouble(request -> request.getSpecialist().getConsultationFee())
                .sum();
    }


    public void updateTimeSlots(Specialist specialist, String slotDateStr, String startTimeStr, String endTimeStr) {
        LocalDate slotDate = LocalDate.parse(slotDateStr);
        LocalTime startTime = LocalTime.parse(startTimeStr);
        LocalTime endTime = LocalTime.parse(endTimeStr);

        if (slotDate.isBefore(LocalDate.now())) {
            throw new IllegalArgumentException("La date du créneau ne peut pas être dans le passé");
        }

        LocalTime currentTime = startTime;
        while (currentTime.isBefore(endTime)) {
            LocalTime slotEndTime = currentTime.plusMinutes(30);
            if (slotEndTime.isAfter(endTime)) {
                break;
            }

            TimeSlot timeSlot = new TimeSlot(specialist, slotDate, currentTime, slotEndTime);
            timeSlotDAO.save(timeSlot);

            currentTime = slotEndTime;
        }
    }
}