package com.consulea.service;

import com.consulea.dao.ConsultationDAO;
import com.consulea.dao.PatientDAO;
import com.consulea.dao.VitalSignsDAO;
import com.consulea.entity.Consultation;
import com.consulea.entity.Patient;
import com.consulea.entity.User;
import com.consulea.entity.VitalSigns;
import com.consulea.enums.ConsultationStatus;
import com.consulea.enums.PatientStatus;
import com.consulea.enums.ExpertiseStatus;
import com.consulea.dao.MedicalActDAO;
import com.consulea.dao.ConsultationMedicalActDAO;
import com.consulea.entity.MedicalAct;
import com.consulea.entity.ConsultationMedicalAct;
import com.consulea.dao.SpecialistDAO;
import com.consulea.dao.ExpertiseRequestDAO;
import com.consulea.dao.TimeSlotDAO;
import com.consulea.entity.Specialist;
import com.consulea.entity.ExpertiseRequest;
import com.consulea.entity.TimeSlot;
import com.consulea.enums.Specialty;
import com.consulea.enums.Priority;

import java.util.List;
import java.util.Optional;

public class DoctorService {

    private final ConsultationDAO consultationDAO;
    private final PatientDAO patientDAO;
    private final VitalSignsDAO vitalSignsDAO;
    private final MedicalActDAO medicalActDAO;
    private final ConsultationMedicalActDAO consultationMedicalActDAO;
    private final SpecialistDAO specialistDAO;
    private final ExpertiseRequestDAO expertiseRequestDAO;
    private final TimeSlotDAO timeSlotDAO;

    public DoctorService() {
        this.consultationDAO = new ConsultationDAO();
        this.patientDAO = new PatientDAO();
        this.vitalSignsDAO = new VitalSignsDAO();
        this.medicalActDAO = new MedicalActDAO();
        this.consultationMedicalActDAO = new ConsultationMedicalActDAO();
        this.specialistDAO = new SpecialistDAO();
        this.expertiseRequestDAO = new ExpertiseRequestDAO();
        this.timeSlotDAO = new TimeSlotDAO();
    }

    public List<Patient> getWaitingPatients() {
        return patientDAO.findRegisteredToday();
    }

    public Optional<Patient> getPatientById(Long patientId) {
        return patientDAO.findById(patientId);
    }

    public List<VitalSigns> getPatientVitalSigns(Long patientId) {
        return vitalSignsDAO.findByPatientId(patientId);
    }

    public Consultation createConsultation(Patient patient, User doctor, String chiefComplaint,
                                           String symptoms, String clinicalExamination) {

        if (patient == null) {
            throw new IllegalArgumentException("Patient cannot be null");
        }
        if (doctor == null) {
            throw new IllegalArgumentException("Doctor cannot be null");
        }
        if (chiefComplaint == null || chiefComplaint.trim().isEmpty()) {
            throw new IllegalArgumentException("Chief complaint cannot be empty");
        }

        Consultation consultation = new Consultation(patient, doctor, chiefComplaint.trim());
        consultation.setSymptoms(symptoms != null ? symptoms.trim() : null);
        consultation.setClinicalExamination(clinicalExamination != null ? clinicalExamination.trim() : null);


        patient.setStatus(PatientStatus.IN_CONSULTATION);
        patientDAO.update(patient);

        return consultationDAO.save(consultation);
    }


    public Consultation completeConsultation(Long consultationId, String diagnosis, String treatment) {
        Optional<Consultation> consultationOpt = consultationDAO.findById(consultationId);

        if (consultationOpt.isEmpty()) {
            throw new IllegalArgumentException("Consultation not found");
        }

        Consultation consultation = consultationOpt.get();
        consultation.setDiagnosis(diagnosis != null ? diagnosis.trim() : null);
        consultation.setTreatment(treatment != null ? treatment.trim() : null);
        consultation.complete();


        Patient patient = consultation.getPatient();
        patient.setStatus(PatientStatus.COMPLETED);
        patientDAO.update(patient);

        return consultationDAO.update(consultation);
    }

    public Consultation updateConsultation(Consultation consultation) {
        if (consultation == null) {
            throw new IllegalArgumentException("Consultation cannot be null");
        }
        return consultationDAO.update(consultation);
    }

