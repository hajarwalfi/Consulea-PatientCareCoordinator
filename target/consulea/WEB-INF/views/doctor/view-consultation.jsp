<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Détails de la Consultation</title>
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

        .success-message {
            background: #d4edda;
            color: #155724;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #28a745;
        }

        .consultation-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #e0e0e0;
        }

        .consultation-header h2 {
            color: #333;
        }

        .badge {
            display: inline-block;
            padding: 6px 15px;
            border-radius: 15px;
            font-size: 13px;
            font-weight: 600;
        }

        .badge-info {
            background: #d1ecf1;
            color: #0c5460;
        }

        .badge-warning {
            background: #fff3cd;
            color: #856404;
        }

        .badge-success {
            background: #d4edda;
            color: #155724;
        }

        .section {
            margin-bottom: 30px;
        }

        .section-title {
            color: #2193b0;
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #e0e0e0;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }

        .info-item {
            display: flex;
            flex-direction: column;
        }

        .info-label {
            font-weight: 600;
            color: #666;
            font-size: 13px;
            margin-bottom: 5px;
        }

        .info-value {
            color: #333;
            font-size: 15px;
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

        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 5px;
            font-size: 14px;
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

        .btn-success {
            background: #28a745;
            color: white;
        }

        .btn-warning {
            background: #ffc107;
            color: #333;
        }

        .vital-signs-card {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 5px;
        }

        .vital-signs-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
            margin-top: 15px;
        }

        .vital-item {
            background: white;
            padding: 15px;
            border-radius: 5px;
            text-align: center;
        }

        .vital-item .label {
            font-size: 12px;
            color: #666;
        }

        .vital-item .value {
            font-size: 18px;
            font-weight: bold;
            color: #2193b0;
            margin-top: 5px;
        }

        .readonly-content {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            color: #333;
            border-left: 4px solid #2193b0;
        }

        .cost-summary {
            background: #e3f2fd;
            padding: 20px;
            border-radius: 5px;
            text-align: center;
        }

        .cost-summary .total {
            font-size: 32px;
            font-weight: bold;
            color: #2193b0;
        }
    </style>
</head>
<body>
<nav class="navbar">
    <div class="navbar-brand">🏥 Consulea - Médecin Généraliste</div>
    <div class="navbar-user">
        <span>Dr. ${sessionScope.userName}</span>
        <a href="${pageContext.request.contextPath}/doctor/dashboard" class="btn-back">← Retour</a>
    </div>
</nav>

<div class="container">
    <c:if test="${not empty sessionScope.success}">
        <div class="success-message">
                ${sessionScope.success}
            <c:remove var="success" scope="session"/>
        </div>
    </c:if>

    <div class="card">
        <div class="consultation-header">
            <div>
                <h2>Consultation #${consultation.id}</h2>
                <p style="color: #666; margin-top: 5px;">
                    Patient: ${consultation.patient.fullName} |
                    ${consultation.createdAt.toLocalDate()} à ${consultation.createdAt.toLocalTime().toString().substring(0, 5)}
                </p>
            </div>
            <div>
                <c:choose>
                    <c:when test="${consultation.status == 'IN_PROGRESS'}">
                        <span class="badge badge-info">EN COURS</span>
                    </c:when>
                    <c:when test="${consultation.status == 'WAITING_FOR_SPECIALIST_OPINION'}">
                        <span class="badge badge-warning">ATTENTE SPÉCIALISTE</span>
                    </c:when>
                    <c:when test="${consultation.status == 'COMPLETED'}">
                        <span class="badge badge-success">TERMINÉE</span>
                    </c:when>
                </c:choose>
            </div>
        </div>

        <div class="section">
            <div class="section-title">📋 Informations Patient</div>
            <div class="info-grid">
                <div class="info-item">
                    <span class="info-label">Nom Complet</span>
                    <span class="info-value">${consultation.patient.fullName}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">Âge</span>
                    <span class="info-value">${consultation.patient.age} ans</span>
                </div>
                <div class="info-item">
                    <span class="info-label">N° Sécurité Sociale</span>
                    <span class="info-value">${consultation.patient.socialSecurityNumber}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">Allergies</span>
                    <span class="info-value" style="color: red;">
                        ${consultation.patient.allergies != null ? consultation.patient.allergies : 'Aucune'}
                    </span>
                </div>
            </div>

            <c:if test="${not empty vitalSignsList && vitalSignsList.size() > 0}">
                <div class="vital-signs-card" style="margin-top: 20px;">
                    <h4>💓 Signes Vitaux</h4>
                    <c:set var="vitals" value="${vitalSignsList[0]}"/>
                    <div class="vital-signs-grid">
                        <div class="vital-item">
                            <div class="label">Tension</div>
                            <div class="value">${vitals.bloodPressure}</div>
                        </div>
                        <div class="vital-item">
                            <div class="label">Fréq. Cardiaque</div>
                            <div class="value">${vitals.heartRate} bpm</div>
                        </div>
                        <div class="vital-item">
                            <div class="label">Température</div>
                            <div class="value">${vitals.temperature}°C</div>
                        </div>
                        <div class="vital-item">
                            <div class="label">Saturation O₂</div>
                            <div class="value">${vitals.oxygenSaturation}%</div>
                        </div>
                    </div>
                </div>
            </c:if>
        </div>

        <div class="section">
            <div class="section-title">🩺 Consultation</div>
            <div class="form-group">
                <label>Motif de Consultation</label>
                <div class="readonly-content">${consultation.chiefComplaint}</div>
            </div>
            <c:if test="${not empty consultation.symptoms}">
                <div class="form-group">
                    <label>Symptômes</label>
                    <div class="readonly-content">${consultation.symptoms}</div>
                </div>
            </c:if>
            <c:if test="${not empty consultation.clinicalExamination}">
                <div class="form-group">
                    <label>Examen Clinique</label>
                    <div class="readonly-content">${consultation.clinicalExamination}</div>
                </div>
            </c:if>
        </div>

        <c:if test="${consultation.status == 'IN_PROGRESS'}">
            <form method="post" action="${pageContext.request.contextPath}/doctor/complete-consultation">
                <input type="hidden" name="consultationId" value="${consultation.id}">

                <div class="section">
                    <div class="section-title">💊 Diagnostic et Traitement</div>
                    <div class="form-group">
                        <label for="diagnosis">Diagnostic</label>
                        <textarea id="diagnosis" name="diagnosis" required
                                  placeholder="Entrez le diagnostic...">${consultation.diagnosis}</textarea>
                    </div>
                    <div class="form-group">
                        <label for="treatment">Traitement Prescrit</label>
                        <textarea id="treatment" name="treatment" required
                                  placeholder="Détaillez le traitement prescrit...">${consultation.treatment}</textarea>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="button" onclick="requestSpecialist()" class="btn btn-warning">
                        Demander Avis Spécialiste
                    </button>
                    <button type="submit" class="btn btn-success">Clôturer la Consultation</button>
                </div>
            </form>
        </c:if>

        <c:if test="${consultation.status == 'COMPLETED'}">
            <div class="section">
                <div class="section-title">💊 Diagnostic et Traitement</div>
                <div class="form-group">
                    <label>Diagnostic</label>
                    <div class="readonly-content">${consultation.diagnosis}</div>
                </div>
                <div class="form-group">
                    <label>Traitement</label>
                    <div class="readonly-content">${consultation.treatment}</div>
                </div>
                <div class="info-item" style="margin-top: 15px;">
                    <span class="info-label">Date de Clôture</span>
                    <span class="info-value">${consultation.completedAt}</span>
                </div>
            </div>
        </c:if>
        <!-- Ajoutez cette section AVANT la section Coût Total -->
        <c:if test="${consultation.status == 'IN_PROGRESS'}">
            <div class="section">
                <div class="section-title">🔬 Actes Techniques Médicaux</div>

                <!-- Actes déjà ajoutés -->
                <c:if test="${not empty consultationMedicalActs}">
                    <table class="acts-table" style="width: 100%; margin-bottom: 20px; border-collapse: collapse;">
                        <thead>
                        <tr style="background: #f8f9fa;">
                            <th style="padding: 10px; text-align: left; border-bottom: 2px solid #e0e0e0;">Acte</th>
                            <th style="padding: 10px; text-align: right; border-bottom: 2px solid #e0e0e0;">Prix (DH)</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="cma" items="${consultationMedicalActs}">
                            <tr style="border-bottom: 1px solid #f0f0f0;">
                                <td style="padding: 10px;">${cma.medicalAct.name}</td>
                                <td style="padding: 10px; text-align: right; font-weight: bold;">${cma.totalPrice} DH</td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:if>

                <!-- Formulaire pour ajouter un acte -->
                <form method="post" action="${pageContext.request.contextPath}/doctor/add-medical-act"
                      style="display: flex; gap: 15px; align-items: flex-end;">
                    <input type="hidden" name="consultationId" value="${consultation.id}">

                    <div class="form-group" style="flex: 1; margin-bottom: 0;">
                        <label for="medicalActId">Ajouter un acte médical</label>
                        <select id="medicalActId" name="medicalActId" required
                                style="width: 100%; padding: 12px; border: 2px solid #e0e0e0; border-radius: 5px;">
                            <option value="">-- Sélectionnez un acte --</option>
                            <c:forEach var="act" items="${availableMedicalActs}">
                                <option value="${act.id}">${act.name} - ${act.price} DH</option>
                            </c:forEach>
                        </select>
                    </div>

                    <button type="submit" class="btn btn-primary" style="margin-bottom: 0;">
                        Ajouter l'Acte
                    </button>
                </form>
            </div>
        </c:if>

        <!-- Modifiez la section Coût Total -->
        <div class="section">
            <div class="section-title">💰 Détail des Coûts</div>

            <div style="background: #f8f9fa; padding: 20px; border-radius: 5px;">
                <div style="display: flex; justify-content: space-between; margin-bottom: 10px;">
                    <span>Consultation de base:</span>
                    <strong>150.0 DH</strong>
                </div>

                <c:if test="${not empty consultationMedicalActs && consultationMedicalActs.size() > 0}">
                    <c:forEach var="cma" items="${consultationMedicalActs}">
                        <div style="display: flex; justify-content: space-between; margin-bottom: 10px; color: #666;">
                            <span>+ ${cma.medicalAct.name}:</span>
                            <span>${cma.totalPrice} DH</span>
                        </div>
                    </c:forEach>
                </c:if>

                <hr style="margin: 15px 0; border: none; border-top: 2px solid #e0e0e0;">

                <div class="cost-summary">
                    <div class="total">${consultation.cost} DH</div>
                    <p style="color: #666; margin-top: 10px;">Coût Total (avec Stream API)</p>
                </div>
            </div>
        </div>

        <div class="section">
            <div class="section-title">💰 Coût Total</div>
            <div class="cost-summary">
                <div class="total">${consultation.cost} DH</div>
                <p style="color: #666; margin-top: 10px;">Coût de la consultation</p>
            </div>
        </div>
    </div>
</div>

<script>
    function requestSpecialist() {
        if (confirm('Voulez-vous demander un avis spécialiste pour cette consultation ?')) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/doctor/request-specialist';

            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'consultationId';
            input.value = '${consultation.id}';

            form.appendChild(input);
            document.body.appendChild(form);
            form.submit();
        }
    }
</script>
</body>
</html>