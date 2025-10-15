package com.consulea.enums;

public enum Specialty {
    CARDIOLOGIE("Cardiologie", "Maladies du cœur et des vaisseaux sanguins (hypertension, insuffisance cardiaque, arythmie, infarctus)"),
    PNEUMOLOGIE("Pneumologie", "Maladies respiratoires et pulmonaires"),
    NEUROLOGIE("Neurologie", "Troubles du système nerveux"),
    GASTRO_ENTEROLOGIE("Gastro-entérologie", "Maladies du système digestif"),
    ENDOCRINOLOGIE("Endocrinologie", "Troubles hormonaux et métaboliques (diabète, problèmes thyroïdiens, obésité)"),
    DERMATOLOGIE("Dermatologie", "Maladies de la peau"),
    RHUMATOLOGIE("Rhumatologie", "Maladies des articulations, os et muscles"),
    PSYCHIATRIE("Psychiatrie", "Troubles mentaux et psychologiques (dépression, anxiété, addictions)"),
    NEPHROLOGIE("Néphrologie", "Maladies des reins (insuffisance rénale, infections urinaires complexes)"),
    ORTHOPEDIE("Orthopédie", "Traumatismes et pathologies des os, articulations et muscles");

    private final String displayName;
    private final String description;

    Specialty(String displayName, String description) {
        this.displayName = displayName;
        this.description = description;
    }

    public String getDisplayName() {
        return displayName;
    }

    public String getDescription() {
        return description;
    }
}