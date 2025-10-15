package com.consulea.enums;

public enum ExpertiseStatus {
    EN_ATTENTE("En attente"),
    TERMINEE("Terminée");

    private final String displayName;
    ExpertiseStatus(String displayName) {
        this.displayName = displayName;
    }
    public String getDisplayName() {
        return displayName;
    }
    public String getStatusDisplay() {
        return displayName;
    }
}