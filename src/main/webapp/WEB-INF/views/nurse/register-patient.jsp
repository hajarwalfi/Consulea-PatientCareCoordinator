<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enregistrer un Patient - Infirmier</title>
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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
            transition: background 0.3s;
        }

        .btn-back:hover {
            background: rgba(255,255,255,0.3);
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
            font-size: 24px;
        }

        .error-message {
            background: #fee;
            color: #c33;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #c33;
        }

        .success-message {
            background: #d4edda;
            color: #155724;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #28a745;
        }

        .info-message {
            background: #d1ecf1;
            color: #0c5460;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #17a2b8;
        }

        .search-section {
            margin-bottom: 30px;
        }

        .search-box {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }

        .search-box input {
            flex: 1;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 5px;
            font-size: 14px;
        }

        .search-box button {
            padding: 12px 30px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 600;
            transition: background 0.3s;
        }

        .search-box button:hover {
            background: #5568d3;
        }

        .section-title {
            color: #667eea;
            font-size: 18px;
            font-weight: 600;
            margin: 30px 0 15px 0;
            padding-bottom: 10px;
            border-bottom: 2px solid #e0e0e0;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
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

        .form-group label .required {
            color: red;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 5px;
            font-size: 14px;
            transition: border-color 0.3s;
        }

        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #667eea;
        }

        .form-group textarea {
            resize: vertical;
            min-height: 80px;
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
            font-size: 14px;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background: #5a6268;
        }

        .patient-info-card {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
        }

        .patient-info-card h3 {
            color: #667eea;
            margin-bottom: 15px;
        }

        .info-row {
            display: grid;
            grid-template-columns: 200px 1fr;
            padding: 8px 0;
            border-bottom: 1px solid #e0e0e0;
        }

        .info-row:last-child {
            border-bottom: none;
        }

        .info-label {
            font-weight: 600;
            color: #666;
        }

        .info-value {
            color: #333;
        }

        label small {
            color: #28a745;
            font-weight: normal;
            font-style: italic;
        }
    </style>
</head>
<body>
<nav class="navbar">
    <div class="navbar-brand">🏥 Consulea - Infirmier</div>
    <div class="navbar-user">
        <span>Bonjour, ${sessionScope.userName}</span>
        <a href="${pageContext.request.contextPath}/nurse/dashboard" class="btn-back">← Retour</a>
    </div>
</nav>

