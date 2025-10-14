package com.consulea.service;

import com.consulea.dao.PatientDAO;
import com.consulea.dao.VitalSignsDAO;
import com.consulea.entity.Patient;
import com.consulea.entity.User;
import com.consulea.entity.VitalSigns;
import com.consulea.enums.PatientStatus;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public class NurseService {

    private final PatientDAO patientDAO;
    private final VitalSignsDAO vitalSignsDAO;

    public NurseService() {
        this.patientDAO = new PatientDAO();
        this.vitalSignsDAO = new VitalSignsDAO();
    }

    public Optional<Patient> findPatientBySocialSecurityNumber(String ssn) {
        if (ssn == null || ssn.trim().isEmpty()) {
            return Optional.empty();
        }
        return patientDAO.findBySocialSecurityNumber(ssn.trim());
    }

    public Optional<Patient> findPatientById(Long patientId) {
        if (patientId == null) {
            return Optional.empty();
        }
        return patientDAO.findById(patientId);
    }

    public Patient registerNewPatient(String lastName, String firstName, LocalDate birthDate,
                                      String socialSecurityNumber, String phone, String address,
                                      String medicalHistory, String currentTreatments, String allergies) {

        if (lastName == null || lastName.trim().isEmpty()) {
            throw new IllegalArgumentException("Last name cannot be empty");
        }
        if (firstName == null || firstName.trim().isEmpty()) {
            throw new IllegalArgumentException("First name cannot be empty");
        }
        if (socialSecurityNumber == null || socialSecurityNumber.trim().isEmpty()) {
            throw new IllegalArgumentException("Social security number cannot be empty");
        }

        if (patientDAO.existsBySocialSecurityNumber(socialSecurityNumber.trim())) {
            throw new IllegalArgumentException("A patient with this social security number already exists");
        }

        Patient patient = new Patient(lastName.trim(), firstName.trim(), birthDate, socialSecurityNumber.trim());
        patient.setPhone(phone != null ? phone.trim() : null);
        patient.setAddress(address != null ? address.trim() : null);
        patient.setMedicalHistory(medicalHistory != null ? medicalHistory.trim() : null);
        patient.setCurrentTreatments(currentTreatments != null ? currentTreatments.trim() : null);
        patient.setAllergies(allergies != null ? allergies.trim() : null);

        return patientDAO.save(patient);
    }

    public VitalSigns recordVitalSigns(Patient patient, User nurse,
                                       String bloodPressure, Integer heartRate, Double temperature,
                                       Integer respiratoryRate, Double weight, Double height,
                                       Integer oxygenSaturation, String observations) {

        if (patient == null) {
            throw new IllegalArgumentException("Patient cannot be null");
        }
        if (nurse == null) {
            throw new IllegalArgumentException("Nurse cannot be null");
        }

        VitalSigns vitalSigns = new VitalSigns();
        vitalSigns.setPatient(patient);
        vitalSigns.setMeasuredBy(nurse);
        vitalSigns.setBloodPressure(bloodPressure);
        vitalSigns.setHeartRate(heartRate);
        vitalSigns.setTemperature(temperature);
        vitalSigns.setRespiratoryRate(respiratoryRate);
        vitalSigns.setWeight(weight);
        vitalSigns.setHeight(height);
        vitalSigns.setOxygenSaturation(oxygenSaturation);
        vitalSigns.setObservations(observations);

        return vitalSignsDAO.save(vitalSigns);
    }

    public Patient registerPatientWithVitalSigns(String lastName, String firstName, LocalDate birthDate,
                                                 String socialSecurityNumber, String phone, String address,
                                                 String medicalHistory, String currentTreatments, String allergies,
                                                 User nurse, String bloodPressure, Integer heartRate,
                                                 Double temperature, Integer respiratoryRate,
                                                 Double weight, Double height, Integer oxygenSaturation,
                                                 String observations) {

        Patient patient = registerNewPatient(lastName, firstName, birthDate, socialSecurityNumber,
                phone, address, medicalHistory, currentTreatments, allergies);

        recordVitalSigns(patient, nurse, bloodPressure, heartRate, temperature, respiratoryRate,
                weight, height, oxygenSaturation, observations);

        return patient;
    }

    public List<Patient> getTodayPatients() {
        List<Patient> patients = patientDAO.findRegisteredToday();
        
        return patients.stream()
                .sorted((p1, p2) -> p1.getRegisteredAt().compareTo(p2.getRegisteredAt()))
                .collect(java.util.stream.Collectors.toList());
    }

    public List<Patient> getTodayPatientsWithVitalSigns() {
        return getTodayPatients();
    }

    public List<VitalSigns> getPatientVitalSigns(Patient patient) {
        return vitalSignsDAO.findByPatient(patient);
    }

    public VitalSigns getLatestVitalSigns(Patient patient) {
        List<VitalSigns> vitalSignsList = vitalSignsDAO.findByPatient(patient);

        return vitalSignsList.stream()
                .sorted((v1, v2) -> v2.getMeasuredAt().compareTo(v1.getMeasuredAt()))
                .findFirst()
                .orElse(null);
    }

    public Patient updatePatientStatus(Long patientId, PatientStatus status) {
        Optional<Patient> patientOpt = patientDAO.findById(patientId);
        if (patientOpt.isEmpty()) {
            throw new IllegalArgumentException("Patient not found");
        }
        
        Patient patient = patientOpt.get();
        patient.setStatus(status);
        return patientDAO.update(patient);
    }

    public VitalSigns updateVitalSigns(Patient patient, User nurse,
                                      String bloodPressure, Integer heartRate, Double temperature,
                                      Integer respiratoryRate, Double weight, Double height,
                                      Integer oxygenSaturation, String observations) {

        if (patient == null) {
            throw new IllegalArgumentException("Patient cannot be null");
        }
        if (nurse == null) {
            throw new IllegalArgumentException("Nurse cannot be null");
        }

        VitalSigns existingVitalSigns = getLatestVitalSigns(patient);

        if (existingVitalSigns != null) {
            if (bloodPressure != null && !bloodPressure.trim().isEmpty()) {
                existingVitalSigns.setBloodPressure(bloodPressure.trim());
            }
            if (heartRate != null) {
                existingVitalSigns.setHeartRate(heartRate);
            }
            if (temperature != null) {
                existingVitalSigns.setTemperature(temperature);
            }
            if (respiratoryRate != null) {
                existingVitalSigns.setRespiratoryRate(respiratoryRate);
            }
            if (weight != null) {
                existingVitalSigns.setWeight(weight);
            }
            if (height != null) {
                existingVitalSigns.setHeight(height);
            }
            if (oxygenSaturation != null) {
                existingVitalSigns.setOxygenSaturation(oxygenSaturation);
            }
            if (observations != null && !observations.trim().isEmpty()) {
                existingVitalSigns.setObservations(observations.trim());
            }

            existingVitalSigns.setMeasuredBy(nurse);
            existingVitalSigns.setMeasuredAt(java.time.LocalDateTime.now());

            return vitalSignsDAO.update(existingVitalSigns);
        } else {
            return recordVitalSigns(patient, nurse, bloodPressure, heartRate, temperature,
                    respiratoryRate, weight, height, oxygenSaturation, observations);
        }
    }
}