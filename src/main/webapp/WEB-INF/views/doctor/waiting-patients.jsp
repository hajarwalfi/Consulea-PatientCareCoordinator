<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patients en Attente</title>
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
        }

        .card h2 {
            color: #333;
            margin-bottom: 20px;
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
            padding: 15px 12px;
            border-bottom: 1px solid #f0f0f0;
            color: #666;
        }

        .patients-table tr:hover {
            background: #f8f9fa;
        }

        .btn {
            padding: 8px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            font-weight: 600;
            display: inline-block;
        }

        .btn-primary {
            background: #2193b0;
            color: white;
        }

        .btn-primary:hover {
            background: #1a7a91;
        }

        .badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
            background: #d4edda;
            color: #155724;
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
        <a href="${pageContext.request.contextPath}/doctor/dashboard" class="btn-back">← Retour</a>
    </div>
</nav>

<div class="container">
    <div class="card">
        <h2>Patients en Attente de Consultation (${waitingPatients.size()})</h2>

        <c:choose>
            <c:when test="${not empty waitingPatients}">
                <table class="patients-table">
                    <thead>
                    <tr>
                        <th>Nom Complet</th>
                        <th>Âge</th>
                        <th>N° Sécurité Sociale</th>
                        <th>Téléphone</th>
                        <th>Heure d'Arrivée</th>
                        <th>Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="patient" items="${waitingPatients}">
                        <tr>
                            <td><strong>${patient.fullName}</strong></td>
                            <td>${patient.age} ans</td>
                            <td>${patient.socialSecurityNumber}</td>
                            <td>${patient.phone != null ? patient.phone : '-'}</td>
                            <td>
                                    ${patient.registeredAt.toLocalTime().toString().substring(0, 5)}
                                <span class="badge">En attente</span>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/doctor/create-consultation?patientId=${patient.id}"
                                   class="btn btn-primary">Consulter</a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <div style="font-size: 64px; margin-bottom: 20px;">📭</div>
                    <p>Aucun patient en attente actuellement</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html>