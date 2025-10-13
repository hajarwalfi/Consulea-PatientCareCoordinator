package com.consulea.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "consultation_medical_acts")
public class ConsultationMedicalAct {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "consultation_id", nullable = false)
    private Consultation consultation;

    @ManyToOne
    @JoinColumn(name = "medical_act_id", nullable = false)
    private MedicalAct medicalAct;

    @Column(nullable = false)
    private Integer quantity = 1;

    public ConsultationMedicalAct() {
    }

    public ConsultationMedicalAct(Consultation consultation, MedicalAct medicalAct) {
        this.consultation = consultation;
        this.medicalAct = medicalAct;
        this.quantity = 1;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Consultation getConsultation() {
        return consultation;
    }

    public void setConsultation(Consultation consultation) {
        this.consultation = consultation;
    }

    public MedicalAct getMedicalAct() {
        return medicalAct;
    }

    public void setMedicalAct(MedicalAct medicalAct) {
        this.medicalAct = medicalAct;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public Double getTotalPrice() {
        return medicalAct.getPrice() * quantity;
    }
}