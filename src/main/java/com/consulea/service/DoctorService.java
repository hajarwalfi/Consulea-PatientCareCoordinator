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
import com.consulea.dao.MedicalActDAO;
import com.consulea.dao.ConsultationMedicalActDAO;
import com.consulea.entity.MedicalAct;
import com.consulea.entity.ConsultationMedicalAct;

import java.util.List;
import java.util.Optional;

public class DoctorService {

    private final ConsultationDAO consultationDAO;
    private final PatientDAO patientDAO;
    private final VitalSignsDAO vitalSignsDAO;
    private final MedicalActDAO medicalActDAO;
    private final ConsultationMedicalActDAO consultationMedicalActDAO;

    public DoctorService() {
        this.consultationDAO = new ConsultationDAO();
        this.patientDAO = new PatientDAO();
        this.vitalSignsDAO = new VitalSignsDAO();
        this.medicalActDAO = new MedicalActDAO();
        this.consultationMedicalActDAO = new ConsultationMedicalActDAO();
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

        // Mettre à jour le statut du patient
        patient.setStatus(PatientStatus.IN_CONSULTATION);
        patientDAO.update(patient);

        return consultationDAO.save(consultation);
    }

    public Consultation updateConsultationDiagnosisTreatment(Long consultationId, String diagnosis, String treatment) {
        Optional<Consultation> consultationOpt = consultationDAO.findById(consultationId);

        if (consultationOpt.isEmpty()) {
            throw new IllegalArgumentException("Consultation not found");
        }

        Consultation consultation = consultationOpt.get();
        consultation.setDiagnosis(diagnosis != null ? diagnosis.trim() : null);
        consultation.setTreatment(treatment != null ? treatment.trim() : null);

        return consultationDAO.update(consultation);
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

        // Mettre à jour le statut du patient
        Patient patient = consultation.getPatient();
        patient.setStatus(PatientStatus.COMPLETED);
        patientDAO.update(patient);

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

    public List<Consultation> getConsultationsInProgress() {
        return consultationDAO.findInProgress();
    }

    public List<Consultation> getConsultationsWaitingForSpecialist() {
        return consultationDAO.findWaitingForSpecialist();
    }

    public Optional<Consultation> getConsultationById(Long consultationId) {
        return consultationDAO.findById(consultationId);
    }

    public Double calculateConsultationTotalCost(Consultation consultation) {
        return consultation.getCost();
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

    public void removeMedicalActFromConsultation(Long consultationMedicalActId) {
        consultationMedicalActDAO.delete(consultationMedicalActId);
    }
}