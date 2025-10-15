<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Créneaux Disponibles - Dr. ${specialist.user.fullName}</title>
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
                    <a href="${pageContext.request.contextPath}/doctor/search-specialists?specialty=${specialist.specialty}&consultationId=${consultationId}" 
                       class="bg-white/10 hover:bg-white/20 text-white px-4 py-2 rounded-lg transition-all duration-200 flex items-center space-x-2">
                        <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M9.707 16.707a1 1 0 01-1.414 0l-6-6a1 1 0 010-1.414l6-6a1 1 0 011.414 1.414L5.414 9H17a1 1 0 110 2H5.414l4.293 4.293a1 1 0 010 1.414z" clip-rule="evenodd"></path>
                        </svg>
                        <span>Autres spécialistes</span>
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <!-- Error Message -->
        <c:if test="${not empty error}">
            <div class="bg-red-50 border border-red-200 text-red-800 px-6 py-4 rounded-xl mb-6 flex items-center shadow-sm">
                <svg class="w-5 h-5 mr-3 text-red-600" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"></path>
                </svg>
                ${error}
            </div>
        </c:if>

        <!-- Specialist Header -->
        <div class="bg-white/90 backdrop-blur-sm rounded-2xl shadow-lg border border-white/50 p-8 mb-8">
            <div class="flex items-center space-x-6">
                <div class="w-20 h-20 bg-gradient-to-br from-blue-500 to-indigo-600 rounded-2xl flex items-center justify-center text-white text-3xl shadow-lg">
                    👨‍⚕️
                </div>
                <div class="flex-1">
                    <h2 class="text-3xl font-bold text-gray-900 mb-2">Dr. ${specialist.user.fullName}</h2>
                    <div class="flex items-center space-x-6 text-gray-600">
                        <span class="flex items-center space-x-2">
                            <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                                <path fill-rule="evenodd" d="M10 2L3 7v11a2 2 0 002 2h10a2 2 0 002-2V7l-7-5zM10 18a3 3 0 100-6 3 3 0 000 6z" clip-rule="evenodd"></path>
                            </svg>
                            <span class="font-semibold">${specialist.specialty.displayName}</span>
                        </span>
                        <span class="flex items-center space-x-2 text-green-600 font-bold">
                            <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                                <path d="M8.433 7.418c.155-.103.346-.196.567-.267v1.698a2.305 2.305 0 01-.567-.267C8.07 8.34 8 8.114 8 8c0-.114.07-.34.433-.582zM11 12.849v-1.698c.22.071.412.164.567.267.364.243.433.468.433.582 0 .114-.07.34-.433.582a2.305 2.305 0 01-.567.267z"></path>
                                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-13a1 1 0 10-2 0v.092a4.535 4.535 0 00-1.676.662C6.602 6.234 6 7.009 6 8c0 .99.602 1.765 1.324 2.246.48.32 1.054.545 1.676.662v1.941c-.391-.127-.68-.317-.843-.504a1 1 0 10-1.51 1.31c.562.649 1.413 1.076 2.353 1.253V15a1 1 0 102 0v-.092a4.535 4.535 0 001.676-.662C13.398 13.766 14 12.991 14 12c0-.99-.602-1.765-1.324-2.246A4.535 4.535 0 0011 9.092V7.151c.391.127.68.317.843.504a1 1 0 101.511-1.31c-.563-.649-1.413-1.076-2.354-1.253V5z" clip-rule="evenodd"></path>
                            </svg>
                            <span>${specialist.consultationFee} DH</span>
                        </span>
                        <span class="text-sm">📧 ${specialist.user.email}</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Time Slots Selection -->
        <div class="bg-white/90 backdrop-blur-sm rounded-2xl shadow-lg border border-white/50 p-8">
            <h3 class="text-2xl font-bold text-gray-900 mb-6 flex items-center">
                <div class="w-10 h-10 bg-gradient-to-br from-emerald-500 to-teal-600 rounded-xl flex items-center justify-center text-white text-lg mr-4">
                    📅
                </div>
                Créneaux Disponibles
            </h3>

            <form method="post" action="${pageContext.request.contextPath}/doctor/create-expertise-request" onsubmit="return validateForm()">
                <input type="hidden" name="consultationId" value="${consultationId}">
                <input type="hidden" name="specialistId" value="${specialist.id}">
                
                <!-- Time Slots Grid -->
                <div class="mb-8">
                    <label class="block text-sm font-medium text-gray-700 mb-4">
                        Sélectionnez un créneau disponible *
                    </label>
                    <c:choose>
                        <c:when test="${not empty availableSlots}">
                            <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-6 gap-3">
                                <c:forEach var="slot" items="${availableSlots}">
                                    <label class="relative cursor-pointer">
                                        <input type="radio" name="timeSlotId" value="${slot.id}" 
                                               class="sr-only peer" required>
                                        <div class="bg-gradient-to-br from-emerald-50 to-teal-50 border-2 border-emerald-200 rounded-xl p-4 text-center transition-all duration-200 peer-checked:border-emerald-500 peer-checked:bg-gradient-to-br peer-checked:from-emerald-500 peer-checked:to-teal-600 peer-checked:text-white hover:border-emerald-400 hover:shadow-md">
                                            <div class="font-bold text-lg">${slot.timeSlotDisplay}</div>
                                            <div class="text-xs opacity-75 mt-1">30 minutes</div>
                                        </div>
                                        <div class="absolute top-2 right-2 w-4 h-4 bg-emerald-500 rounded-full opacity-0 peer-checked:opacity-100 transition-opacity duration-200">
                                            <svg class="w-4 h-4 text-white" fill="currentColor" viewBox="0 0 20 20">
                                                <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"></path>
                                            </svg>
                                        </div>
                                    </label>
                                </c:forEach>
                            </div>
                            <p class="mt-3 text-sm text-gray-600">
                                💡 Tous les créneaux sont de 30 minutes. Sélectionnez celui qui vous convient le mieux.
                            </p>
                        </c:when>
                        <c:otherwise>
                            <div class="bg-yellow-50 border border-yellow-200 rounded-xl p-6 text-center">
                                <div class="w-12 h-12 bg-yellow-100 rounded-xl flex items-center justify-center text-2xl mx-auto mb-3">
                                    😔
                                </div>
                                <h4 class="text-lg font-semibold text-yellow-800 mb-2">Aucun créneau disponible</h4>
                                <p class="text-yellow-700">
                                    Ce spécialiste n'a actuellement aucun créneau disponible. Veuillez choisir un autre spécialiste.
                                </p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <c:if test="${not empty availableSlots}">
                    <!-- Priority Selection -->
                    <div class="mb-6">
                        <label for="priority" class="block text-sm font-medium text-gray-700 mb-2">
                            Priorité de la demande *
                        </label>
                        <select id="priority" name="priority" required
                                class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-emerald-500 focus:border-transparent">
                            <option value="">-- Sélectionnez une priorité --</option>
                            <c:forEach var="priority" items="${priorities}">
                                <option value="${priority}">${priority.displayName}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Question -->
                    <div class="mb-6">
                        <label for="question" class="block text-sm font-medium text-gray-700 mb-2">
                            Question pour le spécialiste *
                        </label>
                        <textarea id="question" name="question" required
                                  placeholder="Décrivez précisément votre question médicale pour le spécialiste..."
                                  class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-emerald-500 focus:border-transparent resize-none"
                                  rows="4"></textarea>
                        <p class="mt-2 text-sm text-gray-600">
                            Soyez précis dans votre question pour obtenir un avis médical pertinent.
                        </p>
                    </div>

                    <!-- Clinical Data -->
                    <div class="mb-8">
                        <label for="clinicalData" class="block text-sm font-medium text-gray-700 mb-2">
                            Données cliniques supplémentaires (optionnel)
                        </label>
                        <textarea id="clinicalData" name="clinicalData"
                                  placeholder="Informations complémentaires, résultats d'examens, antécédents pertinents..."
                                  class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-emerald-500 focus:border-transparent resize-none"
                                  rows="3"></textarea>
                        <p class="mt-2 text-sm text-gray-600">
                            Ajoutez toute information clinique qui pourrait aider le spécialiste.
                        </p>
                    </div>

                    <!-- Summary Box -->
                    <div class="bg-emerald-50 rounded-xl p-6 border border-emerald-200 mb-8">
                        <h4 class="text-lg font-semibold text-emerald-900 mb-4">📋 Récapitulatif de la demande</h4>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm">
                            <div class="space-y-2">
                                <div class="flex justify-between">
                                    <span class="text-emerald-700">Spécialiste:</span>
                                    <span class="font-semibold text-emerald-900">Dr. ${specialist.user.fullName}</span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-emerald-700">Spécialité:</span>
                                    <span class="font-semibold text-emerald-900">${specialist.specialty.displayName}</span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-emerald-700">Durée:</span>
                                    <span class="font-semibold text-emerald-900">30 minutes</span>
                                </div>
                            </div>
                            <div class="space-y-2">
                                <div class="flex justify-between">
                                    <span class="text-emerald-700">Tarif expertise:</span>
                                    <span class="font-bold text-emerald-900 text-lg">${specialist.consultationFee} DH</span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-emerald-700">Contact:</span>
                                    <span class="font-semibold text-emerald-900">${specialist.user.email}</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="flex justify-end space-x-4">
                        <a href="${pageContext.request.contextPath}/doctor/search-specialists?specialty=${specialist.specialty}&consultationId=${consultationId}"
                           class="px-6 py-3 border border-gray-300 text-gray-700 rounded-xl font-semibold hover:bg-gray-50 transition-all duration-200">
                            Choisir un autre spécialiste
                        </a>
                        <button type="submit" id="submitBtn" disabled
                                class="px-8 py-3 bg-gradient-to-r from-emerald-500 to-teal-600 text-white rounded-xl font-semibold hover:from-emerald-600 hover:to-teal-700 transition-all duration-200 shadow-lg hover:shadow-xl disabled:opacity-50 disabled:cursor-not-allowed">
                            Envoyer la demande d'expertise
                        </button>
                    </div>
                </c:if>
            </form>
        </div>
    </div>

    <script>
        function validateForm() {
            const timeSlot = document.querySelector('input[name="timeSlotId"]:checked');
            const priority = document.getElementById('priority').value;
            const question = document.getElementById('question').value.trim();
            
            if (!timeSlot) {
                alert('Veuillez sélectionner un créneau horaire.');
                return false;
            }
            if (!priority) {
                alert('Veuillez sélectionner une priorité.');
                return false;
            }
            if (!question) {
                alert('Veuillez saisir votre question.');
                return false;
            }
            
            return true;
        }

        // Enable submit button when form is valid
        function checkFormValidity() {
            const timeSlot = document.querySelector('input[name="timeSlotId"]:checked');
            const priority = document.getElementById('priority').value;
            const question = document.getElementById('question').value.trim();
            const submitBtn = document.getElementById('submitBtn');
            
            if (timeSlot && priority && question) {
                submitBtn.disabled = false;
            } else {
                submitBtn.disabled = true;
            }
        }

        // Add event listeners
        document.addEventListener('DOMContentLoaded', function() {
            const timeSlots = document.querySelectorAll('input[name="timeSlotId"]');
            const priority = document.getElementById('priority');
            const question = document.getElementById('question');
            
            timeSlots.forEach(slot => slot.addEventListener('change', checkFormValidity));
            if (priority) priority.addEventListener('change', checkFormValidity);
            if (question) question.addEventListener('input', checkFormValidity);
        });
    </script>
</body>
</html>