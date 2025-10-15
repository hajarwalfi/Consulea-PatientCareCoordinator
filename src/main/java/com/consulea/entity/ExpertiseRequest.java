package com.consulea.entity;

import com.consulea.enums.ExpertiseStatus;
import com.consulea.enums.Priority;
import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "expertise_requests")
public class ExpertiseRequest {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    @JoinColumn(name = "consultation_id", referencedColumnName = "id", unique = true)
    private Consultation consultation;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "requesting_doctor_id", nullable = false)
    private User requestingDoctor;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "specialist_id", nullable = false)
    private Specialist specialist;

    @OneToOne
    @JoinColumn(name = "time_slot_id", referencedColumnName = "id")
    private TimeSlot timeSlot;

    @Column(name = "question", columnDefinition = "TEXT", nullable = false)
    private String question;

    @Column(name = "clinical_data", columnDefinition = "TEXT")
    private String clinicalData;

    @Enumerated(EnumType.STRING)
    @Column(name = "priority", nullable = false)
    private Priority priority;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private ExpertiseStatus status = ExpertiseStatus.EN_ATTENTE;

    @Column(name = "specialist_response", columnDefinition = "TEXT")
    private String specialistResponse;

    @Column(name = "recommendations", columnDefinition = "TEXT")
    private String recommendations;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @Column(name = "completed_at")
    private LocalDateTime completedAt;

    public ExpertiseRequest() {
        this.createdAt = LocalDateTime.now();
    }

    public ExpertiseRequest(Consultation consultation, User requestingDoctor, Specialist specialist, 
                           String question, Priority priority, TimeSlot timeSlot) {
        this();
        this.consultation = consultation;
        this.requestingDoctor = requestingDoctor;
        this.specialist = specialist;
        this.question = question;
        this.priority = priority;
        this.timeSlot = timeSlot;
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

    public User getRequestingDoctor() {
        return requestingDoctor;
    }

    public void setRequestingDoctor(User requestingDoctor) {
        this.requestingDoctor = requestingDoctor;
    }

    public Specialist getSpecialist() {
        return specialist;
    }

    public void setSpecialist(Specialist specialist) {
        this.specialist = specialist;
    }

    public TimeSlot getTimeSlot() {
        return timeSlot;
    }

    public void setTimeSlot(TimeSlot timeSlot) {
        this.timeSlot = timeSlot;
    }

    public String getQuestion() {
        return question;
    }

    public void setQuestion(String question) {
        this.question = question;
    }

    public String getClinicalData() {
        return clinicalData;
    }

    public void setClinicalData(String clinicalData) {
        this.clinicalData = clinicalData;
    }

    public Priority getPriority() {
        return priority;
    }

    public void setPriority(Priority priority) {
        this.priority = priority;
    }

    public ExpertiseStatus getStatus() {
        return status;
    }

    public void setStatus(ExpertiseStatus status) {
        this.status = status;
    }

    public String getSpecialistResponse() {
        return specialistResponse;
    }

    public void setSpecialistResponse(String specialistResponse) {
        this.specialistResponse = specialistResponse;
    }

    public String getRecommendations() {
        return recommendations;
    }

    public void setRecommendations(String recommendations) {
        this.recommendations = recommendations;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(LocalDateTime completedAt) {
        this.completedAt = completedAt;
    }

    public void complete(String response, String recommendations) {
        this.specialistResponse = response;
        this.recommendations = recommendations;
        this.status = ExpertiseStatus.TERMINEE;
        this.completedAt = LocalDateTime.now();
    }

    public boolean isCompleted() {
        return status == ExpertiseStatus.TERMINEE;
    }

    public String getPriorityDisplay() {
        return priority != null ? priority.getDisplayName() : "";
    }

    public String getStatusDisplay() {
        return status != null ? status.getDisplayName() : "";
    }

    @Override
    public String toString() {
        return "ExpertiseRequest{" +
                "id=" + id +
                ", priority=" + priority +
                ", status=" + status +
                ", specialist=" + (specialist != null ? specialist.getDisplayName() : "null") +
                '}';
    }
}