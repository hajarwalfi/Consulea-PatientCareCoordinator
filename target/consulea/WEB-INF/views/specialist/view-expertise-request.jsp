<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Répondre à l'Expertise Médicale</title>
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
                    <a href="${pageContext.request.contextPath}/specialist/expertise-requests" 
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
        <!-- Success/Error Messages -->
        <c:if test="${not empty sessionScope.success}">
            <div class="bg-green-50 border border-green-200 text-green-800 px-6 py-4 rounded-xl mb-6 flex items-center shadow-sm">
                <svg class="w-5 h-5 mr-3 text-green-600" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path>
                </svg>
                ${sessionScope.success}
                <c:remove var="success" scope="session"/>
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="bg-red-50 border border-red-200 text-red-800 px-6 py-4 rounded-xl mb-6 flex items-center shadow-sm">
                <svg class="w-5 h-5 mr-3 text-red-600" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"></path>
                </svg>
                ${error}
            </div>
        </c:if>

        <!-- Header -->
        <div class="mb-8">
            <div class="flex items-center space-x-3 mb-3">
                <div class="w-10 h-10 bg-gradient-to-br from-blue-500 to-indigo-600 rounded-xl flex items-center justify-center text-white text-lg">
                    🩺
                </div>
                <h2 class="text-3xl font-semibold text-gray-900">Expertise Médicale</h2>
            </div>
            <p class="text-gray-600 ml-13">Répondre à la demande d'expertise du médecin généraliste</p>
        </div>

        <!-- Two-Column Grid Layout -->
        <div class="grid grid-cols-1 xl:grid-cols-2 gap-8">
            <!-- LEFT COLUMN: Patient Information -->  
            <div class="bg-white rounded-2xl shadow-lg border border-gray-100 p-8">
                <!-- Patient Header -->
                <div class="flex items-center space-x-4 mb-6 pb-6 border-b border-gray-200">
                    <div class="w-16 h-16 bg-gradient-to-br from-blue-400 to-indigo-500 rounded-2xl flex items-center justify-center text-white font-semibold text-xl shadow-sm">
                        ${expertiseRequest.consultation.patient.fullName.substring(0, 1)}
                    </div>
                    <div>
                        <h3 class="text-2xl font-semibold text-gray-900">${expertiseRequest.consultation.patient.fullName}</h3>
                        <p class="text-gray-600">${expertiseRequest.consultation.patient.age} ans • Demande #${expertiseRequest.id}</p>
                        <div class="flex items-center space-x-3 mt-2">
                            <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium ${expertiseRequest.status == 'EN_ATTENTE' ? 'bg-amber-100 text-amber-800' : 'bg-green-100 text-green-800'}">
                                ${expertiseRequest.statusDisplay}
                            </span>
                            <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium ${expertiseRequest.priority == 'URGENTE' ? 'bg-red-100 text-red-800' : 'bg-yellow-100 text-yellow-800'}">
                                ${expertiseRequest.priorityDisplay}
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Patient Details -->
                <div class="space-y-4">
                    <!-- Administrative Info -->
                    <div>
                        <h4 class="text-sm font-semibold text-gray-700 mb-3 flex items-center space-x-2">
                            <span>📋</span>
                            <span>Informations administratives</span>
                        </h4>
                        <div class="grid grid-cols-1 gap-3">
                            <div class="bg-gray-50 rounded-lg p-3">
                                <p class="text-xs text-gray-500 uppercase font-medium">Date de naissance</p>
                                <p class="text-sm font-medium text-gray-900">${expertiseRequest.consultation.patient.birthDate}</p>
                            </div>
                            <div class="bg-gray-50 rounded-lg p-3">
                                <p class="text-xs text-gray-500 uppercase font-medium">Sécurité sociale</p>
                                <p class="text-sm font-medium text-gray-900 font-mono">${expertiseRequest.consultation.patient.socialSecurityNumber}</p>
                            </div>
                            <div class="bg-gray-50 rounded-lg p-3">
                                <p class="text-xs text-gray-500 uppercase font-medium">Téléphone</p>
                                <p class="text-sm font-medium text-gray-900">${expertiseRequest.consultation.patient.phone != null ? expertiseRequest.consultation.patient.phone : 'Non renseigné'}</p>
                            </div>
                        </div>
                    </div>

                    <!-- Medical Alerts -->
                    <div>
                        <h4 class="text-sm font-semibold text-gray-700 mb-3 flex items-center space-x-2">
                            <span>⚠️</span>
                            <span>Alertes médicales</span>
                        </h4>
                        <div class="bg-red-50 border border-red-200 rounded-lg p-3">
                            <p class="text-xs text-red-600 uppercase font-medium">Allergies</p>
                            <p class="text-sm font-medium text-red-700">${expertiseRequest.consultation.patient.allergies != null ? expertiseRequest.consultation.patient.allergies : 'Aucune allergie connue'}</p>
                        </div>
                    </div>

                    <!-- Requesting Doctor Info -->
                    <div>
                        <h4 class="text-sm font-semibold text-gray-700 mb-3 flex items-center space-x-2">
                            <span>👨‍⚕️</span>
                            <span>Médecin demandeur</span>
                        </h4>
                        <div class="bg-green-50 border border-green-200 rounded-lg p-4">
                            <div class="font-semibold text-gray-900">Dr. ${expertiseRequest.requestingDoctor.fullName}</div>
                            <div class="text-sm text-gray-600">Médecin Généraliste</div>
                            <div class="text-xs text-green-600 mt-2">
                                Demande créée le ${expertiseRequest.createdAt.toLocalDate()} à ${expertiseRequest.createdAt.toLocalTime().toString().substring(0, 5)}
                            </div>
                            <div class="text-xs text-green-600">
                                Créneau prévu: ${expertiseRequest.timeSlot.timeSlotDisplay}
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- RIGHT COLUMN: Expertise Details and Response Form -->
            <div class="bg-white rounded-2xl shadow-lg border border-gray-100 p-8">
                <div class="flex items-center space-x-3 mb-6">
                    <div class="w-8 h-8 bg-gradient-to-br from-green-500 to-emerald-600 rounded-lg flex items-center justify-center text-white">
                        ✏️
                    </div>
                    <h3 class="text-xl font-semibold text-gray-900">
                        <c:choose>
                            <c:when test="${expertiseRequest.status == 'EN_ATTENTE'}">Répondre à l'Expertise</c:when>
                            <c:otherwise>Expertise Terminée</c:otherwise>
                        </c:choose>
                    </h3>
                </div>

                <div class="space-y-6">
                    <!-- Consultation Details -->
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-2">
                            Motif de consultation <span class="text-red-500">*</span>
                        </label>
                        <div class="w-full px-4 py-3 border border-gray-300 rounded-xl bg-gray-50 text-gray-700">
                            ${expertiseRequest.consultation.chiefComplaint}
                        </div>
                    </div>

                    <!-- Symptoms -->  
                    <c:if test="${not empty expertiseRequest.consultation.symptoms}">
                        <div>
                            <label class="block text-sm font-semibold text-gray-700 mb-2">
                                Analyse des symptômes <span class="text-red-500">*</span>
                            </label>
                            <div class="w-full px-4 py-3 border border-gray-300 rounded-xl bg-gray-50 text-gray-700 min-h-[72px]">
                                ${expertiseRequest.consultation.symptoms}
                            </div>
                        </div>
                    </c:if>

                    <!-- Clinical Examination -->
                    <c:if test="${not empty expertiseRequest.consultation.clinicalExamination}">
                        <div>
                            <label class="block text-sm font-semibold text-gray-700 mb-2">
                                Observations cliniques <span class="text-red-500">*</span>
                            </label>
                            <div class="w-full px-4 py-3 border border-gray-300 rounded-xl bg-gray-50 text-gray-700 min-h-[96px]">
                                ${expertiseRequest.consultation.clinicalExamination}
                            </div>
                        </div>
                    </c:if>

                    <!-- Expertise Question -->
                    <div class="pt-4 border-t border-gray-200">
                        <h4 class="text-sm font-semibold text-gray-700 mb-3 flex items-center space-x-2">
                            <span>❓</span>
                            <span>Question du médecin généraliste</span>
                        </h4>
                        <div class="w-full px-4 py-3 border border-purple-300 rounded-xl bg-purple-50 text-purple-800 min-h-[72px]">
                            ${expertiseRequest.question}
                        </div>
                    </div>

                    <!-- Clinical Data -->
                    <c:if test="${not empty expertiseRequest.clinicalData}">
                        <div>
                            <label class="block text-sm font-semibold text-gray-700 mb-2">
                                Données cliniques supplémentaires
                            </label>
                            <div class="w-full px-4 py-3 border border-indigo-300 rounded-xl bg-indigo-50 text-indigo-800 min-h-[72px]">
                                ${expertiseRequest.clinicalData}
                            </div>
                        </div>
                    </c:if>

                    <!-- Response Section -->
                    <c:choose>
                        <c:when test="${expertiseRequest.status == 'EN_ATTENTE'}">
                            <!-- Response Form -->
                            <form method="post" action="${pageContext.request.contextPath}/specialist/respond-expertise" class="pt-4 border-t border-gray-200">
                                <input type="hidden" name="requestId" value="${expertiseRequest.id}">
                                
                                <h4 class="text-sm font-semibold text-gray-700 mb-4 flex items-center space-x-2">
                                    <span>💡</span>
                                    <span>Votre Avis d'Expert</span>
                                </h4>
                                
                                <div class="space-y-6">
                                    <div>
                                        <label for="specialistResponse" class="block text-sm font-semibold text-gray-700 mb-2">
                                            Avis médical <span class="text-red-500">*</span>
                                        </label>
                                        <textarea 
                                            id="specialistResponse" 
                                            name="specialistResponse" 
                                            required
                                            rows="6"
                                            class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200"
                                            placeholder="Donnez votre avis d'expert concernant le cas présenté..."
                                        ></textarea>
                                    </div>
                                    
                                    <div>
                                        <label for="recommendations" class="block text-sm font-semibold text-gray-700 mb-2">
                                            Recommandations (optionnel)
                                        </label>
                                        <textarea 
                                            id="recommendations" 
                                            name="recommendations"
                                            rows="4"
                                            class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200"
                                            placeholder="Recommandations spécifiques pour la prise en charge..."
                                        ></textarea>
                                    </div>
                                </div>

                                <!-- Actions finales -->
                                <div class="flex flex-col space-y-3 pt-6 border-t border-gray-200 mt-6">
                                    <button type="submit" class="w-full bg-gradient-to-r from-blue-500 to-indigo-600 hover:from-blue-600 hover:to-indigo-700 text-white px-6 py-3 rounded-xl font-medium transition-all duration-200 shadow-md hover:shadow-lg flex items-center justify-center space-x-2">
                                        <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                                            <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"></path>
                                        </svg>
                                        <span>Envoyer la réponse</span>
                                    </button>
                                    <a href="${pageContext.request.contextPath}/specialist/expertise-requests"
                                       class="w-full bg-gray-100 hover:bg-gray-200 text-gray-700 px-6 py-3 rounded-xl font-medium transition-all duration-200 flex items-center justify-center space-x-2">
                                        <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                                            <path fill-rule="evenodd" d="M9.707 16.707a1 1 0 01-1.414 0l-6-6a1 1 0 010-1.414l6-6a1 1 0 011.414 1.414L5.414 9H17a1 1 0 110 2H5.414l4.293 4.293a1 1 0 010 1.414z" clip-rule="evenodd"></path>
                                        </svg>
                                        <span>Retour à la liste</span>
                                    </a>
                                </div>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <!-- Display Response -->
                            <div class="pt-4 border-t border-gray-200">
                                <h4 class="text-sm font-semibold text-gray-700 mb-4 flex items-center space-x-2">
                                    <span>✅</span>
                                    <span>Expertise Terminée</span>
                                </h4>
                                
                                <div class="space-y-4">
                                    <div>
                                        <label class="block text-sm font-semibold text-gray-700 mb-2">
                                            Avis médical
                                        </label>
                                        <div class="w-full px-4 py-3 border border-green-300 rounded-xl bg-green-50 text-green-800 min-h-[144px]">
                                            ${expertiseRequest.specialistResponse}
                                        </div>
                                    </div>
                                    
                                    <c:if test="${not empty expertiseRequest.recommendations}">
                                        <div>
                                            <label class="block text-sm font-semibold text-gray-700 mb-2">
                                                Recommandations
                                            </label>
                                            <div class="w-full px-4 py-3 border border-blue-300 rounded-xl bg-blue-50 text-blue-800 min-h-[96px]">
                                                ${expertiseRequest.recommendations}
                                            </div>
                                        </div>
                                    </c:if>
                                    
                                    <div class="bg-gray-50 rounded-xl p-3 text-center">
                                        <span class="text-sm font-medium text-gray-500">Expertise terminée le:</span>
                                        <span class="text-sm font-semibold text-gray-900 ml-2">${expertiseRequest.completedAt.toLocalDate()} à ${expertiseRequest.completedAt.toLocalTime().toString().substring(0, 5)}</span>
                                    </div>
                                </div>
                                
                                <div class="flex justify-center pt-6">
                                    <a href="${pageContext.request.contextPath}/specialist/expertise-requests"
                                       class="bg-gray-100 hover:bg-gray-200 text-gray-700 px-6 py-3 rounded-xl font-medium transition-all duration-200 flex items-center space-x-2">
                                        <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                                            <path fill-rule="evenodd" d="M9.707 16.707a1 1 0 01-1.414 0l-6-6a1 1 0 010-1.414l6-6a1 1 0 011.414 1.414L5.414 9H17a1 1 0 110 2H5.414l4.293 4.293a1 1 0 010 1.414z" clip-rule="evenodd"></path>
                                        </svg>
                                        <span>Retour à la liste</span>
                                    </a>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</body>
</html>