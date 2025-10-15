package com.consulea.enums;

public enum Priority {
    URGENTE("Urgente"),
    NORMALE("Normale"), 
    NON_URGENTE("Non urgente");

    private final String displayName;

    Priority(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }

    public String getPriorityDisplay() {
        return displayName;
    }
}