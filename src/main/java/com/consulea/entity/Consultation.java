package com.consulea.entity;

import com.consulea.enums.ConsultationStatus;
import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "consultations")
public class Consultation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "patientId", nullable = false)
    private Patient patient;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "doctorId", nullable = false)
    private User doctor;

    @Column(nullable = false, length = 500)
    private String chiefComplaint;

    @Column(length = 2000)
    private String clinicalExamination;

    @Column(length = 2000)
    private String symptoms;

    @Column(length = 1000)
    private String diagnosis;

    @Column(length = 2000)
    private String treatment;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 50)
    private ConsultationStatus status;

    @Column(nullable = false)
    private Double cost = 150.0;

    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column
    private LocalDateTime completedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        if (status == null) {
            status = ConsultationStatus.IN_PROGRESS;
        }
    }

    public Consultation() {
    }

    public Consultation(Patient patient, User doctor, String chiefComplaint) {
        this.patient = patient;
        this.doctor = doctor;
        this.chiefComplaint = chiefComplaint;
        this.status = ConsultationStatus.IN_PROGRESS;
        this.cost = 150.0;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Patient getPatient() {
        return patient;
    }

    public void setPatient(Patient patient) {
        this.patient = patient;
    }

    public User getDoctor() {
        return doctor;
    }

    public void setDoctor(User doctor) {
        this.doctor = doctor;
    }

    public String getChiefComplaint() {
        return chiefComplaint;
    }

    public void setChiefComplaint(String chiefComplaint) {
        this.chiefComplaint = chiefComplaint;
    }

    public String getClinicalExamination() {
        return clinicalExamination;
    }

    public void setClinicalExamination(String clinicalExamination) {
        this.clinicalExamination = clinicalExamination;
    }

    public String getSymptoms() {
        return symptoms;
    }

    public void setSymptoms(String symptoms) {
        this.symptoms = symptoms;
    }

    public String getDiagnosis() {
        return diagnosis;
    }

    public void setDiagnosis(String diagnosis) {
        this.diagnosis = diagnosis;
    }

    public String getTreatment() {
        return treatment;
    }

    public void setTreatment(String treatment) {
        this.treatment = treatment;
    }

    public ConsultationStatus getStatus() {
        return status;
    }

    public void setStatus(ConsultationStatus status) {
        this.status = status;
    }


    public void setCost(Double cost) {
        this.cost = cost;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public Date getCreatedAtAsDate() {
        if (this.createdAt == null) {
            return null;
        }
        return Date.from(this.createdAt.atZone(ZoneId.systemDefault()).toInstant());
    }

    public LocalDateTime getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(LocalDateTime completedAt) {
        this.completedAt = completedAt;
    }

    public void complete() {
        this.status = ConsultationStatus.COMPLETED;
        this.completedAt = LocalDateTime.now();
    }

    public void requestSpecialistOpinion() {
        this.status = ConsultationStatus.WAITING_FOR_SPECIALIST_OPINION;
    }

    public boolean isCompleted() {
        return status == ConsultationStatus.COMPLETED;
    }

    public boolean isWaitingForSpecialist() {
        return status == ConsultationStatus.WAITING_FOR_SPECIALIST_OPINION;
    }

    @Override
    public String toString() {
        return "Consultation{" +
                "id=" + id +
                ", patientId=" + (patient != null ? patient.getId() : null) +
                ", doctorId=" + (doctor != null ? doctor.getId() : null) +
                ", status=" + status +
                ", cost=" + cost +
                ", createdAt=" + createdAt +
                '}';
    }

    @OneToMany(mappedBy = "consultation", cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    private List<ConsultationMedicalAct> medicalActs = new ArrayList<>();

    public List<ConsultationMedicalAct> getMedicalActs() {
        return medicalActs;
    }

    public void setMedicalActs(List<ConsultationMedicalAct> medicalActs) {
        this.medicalActs = medicalActs;
    }

    public void addMedicalAct(MedicalAct medicalAct) {
        ConsultationMedicalAct consultationMedicalAct = new ConsultationMedicalAct(this, medicalAct);
        this.medicalActs.add(consultationMedicalAct);
    }

    public Double getCost() {
        double totalCost = this.cost;

        if (medicalActs != null && !medicalActs.isEmpty()) {
            totalCost += medicalActs.stream()
                    .mapToDouble(ConsultationMedicalAct::getTotalPrice)
                    .sum();
        }

        return totalCost;
    }
}