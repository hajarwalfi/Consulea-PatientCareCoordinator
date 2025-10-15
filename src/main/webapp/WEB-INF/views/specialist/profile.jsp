<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Configuration du Profil - Médecin Spécialiste</title>
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
                        <span>Dashboard</span>
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <!-- Error Message -->
        <c:if test="${not empty error}">
            <div class="bg-red-50 border border-red-200 text-red-800 px-6 py-4 rounded-xl mb-6 flex items-center shadow-sm">
                <svg class="w-5 h-5 mr-3 text-red-600" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"></path>
                </svg>
                ${error}
            </div>
        </c:if>

        <!-- Header -->
        <div class="bg-white/90 backdrop-blur-sm rounded-2xl shadow-lg border border-white/50 p-8 mb-8">
            <div class="flex items-center space-x-4">
                <div class="w-16 h-16 bg-gradient-to-br from-blue-500 to-indigo-600 rounded-2xl flex items-center justify-center text-white text-2xl shadow-lg">
                    ⚙️
                </div>
                <div>
                    <h2 class="text-3xl font-bold text-gray-900 mb-2">Configuration du Profil</h2>
                    <p class="text-gray-600 font-medium">Configurez votre spécialité et vos tarifs de consultation</p>
                </div>
            </div>
        </div>

        <!-- Profile Form -->
        <div class="bg-white/90 backdrop-blur-sm rounded-2xl shadow-lg border border-white/50 p-8">
            <form method="post" action="${pageContext.request.contextPath}/specialist/update-profile">
                <div class="space-y-6">
                    <!-- Spécialité -->
                    <div>
                        <label for="specialty" class="block text-sm font-medium text-gray-700 mb-2">
                            Spécialité Médicale *
                        </label>
                        <select id="specialty" name="specialty" required
                                class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                            <option value="">-- Sélectionnez votre spécialité --</option>
                            <c:forEach var="spec" items="${specialties}">
                                <option value="${spec}" ${specialist != null && specialist.specialty == spec ? 'selected' : ''}>
                                    ${spec.displayName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Tarif de consultation -->
                    <div>
                        <label for="consultationFee" class="block text-sm font-medium text-gray-700 mb-2">
                            Tarif de Consultation (DH) *
                        </label>
                        <div class="relative">
                            <input type="number" 
                                   id="consultationFee" 
                                   name="consultationFee" 
                                   step="0.01" 
                                   min="0" 
                                   required
                                   value="${specialist != null ? specialist.consultationFee : ''}"
                                   placeholder="Ex: 200.00"
                                   class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent pr-12">
                            <div class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none">
                                <span class="text-gray-500 text-sm font-medium">DH</span>
                            </div>
                        </div>
                        <p class="mt-2 text-sm text-gray-600">
                            Ce tarif sera affiché aux médecins généralistes lors de la recherche de spécialistes
                        </p>
                    </div>

                    <!-- Durée de consultation (lecture seule) -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">
                            Durée de Consultation
                        </label>
                        <div class="w-full px-4 py-3 border border-gray-200 rounded-xl bg-gray-50 text-gray-600">
                            30 minutes (fixe)
                        </div>
                        <p class="mt-2 text-sm text-gray-500">
                            La durée des consultations est fixée à 30 minutes pour tous les spécialistes
                        </p>
                    </div>

                    <!-- Informations actuelles du profil -->
                    <c:if test="${specialist != null}">
                        <div class="bg-blue-50 rounded-xl p-6 border border-blue-200">
                            <h4 class="text-lg font-semibold text-blue-900 mb-4">Profil Actuel</h4>
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                <div>
                                    <span class="text-sm font-medium text-blue-700">Spécialité:</span>
                                    <p class="text-blue-900 font-semibold">${specialist.specialty.displayName}</p>
                                </div>
                                <div>
                                    <span class="text-sm font-medium text-blue-700">Tarif actuel:</span>
                                    <p class="text-blue-900 font-semibold">${specialist.consultationFee} DH</p>
                                </div>
                                <div>
                                    <span class="text-sm font-medium text-blue-700">Créé le:</span>
                                    <p class="text-blue-900">${specialist.createdAt.toLocalDate()}</p>
                                </div>
                                <c:if test="${specialist.updatedAt != null}">
                                    <div>
                                        <span class="text-sm font-medium text-blue-700">Dernière mise à jour:</span>
                                        <p class="text-blue-900">${specialist.updatedAt.toLocalDate()}</p>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </c:if>

                    <!-- Boutons -->
                    <div class="flex justify-end space-x-4 pt-6">
                        <a href="${pageContext.request.contextPath}/specialist/dashboard"
                           class="px-6 py-3 border border-gray-300 text-gray-700 rounded-xl font-semibold hover:bg-gray-50 transition-all duration-200">
                            Annuler
                        </a>
                        <button type="submit" 
                                class="px-6 py-3 bg-gradient-to-r from-blue-500 to-indigo-600 text-white rounded-xl font-semibold hover:from-blue-600 hover:to-indigo-700 transition-all duration-200 shadow-lg hover:shadow-xl">
                            ${specialist != null ? 'Mettre à jour' : 'Créer le profil'}
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <!-- Configuration des Créneaux Horaires -->
        <div class="mt-8 bg-white/90 backdrop-blur-sm rounded-2xl shadow-lg border border-white/50 p-8">
            <div class="flex items-center space-x-4 mb-6">
                <div class="w-10 h-10 bg-gradient-to-br from-emerald-500 to-teal-600 rounded-xl flex items-center justify-center text-white text-lg">
                    📅
                </div>
                <div>
                    <h3 class="text-xl font-semibold text-gray-900">Créer des Créneaux Horaires</h3>
                    <p class="text-gray-600">Sélectionnez les dates exactes et heures pour créer vos créneaux de disponibilité</p>
                </div>
            </div>

            <!-- Configuration des créneaux -->
            <form method="post" action="${pageContext.request.contextPath}/specialist/update-time-slots" class="space-y-6">
                <!-- Sélection de la date -->
                <div>
                    <label for="slotDate" class="block text-sm font-semibold text-gray-700 mb-2">
                        Date du créneau <span class="text-red-500">*</span>
                    </label>
                    <input type="date" 
                           id="slotDate" 
                           name="slotDate" 
                           min="${LocalDate.now()}"
                           required
                           class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                    <p class="mt-2 text-sm text-gray-600">
                        Choisissez la date exacte pour laquelle vous voulez créer des créneaux
                    </p>
                </div>

                <!-- Heures de travail -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                        <label for="startTime" class="block text-sm font-semibold text-gray-700 mb-2">
                            Heure de début <span class="text-red-500">*</span>
                        </label>
                        <input type="time" 
                               id="startTime" 
                               name="startTime" 
                               value="09:00"
                               required
                               class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                    </div>
                    <div>
                        <label for="endTime" class="block text-sm font-semibold text-gray-700 mb-2">
                            Heure de fin <span class="text-red-500">*</span>
                        </label>
                        <input type="time" 
                               id="endTime" 
                               name="endTime" 
                               value="17:00"
                               required
                               class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                    </div>
                </div>

                <!-- Durée des créneaux -->
                <div>
                    <label for="slotDuration" class="block text-sm font-semibold text-gray-700 mb-2">
                        Durée des créneaux
                    </label>
                    <select id="slotDuration" name="slotDuration" 
                            class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent bg-gray-50" disabled>
                        <option value="30" selected>30 minutes (fixe)</option>
                    </select>
                    <p class="mt-2 text-sm text-gray-600">
                        La durée des créneaux est fixée à 30 minutes pour assurer une consultation de qualité
                    </p>
                </div>

                <!-- Bouton de mise à jour des créneaux -->
                <div class="pt-4 border-t border-gray-200">
                    <button type="submit" 
                            class="w-full bg-gradient-to-r from-emerald-500 to-teal-600 text-white px-6 py-3 rounded-xl font-semibold hover:from-emerald-600 hover:to-teal-700 transition-all duration-200 shadow-lg hover:shadow-xl flex items-center justify-center space-x-2">
                        <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M4 2a1 1 0 011 1v2.101a7.002 7.002 0 0111.601 2.566 1 1 0 11-1.885.666A5.002 5.002 0 005.999 7H9a1 1 0 010 2H4a1 1 0 01-1-1V3a1 1 0 011-1zm.008 9.057a1 1 0 011.276.61A5.002 5.002 0 0014.001 13H11a1 1 0 110-2h5a1 1 0 011 1v5a1 1 0 11-2 0v-2.101a7.002 7.002 0 01-11.601-2.566 1 1 0 01.61-1.276z" clip-rule="evenodd"></path>
                        </svg>
                        <span>Mettre à jour les créneaux</span>
                    </button>
                </div>
            </form>

            <!-- Gestion automatique des créneaux -->
            <div class="mt-8 bg-gradient-to-r from-blue-50 to-indigo-50 rounded-xl p-6 border border-blue-200">
                <h4 class="text-lg font-semibold text-blue-900 mb-4 flex items-center space-x-2">
                    <span>🤖</span>
                    <span>Gestion Automatique des Créneaux</span>
                </h4>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <div class="bg-white/80 rounded-lg p-4">
                        <div class="flex items-center space-x-3 mb-2">
                            <div class="w-8 h-8 bg-orange-100 rounded-full flex items-center justify-center">
                                🔒
                            </div>
                            <h5 class="font-semibold text-gray-900">Créneau réservé</h5>
                        </div>
                        <p class="text-sm text-gray-700">Devient automatiquement indisponible dès qu'une expertise est planifiée</p>
                    </div>
                    <div class="bg-white/80 rounded-lg p-4">
                        <div class="flex items-center space-x-3 mb-2">
                            <div class="w-8 h-8 bg-gray-100 rounded-full flex items-center justify-center">
                                📁
                            </div>
                            <h5 class="font-semibold text-gray-900">Créneau passé</h5>
                        </div>
                        <p class="text-sm text-gray-700">Archivé automatiquement après la date et heure prévues</p>
                    </div>
                    <div class="bg-white/80 rounded-lg p-4">
                        <div class="flex items-center space-x-3 mb-2">
                            <div class="w-8 h-8 bg-green-100 rounded-full flex items-center justify-center">
                                ↩️
                            </div>
                            <h5 class="font-semibold text-gray-900">Annulation</h5>
                        </div>
                        <p class="text-sm text-gray-700">Le créneau redevient automatiquement disponible</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>