    public Consultation requestSpecialistOpinion(Long consultationId) {
        Optional<Consultation> consultationOpt = consultationDAO.findById(consultationId);

        if (consultationOpt.isEmpty()) {
            throw new IllegalArgumentException("Consultation not found");
        }

        Consultation consultation = consultationOpt.get();
        consultation.requestSpecialistOpinion();

        return consultationDAO.update(consultation);
    }

    public List<Consultation> getDoctorConsultations(User doctor) {
        return consultationDAO.findByDoctor(doctor);
    }

    public List<Consultation> getPatientConsultations(Patient patient) {
        return consultationDAO.findByPatient(patient);
    }


    public List<Consultation> getDoctorConsultationsInProgress(User doctor) {
        return consultationDAO.findInProgressByDoctor(doctor);
    }

    public List<Consultation> getDoctorConsultationsWaitingForSpecialist(User doctor) {
        return consultationDAO.findWaitingForSpecialistByDoctor(doctor);
    }

    public List<Consultation> getDoctorCompletedConsultations(User doctor) {
        return consultationDAO.findCompletedByDoctor(doctor);
    }

    public Optional<Consultation> getConsultationById(Long consultationId) {
        return consultationDAO.findById(consultationId);
    }

    public List<MedicalAct> getAllMedicalActs() {
        return medicalActDAO.findAll();
    }

    public void addMedicalActToConsultation(Long consultationId, Long medicalActId) {
        Optional<Consultation> consultationOpt = consultationDAO.findById(consultationId);
        Optional<MedicalAct> medicalActOpt = medicalActDAO.findById(medicalActId);

        if (consultationOpt.isEmpty()) {
            throw new IllegalArgumentException("Consultation not found");
        }
        if (medicalActOpt.isEmpty()) {
            throw new IllegalArgumentException("Medical act not found");
        }

        Consultation consultation = consultationOpt.get();
        MedicalAct medicalAct = medicalActOpt.get();

        ConsultationMedicalAct consultationMedicalAct = new ConsultationMedicalAct(consultation, medicalAct);
        consultationMedicalActDAO.save(consultationMedicalAct);
    }

    public List<ConsultationMedicalAct> getConsultationMedicalActs(Long consultationId) {
        return consultationMedicalActDAO.findByConsultationId(consultationId);
    }

    public Optional<ExpertiseRequest> getExpertiseRequestsByConsultation(Long consultationId) {
        return expertiseRequestDAO.findByConsultationId(consultationId);
    }


    public List<Specialist> findSpecialistsBySpecialty(Specialty specialty) {

        return specialistDAO.findAllWithUser()
                .stream()
                .filter(specialist -> specialist.getSpecialty().equals(specialty))
                .sorted((s1, s2) -> s1.getConsultationFee().compareTo(s2.getConsultationFee()))
                .collect(java.util.stream.Collectors.toList());
    }

    public Optional<Specialist> getSpecialistById(Long specialistId) {
        return specialistDAO.findById(specialistId);
    }


    public List<Specialist> findSpecialistsBySpecialtyAndMaxFee(Specialty specialty, Double maxFee) {
        return specialistDAO.findAllWithUser()
                .stream()
                .filter(specialist -> specialist.getSpecialty().equals(specialty))
                .filter(specialist -> specialist.getConsultationFee() <= maxFee)
                .sorted((s1, s2) -> s1.getConsultationFee().compareTo(s2.getConsultationFee()))
                .collect(java.util.stream.Collectors.toList());
    }


    public List<Specialist> findMostAffordableSpecialistsBySpecialty(Specialty specialty, int limit) {
        return specialistDAO.findAllWithUser()
                .stream()
                .filter(specialist -> specialist.getSpecialty().equals(specialty))
                .sorted((s1, s2) -> s1.getConsultationFee().compareTo(s2.getConsultationFee()))
                .limit(limit)
                .collect(java.util.stream.Collectors.toList());
    }

    public List<TimeSlot> getAllTimeSlots(Specialist specialist) {
        return timeSlotDAO.findBySpecialist(specialist);
    }

    public List<TimeSlot> getAvailableTimeSlots(Specialist specialist) {

        return timeSlotDAO.findAvailableBySpecialist(specialist);
    }

