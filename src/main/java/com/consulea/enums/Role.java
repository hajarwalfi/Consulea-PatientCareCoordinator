package com.consulea.enums;

/**
 * Énumération des différents rôles possibles dans le système.
 * Chaque utilisateur a exactement un rôle qui détermine ses permissions.
 */
public enum Role {
    /**
     * Infirmier : peut enregistrer les patients et leurs signes vitaux.
     */
    INFIRMIER,

    /**
     * Médecin généraliste : peut créer des consultations et demander des expertises.
     */
    MEDECIN_GENERALISTE,

    /**
     * Médecin spécialiste : peut répondre aux demandes d'expertise.
     */
    MEDECIN_SPECIALISTE
}