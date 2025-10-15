<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tableau de Bord - Médecin Spécialiste</title>
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
                <div class="w-16 h-16 bg-gradient-to-br from-blue-500 to-indigo-600 rounded-2xl flex items-center justify-center text-white text-2xl shadow-lg">
                    🩺
                </div>
                <div>
                    <h2 class="text-3xl font-bold text-gray-900 mb-2">Tableau de Bord</h2>
                    <p class="text-gray-600 font-medium">Bienvenue Dr. ${sessionScope.userName} - ${specialist.specialty.displayName}</p>
                    <p class="text-gray-500 text-sm">Tarif de consultation: ${specialist.consultationFee} DH</p>
                </div>
            </div>
        </div>

        <!-- Dashboard Cards -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
            <!-- Demandes en attente -->
            <a href="${pageContext.request.contextPath}/specialist/expertise-requests?status=EN_ATTENTE" 
               class="bg-white/90 backdrop-blur-sm rounded-2xl shadow-lg border border-white/50 p-6 hover:shadow-xl transition-all duration-300 hover:-translate-y-1 cursor-pointer group">
                <div class="flex items-center space-x-4">
                    <div class="w-14 h-14 bg-gradient-to-br from-amber-100 to-amber-200 rounded-2xl flex items-center justify-center text-2xl group-hover:scale-110 transition-transform duration-200">
                        ⏳
                    </div>
                    <div>
                        <h3 class="text-3xl font-bold text-gray-900 group-hover:text-amber-600 transition-colors duration-200">${pendingRequests.size()}</h3>
                        <p class="text-gray-600 font-medium group-hover:text-amber-500 transition-colors duration-200">En Attente</p>
                    </div>
                </div>
                <div class="mt-3 text-sm text-gray-500 group-hover:text-amber-400 transition-colors duration-200">
                    Demandes d'expertise à traiter
                </div>
            </a>

            <!-- Expertises terminées -->
            <a href="${pageContext.request.contextPath}/specialist/expertise-requests?status=TERMINEE" 
               class="bg-white/90 backdrop-blur-sm rounded-2xl shadow-lg border border-white/50 p-6 hover:shadow-xl transition-all duration-300 hover:-translate-y-1 cursor-pointer group">
                <div class="flex items-center space-x-4">
                    <div class="w-14 h-14 bg-gradient-to-br from-green-100 to-green-200 rounded-2xl flex items-center justify-center text-2xl group-hover:scale-110 transition-transform duration-200">
                        ✅
                    </div>
                    <div>
                        <h3 class="text-3xl font-bold text-gray-900 group-hover:text-green-600 transition-colors duration-200">${completedRequests.size()}</h3>
                        <p class="text-gray-600 font-medium group-hover:text-green-500 transition-colors duration-200">Terminées</p>
                    </div>
                </div>
                <div class="mt-3 text-sm text-gray-500 group-hover:text-green-400 transition-colors duration-200">
                    Expertises complétées
                </div>
            </a>

            <!-- Revenus totaux -->
            <a href="${pageContext.request.contextPath}/specialist/statistics" 
               class="bg-white/90 backdrop-blur-sm rounded-2xl shadow-lg border border-white/50 p-6 hover:shadow-xl transition-all duration-300 hover:-translate-y-1 cursor-pointer group">
                <div class="flex items-center space-x-4">
                    <div class="w-14 h-14 bg-gradient-to-br from-emerald-100 to-emerald-200 rounded-2xl flex items-center justify-center text-2xl group-hover:scale-110 transition-transform duration-200">
                        💰
                    </div>
                    <div>
                        <h3 class="text-3xl font-bold text-gray-900 group-hover:text-emerald-600 transition-colors duration-200">${statistics.totalRevenue}</h3>
                        <p class="text-gray-600 font-medium group-hover:text-emerald-500 transition-colors duration-200">Revenus (DH)</p>
                    </div>
                </div>
                <div class="mt-3 text-sm text-gray-500 group-hover:text-emerald-400 transition-colors duration-200">
                    Revenus générés par les expertises
                </div>
            </a>

            <!-- Configurer Profil -->
            <a href="${pageContext.request.contextPath}/specialist/profile" 
               class="bg-white/90 backdrop-blur-sm rounded-2xl shadow-lg border border-white/50 p-6 hover:shadow-xl transition-all duration-300 hover:-translate-y-1 cursor-pointer group">
                <div class="flex items-center space-x-4">
                    <div class="w-14 h-14 bg-gradient-to-br from-purple-100 to-purple-200 rounded-2xl flex items-center justify-center text-2xl group-hover:scale-110 transition-transform duration-200">
                        ⚙️
                    </div>
                    <div>
                        <h3 class="text-2xl font-bold text-gray-900 group-hover:text-purple-600 transition-colors duration-200">Profil</h3>
                        <p class="text-gray-600 font-medium group-hover:text-purple-500 transition-colors duration-200">Configuration</p>
                    </div>
                </div>
                <div class="mt-3 text-sm text-gray-500 group-hover:text-purple-400 transition-colors duration-200">
                    Mettre à jour spécialité et tarifs
                </div>
            </a>
        </div>

    </div>
</body>
</html>