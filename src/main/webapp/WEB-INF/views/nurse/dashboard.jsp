<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tableau de Bord - Infirmier</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: {
                        'sans': ['Inter', 'system-ui', 'sans-serif'],
                    }
                }
            }
        }
    </script>
</head>
<body class="bg-gradient-to-br from-slate-50 to-purple-50 min-h-screen">
    <!-- Navigation -->
    <nav class="bg-gradient-to-r from-purple-600 via-purple-700 to-indigo-800 shadow-xl">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-center h-16">
                <div class="flex items-center space-x-4">
                    <div class="flex items-center space-x-2">
                        <div class="bg-white/20 p-2 rounded-lg">
                            🏥
                        </div>
                        <div>
                            <h1 class="text-xl font-bold text-white">Consulea</h1>
                            <p class="text-xs text-purple-100">Infirmier</p>
                        </div>
                    </div>
                </div>
                
                <div class="flex items-center space-x-4">
                    <div class="flex items-center space-x-2 text-white">
                        <div class="w-8 h-8 bg-white/20 rounded-full flex items-center justify-center">
                            👩‍⚕️
                        </div>
                        <span class="font-medium">Bonjour, ${sessionScope.userName}</span>
                    </div>
                    <a href="${pageContext.request.contextPath}/logout" 
                       class="bg-white/10 hover:bg-white/20 text-white px-4 py-2 rounded-lg transition-all duration-200 flex items-center space-x-2">
                        <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M3 3a1 1 0 00-1 1v12a1 1 0 102 0V4a1 1 0 00-1-1zm10.293 9.293a1 1 0 001.414 1.414l3-3a1 1 0 000-1.414l-3-3a1 1 0 10-1.414 1.414L14.586 9H7a1 1 0 100 2h7.586l-1.293 1.293z" clip-rule="evenodd"></path>
                        </svg>
                        <span>Déconnexion</span>
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <!-- Success Message -->
        <c:if test="${not empty sessionScope.success}">
            <div class="bg-green-50 border border-green-200 text-green-800 px-6 py-4 rounded-xl mb-6 flex items-center shadow-sm">
                <svg class="w-5 h-5 mr-3 text-green-600" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path>
                </svg>
                ${sessionScope.success}
                <c:remove var="success" scope="session"/>
            </div>
        </c:if>

        <!-- Welcome Card -->
        <div class="bg-white/80 backdrop-blur-sm rounded-2xl shadow-lg border border-white/50 p-8 mb-8">
            <div class="flex items-center space-x-4">
                <div class="w-16 h-16 bg-gradient-to-br from-purple-500 to-indigo-600 rounded-2xl flex items-center justify-center text-white text-2xl shadow-lg">
                    👩‍⚕️
                </div>
                <div>
                    <h2 class="text-3xl font-bold text-gray-900 mb-2">Tableau de Bord</h2>
                    <p class="text-gray-600 font-medium">Bienvenue sur votre espace infirmier. Gérez les patients et enregistrez leurs signes vitaux.</p>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
            <a href="${pageContext.request.contextPath}/nurse/register-patient" 
               class="bg-white/90 backdrop-blur-sm rounded-2xl shadow-lg border border-white/50 p-8 text-center hover:shadow-xl transition-all duration-300 hover:-translate-y-1 group">
                <div class="w-16 h-16 bg-gradient-to-br from-green-500 to-emerald-600 rounded-2xl flex items-center justify-center text-white text-3xl mx-auto mb-4 group-hover:scale-110 transition-transform duration-200 shadow-lg">
                    ➕
                </div>
                <h3 class="text-xl font-bold text-gray-900 mb-2">Enregistrer un Patient</h3>
                <p class="text-gray-600">Ajouter un nouveau patient et ses signes vitaux</p>
            </a>

            <a href="${pageContext.request.contextPath}/nurse/patients-list" 
               class="bg-white/90 backdrop-blur-sm rounded-2xl shadow-lg border border-white/50 p-8 text-center hover:shadow-xl transition-all duration-300 hover:-translate-y-1 group">
                <div class="w-16 h-16 bg-gradient-to-br from-blue-500 to-indigo-600 rounded-2xl flex items-center justify-center text-white text-3xl mx-auto mb-4 group-hover:scale-110 transition-transform duration-200 shadow-lg">
                    📋
                </div>
                <h3 class="text-xl font-bold text-gray-900 mb-2">Liste des Patients</h3>
                <p class="text-gray-600">Voir tous les patients enregistrés aujourd'hui</p>
            </a>
        </div>

        <!-- Patients Section -->
        <div class="bg-white/90 backdrop-blur-sm rounded-2xl shadow-lg border border-white/50 p-8">
            <h3 class="text-2xl font-bold text-gray-900 mb-6 flex items-center">
                <div class="w-8 h-8 bg-gradient-to-br from-purple-500 to-indigo-600 rounded-lg flex items-center justify-center text-white text-sm mr-3">
                    👥
                </div>
                Patients Enregistrés Aujourd'hui (${todayPatients.size()})
            </h3>

            <c:choose>
                <c:when test="${not empty todayPatients}">
                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead>
                                <tr class="border-b-2 border-gray-100">
                                    <th class="text-left py-4 px-2 font-semibold text-gray-700">Patient</th>
                                    <th class="text-left py-4 px-2 font-semibold text-gray-700">Naissance</th>
                                    <th class="text-left py-4 px-2 font-semibold text-gray-700">N° Sécurité</th>
                                    <th class="text-left py-4 px-2 font-semibold text-gray-700">Téléphone</th>
                                    <th class="text-left py-4 px-2 font-semibold text-gray-700">Arrivée</th>
                                    <th class="text-left py-4 px-2 font-semibold text-gray-700">Signes Vitaux</th>
                                    <th class="text-left py-4 px-2 font-semibold text-gray-700">Statut</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-gray-100">
                                <c:forEach var="patient" items="${todayPatients}">
                                    <tr class="hover:bg-gray-50 transition-colors duration-150">
                                        <td class="py-4 px-2">
                                            <div class="flex items-center space-x-3">
                                                <div class="w-10 h-10 bg-gradient-to-br from-purple-500 to-indigo-600 rounded-full flex items-center justify-center text-white font-semibold text-sm">
                                                    ${patient.fullName.substring(0, 1)}
                                                </div>
                                                <div>
                                                    <p class="font-semibold text-gray-900">${patient.fullName}</p>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="py-4 px-2 text-gray-600">${patient.birthDate}</td>
                                        <td class="py-4 px-2 text-gray-600 font-mono text-sm">${patient.socialSecurityNumber}</td>
                                        <td class="py-4 px-2 text-gray-600">${patient.phone != null ? patient.phone : '-'}</td>
                                        <td class="py-4 px-2 text-gray-600">${patient.registeredAt.toLocalTime().toString().substring(0, 5)}</td>
                                        <td class="py-4 px-2">
                                            <c:set var="vitalSigns" value="${latestVitalSignsMap[patient.id]}"/>
                                            <c:choose>
                                                <c:when test="${vitalSigns != null}">
                                                    <div class="space-y-1 text-xs">
                                                        <c:if test="${vitalSigns.bloodPressure != null}">
                                                            <div class="flex items-center space-x-1">
                                                                <span>🩸</span>
                                                                <span class="text-gray-600">${vitalSigns.bloodPressure}</span>
                                                            </div>
                                                        </c:if>
                                                        <c:if test="${vitalSigns.temperature != null}">
                                                            <div class="flex items-center space-x-1">
                                                                <span>🌡️</span>
                                                                <span class="text-gray-600">${vitalSigns.temperature}°C</span>
                                                            </div>
                                                        </c:if>
                                                        <c:if test="${vitalSigns.heartRate != null}">
                                                            <div class="flex items-center space-x-1">
                                                                <span>💓</span>
                                                                <span class="text-gray-600">${vitalSigns.heartRate} bpm</span>
                                                            </div>
                                                        </c:if>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-gray-400 italic text-sm">Aucun</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="py-4 px-2">
                                            <c:choose>
                                                <c:when test="${patient.status == 'WAITING'}">
                                                    <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-amber-100 text-amber-800">
                                                        En attente
                                                    </span>
                                                </c:when>
                                                <c:when test="${patient.status == 'IN_CONSULTATION'}">
                                                    <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                                                        En consultation
                                                    </span>
                                                </c:when>
                                                <c:when test="${patient.status == 'COMPLETED'}">
                                                    <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                                        Consultation terminée
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-amber-100 text-amber-800">
                                                        En attente
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-12">
                        <div class="w-16 h-16 bg-gray-100 rounded-2xl flex items-center justify-center text-4xl mx-auto mb-4">
                            📭
                        </div>
                        <p class="text-gray-500 font-medium">Aucun patient enregistré aujourd'hui</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>