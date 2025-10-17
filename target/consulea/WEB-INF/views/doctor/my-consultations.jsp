<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes Consultations - Médecin Généraliste</title>
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
                        <span>Dashboard</span>
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <!-- Header -->
        <div class="bg-white/90 backdrop-blur-sm rounded-2xl shadow-lg border border-white/50 p-8 mb-8">
            <div class="flex items-center space-x-4">
                <div class="w-16 h-16 bg-gradient-to-br from-blue-500 to-indigo-600 rounded-2xl flex items-center justify-center text-white text-2xl shadow-lg">
                    📋
                </div>
                <div>
                    <h2 class="text-3xl font-bold text-gray-900 mb-2">Mes Consultations</h2>
                    <p class="text-gray-600 font-medium">Toutes vos consultations - Total: ${myConsultations.size()} consultations</p>
                </div>
            </div>
        </div>

        <!-- Stats Summary -->
        <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
            <div class="bg-white/90 backdrop-blur-sm rounded-xl shadow-lg border border-white/50 p-6">
                <div class="flex items-center space-x-3">
                    <div class="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center text-xl">
                        📊
                    </div>
                    <div>
                        <div class="text-2xl font-bold text-gray-900">${myConsultations.size()}</div>
                        <div class="text-sm text-gray-600">Total</div>
                    </div>
                </div>
            </div>
            <div class="bg-white/90 backdrop-blur-sm rounded-xl shadow-lg border border-white/50 p-6">
                <div class="flex items-center space-x-3">
                    <div class="w-12 h-12 bg-amber-100 rounded-lg flex items-center justify-center text-xl">
                        ⏳
                    </div>
                    <div>
                        <div class="text-2xl font-bold text-gray-900">${inProgressCount}</div>
                        <div class="text-sm text-gray-600">En Cours</div>
                    </div>
                </div>
            </div>
            <div class="bg-white/90 backdrop-blur-sm rounded-xl shadow-lg border border-white/50 p-6">
                <div class="flex items-center space-x-3">
                    <div class="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center text-xl">
                        ✅
                    </div>
                    <div>
                        <div class="text-2xl font-bold text-gray-900">${completedCount}</div>
                        <div class="text-sm text-gray-600">Terminées</div>
                    </div>
                </div>
            </div>
            <div class="bg-white/90 backdrop-blur-sm rounded-xl shadow-lg border border-white/50 p-6">
                <div class="flex items-center space-x-3">
                    <div class="w-12 h-12 bg-purple-100 rounded-lg flex items-center justify-center text-xl">
                        👨‍⚕️
                    </div>
                    <div>
                        <div class="text-2xl font-bold text-gray-900">${waitingSpecialistCount}</div>
                        <div class="text-sm text-gray-600">Attente Spéc.</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Consultations Table -->
        <div class="bg-white/90 backdrop-blur-sm rounded-2xl shadow-lg border border-white/50 overflow-hidden">
            <div class="px-8 py-6 border-b border-gray-200">
                <h3 class="text-xl font-bold text-gray-900">Liste des Consultations</h3>
            </div>

            <c:choose>
                <c:when test="${not empty myConsultations}">
                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th class="px-6 py-4 text-left text-sm font-medium text-gray-700">Patient</th>
                                    <th class="px-6 py-4 text-left text-sm font-medium text-gray-700">Date</th>
                                    <th class="px-6 py-4 text-left text-sm font-medium text-gray-700">Motif</th>
                                    <th class="px-6 py-4 text-left text-sm font-medium text-gray-700">Statut</th>
                                    <th class="px-6 py-4 text-left text-sm font-medium text-gray-700">Coût</th>
                                    <th class="px-6 py-4 text-center text-sm font-medium text-gray-700">Actions</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-gray-200">
                                <c:forEach var="consultation" items="${myConsultations}">
                                    <tr class="hover:bg-gray-50 transition-colors duration-150">
                                        <!-- Patient Info -->
                                        <td class="px-6 py-4">
                                            <div class="flex items-center space-x-3">
                                                <div class="w-10 h-10 bg-gradient-to-br from-blue-500 to-indigo-600 rounded-full flex items-center justify-center text-white font-semibold text-sm">
                                                    ${consultation.patient.fullName.substring(0, 1)}
                                                </div>
                                                <div>
                                                    <div class="font-semibold text-gray-900">${consultation.patient.fullName}</div>
                                                    <div class="text-sm text-gray-600">${consultation.patient.age} ans</div>
                                                </div>
                                            </div>
                                        </td>

                                        <!-- Date -->
                                        <td class="px-6 py-4">
                                            <div class="text-sm text-gray-900">${consultation.createdAt.toLocalDate()}</div>
                                            <div class="text-sm text-gray-500">${consultation.createdAt.toLocalTime().toString().substring(0, 5)}</div>
                                        </td>

                                        <!-- Chief Complaint -->
                                        <td class="px-6 py-4">
                                            <div class="text-sm text-gray-900 max-w-xs truncate" title="${consultation.chiefComplaint}">
                                                ${consultation.chiefComplaint}
                                            </div>
                                        </td>

                                        <!-- Status -->
                                        <td class="px-6 py-4">
                                            <c:choose>
                                                <c:when test="${consultation.status == 'IN_PROGRESS'}">
                                                    <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-amber-100 text-amber-800">
                                                        ⏳ En Cours
                                                    </span>
                                                </c:when>
                                                <c:when test="${consultation.status == 'WAITING_FOR_SPECIALIST_OPINION'}">
                                                    <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-purple-100 text-purple-800">
                                                        👨‍⚕️ Attente Spéc.
                                                    </span>
                                                </c:when>
                                                <c:when test="${consultation.status == 'COMPLETED'}">
                                                    <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                                        ✅ Terminée
                                                    </span>
                                                </c:when>
                                            </c:choose>
                                        </td>

                                        <!-- Cost -->
                                        <td class="px-6 py-4">
                                            <div class="text-sm font-semibold text-green-600">${consultation.cost} DH</div>
                                        </td>

                                        <!-- Actions -->
                                        <td class="px-6 py-4 text-center">
                                            <a href="${pageContext.request.contextPath}/doctor/create-consultation?consultationId=${consultation.id}"
                                               class="inline-flex items-center px-4 py-2 bg-gradient-to-r from-blue-600 to-indigo-700 text-white rounded-lg font-medium hover:from-blue-700 hover:to-indigo-800 transition-all duration-200 shadow-sm hover:shadow-md">
                                                <svg class="w-4 h-4 mr-2" fill="currentColor" viewBox="0 0 20 20">
                                                    <path d="M10 12a2 2 0 100-4 2 2 0 000 4z"></path>
                                                    <path fill-rule="evenodd" d="M.458 10C1.732 5.943 5.522 3 10 3s8.268 2.943 9.542 7c-1.274 4.057-5.064 7-9.542 7S1.732 14.057.458 10zM14 10a4 4 0 11-8 0 4 4 0 018 0z" clip-rule="evenodd"></path>
                                                </svg>
                                                Voir
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="p-12 text-center">
                        <div class="w-16 h-16 bg-gray-100 rounded-2xl flex items-center justify-center text-3xl mx-auto mb-4">
                            📭
                        </div>
                        <h3 class="text-lg font-medium text-gray-900 mb-2">Aucune consultation</h3>
                        <p class="text-gray-500">Vous n'avez pas encore de consultations.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>