    public ExpertiseRequest createExpertiseRequest(Long consultationId, User requestingDoctor, 
                                                   Long specialistId, Long timeSlotId, 
                                                   String question, String clinicalData, Priority priority) {
        
        Optional<Consultation> consultationOpt = consultationDAO.findById(consultationId);
        Optional<Specialist> specialistOpt = specialistDAO.findById(specialistId);
        Optional<TimeSlot> timeSlotOpt = timeSlotDAO.findById(timeSlotId);

        if (consultationOpt.isEmpty()) {
            throw new IllegalArgumentException("Consultation non trouvée");
        }
        if (specialistOpt.isEmpty()) {
            throw new IllegalArgumentException("Spécialiste non trouvé");
        }
        if (timeSlotOpt.isEmpty()) {
            throw new IllegalArgumentException("Créneau non trouvé");
        }

        Consultation consultation = consultationOpt.get();
        Specialist specialist = specialistOpt.get();
        TimeSlot timeSlot = timeSlotOpt.get();


        if (!timeSlot.getIsAvailable() || timeSlot.isBooked()) {
            throw new IllegalArgumentException("Le créneau sélectionné n'est plus disponible");
        }


        ExpertiseRequest expertiseRequest = new ExpertiseRequest(consultation, requestingDoctor, specialist, question, priority, timeSlot);
        expertiseRequest.setClinicalData(clinicalData);

        ExpertiseRequest savedRequest = expertiseRequestDAO.save(expertiseRequest);


        timeSlot.setExpertiseRequest(savedRequest);
        timeSlot.setIsAvailable(false);
        timeSlotDAO.update(timeSlot);


        consultation.setStatus(ConsultationStatus.WAITING_FOR_SPECIALIST_OPINION);
        consultationDAO.update(consultation);

        return savedRequest;
    }

    public List<ExpertiseRequest> getDoctorExpertiseRequests(User doctor) {
        return expertiseRequestDAO.findByRequestingDoctor(doctor);
    }


    public List<ExpertiseRequest> getDoctorCompletedExpertiseRequests(User doctor) {
        return expertiseRequestDAO.findByRequestingDoctor(doctor)
                .stream()
                .filter(request -> request.getStatus() == ExpertiseStatus.TERMINEE)
                .sorted((r1, r2) -> r2.getCompletedAt().compareTo(r1.getCompletedAt())) // Plus récentes en premier
                .collect(java.util.stream.Collectors.toList());
    }


    public List<ExpertiseRequest> getDoctorPendingExpertiseRequests(User doctor) {
        return expertiseRequestDAO.findByRequestingDoctor(doctor)
                .stream()
                .filter(request -> request.getStatus() == ExpertiseStatus.EN_ATTENTE)
                .sorted((r1, r2) -> r2.getCreatedAt().compareTo(r1.getCreatedAt())) // Plus récentes en premier
                .collect(java.util.stream.Collectors.toList());
    }

    public Optional<TimeSlot> getTimeSlotById(Long timeSlotId) {
        return timeSlotDAO.findById(timeSlotId);
    }


    public void createTimeSlotsForSpecialist(Long specialistId) {
        Optional<Specialist> specialistOpt = specialistDAO.findById(specialistId);
        if (specialistOpt.isPresent()) {
            Specialist specialist = specialistOpt.get();
            

            List<TimeSlot> existingSlots = timeSlotDAO.findBySpecialist(specialist);
            if (existingSlots.isEmpty()) {
                timeSlotDAO.initializeDefaultTimeSlots(specialist);
            }
        }
    }

    public Optional<ExpertiseRequest> getExpertiseRequestById(Long requestId) {
        return expertiseRequestDAO.findById(requestId);
    }


    public Optional<ExpertiseRequest> getExpertiseRequestByConsultation(Long consultationId) {
        return expertiseRequestDAO.findByConsultationId(consultationId);
    }


    public void removeMedicalActFromConsultation(Long consultationMedicalActId) {
        consultationMedicalActDAO.delete(consultationMedicalActId);
    }


    public Double calculateConsultationTotalCost(Consultation consultation) {
        Double baseCost = consultation.getCost(); // Coût de base + actes médicaux
        

        List<ExpertiseRequest> expertiseRequests = expertiseRequestDAO.findByRequestingDoctor(consultation.getDoctor());
        
        Double expertiseCost = expertiseRequests.stream()
            .filter(request -> request.getConsultation().getId().equals(consultation.getId()) && request.isCompleted())
            .mapToDouble(request -> request.getSpecialist().getConsultationFee())
            .sum();
        
        return baseCost + expertiseCost;
    }

}