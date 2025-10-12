<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tableau de Bord - Infirmier</title>
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

        .btn-logout {
            background: rgba(255,255,255,0.2);
            color: white;
            padding: 8px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            transition: background 0.3s;
        }

        .btn-logout:hover {
            background: rgba(255,255,255,0.3);
        }

        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }

        .welcome-card {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            margin-bottom: 30px;
        }

        .welcome-card h2 {
            color: #333;
            margin-bottom: 10px;
        }

        .welcome-card p {
            color: #666;
        }

        .success-message {
            background: #d4edda;
            color: #155724;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #28a745;
        }

        .actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .action-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            text-align: center;
            cursor: pointer;
            transition: transform 0.3s, box-shadow 0.3s;
            text-decoration: none;
            color: inherit;
        }

        .action-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }

        .action-card-icon {
            font-size: 48px;
            margin-bottom: 15px;
        }

        .action-card h3 {
            color: #333;
            margin-bottom: 10px;
        }

        .action-card p {
            color: #666;
            font-size: 14px;
        }

        .patients-section {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        .patients-section h3 {
            color: #333;
            margin-bottom: 20px;
            font-size: 20px;
        }

        .patients-table {
            width: 100%;
            border-collapse: collapse;
        }

        .patients-table th {
            background: #f8f9fa;
            padding: 12px;
            text-align: left;
            font-weight: 600;
            color: #333;
            border-bottom: 2px solid #e0e0e0;
        }

        .patients-table td {
            padding: 12px;
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
            padding: 40px;
            color: #999;
        }

        .empty-state-icon {
            font-size: 64px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
<nav class="navbar">
    <div class="navbar-brand">🏥 Consulea - Infirmier</div>
    <div class="navbar-user">
        <span>Bonjour, ${sessionScope.userName}</span>
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Déconnexion</a>
    </div>
</nav>

<div class="container">
    <c:if test="${not empty sessionScope.success}">
        <div class="success-message">
                ${sessionScope.success}
            <c:remove var="success" scope="session"/>
        </div>
    </c:if>

    <div class="welcome-card">
        <h2>Tableau de Bord</h2>
        <p>Bienvenue sur votre espace infirmier. Gérez les patients et enregistrez leurs signes vitaux.</p>
    </div>

    <div class="actions">
        <a href="${pageContext.request.contextPath}/nurse/register-patient" class="action-card">
            <div class="action-card-icon">➕</div>
            <h3>Enregistrer un Patient</h3>
            <p>Ajouter un nouveau patient et ses signes vitaux</p>
        </a>

        <a href="${pageContext.request.contextPath}/nurse/patients-list" class="action-card">
            <div class="action-card-icon">📋</div>
            <h3>Liste des Patients</h3>
            <p>Voir tous les patients enregistrés aujourd'hui</p>
        </a>
    </div>

    <div class="patients-section">
        <h3>Patients Enregistrés Aujourd'hui (${todayPatients.size()})</h3>

        <c:choose>
            <c:when test="${not empty todayPatients}">
                <table class="patients-table">
                    <thead>
                    <tr>
                        <th>Nom Complet</th>
                        <th>Date de Naissance</th>
                        <th>N° Sécurité Sociale</th>
                        <th>Téléphone</th>
                        <th>Heure d'Arrivée</th>
                        <th>Derniers Signes Vitaux</th>
                        <th>Statut</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="patient" items="${todayPatients}">
                        <tr>
                            <td><strong>${patient.fullName}</strong></td>
                            <td>${patient.birthDate}</td>
                            <td>${patient.socialSecurityNumber}</td>
                            <td>${patient.phone != null ? patient.phone : '-'}</td>
                            <td>${patient.registeredAt.toLocalTime().toString().substring(0, 5)}</td>
                            <td>
                                <c:set var="vitalSigns" value="${latestVitalSignsMap[patient.id]}"/>
                                <c:choose>
                                    <c:when test="${vitalSigns != null}">
                                        <div style="font-size: 12px; line-height: 1.4;">
                                            <c:if test="${vitalSigns.bloodPressure != null}">
                                                <div>🩸 ${vitalSigns.bloodPressure}</div>
                                            </c:if>
                                            <c:if test="${vitalSigns.temperature != null}">
                                                <div>🌡️ ${vitalSigns.temperature}°C</div>
                                            </c:if>
                                            <c:if test="${vitalSigns.heartRate != null}">
                                                <div>💓 ${vitalSigns.heartRate} bpm</div>
                                            </c:if>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: #999; font-style: italic;">Aucun</span>
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
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <div class="empty-state-icon">📭</div>
                    <p>Aucun patient enregistré aujourd'hui</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html>