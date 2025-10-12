<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Patients - Infirmier</title>
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
            max-width: 1400px;
            margin: 30px auto;
            padding: 0 20px;
        }

        .card {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        .card h2 {
            color: #333;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .patients-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .patients-table th {
            background: #f8f9fa;
            padding: 15px 12px;
            text-align: left;
            font-weight: 600;
            color: #333;
            border-bottom: 2px solid #e0e0e0;
        }

        .patients-table td {
            padding: 15px 12px;
            border-bottom: 1px solid #f0f0f0;
            color: #666;
        }

        .patients-table tr:hover {
            background: #f8f9fa;
        }

        .badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
        }

        .badge-success {
            background: #d4edda;
            color: #155724;
        }

        .badge-info {
            background: #d1ecf1;
            color: #0c5460;
        }

        .badge-waiting {
            background: #fff3cd;
            color: #856404;
        }

        .badge-consultation {
            background: #cce5ff;
            color: #004085;
        }

        .badge-completed {
            background: #d4edda;
            color: #155724;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }

        .empty-state-icon {
            font-size: 80px;
            margin-bottom: 20px;
        }

        .stats-summary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            display: flex;
            justify-content: space-around;
            align-items: center;
        }

        .stat-item {
            text-align: center;
        }

        .stat-item .number {
            font-size: 36px;
            font-weight: bold;
            margin-bottom: 5px;
        }

        .stat-item .label {
            font-size: 14px;
            opacity: 0.9;
        }

        .patient-name {
            font-weight: 600;
            color: #667eea;
        }

        .vital-signs-mini {
            display: flex;
            gap: 15px;
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }

        .vital-signs-mini span {
            display: flex;
            align-items: center;
            gap: 3px;
        }
    </style>
</head>
<body>
<nav class="navbar">
    <div class="navbar-brand">🏥 Consulea - Infirmier</div>
    <div class="navbar-user">
        <span>Bonjour, ${sessionScope.userName}</span>
        <a href="${pageContext.request.contextPath}/nurse/dashboard" class="btn-back">← Retour au Dashboard</a>
    </div>
</nav>

<div class="container">
    <div class="stats-summary">
        <div class="stat-item">
            <div class="number">${patients.size()}</div>
            <div class="label">Patients Enregistrés Aujourd'hui</div>
        </div>
        <div class="stat-item">
            <div class="number">📋</div>
            <div class="label">Liste Complète</div>
        </div>
    </div>

    <div class="card">
        <h2>
            <span>👥</span>
            Liste des Patients du Jour
        </h2>

        <c:choose>
            <c:when test="${not empty patients}">
                <table class="patients-table">
                    <thead>
                    <tr>
                        <th>Nom Complet</th>
                        <th>Âge</th>
                        <th>Date de Naissance</th>
                        <th>N° Sécurité Sociale</th>
                        <th>Téléphone</th>
                        <th>Adresse</th>
                        <th>Heure d'Arrivée</th>
                        <th>Signes Vitaux</th>
                        <th>Statut</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="patient" items="${patients}">
                        <tr>
                            <td>
                                <div class="patient-name">${patient.fullName}</div>
                                <c:if test="${not empty patient.allergies}">
                                    <div style="color: red; font-size: 11px; margin-top: 3px;">
                                        ⚠️ Allergies: ${patient.allergies}
                                    </div>
                                </c:if>
                            </td>
                            <td><strong>${patient.age}</strong> ans</td>
                            <td>${patient.birthDate}</td>
                            <td><code>${patient.socialSecurityNumber}</code></td>
                            <td>${patient.phone != null ? patient.phone : '-'}</td>
                            <td style="max-width: 200px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                    ${patient.address != null ? patient.address : '-'}
                            </td>
                            <td>
                                <strong>${patient.registeredAt.toLocalTime().toString().substring(0, 5)}</strong>
                                <div style="font-size: 11px; color: #999; margin-top: 3px;">
                                        ${patient.registeredAt.toLocalDate()}
                                </div>
                            </td>
                            <td>
                                <c:set var="vitalSigns" value="${latestVitalSignsMap[patient.id]}"/>
                                <c:choose>
                                    <c:when test="${vitalSigns != null}">
                                        <div style="font-size: 11px; line-height: 1.3;">
                                            <c:if test="${vitalSigns.bloodPressure != null}">
                                                <div>🩸 ${vitalSigns.bloodPressure}</div>
                                            </c:if>
                                            <c:if test="${vitalSigns.temperature != null}">
                                                <div>🌡️ ${vitalSigns.temperature}°C</div>
                                            </c:if>
                                            <c:if test="${vitalSigns.heartRate != null}">
                                                <div>💓 ${vitalSigns.heartRate} bpm</div>
                                            </c:if>
                                            <c:if test="${vitalSigns.respiratoryRate != null}">
                                                <div>🫁 ${vitalSigns.respiratoryRate}/min</div>
                                            </c:if>
                                            <c:if test="${vitalSigns.oxygenSaturation != null}">
                                                <div>🫁 SpO2: ${vitalSigns.oxygenSaturation}%</div>
                                            </c:if>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: #999; font-style: italic;">Non mesurés</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${patient.status == 'WAITING'}">
                                        <span class="badge badge-waiting">En attente</span>
                                    </c:when>
                                    <c:when test="${patient.status == 'IN_CONSULTATION'}">
                                        <span class="badge badge-consultation">En consultation</span>
                                    </c:when>
                                    <c:when test="${patient.status == 'COMPLETED'}">
                                        <span class="badge badge-completed">Consultation terminée</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-waiting">En attente</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>

                <div style="margin-top: 20px; padding: 15px; background: #f8f9fa; border-radius: 5px; color: #666; font-size: 14px;">
                    <strong>💡 Astuce :</strong> Les patients avec des allergies sont marqués en rouge.
                    Assurez-vous de bien informer le médecin lors de la consultation.
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <div class="empty-state-icon">📭</div>
                    <h3 style="color: #666; margin-bottom: 10px;">Aucun patient enregistré aujourd'hui</h3>
                    <p>Les patients enregistrés apparaîtront ici automatiquement.</p>
                    <a href="${pageContext.request.contextPath}/nurse/register-patient"
                       style="display: inline-block; margin-top: 20px; padding: 12px 30px; background: #667eea; color: white; text-decoration: none; border-radius: 5px; font-weight: 600;">
                        ➕ Enregistrer un Patient
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html>