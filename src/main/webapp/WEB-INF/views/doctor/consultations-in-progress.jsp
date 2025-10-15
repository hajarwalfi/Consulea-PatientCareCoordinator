<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Consultations en Cours</title>
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
                            <p class="text-xs text-blue-100">Médecin Généraliste</p>
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
                    <a href="${pageContext.request.contextPath}/doctor/dashboard" 
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
                <div class="w-10 h-10 bg-gradient-to-br from-amber-500 to-orange-600 rounded-xl flex items-center justify-center text-white text-lg">
                    ⏳
                </div>
                <h2 class="text-3xl font-semibold text-gray-900">Consultations en cours</h2>
            </div>
        </div>

        <c:choose>
            <c:when test="${not empty inProgressConsultations}">
                <!-- Professional Table -->
                <div class="bg-white rounded-2xl shadow-lg border border-gray-100 overflow-hidden">
                    <table class="w-full">
                        <thead class="bg-gradient-to-r from-gray-50 to-amber-50 border-b border-gray-200">
                            <tr>
                                <th class="px-8 py-5 text-left text-sm font-semibold text-gray-800">Patient</th>
                                <th class="px-8 py-5 text-left text-sm font-semibold text-gray-800">Motif de consultation</th>
                                <th class="px-8 py-5 text-left text-sm font-semibold text-gray-800">Date/Heure</th>
                                <th class="px-8 py-5 text-left text-sm font-semibold text-gray-800">Coût</th>
                                <th class="px-8 py-5 text-left text-sm font-semibold text-gray-800">Statut</th>
                                <th class="px-8 py-5 text-center text-sm font-semibold text-gray-800">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="consultation" items="${inProgressConsultations}" varStatus="status">
                                <tr class="hover:bg-amber-50/50 transition-colors duration-200 ${status.index % 2 == 0 ? 'bg-white' : 'bg-gray-50/30'}">
                                    <td class="px-8 py-6">
                                        <div class="flex items-center space-x-4">
                                            <div class="w-12 h-12 bg-gradient-to-br from-amber-400 to-orange-500 rounded-full flex items-center justify-center text-white font-semibold text-lg shadow-sm">
                                                ${consultation.patient.fullName.substring(0, 1)}
                                            </div>
                                            <div>
                                                <div class="text-lg font-medium text-gray-900">${consultation.patient.fullName}</div>
                                                <div class="text-sm text-gray-500">${consultation.patient.age} ans</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="px-8 py-6">
                                        <div class="max-w-xs">
                                            <p class="text-sm text-gray-800 line-clamp-2">${consultation.chiefComplaint}</p>
                                            <c:if test="${not empty consultation.patient.allergies}">
                                                <div class="mt-2">
                                                    <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-red-100 text-red-800">
                                                        ⚠️ Allergies
                                                    </span>
                                                </div>
                                            </c:if>
                                        </div>
                                    </td>
                                    <td class="px-8 py-6">
                                        <div class="space-y-1">
                                            <div class="flex items-center space-x-2">
                                                <div class="w-6 h-6 bg-green-100 rounded-lg flex items-center justify-center">
                                                    📅
                                                </div>
                                                <span class="text-sm font-medium text-gray-800">${consultation.createdAt.toLocalDate()}</span>
                                            </div>
                                            <div class="flex items-center space-x-2">
                                                <div class="w-6 h-6 bg-blue-100 rounded-lg flex items-center justify-center">
                                                    🕐
                                                </div>
                                                <span class="text-sm font-medium text-gray-800">${consultation.createdAt.toLocalTime().toString().substring(0, 5)}</span>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="px-8 py-6">
                                        <div class="flex items-center space-x-2">
                                            <div class="w-6 h-6 bg-green-100 rounded-lg flex items-center justify-center">
                                                💰
                                            </div>
                                            <span class="text-lg font-semibold text-green-600">${consultation.cost} DH</span>
                                        </div>
                                    </td>
                                    <td class="px-8 py-6">
                                        <div class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-amber-100 text-amber-800 border border-amber-200">
                                            <div class="w-2 h-2 bg-amber-500 rounded-full mr-2 animate-pulse"></div>
                                            En cours
                                        </div>
                                    </td>
                                    <td class="px-8 py-6 text-center">
                                        <a href="${pageContext.request.contextPath}/doctor/create-consultation?consultationId=${consultation.id}"
                                           class="bg-gradient-to-r from-amber-500 to-orange-600 hover:from-amber-600 hover:to-orange-700 text-white px-6 py-3 rounded-xl font-medium transition-all duration-200 shadow-md hover:shadow-lg inline-flex items-center space-x-2">
                                            <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                                                <path d="M13.586 3.586a2 2 0 112.828 2.828l-.793.793-2.828-2.828.793-.793zM11.379 5.793L3 14.172V17h2.828l8.379-8.379-2.828-2.828z"></path>
                                            </svg>
                                            <span>Compléter</span>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="bg-white rounded-2xl shadow-lg border border-gray-100 p-16 text-center">
                    <div class="w-20 h-20 bg-gradient-to-br from-green-100 to-emerald-100 rounded-2xl flex items-center justify-center text-4xl mx-auto mb-4">
                        ✅
                    </div>
                    <h3 class="text-xl font-medium text-gray-700 mb-2">Aucune consultation en cours</h3>
                    <p class="text-gray-500 mb-4">Toutes vos consultations ont été traitées</p>
                    <a href="${pageContext.request.contextPath}/doctor/waiting-patients" 
                       class="inline-flex items-center px-6 py-3 bg-gradient-to-r from-blue-500 to-indigo-600 text-white rounded-xl font-medium hover:from-blue-600 hover:to-indigo-700 transition-all duration-200 shadow-md hover:shadow-lg">
                        <span class="mr-2">👥</span>
                        <span>Voir les patients en attente</span>
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>