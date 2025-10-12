package com.consulea.enums;

public enum PatientStatus {
    WAITING("En attente"),
    IN_CONSULTATION("En consultation"),
    COMPLETED("Consultation terminée");

    private final String displayName;

    PatientStatus(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}