<div class="container">
    <div class="card">
        <h2>Enregistrer un Patient</h2>

        <c:if test="${not empty error}">
            <div class="error-message">${error}</div>
        </c:if>

        <c:if test="${not empty message}">
            <div class="info-message">${message}</div>
        </c:if>

        <!-- Search Patient Section -->
        <div class="search-section">
            <p style="color: #666; margin-bottom: 10px;">
                Recherchez d'abord si le patient existe déjà dans le système
            </p>
            <form method="post" action="${pageContext.request.contextPath}/nurse/search-patient" class="search-box">
                <input type="text"
                       name="socialSecurityNumber"
                       placeholder="Entrez le numéro de sécurité sociale"
                       value="${socialSecurityNumber}"
                       required>
                <button type="submit">🔍 Rechercher</button>
            </form>
        </div>

        <!-- Existing Patient Info -->
        <c:if test="${not empty patient}">
            <div class="patient-info-card">
                <h3>✓ Patient Existant</h3>
                <div class="info-row">
                    <span class="info-label">Nom Complet:</span>
                    <span class="info-value">${patient.fullName}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Date de Naissance:</span>
                    <span class="info-value">${patient.birthDate}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Âge:</span>
                    <span class="info-value">${patient.age} ans</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Téléphone:</span>
                    <span class="info-value">${patient.phone != null ? patient.phone : 'Non renseigné'}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Allergies:</span>
                    <span class="info-value">${patient.allergies != null ? patient.allergies : 'Aucune'}</span>
                </div>
            </div>
        </c:if>

        <!-- Vital Signs Form for Existing Patient -->
        <c:if test="${existingPatient}">
            <div class="patient-info-card" style="border-left: 4px solid #28a745;">
                <h3>💓 Ajouter de Nouveaux Signes Vitaux</h3>
                <p style="color: #666; margin-bottom: 20px;">
                    <strong>Instructions :</strong> Remplissez <u>seulement</u> les signes vitaux que vous souhaitez enregistrer. 
                    Vous pouvez laisser vides les champs que vous ne voulez pas mesurer maintenant.
                </p>
                
                <form method="post" action="${pageContext.request.contextPath}/nurse/add-vital-signs">
                    <input type="hidden" name="patientId" value="${patient.id}">
                    
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="vitalBloodPressure">🩸 Tension Artérielle <small>(optionnel)</small></label>
                            <input type="text" id="vitalBloodPressure" name="bloodPressure" placeholder="ex: 120/80">
                        </div>
                        <div class="form-group">
                            <label for="vitalHeartRate">💓 Fréquence Cardiaque <small>(optionnel)</small></label>
                            <input type="number" id="vitalHeartRate" name="heartRate" placeholder="ex: 75 bpm">
                        </div>
                        <div class="form-group">
                            <label for="vitalTemperature">🌡️ Température <small>(optionnel)</small></label>
                            <input type="number" step="0.1" id="vitalTemperature" name="temperature" placeholder="ex: 37.0°C">
                        </div>
                        <div class="form-group">
                            <label for="vitalRespiratoryRate">🫁 Fréquence Respiratoire <small>(optionnel)</small></label>
                            <input type="number" id="vitalRespiratoryRate" name="respiratoryRate" placeholder="ex: 20/min">
                        </div>
                        <div class="form-group">
                            <label for="vitalWeight">⚖️ Poids <small>(optionnel)</small></label>
                            <input type="number" step="0.1" id="vitalWeight" name="weight" placeholder="ex: 70.0 kg">
                        </div>
                        <div class="form-group">
                            <label for="vitalHeight">📏 Taille <small>(optionnel)</small></label>
                            <input type="number" step="0.1" id="vitalHeight" name="height" placeholder="ex: 175.0 cm">
                        </div>
                        <div class="form-group">
                            <label for="vitalOxygenSaturation">🫁 Saturation O₂ <small>(optionnel)</small></label>
                            <input type="number" id="vitalOxygenSaturation" name="oxygenSaturation" placeholder="ex: 98%">
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="vitalObservations">Observations</label>
                        <textarea id="vitalObservations" name="observations" placeholder="Observations sur l'état du patient..."></textarea>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">
                            💓 Enregistrer les Nouveaux Signes Vitaux
                        </button>
                        <p style="font-size: 12px; color: #666; margin-top: 10px;">
                            ℹ️ Seuls les champs remplis seront enregistrés. Le patient sera automatiquement ajouté à la file d'attente.
                        </p>
                    </div>
                </form>
            </div>
        </c:if>

        <!-- Registration Form for New Patient -->
        <c:if test="${not existingPatient}">
        <form method="post" action="${pageContext.request.contextPath}/nurse/register-patient">

            <div class="section-title">📋 Informations Administratives</div>
            <div class="form-grid">
                <div class="form-group">
                    <label for="lastName">Nom <span class="required">*</span></label>
                    <input type="text" id="lastName" name="lastName"
                           value="${patient != null ? patient.lastName : ''}"
                    ${existingPatient ? 'readonly' : ''} required>
                </div>
                <div class="form-group">
                    <label for="firstName">Prénom <span class="required">*</span></label>
                    <input type="text" id="firstName" name="firstName"
                           value="${patient != null ? patient.firstName : ''}"
                    ${existingPatient ? 'readonly' : ''} required>
                </div>
                <div class="form-group">
                    <label for="birthDate">Date de Naissance</label>
                    <input type="date" id="birthDate" name="birthDate"
                           value="${patient != null ? patient.birthDate : ''}"
                    ${existingPatient ? 'readonly' : ''}>
                </div>
                <div class="form-group">
                    <label for="socialSecurityNumber">N° Sécurité Sociale <span class="required">*</span></label>
                    <input type="text" id="socialSecurityNumber" name="socialSecurityNumber"
                           value="${patient != null ? patient.socialSecurityNumber : socialSecurityNumber}"
                    ${existingPatient ? 'readonly' : ''} required>
                </div>
                <div class="form-group">
                    <label for="phone">Téléphone</label>
                    <input type="tel" id="phone" name="phone"
                           value="${patient != null ? patient.phone : ''}"
                    ${existingPatient ? 'readonly' : ''}>
                </div>
            </div>

            <div class="form-group">
                <label for="address">Adresse</label>
                <input type="text" id="address" name="address"
                       value="${patient != null ? patient.address : ''}"
                ${existingPatient ? 'readonly' : ''}>
            </div>

            <div class="section-title">🏥 Informations Médicales</div>
            <div class="form-group">
                <label for="medicalHistory">Antécédents Médicaux</label>
                <textarea id="medicalHistory" name="medicalHistory"
                ${existingPatient ? 'readonly' : ''}>${patient != null ? patient.medicalHistory : ''}</textarea>
            </div>
            <div class="form-group">
                <label for="currentTreatments">Traitements en Cours</label>
                <textarea id="currentTreatments" name="currentTreatments"
                ${existingPatient ? 'readonly' : ''}>${patient != null ? patient.currentTreatments : ''}</textarea>
            </div>
            <div class="form-group">
                <label for="allergies">Allergies</label>
                <textarea id="allergies" name="allergies"
                ${existingPatient ? 'readonly' : ''}>${patient != null ? patient.allergies : ''}</textarea>
            </div>

            <div class="section-title">💓 Signes Vitaux <span class="required">*</span></div>
            <div class="form-grid">
                <div class="form-group">
                    <label for="bloodPressure">Tension Artérielle (ex: 120/80)</label>
                    <input type="text" id="bloodPressure" name="bloodPressure" placeholder="120/80">
                </div>
                <div class="form-group">
                    <label for="heartRate">Fréquence Cardiaque (bpm)</label>
                    <input type="number" id="heartRate" name="heartRate" placeholder="75">
                </div>
                <div class="form-group">
                    <label for="temperature">Température (°C)</label>
                    <input type="number" step="0.1" id="temperature" name="temperature" placeholder="37.0">
                </div>
                <div class="form-group">
                    <label for="respiratoryRate">Fréquence Respiratoire (/min)</label>
                    <input type="number" id="respiratoryRate" name="respiratoryRate" placeholder="16">
                </div>
                <div class="form-group">
                    <label for="weight">Poids (kg)</label>
                    <input type="number" step="0.1" id="weight" name="weight" placeholder="70.5">
                </div>
                <div class="form-group">
                    <label for="height">Taille (cm)</label>
                    <input type="number" step="0.1" id="height" name="height" placeholder="175">
                </div>
                <div class="form-group">
                    <label for="oxygenSaturation">Saturation en Oxygène (%)</label>
                    <input type="number" id="oxygenSaturation" name="oxygenSaturation" placeholder="98">
                </div>
            </div>

            <div class="form-group">
                <label for="observations">Observations</label>
                <textarea id="observations" name="observations"
                          placeholder="Notes supplémentaires de l'infirmier..."></textarea>
            </div>

            <div class="form-actions">
                <a href="${pageContext.request.contextPath}/nurse/dashboard" class="btn btn-secondary">Annuler</a>
                <button type="submit" class="btn btn-primary">Enregistrer le Patient</button>
            </div>
        </form>
        </c:if>
    </div>
</div>
</body>
</html>