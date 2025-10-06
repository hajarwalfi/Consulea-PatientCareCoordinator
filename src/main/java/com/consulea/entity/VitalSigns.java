package com.consulea.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "vitalSigns")
public class VitalSigns {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "patientId", nullable = false)
    private Patient patient;

    @Column(length = 20)
    private String bloodPressure;

    @Column
    private Integer heartRate;

    @Column
    private Double temperature;

    @Column
    private Integer respiratoryRate;

    @Column
    private Double weight;

    @Column
    private Double height;

    @Column
    private Integer oxygenSaturation;

    @Column(nullable = false, updatable = false)
    private LocalDateTime measuredAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "measuredById")
    private User measuredBy;

    @Column(length = 500)
    private String observations;

    @PrePersist
    protected void onCreate() {
        measuredAt = LocalDateTime.now();
    }

    public VitalSigns() {
    }

    public VitalSigns(Patient patient, String bloodPressure, Integer heartRate,
                      Double temperature, Integer respiratoryRate) {
        this.patient = patient;
        this.bloodPressure = bloodPressure;
        this.heartRate = heartRate;
        this.temperature = temperature;
        this.respiratoryRate = respiratoryRate;
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

    public String getBloodPressure() {
        return bloodPressure;
    }

    public void setBloodPressure(String bloodPressure) {
        this.bloodPressure = bloodPressure;
    }

    public Integer getHeartRate() {
        return heartRate;
    }

    public void setHeartRate(Integer heartRate) {
        this.heartRate = heartRate;
    }

    public Double getTemperature() {
        return temperature;
    }

    public void setTemperature(Double temperature) {
        this.temperature = temperature;
    }

    public Integer getRespiratoryRate() {
        return respiratoryRate;
    }

    public void setRespiratoryRate(Integer respiratoryRate) {
        this.respiratoryRate = respiratoryRate;
    }

    public Double getWeight() {
        return weight;
    }

    public void setWeight(Double weight) {
        this.weight = weight;
    }

    public Double getHeight() {
        return height;
    }

    public void setHeight(Double height) {
        this.height = height;
    }

    public Integer getOxygenSaturation() {
        return oxygenSaturation;
    }

    public void setOxygenSaturation(Integer oxygenSaturation) {
        this.oxygenSaturation = oxygenSaturation;
    }

    public LocalDateTime getMeasuredAt() {
        return measuredAt;
    }

    public void setMeasuredAt(LocalDateTime measuredAt) {
        this.measuredAt = measuredAt;
    }

    public User getMeasuredBy() {
        return measuredBy;
    }

    public void setMeasuredBy(User measuredBy) {
        this.measuredBy = measuredBy;
    }

    public String getObservations() {
        return observations;
    }

    public void setObservations(String observations) {
        this.observations = observations;
    }

    public Double calculateBMI() {
        if (weight == null || height == null || height == 0) {
            return null;
        }
        double heightInMeters = height / 100.0;
        return weight / (heightInMeters * heightInMeters);
    }

    public boolean isCritical() {
        if (bloodPressure != null) {
            String[] parts = bloodPressure.split("/");
            if (parts.length == 2) {
                try {
                    int systolic = Integer.parseInt(parts[0].trim());
                    int diastolic = Integer.parseInt(parts[1].trim());
                    if (systolic > 180 || systolic < 90 || diastolic > 120 || diastolic < 60) {
                        return true;
                    }
                } catch (NumberFormatException e) {
                }
            }
        }

        if (heartRate != null && (heartRate > 120 || heartRate < 50)) {
            return true;
        }

        if (temperature != null && (temperature > 39.0 || temperature < 35.0)) {
            return true;
        }

        if (oxygenSaturation != null && oxygenSaturation < 90) {
            return true;
        }

        return false;
    }

    @Override
    public String toString() {
        return "VitalSigns{" +
                "id=" + id +
                ", patientId=" + (patient != null ? patient.getId() : null) +
                ", bloodPressure='" + bloodPressure + '\'' +
                ", heartRate=" + heartRate +
                ", temperature=" + temperature +
                ", measuredAt=" + measuredAt +
                '}';
    }
}