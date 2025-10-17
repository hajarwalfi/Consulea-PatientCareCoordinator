<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Spécialistes Disponibles - Médecin Généraliste</title>
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
<body class="bg-gradient-to-br from-slate-50 to-emerald-50 min-h-screen">
    <!-- Navigation -->
    <nav class="bg-gradient-to-r from-emerald-600 via-teal-700 to-cyan-800 shadow-xl">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-center h-16">
                <div class="flex items-center space-x-4">
                    <div class="flex items-center space-x-2">
                        <div class="bg-white/20 p-2 rounded-lg">
                            🏥
                        </div>
                        <div>
                            <h1 class="text-xl font-bold text-white">Consulea</h1>
                            <p class="text-xs text-emerald-100">Médecin Généraliste</p>
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
                    <a href="${pageContext.request.contextPath}/doctor/request-expertise?consultationId=${consultationId}" 
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
        <div class="bg-white/90 backdrop-blur-sm rounded-2xl shadow-lg border border-white/50 p-8 mb-8">
            <div class="flex items-center justify-between">
                <div class="flex items-center space-x-4">
                    <div class="w-16 h-16 bg-gradient-to-br from-emerald-500 to-teal-600 rounded-2xl flex items-center justify-center text-white text-2xl shadow-lg">
                        👨‍⚕️
                    </div>
                    <div>
                        <h2 class="text-3xl font-bold text-gray-900 mb-2">Spécialistes en ${selectedSpecialty.displayName}</h2>
                        <p class="text-gray-600 font-medium">Choisissez un spécialiste pour votre demande d'expertise - ${specialists.size()} spécialiste(s) disponible(s)</p>
                    </div>
                </div>
                <div class="text-right">
                    <div class="text-sm text-gray-500">Triés par tarif croissant</div>
                    <div class="text-xs text-gray-400">Les plus abordables en premier</div>
                </div>
            </div>
        </div>

        <!-- Specialists List -->
        <div class="space-y-6">
            <c:choose>
                <c:when test="${not empty specialists}">
                    <c:forEach var="specialist" items="${specialists}">
                        <div class="bg-white/90 backdrop-blur-sm rounded-2xl shadow-lg border border-white/50 p-6 hover:shadow-xl transition-all duration-300">
                            <div class="flex items-center justify-between">
                                <!-- Specialist Info -->
                                <div class="flex-1">
                                    <div class="flex items-center space-x-4 mb-4">
                                        <div class="w-16 h-16 bg-gradient-to-br from-blue-500 to-indigo-600 rounded-2xl flex items-center justify-center text-white text-2xl shadow-lg">
                                            👨‍⚕️
                                        </div>
                                        <div>
                                            <h3 class="text-2xl font-bold text-gray-900">Dr. ${specialist.user.fullName}</h3>
                                            <div class="flex items-center space-x-4 text-gray-600">
                                                <span class="flex items-center space-x-1">
                                                    <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                                                        <path fill-rule="evenodd" d="M10 2L3 7v11a2 2 0 002 2h10a2 2 0 002-2V7l-7-5zM10 18a3 3 0 100-6 3 3 0 000 6z" clip-rule="evenodd"></path>
                                                    </svg>
                                                    <span class="font-semibold">${specialist.specialty.displayName}</span>
                                                </span>
                                                <span class="flex items-center space-x-1 text-green-600 font-semibold">
                                                    <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                                                        <path d="M8.433 7.418c.155-.103.346-.196.567-.267v1.698a2.305 2.305 0 01-.567-.267C8.07 8.34 8 8.114 8 8c0-.114.07-.34.433-.582zM11 12.849v-1.698c.22.071.412.164.567.267.364.243.433.468.433.582 0 .114-.07.34-.433.582a2.305 2.305 0 01-.567.267z"></path>
                                                        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-13a1 1 0 10-2 0v.092a4.535 4.535 0 00-1.676.662C6.602 6.234 6 7.009 6 8c0 .99.602 1.765 1.324 2.246.48.32 1.054.545 1.676.662v1.941c-.391-.127-.68-.317-.843-.504a1 1 0 10-1.51 1.31c.562.649 1.413 1.076 2.353 1.253V15a1 1 0 102 0v-.092a4.535 4.535 0 001.676-.662C13.398 13.766 14 12.991 14 12c0-.99-.602-1.765-1.324-2.246A4.535 4.535 0 0011 9.092V7.151c.391.127.68.317.843.504a1 1 0 101.511-1.31c-.563-.649-1.413-1.076-2.354-1.253V5z" clip-rule="evenodd"></path>
                                                    </svg>
                                                    <span>${specialist.consultationFee} DH</span>
                                                </span>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Specialist Details -->
                                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
                                        <div class="bg-blue-50 rounded-xl p-4 border-l-4 border-blue-500">
                                            <h4 class="font-semibold text-gray-900 mb-2">💼 Spécialité</h4>
                                            <p class="text-blue-700 font-medium">${specialist.specialty.displayName}</p>
                                        </div>
                                        
                                        <div class="bg-green-50 rounded-xl p-4 border-l-4 border-green-500">
                                            <h4 class="font-semibold text-gray-900 mb-2">💰 Tarif</h4>
                                            <p class="text-green-700 font-bold text-lg">${specialist.consultationFee} DH</p>
                                            <p class="text-xs text-gray-500">pour 30 minutes</p>
                                        </div>
                                        
                                        <div class="bg-purple-50 rounded-xl p-4 border-l-4 border-purple-500">
                                            <h4 class="font-semibold text-gray-900 mb-2">📅 Disponibilité</h4>
                                            <p class="text-purple-700 font-medium">9h00 - 12h00</p>
                                            <p class="text-xs text-gray-500">créneaux de 30 min</p>
                                        </div>
                                    </div>

                                    <!-- Professional Info -->
                                    <div class="bg-gray-50 rounded-xl p-4">
                                        <div class="flex items-center justify-between">
                                            <div>
                                                <h4 class="font-semibold text-gray-900 mb-1">Informations Professionnelles</h4>
                                                <div class="flex items-center space-x-4 text-sm text-gray-600">
                                                    <span>📧 ${specialist.user.email}</span>
                                                    <span>🆔 Spécialiste #${specialist.id}</span>
                                                    <span>📅 Inscrit le ${specialist.createdAt.toLocalDate()}</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Action Button -->
                                <div class="ml-8 text-center">
                                    <a href="${pageContext.request.contextPath}/doctor/specialist-slots/${specialist.id}?consultationId=${consultationId}"
                                       class="inline-flex items-center px-8 py-4 bg-gradient-to-r from-emerald-500 to-teal-600 text-white rounded-2xl font-bold text-lg hover:from-emerald-600 hover:to-teal-700 transition-all duration-200 shadow-lg hover:shadow-xl transform hover:scale-105">
                                        <svg class="w-5 h-5 mr-3" fill="currentColor" viewBox="0 0 20 20">
                                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path>
                                        </svg>
                                        <span>Voir créneaux</span>
                                    </a>
                                    <p class="mt-2 text-xs text-gray-500 font-medium">
                                        Choisir ce spécialiste
                                    </p>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="bg-white/90 backdrop-blur-sm rounded-2xl shadow-lg border border-white/50 p-12 text-center">
                        <div class="w-16 h-16 bg-gray-100 rounded-2xl flex items-center justify-center text-3xl mx-auto mb-4">
                            😞
                        </div>
                        <h3 class="text-lg font-medium text-gray-900 mb-2">Aucun spécialiste disponible</h3>
                        <p class="text-gray-500 mb-6">
                            Aucun spécialiste en ${selectedSpecialty.displayName} n'est actuellement disponible.
                        </p>
                        <div class="flex justify-center space-x-4">
                            <a href="${pageContext.request.contextPath}/doctor/request-expertise?consultationId=${consultationId}" 
                               class="inline-flex items-center px-6 py-3 bg-gradient-to-r from-emerald-600 to-teal-700 text-white rounded-xl font-semibold hover:from-emerald-700 hover:to-teal-800 transition-all duration-200 shadow-lg hover:shadow-xl">
                                <span class="mr-2">🔄</span>
                                <span>Choisir une autre spécialité</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/doctor/create-consultation?consultationId=${consultationId}" 
                               class="inline-flex items-center px-6 py-3 bg-gray-500 text-white rounded-xl font-semibold hover:bg-gray-600 transition-all duration-200">
                                <span class="mr-2">🏠</span>
                                <span>Retour à la consultation</span>
                            </a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Info Box -->
        <div class="mt-8 bg-emerald-50 rounded-2xl p-6 border border-emerald-200">
            <h4 class="text-lg font-semibold text-emerald-900 mb-4">ℹ️ Informations sur la Procédure</h4>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm text-emerald-700">
                <div>
                    <p>• <strong>Tri par tarif:</strong> Les spécialistes sont triés par tarif croissant pour vous aider à choisir</p>
                    <p>• <strong>Créneaux disponibles:</strong> Chaque spécialiste propose des créneaux de 30 minutes entre 9h00 et 12h00</p>
                </div>
                <div>
                    <p>• <strong>Coût total:</strong> Le tarif du spécialiste s'ajoutera au coût de la consultation</p>
                    <p>• <strong>Réponse rapide:</strong> Les spécialistes s'engagent à répondre dans les meilleurs délais</p>
                </div>
            </div>
        </div>
    </div>
</body>
</html>