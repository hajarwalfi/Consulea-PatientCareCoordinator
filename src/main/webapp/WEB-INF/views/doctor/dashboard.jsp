<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tableau de Bord - Médecin Généraliste</title>
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
            max-width: 1400px;
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

        .success-message {
            background: #d4edda;
            color: #155724;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #28a745;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .stat-icon {
            font-size: 48px;
            width: 70px;
            height: 70px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 10px;
        }

        .stat-icon.blue {
            background: #e3f2fd;
        }

        .stat-icon.orange {
            background: #fff3e0;
        }

        .stat-icon.green {
            background: #e8f5e9;
        }

        .stat-info h3 {
            font-size: 32px;
            color: #333;
            margin-bottom: 5px;
        }

        .stat-info p {
            color: #666;
            font-size: 14px;
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

        .section-title {
            color: #333;
            font-size: 20px;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #e0e0e0;
        }

        .consultations-grid {
            display: grid;
            gap: 20px;
        }

        .consultation-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            display: grid;
            grid-template-columns: 1fr auto;
            gap: 20px;
            align-items: center;
        }

        .consultation-info h4 {
            color: #2193b0;
            margin-bottom: 10px;
        }

        .consultation-details {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            color: #666;
            font-size: 14px;
        }

        .badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
        }

        .badge-warning {
            background: #fff3cd;
            color: #856404;
        }

        .badge-info {
            background: #d1ecf1;
            color: #0c5460;
        }

        .badge-success {
            background: #d4edda;
            color: #155724;
        }

        .btn {
            padding: 8px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
            display: inline-block;
        }

        .btn-primary {
            background: #2193b0;
            color: white;
        }

        .btn-primary:hover {
            background: #1a7a91;
        }

        .empty-state {
            text-align: center;
            padding: 40px;
            color: #999;
        }
    </style>
</head>
<body>
<nav class="navbar">
    <div class="navbar-brand">🏥 Consulea - Médecin Généraliste</div>
    <div class="navbar-user">
        <span>Dr. ${sessionScope.userName}</span>
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
        <p>Bienvenue Dr. ${sessionScope.userName}. Gérez vos consultations et vos patients.</p>
    </div>

    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon blue">📋</div>
            <div class="stat-info">
                <h3>${myConsultations.size()}</h3>
                <p>Mes Consultations</p>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon orange">⏳</div>
            <div class="stat-info">
                <h3>${inProgressConsultations.size()}</h3>
                <p>En Cours</p>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon green">👨‍⚕️</div>
            <div class="stat-info">
                <h3>${waitingForSpecialist.size()}</h3>
                <p>Attente Spécialiste</p>
            </div>
        </div>
    </div>

    <div class="actions">
        <a href="${pageContext.request.contextPath}/doctor/waiting-patients" class="action-card">
            <div class="action-card-icon">🩺</div>
            <h3>Patients en Attente</h3>
            <p>Voir les patients et créer une consultation</p>
        </a>
    </div>

    <h3 class="section-title">Consultations en Cours</h3>
    <div class="consultations-grid">
        <c:choose>
            <c:when test="${not empty inProgressConsultations}">
                <c:forEach var="consultation" items="${inProgressConsultations}">
                    <div class="consultation-card">
                        <div class="consultation-info">
                            <h4>${consultation.patient.fullName}</h4>
                            <div class="consultation-details">
                                <span>📅 ${consultation.createdAt.toLocalDate()}</span>
                                <span>🕐 ${consultation.createdAt.toLocalTime().toString().substring(0, 5)}</span>
                                <span class="badge badge-info">${consultation.status}</span>
                                <span>💰 ${consultation.cost} DH</span>
                            </div>
                            <p style="margin-top: 10px; color: #666;">
                                <strong>Motif:</strong> ${consultation.chiefComplaint}
                            </p>
                        </div>
                        <div>
                            <a href="${pageContext.request.contextPath}/doctor/view-consultation/${consultation.id}"
                               class="btn btn-primary">Voir Détails</a>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <p>Aucune consultation en cours</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <c:if test="${not empty waitingForSpecialist && waitingForSpecialist.size() > 0}">
        <h3 class="section-title" style="margin-top: 30px;">En Attente d'Avis Spécialiste</h3>
        <div class="consultations-grid">
            <c:forEach var="consultation" items="${waitingForSpecialist}">
                <div class="consultation-card">
                    <div class="consultation-info">
                        <h4>${consultation.patient.fullName}</h4>
                        <div class="consultation-details">
                            <span>📅 ${consultation.createdAt.toLocalDate()}</span>
                            <span class="badge badge-warning">ATTENTE SPÉCIALISTE</span>
                        </div>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/doctor/view-consultation/${consultation.id}"
                           class="btn btn-primary">Voir</a>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:if>
</div>
</body>
</html>