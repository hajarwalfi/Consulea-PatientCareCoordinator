<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patients en Attente</title>
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
                <div class="w-10 h-10 bg-gradient-to-br from-blue-500 to-indigo-600 rounded-xl flex items-center justify-center text-white text-lg">
                    👥
                </div>
                <h2 class="text-3xl font-semibold text-gray-900">File d'attente des patients</h2>
            </div>
        </div>

        <c:choose>
            <c:when test="${not empty waitingPatients}">
                <!-- Professional Table -->
                <div class="bg-white rounded-2xl shadow-lg border border-gray-100 overflow-hidden">
                    <table class="w-full">
                        <thead class="bg-gradient-to-r from-gray-50 to-blue-50 border-b border-gray-200">
                            <tr>
                                <th class="px-8 py-5 text-left text-sm font-semibold text-gray-800">Patient</th>
                                <th class="px-8 py-5 text-left text-sm font-semibold text-gray-800">Heure d'arrivée</th>
                                <th class="px-8 py-5 text-left text-sm font-semibold text-gray-800">Date</th>
                                <th class="px-8 py-5 text-left text-sm font-semibold text-gray-800">Statut</th>
                                <th class="px-8 py-5 text-center text-sm font-semibold text-gray-800">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="patient" items="${waitingPatients}" varStatus="status">
                                <tr class="hover:bg-blue-50/50 transition-colors duration-200 ${status.index % 2 == 0 ? 'bg-white' : 'bg-gray-50/30'}">
                                    <td class="px-8 py-6">
                                        <div class="flex items-center space-x-4">
                                            <div class="w-12 h-12 bg-gradient-to-br from-blue-400 to-indigo-500 rounded-full flex items-center justify-center text-white font-semibold text-lg shadow-sm">
                                                ${patient.fullName.substring(0, 1)}
                                            </div>
                                            <div>
                                                <div class="text-lg font-medium text-gray-900">${patient.fullName}</div>
                                                <div class="text-sm text-gray-500">${patient.age} ans</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="px-8 py-6">
                                        <div class="flex items-center space-x-2">
                                            <div class="w-8 h-8 bg-blue-100 rounded-lg flex items-center justify-center">
                                                🕐
                                            </div>
                                            <span class="text-lg font-medium text-gray-800">${patient.registeredAt.toLocalTime().toString().substring(0, 5)}</span>
                                        </div>
                                    </td>
                                    <td class="px-8 py-6">
                                        <div class="flex items-center space-x-2">
                                            <div class="w-8 h-8 bg-green-100 rounded-lg flex items-center justify-center">
                                                📅
                                            </div>
                                            <span class="text-lg font-medium text-gray-800">${patient.registeredAt.toLocalDate()}</span>
                                        </div>
                                    </td>
                                    <td class="px-8 py-6">
                                        <div class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-yellow-100 text-yellow-800 border border-yellow-200">
                                            <div class="w-2 h-2 bg-yellow-500 rounded-full mr-2 animate-pulse"></div>
                                            En attente consultation
                                        </div>
                                    </td>
                                    <td class="px-8 py-6 text-center">
                                        <a href="${pageContext.request.contextPath}/doctor/create-consultation?patientId=${patient.id}"
                                           class="bg-gradient-to-r from-blue-500 to-indigo-600 hover:from-blue-600 hover:to-indigo-700 text-white px-6 py-3 rounded-xl font-medium transition-all duration-200 shadow-md hover:shadow-lg inline-flex items-center space-x-2">
                                            <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                                                <path fill-rule="evenodd" d="M10 3a1 1 0 011 1v5h5a1 1 0 110 2h-5v5a1 1 0 11-2 0v-5H4a1 1 0 110-2h5V4a1 1 0 011-1z" clip-rule="evenodd"></path>
                                            </svg>
                                            <span>Consulter</span>
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
                    <div class="w-20 h-20 bg-gradient-to-br from-blue-100 to-indigo-100 rounded-2xl flex items-center justify-center text-4xl mx-auto mb-4">
                        😊
                    </div>
                    <h3 class="text-xl font-medium text-gray-700 mb-2">Journée calme</h3>
                    <p class="text-gray-500">Aucun patient en attente pour le moment</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>