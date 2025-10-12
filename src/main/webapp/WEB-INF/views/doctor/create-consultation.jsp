<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Créer une Consultation</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f7fa;
        }

        .navbar {
            background: linear-gradient(135deg, #2193b0 0%, #6dd5ed 100%);
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .navbar-brand {
            font-size: 24px;
            font-weight: bold;
        }

        .navbar-user {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .btn-back {
            background: rgba(255,255,255,0.2);
            color: white;
            padding: 8px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
        }

        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }

        .card {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            margin-bottom: 20px;
        }

        .card h2 {
            color: #333;
            margin-bottom: 20px;
        }

        .patient-info-card {
            background: #e3f2fd;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 30px;
        }

        .patient-info-card h3 {
            color: #2193b0;
            margin-bottom: 15px;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 15px;
        }

        .info-item {
            display: flex;
            flex-direction: column;
        }

        .info-label {
            font-weight: 600;
            color: #666;
            font-size: 12px;
            margin-bottom: 5px;
        }

        .info-value {
            color: #333;
            font-size: 14px;
        }

        .vital-signs {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            margin-top: 15px;
        }

        .vital-signs h4 {
            color: #333;
            margin-bottom: 10px;
            font-size: 14px;
        }

        .vital-signs-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 10px;
        }

        .vital-item {
            background: white;
            padding: 10px;
            border-radius: 5px;
            text-align: center;
        }

        .vital-item .label {
            font-size: 11px;
            color: #666;
        }

        .vital-item .value {
            font-size: 16px;
            font-weight: bold;
            color: #2193b0;
            margin-top: 5px;
        }

        .section-title {
            color: #2193b0;
            font-size: 18px;
            font-weight: 600;
            margin: 30px 0 15px 0;
            padding-bottom: 10px;
            border-bottom: 2px solid #e0e0e0;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 500;
        }

        .form-group .required {
            color: red;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 5px;
            font-size: 14px;
        }

        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }

        .form-actions {
            display: flex;
            gap: 15px;
            justify-content: flex-end;
            margin-top: 30px;
        }

        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
        }

        .btn-primary {
            background: #2193b0;
            color: white;
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .error-message {
            background: #fee;
            color: #c33;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #c33;
        }
    </style>
</head>
<body>
<nav class="navbar">
    <div class="navbar-brand">🏥 Consulea - Médecin Généraliste</div>
    <div class="navbar-user">
        <span>Dr. ${sessionScope.userName}</span>
        <a href="${pageContext.request.contextPath}/doctor/waiting-patients" class="btn-back">← Retour</a>
    </div>
</nav>

<div class="container">
    <c:if test="${not empty error}">
        <div class="error-message">${error}</div>
    </c:if>

    <c:if test="${not empty patient}">
        <div class="patient-info-card">
            <h3>📋 Informations du Patient</h3>
            <div class="info-grid">
                <div class="info-item">
                    <span class="info-label">Nom Complet</span>
                    <span class="info-value">${patient.fullName}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">Âge</span>
                    <span class="info-value">${patient.age} ans</span>
                </div>
                <div class="info-item">
                    <span class="info-label">Date de Naissance</span>
                    <span class="info-value">${patient.birthDate}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">N° Sécurité Sociale</span>
                    <span class="info-value">${patient.socialSecurityNumber}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">Téléphone</span>
                    <span class="info-value">${patient.phone != null ? patient.phone : '-'}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">Allergies</span>
                    <span class="info-value" style="color: red;">${patient.allergies != null ? patient.allergies : 'Aucune'}</span>
                </div>
            </div>

            <c:if test="${not empty vitalSignsList && vitalSignsList.size() > 0}">
                <div class="vital-signs">
                    <h4>💓 Derniers Signes Vitaux</h4>
                    <c:set var="latestVitals" value="${vitalSignsList[0]}"/>
                    <div class="vital-signs-grid">
                        <div class="vital-item">
                            <div class="label">Tension</div>
                            <div class="value">${latestVitals.bloodPressure}</div>
                        </div>
                        <div class="vital-item">
                            <div class="label">Fréquence Cardiaque</div>
                            <div class="value">${latestVitals.heartRate} bpm</div>
                        </div>
                        <div class="vital-item">
                            <div class="label">Température</div>
                            <div class="value">${latestVitals.temperature}°C</div>
                        </div>
                        <div class="vital-item">
                            <div class="label">Saturation O₂</div>
                            <div class="value">${latestVitals.oxygenSaturation}%</div>
                        </div>
                        <c:if test="${latestVitals.weight != null && latestVitals.height != null}">
                            <div class="vital-item">
                                <div class="label">IMC</div>
                                <div class="value">${String.format("%.1f", latestVitals.calculateBMI())}</div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </c:if>
        </div>
    </c:if>

    <div class="card">
        <h2>Créer une Consultation</h2>

        <form method="post" action="${pageContext.request.contextPath}/doctor/create-consultation">
            <input type="hidden" name="patientId" value="${patient.id}">

            <div class="section-title">📝 Motif de Consultation</div>
            <div class="form-group">
                <label for="chiefComplaint">Motif Principal <span class="required">*</span></label>
                <textarea id="chiefComplaint" name="chiefComplaint" required
                          placeholder="Ex: Douleurs abdominales depuis 2 jours..."></textarea>
            </div>

            <div class="section-title">🔍 Examen Clinique</div>
            <div class="form-group">
                <label for="symptoms">Symptômes</label>
                <textarea id="symptoms" name="symptoms"
                          placeholder="Décrivez les symptômes rapportés par le patient..."></textarea>
            </div>

            <div class="form-group">
                <label for="clinicalExamination">Examen Clinique</label>
                <textarea id="clinicalExamination" name="clinicalExamination"
                          placeholder="Observations de l'examen physique..."></textarea>
            </div>

            <div class="form-actions">
                <a href="${pageContext.request.contextPath}/doctor/waiting-patients"
                   class="btn btn-secondary">Annuler</a>
                <button type="submit" class="btn btn-primary">Créer la Consultation</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>