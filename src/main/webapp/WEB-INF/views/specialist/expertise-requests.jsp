<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Demandes d'Expertise</title>
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
<body class="bg-gradient-to-br from-slate-50 to-blue-50 min-h-screen">
    <!-- Navigation -->
    <nav class="bg-gradient-to-r from-blue-600 via-blue-700 to-indigo-800 shadow-xl">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-center h-16">
                <div class="flex items-center space-x-4">
                    <div class="flex items-center space-x-2">
                        <div class="bg-white/20 p-2 rounded-lg">
                            🏥
                        </div>
                        <div>
                            <h1 class="text-xl font-bold text-white">Consulea</h1>
                            <p class="text-xs text-blue-100">Médecin Spécialiste</p>
                        </div>
                    </div>
                </div>
                
                <div class="flex items-center space-x-4">
                    <div class="flex items-center space-x-2 text-white">
                        <div class="w-8 h-8 bg-white/20 rounded-full flex items-center justify-center">
                            👨‍⚕️
                        </div>
                        <span class="font-medium">Dr. ${sessionScope.userName}</span>
                    </div>
                    <a href="${pageContext.request.contextPath}/specialist/dashboard" 
                       class="bg-white/10 hover:bg-white/20 text-white px-4 py-2 rounded-lg transition-all duration-200 flex items-center space-x-2">
                        <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M9.707 16.707a1 1 0 01-1.414 0l-6-6a1 1 0 010-1.414l6-6a1 1 0 011.414 1.414L5.414 9H17a1 1 0 110 2H5.414l4.293 4.293a1 1 0 010 1.414z" clip-rule="evenodd"></path>
                        </svg>
                        <span>Retour</span>
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <!-- Header -->
        <div class="mb-8">
            <div class="flex items-center space-x-3 mb-3">
                <div class="w-10 h-10 bg-gradient-to-br from-blue-500 to-indigo-600 rounded-xl flex items-center justify-center text-white text-lg">
                    📋
                </div>
                <h2 class="text-3xl font-semibold text-gray-900">Demandes d'expertise</h2>
            </div>
        </div>

        <!-- Modern Filters -->
        <div class="bg-white/95 backdrop-blur-sm rounded-xl shadow-lg border border-slate-200/60 p-6 mb-6">
            <form method="get" action="${pageContext.request.contextPath}/specialist/expertise-requests" class="flex flex-wrap gap-4 items-end">
                <div class="flex-1 min-w-[240px]">
                    <label for="status" class="block text-xs font-semibold text-slate-700 uppercase tracking-wide mb-3">Filtrer par statut</label>
                    <select id="status" name="status" class="w-full px-4 py-3 bg-white border border-slate-300 rounded-lg text-sm font-medium text-slate-700 focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all duration-200 shadow-sm hover:border-slate-400">
                        <option value="">🔍 Tous les statuts</option>
                        <c:forEach var="status" items="${expertiseStatuses}">
                            <option value="${status}" ${statusFilter == status ? 'selected' : ''}>
                                <c:choose>
                                    <c:when test="${status == 'EN_ATTENTE'}">⏳ En attente</c:when>
                                    <c:otherwise>✅ Terminées</c:otherwise>
                                </c:choose>
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="flex-1 min-w-[240px]">
                    <label for="priority" class="block text-xs font-semibold text-slate-700 uppercase tracking-wide mb-3">Filtrer par priorité</label>
                    <select id="priority" name="priority" class="w-full px-4 py-3 bg-white border border-slate-300 rounded-lg text-sm font-medium text-slate-700 focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all duration-200 shadow-sm hover:border-slate-400">
                        <option value="">🎯 Toutes les priorités</option>
                        <c:forEach var="priority" items="${priorities}">
                            <option value="${priority}" ${priorityFilter == priority ? 'selected' : ''}>
                                <c:choose>
                                    <c:when test="${priority == 'URGENTE'}">🚨 Urgente</c:when>
                                    <c:otherwise>⏰ Normale</c:otherwise>
                                </c:choose>
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="flex space-x-3">
                    <button type="submit" class="inline-flex items-center px-6 py-3 bg-gradient-to-r from-blue-600 to-blue-700 hover:from-blue-700 hover:to-blue-800 text-white text-sm font-semibold rounded-lg transition-all duration-200 shadow-md hover:shadow-lg focus:ring-2 focus:ring-blue-500 focus:ring-offset-2">
                        <svg class="w-4 h-4 mr-2" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z" clip-rule="evenodd"></path>
                        </svg>
                        Filtrer
                    </button>

                    <a href="${pageContext.request.contextPath}/specialist/expertise-requests" class="inline-flex items-center px-6 py-3 bg-slate-100 hover:bg-slate-200 text-slate-700 text-sm font-semibold rounded-lg transition-all duration-200 border border-slate-300 hover:border-slate-400">
                        <svg class="w-4 h-4 mr-2" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M4 2a1 1 0 011 1v2.101a7.002 7.002 0 0111.601 2.566 1 1 0 11-1.885.666A5.002 5.002 0 005.999 7H9a1 1 0 010 2H4a1 1 0 01-1-1V3a1 1 0 011-1zm.008 9.057a1 1 0 011.276.61A5.002 5.002 0 0014.001 13H11a1 1 0 110-2h5a1 1 0 011 1v5a1 1 0 11-2 0v-2.101a7.002 7.002 0 01-11.601-2.566 1 1 0 01.61-1.276z" clip-rule="evenodd"></path>
                        </svg>
                        Réinitialiser
                    </a>
                </div>
            </form>

            <!-- Filter Status Indicator -->
            <c:if test="${statusFilter != null || priorityFilter != null}">
                <div class="mt-4 pt-4 border-t border-slate-200">
                    <div class="flex items-center justify-between">
                        <div class="flex items-center space-x-2 text-sm text-slate-600">
                            <svg class="w-4 h-4 text-blue-500" fill="currentColor" viewBox="0 0 20 20">
                                <path fill-rule="evenodd" d="M3 3a1 1 0 011-1h12a1 1 0 011 1v3a1 1 0 01-.293.707L12 11.414V15a1 1 0 01-.293.707l-2 2A1 1 0 018 17v-5.586L3.293 6.707A1 1 0 013 6V3z" clip-rule="evenodd"></path>
                            </svg>
                            <span class="font-medium">Filtres actifs :</span>
                            <c:if test="${statusFilter != null}">
                                <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                                    Statut: <c:choose><c:when test="${statusFilter == 'EN_ATTENTE'}">En attente</c:when><c:otherwise>Terminées</c:otherwise></c:choose>
                                </span>
                            </c:if>
                            <c:if test="${priorityFilter != null}">
                                <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800">
                                    Priorité: <c:choose><c:when test="${priorityFilter == 'URGENTE'}">Urgente</c:when><c:otherwise>Normale</c:otherwise></c:choose>
                                </span>
                            </c:if>
                        </div>
                        <span class="text-sm text-slate-500 font-medium">${expertiseRequests.size()} résultat(s)</span>
                    </div>
                </div>
            </c:if>
        </div>

        <c:choose>
            <c:when test="${not empty expertiseRequests}">
                <!-- Modern Enhanced Table -->
                <div class="bg-white rounded-2xl shadow-xl border border-gray-200/50 overflow-hidden">
                    <!-- Table Header with Stats -->
                    <div class="bg-gradient-to-r from-slate-800 to-slate-900 px-8 py-6 border-b border-slate-700">
                        <div class="flex items-center justify-between">
                            <div class="flex items-center space-x-4">
                                <div class="w-10 h-10 bg-gradient-to-br from-blue-500 to-indigo-600 rounded-lg flex items-center justify-center">
                                    <svg class="w-5 h-5 text-white" fill="currentColor" viewBox="0 0 20 20">
                                        <path d="M9 2a1 1 0 000 2h2a1 1 0 100-2H9z"></path>
                                        <path fill-rule="evenodd" d="M4 5a2 2 0 012-2v1a1 1 0 001 1h6a1 1 0 001-1V3a2 2 0 012 2v6a2 2 0 01-2 2H6a2 2 0 01-2-2V5zm3 4a1 1 0 000 2h.01a1 1 0 100-2H7zm3 0a1 1 0 000 2h3a1 1 0 100-2h-3z" clip-rule="evenodd"></path>
                                    </svg>
                                </div>
                                <div>
                                    <h3 class="text-lg font-semibold text-white">Demandes d'Expertise Médicale</h3>
                                    <p class="text-sm text-slate-300">${expertiseRequests.size()} demande(s) au total</p>
                                </div>
                            </div>
                            <div class="flex items-center space-x-6 text-sm">
                                <div class="flex items-center space-x-2">
                                    <div class="w-3 h-3 bg-orange-400 rounded-full animate-pulse"></div>
                                    <span class="text-slate-300">En attente</span>
                                </div>
                                <div class="flex items-center space-x-2">
                                    <div class="w-3 h-3 bg-green-400 rounded-full"></div>
                                    <span class="text-slate-300">Terminées</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Table Content -->
                    <div class="overflow-x-auto">
                        <table class="w-full table-fixed">
                            <thead class="bg-slate-50 border-b border-slate-200">
                                <tr>
                                    <th class="w-72 px-6 py-4 text-left text-xs font-semibold text-slate-700 uppercase tracking-wide">Patient & Médecin</th>
                                    <th class="w-48 px-6 py-4 text-left text-xs font-semibold text-slate-700 uppercase tracking-wide">Date & Heure</th>
                                    <th class="w-80 px-6 py-4 text-left text-xs font-semibold text-slate-700 uppercase tracking-wide">Question Médicale</th>
                                    <th class="w-32 px-6 py-4 text-left text-xs font-semibold text-slate-700 uppercase tracking-wide">Priorité</th>
                                    <th class="w-32 px-6 py-4 text-left text-xs font-semibold text-slate-700 uppercase tracking-wide">Statut</th>
                                    <th class="w-40 px-6 py-4 text-center text-xs font-semibold text-slate-700 uppercase tracking-wide">Actions</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-slate-100">
                                <c:forEach var="request" items="${expertiseRequests}" varStatus="status">
                                    <tr class="hover:bg-slate-50/80 transition-all duration-200 group ${status.index % 2 == 0 ? 'bg-white' : 'bg-slate-25'}">
                                        <!-- Patient & Doctor Info -->
                                        <td class="px-6 py-5">
                                            <div class="flex items-start space-x-4">
                                                <div class="w-11 h-11 bg-gradient-to-br from-blue-500 to-indigo-600 rounded-full flex items-center justify-center text-white font-medium text-sm shadow-sm group-hover:shadow-md transition-shadow duration-200">
                                                    ${request.consultation.patient.fullName.substring(0, 1)}
                                                </div>
                                                <div class="flex-1 min-w-0">
                                                    <div class="flex items-center space-x-2 mb-1">
                                                        <p class="text-sm font-semibold text-slate-900 truncate">${request.consultation.patient.fullName}</p>
                                                        <span class="inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium bg-slate-100 text-slate-700">
                                                            ${request.consultation.patient.age} ans
                                                        </span>
                                                    </div>
                                                    <p class="text-xs text-slate-600 truncate mb-1">Dr. ${request.requestingDoctor.fullName}</p>
                                                    <p class="text-xs text-slate-500 truncate">${request.consultation.chiefComplaint}</p>
                                                    <c:if test="${not empty request.consultation.patient.allergies}">
                                                        <div class="flex items-center space-x-1 mt-1">
                                                            <svg class="w-3 h-3 text-red-500" fill="currentColor" viewBox="0 0 20 20">
                                                                <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd"></path>
                                                            </svg>
                                                            <span class="text-xs text-red-600 font-medium">Allergies</span>
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </td>

                                        <!-- Date & Time -->
                                        <td class="px-6 py-5">
                                            <div class="flex items-center space-x-3">
                                                <div class="w-8 h-8 bg-blue-100 rounded-lg flex items-center justify-center group-hover:bg-blue-200 transition-colors duration-200">
                                                    <svg class="w-4 h-4 text-blue-600" fill="currentColor" viewBox="0 0 20 20">
                                                        <path fill-rule="evenodd" d="M6 2a1 1 0 00-1 1v1H4a2 2 0 00-2 2v10a2 2 0 002 2h12a2 2 0 002-2V6a2 2 0 00-2-2h-1V3a1 1 0 10-2 0v1H7V3a1 1 0 00-1-1zm0 5a1 1 0 000 2h8a1 1 0 100-2H6z" clip-rule="evenodd"></path>
                                                    </svg>
                                                </div>
                                                <div>
                                                    <p class="text-sm font-medium text-slate-900">${request.createdAt.toLocalDate()}</p>
                                                    <p class="text-xs text-slate-600">${request.createdAt.toLocalTime().toString().substring(0, 5)}</p>
                                                    <p class="text-xs text-slate-500 mt-0.5">Créneau: ${request.timeSlot.timeSlotDisplay}</p>
                                                </div>
                                            </div>
                                        </td>

                                        <!-- Medical Question -->
                                        <td class="px-6 py-5">
                                            <div class="space-y-2">
                                                <p class="text-sm text-slate-900 leading-relaxed line-clamp-3">
                                                    ${request.question.length() > 120 ? request.question.substring(0, 120).concat('...') : request.question}
                                                </p>
                                                <c:if test="${not empty request.clinicalData}">
                                                    <div class="flex items-center space-x-1">
                                                        <svg class="w-3 h-3 text-green-600" fill="currentColor" viewBox="0 0 20 20">
                                                            <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd"></path>
                                                        </svg>
                                                        <span class="text-xs text-green-700 font-medium">Données cliniques incluses</span>
                                                    </div>
                                                </c:if>
                                                <c:if test="${request.status == 'TERMINEE' && not empty request.specialistResponse}">
                                                    <div class="pt-2 border-t border-slate-100">
                                                        <p class="text-xs text-slate-600 font-medium mb-1">Votre réponse:</p>
                                                        <p class="text-xs text-slate-700 line-clamp-2">
                                                            ${request.specialistResponse.length() > 100 ? request.specialistResponse.substring(0, 100).concat('...') : request.specialistResponse}
                                                        </p>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </td>

                                        <!-- Priority -->
                                        <td class="px-6 py-5">
                                            <c:choose>
                                                <c:when test="${request.priority == 'URGENTE'}">
                                                    <span class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-semibold bg-red-100 text-red-800 border border-red-200">
                                                        <svg class="w-3 h-3 mr-1" fill="currentColor" viewBox="0 0 20 20">
                                                            <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92z" clip-rule="evenodd"></path>
                                                        </svg>
                                                        Urgente
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800 border border-yellow-200">
                                                        <svg class="w-3 h-3 mr-1" fill="currentColor" viewBox="0 0 20 20">
                                                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-12a1 1 0 10-2 0v4a1 1 0 00.293.707l2.828 2.829a1 1 0 101.415-1.415L11 9.586V6z" clip-rule="evenodd"></path>
                                                        </svg>
                                                        Normale
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <!-- Status -->
                                        <td class="px-6 py-5">
                                            <c:choose>
                                                <c:when test="${request.status == 'EN_ATTENTE'}">
                                                    <span class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-semibold bg-orange-100 text-orange-800 border border-orange-200">
                                                        <div class="w-2 h-2 bg-orange-500 rounded-full mr-2 animate-pulse"></div>
                                                        En attente
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-semibold bg-green-100 text-green-800 border border-green-200">
                                                        <svg class="w-3 h-3 mr-1" fill="currentColor" viewBox="0 0 20 20">
                                                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path>
                                                        </svg>
                                                        Terminée
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <!-- Actions -->
                                        <td class="px-6 py-5 text-center">
                                            <a href="${pageContext.request.contextPath}/specialist/expertise-request/${request.id}"
                                               class="inline-flex items-center px-4 py-2 bg-gradient-to-r from-blue-600 to-blue-700 hover:from-blue-700 hover:to-blue-800 text-white text-xs font-semibold rounded-lg transition-all duration-200 shadow-sm hover:shadow-md group-hover:scale-105">
                                                <c:choose>
                                                    <c:when test="${request.status == 'EN_ATTENTE'}">
                                                        <svg class="w-3 h-3 mr-1.5" fill="currentColor" viewBox="0 0 20 20">
                                                            <path d="M17.414 2.586a2 2 0 00-2.828 0L7 10.172V13h2.828l7.586-7.586a2 2 0 000-2.828z"></path>
                                                            <path fill-rule="evenodd" d="M2 6a2 2 0 012-2h4a1 1 0 010 2H4v10h10v-4a1 1 0 112 0v4a2 2 0 01-2 2H4a2 2 0 01-2-2V6z" clip-rule="evenodd"></path>
                                                        </svg>
                                                        Répondre
                                                    </c:when>
                                                    <c:otherwise>
                                                        <svg class="w-3 h-3 mr-1.5" fill="currentColor" viewBox="0 0 20 20">
                                                            <path d="M10 12a2 2 0 100-4 2 2 0 000 4z"></path>
                                                            <path fill-rule="evenodd" d="M.458 10C1.732 5.943 5.522 3 10 3s8.268 2.943 9.542 7c-1.274 4.057-5.064 7-9.542 7S1.732 14.057.458 10zM14 10a4 4 0 11-8 0 4 4 0 018 0z" clip-rule="evenodd"></path>
                                                        </svg>
                                                        Détails
                                                    </c:otherwise>
                                                </c:choose>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="bg-white rounded-2xl shadow-lg border border-gray-100 p-16 text-center">
                    <div class="w-20 h-20 bg-gradient-to-br from-blue-100 to-indigo-100 rounded-2xl flex items-center justify-center text-4xl mx-auto mb-4">
                        😊
                    </div>
                    <h3 class="text-xl font-medium text-gray-700 mb-2">Aucune demande d'expertise</h3>
                    <p class="text-gray-500">Vous n'avez reçu aucune demande pour le moment</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>