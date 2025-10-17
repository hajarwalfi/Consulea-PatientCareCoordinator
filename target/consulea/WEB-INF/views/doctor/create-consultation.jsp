<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Créer une Consultation</title>
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
    <script>
        // Variables globales pour les actes médicaux
        let selectedMedicalActs = [];
        let availableMedicalActs = {};
        const BASE_CONSULTATION_COST = 150.0;
        
        // Actes médicaux existants pour le mode édition (JSON sérialisé)
        <c:if test="${mode == 'edit' && not empty consultationMedicalActs}">
            const existingMedicalActsFromServer = JSON.parse('[<c:forEach var="cma" items="${consultationMedicalActs}" varStatus="status">{"id":${cma.medicalAct.id},"name":"<c:out value="${cma.medicalAct.name}" escapeXml="true"/>","price":${cma.medicalAct.price}}<c:if test="${!status.last}">,</c:if></c:forEach>]');
        </c:if>

        // Initialisation
        document.addEventListener('DOMContentLoaded', function() {
            console.log('DOM chargé, initialisation...');
            
            const completeRadio = document.getElementById('completeConsultation');
            const completeFields = document.getElementById('completeFields');
            
            // Afficher/masquer les champs de diagnostic
            document.querySelectorAll('input[name="decision"]').forEach(radio => {
                radio.addEventListener('change', function() {
                    if (completeRadio && completeRadio.checked) {
                        completeFields.classList.remove('hidden');
                    } else if (completeFields) {
                        completeFields.classList.add('hidden');
                    }
                });
            });

            // Charger les actes médicaux disponibles
            loadAvailableMedicalActs();
            
            // Charger les actes déjà ajoutés (si en mode édition)
            loadExistingMedicalActs();
            
            // Initialiser l'affichage des coûts
            updateCostDisplay();
            
            console.log('Initialisation terminée');
        });

        // Charger les actes médicaux disponibles depuis le select
        function loadAvailableMedicalActs() {
            console.log('Chargement des actes médicaux disponibles...');
            const select = document.getElementById('medicalActId');
            
            if (!select) {
                console.error('Select medicalActId non trouvé lors du chargement');
                return;
            }
            
            const options = select.querySelectorAll('option[value]:not([value=""])');
            console.log('Nombre d\'options trouvées:', options.length);
            
            options.forEach(option => {
                const id = parseInt(option.value);
                const price = parseFloat(option.dataset.price);
                const name = option.textContent.split(' - ')[0];
                
                console.log('Acte trouvé:', { id, name, price });
                
                availableMedicalActs[id] = {
                    id: id,
                    name: name,
                    price: price
                };
            });
            
            console.log('Actes médicaux chargés:', availableMedicalActs);
        }

        // Charger les actes déjà ajoutés (mode édition)
        function loadExistingMedicalActs() {
            // En mode édition, utiliser les données du serveur
            if (typeof existingMedicalActsFromServer !== 'undefined') {
                existingMedicalActsFromServer.forEach(existingAct => {
                    // Ajouter à availableMedicalActs si pas déjà présent
                    if (!availableMedicalActs[existingAct.id]) {
                        availableMedicalActs[existingAct.id] = existingAct;
                    }
                    
                    // Ajouter à selectedMedicalActs si pas déjà présent
                    if (!selectedMedicalActs.find(act => act.id === existingAct.id)) {
                        selectedMedicalActs.push(existingAct);
                    }
                });
            }
            
            updateSelectedMedicalActsInput();
        }

        // Ajouter un acte médical
        function addMedicalAct() {
            console.log('Fonction addMedicalAct appelée');
            const select = document.getElementById('medicalActId');
            
            if (!select) {
                console.error('Select medicalActId non trouvé');
                alert('Erreur: élément de sélection non trouvé');
                return;
            }
            
            const selectedId = parseInt(select.value);
            console.log('ID sélectionné:', selectedId);
            console.log('Actes disponibles:', availableMedicalActs);
            
            if (!selectedId || !availableMedicalActs[selectedId]) {
                alert('Veuillez sélectionner un acte médical valide');
                return;
            }

            // Vérifier si l'acte n'est pas déjà ajouté
            if (selectedMedicalActs.find(act => act.id === selectedId)) {
                alert('Cet acte médical est déjà ajouté');
                return;
            }

            // Ajouter l'acte à la liste
            const medicalAct = availableMedicalActs[selectedId];
            console.log('Acte médical trouvé dans availableMedicalActs:', medicalAct);
            console.log('Structure complète de l\'acte:', JSON.stringify(medicalAct, null, 2));
            
            selectedMedicalActs.push(medicalAct);
            console.log('Acte ajouté à selectedMedicalActs:', medicalAct);
            console.log('Liste complète des actes sélectionnés:', JSON.stringify(selectedMedicalActs, null, 2));

            // Mettre à jour l'affichage
            updateMedicalActsDisplay();
            updateCostDisplay();
            updateSelectedMedicalActsInput();

            // Reset du select
            select.value = '';
        }

        // Supprimer un acte médical
        function removeMedicalAct(actId) {
            selectedMedicalActs = selectedMedicalActs.filter(act => act.id !== actId);
            
            updateMedicalActsDisplay();
            updateCostDisplay();
            updateSelectedMedicalActsInput();
        }

        // Mettre à jour l'affichage des actes médicaux
        function updateMedicalActsDisplay() {
            console.log('Mise à jour de l\'affichage des actes médicaux...');
            console.log('Actes sélectionnés:', selectedMedicalActs);
            
            // Créer la section si elle n'existe pas
            let container = document.getElementById('addedMedicalActs');
            console.log('Container trouvé:', container);
            
            if (!container) {
                console.log('Container non trouvé, création de la section...');
                createMedicalActsSection();
                // Attendre un peu pour que la section soit créée
                setTimeout(() => {
                    container = document.getElementById('addedMedicalActs');
                    console.log('Container après création:', container);
                    if (container) {
                        displayActsInContainer(container);
                    }
                }, 10);
                return;
            }
            
            displayActsInContainer(container);
        }
        
        // Fonction séparée pour afficher les actes dans le container
        function displayActsInContainer(container) {
            console.log('Affichage des actes dans le container:', container);
            
            if (selectedMedicalActs.length === 0) {
                const parentDiv = container.closest('.bg-gray-50');
                if (parentDiv) {
                    parentDiv.style.display = 'none';
                }
                return;
            }

            // Afficher le conteneur s'il était caché
            const parentDiv = container.closest('.bg-gray-50');
            if (parentDiv) {
                parentDiv.style.display = 'block';
            }

            // Reconstruire la liste
            container.innerHTML = '';
            console.log('Reconstruction de la liste avec', selectedMedicalActs.length, 'actes');
            
            selectedMedicalActs.forEach((act, index) => {
                console.log('=== DÉBUT ACTE', index + 1, '===');
                console.log('Objet act complet:', act);
                console.log('Type de act:', typeof act);
                console.log('act.id:', act.id, 'type:', typeof act.id);
                console.log('act.name:', act.name, 'type:', typeof act.name);
                console.log('act.price:', act.price, 'type:', typeof act.price);
                console.log('Object.keys(act):', Object.keys(act));
                console.log('JSON.stringify(act):', JSON.stringify(act));
                
                const actElement = document.createElement('div');
                actElement.className = 'flex justify-between items-center py-2 px-3 bg-white rounded-lg border';
                actElement.dataset.actId = act.id;
                
                // Accès direct aux propriétés avec fallbacks explicites
                let actName, actPrice, actId;
                
                try {
                    actName = act.name || act['name'] || 'Nom indisponible';
                    actPrice = act.price || act['price'] || '0';
                    actId = act.id || act['id'] || 'unknown';
                } catch (e) {
                    console.error('Erreur lors de l\'accès aux propriétés:', e);
                    actName = 'Erreur nom';
                    actPrice = '0';
                    actId = 'error';
                }
                
                console.log('VALEURS FINALES - Name:', actName, 'Price:', actPrice, 'ID:', actId);
                
                // Construction du HTML avec échappement
                const nameEscaped = String(actName).replace(/'/g, '&apos;').replace(/"/g, '&quot;');
                const priceEscaped = String(actPrice);
                const idEscaped = String(actId);
                
                console.log('Variables échappées - Name:', nameEscaped, 'Price:', priceEscaped, 'ID:', idEscaped);
                
                // Construction du HTML en utilisant la concaténation de strings pour éviter les problèmes d'interpolation
                const htmlContent = 
                    '<span class="text-sm text-gray-900">' + nameEscaped + '</span>' +
                    '<div class="flex items-center space-x-2">' +
                        '<span class="font-semibold text-indigo-600">' + priceEscaped + ' DH</span>' +
                        '<button type="button" onclick="removeMedicalAct(' + idEscaped + ')" ' +
                                'class="text-red-500 hover:text-red-700 text-sm">' +
                            '❌' +
                        '</button>' +
                    '</div>';
                
                actElement.innerHTML = htmlContent;
                
                console.log('HTML généré:', actElement.innerHTML);
                console.log('=== FIN ACTE', index + 1, '===');
                
                container.appendChild(actElement);
            });
            
            console.log('Liste reconstruite, container HTML:', container.innerHTML);
        }

        // Créer la section des actes médicaux ajoutés si elle n'existe pas
        function createMedicalActsSection() {
            console.log('Création de la section des actes médicaux...');
            
            // Chercher le formulaire d'ajout (div qui contient le select)
            const selectElement = document.getElementById('medicalActId');
            if (!selectElement) {
                console.error('Select medicalActId non trouvé');
                return;
            }
            
            const addFormDiv = selectElement.closest('.flex');
            console.log('Div du formulaire trouvé:', addFormDiv);
            
            if (!addFormDiv) {
                console.error('Formulaire d\'ajout d\'actes non trouvé');
                return;
            }

            // Trouver le parent commun (le conteneur principal des actes médicaux)
            const parentContainer = addFormDiv.parentNode;
            console.log('Parent container trouvé:', parentContainer);

            const section = document.createElement('div');
            section.className = 'bg-gray-50 rounded-xl p-4 mb-4';
            section.style.display = 'block';
            section.innerHTML = `
                <h5 class="font-medium text-gray-900 mb-3">Actes ajoutés</h5>
                <div class="space-y-2" id="addedMedicalActs"></div>
            `;

            // Insérer la section avant le formulaire d'ajout dans le même parent
            parentContainer.insertBefore(section, addFormDiv);
            console.log('Section créée avec succès dans le parent container');
        }

        // Mettre à jour l'affichage des coûts
        function updateCostDisplay() {
            const costList = document.getElementById('medicalActsCostList');
            const totalCostElement = document.getElementById('totalCost');
            
            if (!costList) {
                console.error('Element medicalActsCostList non trouvé');
                return;
            }
            
            if (!totalCostElement) {
                console.error('Element totalCost non trouvé');
                return;
            }
            
            // Reconstruire la liste des coûts des actes
            costList.innerHTML = '';
            selectedMedicalActs.forEach(act => {
                console.log('Ajout coût pour acte:', act);
                const costElement = document.createElement('div');
                costElement.className = 'flex justify-between items-center py-1 text-sm';
                costElement.dataset.actId = act.id;
                
                // Construction HTML avec concaténation pour éviter les problèmes de template literals
                const actName = act.name || 'Acte inconnu';
                const actPrice = act.price || '0';
                
                const costHtml = 
                    '<span class="text-gray-600">+ ' + actName + '</span>' +
                    '<span class="font-medium text-gray-900">' + actPrice + ' DH</span>';
                
                costElement.innerHTML = costHtml;
                console.log('HTML coût généré:', costHtml);
                costList.appendChild(costElement);
            });

            // Calculer et afficher le coût total
            const medicalActsTotal = selectedMedicalActs.reduce((total, act) => total + act.price, 0);
            const totalCost = BASE_CONSULTATION_COST + medicalActsTotal;
            totalCostElement.textContent = totalCost.toFixed(1) + ' DH';
            
            console.log('Coût total mis à jour:', totalCost + ' DH');
        }

        // Mettre à jour l'input caché avec les actes sélectionnés
        function updateSelectedMedicalActsInput() {
            const input = document.getElementById('selectedMedicalActs');
            input.value = JSON.stringify(selectedMedicalActs.map(act => act.id));
        }

        // Valider le formulaire avant soumission
        function validateForm() {
            // Vous pouvez ajouter des validations supplémentaires ici
            return true;
        }

        // Fonction pour demander un avis spécialiste en mode édition
        function requestSpecialistEdit() {
            const consultationId = '${consultation.id}';
            window.location.href = '${pageContext.request.contextPath}/doctor/request-expertise?consultationId=' + consultationId;
        }

        // Fonction pour préparer le formulaire de clôture avec les actes médicaux
        function prepareCompleteForm(event) {
            console.log('prepareCompleteForm appelée');
            console.log('Event:', event);
            
            const form = event.target;
            console.log('Formulaire:', form);
            console.log('Action du formulaire:', form.action);
            console.log('Méthode du formulaire:', form.method);
            
            const selectedMedicalActs = document.getElementById('selectedMedicalActs');
            const selectedMedicalActsForComplete = document.getElementById('selectedMedicalActsForComplete');
            
            if (selectedMedicalActs && selectedMedicalActsForComplete) {
                selectedMedicalActsForComplete.value = selectedMedicalActs.value;
                console.log('Actes médicaux copiés:', selectedMedicalActs.value);
            } else {
                console.log('Éléments non trouvés:', { selectedMedicalActs, selectedMedicalActsForComplete });
            }
            
            console.log('Soumission du formulaire...');
            return true; // Permettre la soumission du formulaire
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
                    <a href="${pageContext.request.contextPath}/doctor/waiting-patients" 
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
        <div class="mb-8">
            <div class="flex items-center space-x-3 mb-3">
                <div class="w-10 h-10 bg-gradient-to-br from-blue-500 to-indigo-600 rounded-xl flex items-center justify-center text-white text-lg">
                    🩺
                </div>
                <h2 class="text-3xl font-semibold text-gray-900">Consultation</h2>
            </div>
            <p class="text-gray-600 ml-13">Gestion complète de la consultation médicale</p>
        </div>

        <!-- Two-Column Grid Layout -->
        <div class="grid grid-cols-1 xl:grid-cols-2 gap-8">
            <!-- LEFT COLUMN: Patient Information -->
            <c:if test="${not empty patient}">
                <div class="bg-white rounded-2xl shadow-lg border border-gray-100 p-8">
                    <!-- Patient Header -->
                    <div class="flex items-center space-x-4 mb-6 pb-6 border-b border-gray-200">
                        <div class="w-16 h-16 bg-gradient-to-br from-blue-400 to-indigo-500 rounded-2xl flex items-center justify-center text-white font-semibold text-xl shadow-sm">
                            ${patient.fullName.substring(0, 1)}
                        </div>
                        <div>
                            <h3 class="text-2xl font-semibold text-gray-900">${patient.fullName}</h3>
                            <p class="text-gray-600">${patient.age} ans • Arrivé à ${patient.registeredAt.toLocalTime().toString().substring(0, 5)}</p>
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
                                    <p class="text-sm font-medium text-gray-900">${patient.birthDate}</p>
                                </div>
                                <div class="bg-gray-50 rounded-lg p-3">
                                    <p class="text-xs text-gray-500 uppercase font-medium">Sécurité sociale</p>
                                    <p class="text-sm font-medium text-gray-900 font-mono">${patient.socialSecurityNumber}</p>
                                </div>
                                <div class="bg-gray-50 rounded-lg p-3">
                                    <p class="text-xs text-gray-500 uppercase font-medium">Téléphone</p>
                                    <p class="text-sm font-medium text-gray-900">${patient.phone != null ? patient.phone : 'Non renseigné'}</p>
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
                                <p class="text-sm font-medium text-red-700">${patient.allergies != null ? patient.allergies : 'Aucune allergie connue'}</p>
                            </div>
                        </div>

                        <!-- Vital Signs -->
                        <c:if test="${not empty vitalSignsList && vitalSignsList.size() > 0}">
                            <div>
                                <h4 class="text-sm font-semibold text-gray-700 mb-3 flex items-center space-x-2">
                                    <span>💓</span>
                                    <span>Signes vitaux</span>
                                </h4>
                                <c:set var="latestVitals" value="${vitalSignsList[0]}"/>
                                <div class="grid grid-cols-2 gap-3">
                                    <div class="bg-blue-50 rounded-lg p-3 text-center">
                                        <p class="text-xs text-blue-600 uppercase font-medium">Tension</p>
                                        <p class="text-lg font-bold text-blue-700">${latestVitals.bloodPressure}</p>
                                    </div>
                                    <div class="bg-green-50 rounded-lg p-3 text-center">
                                        <p class="text-xs text-green-600 uppercase font-medium">Pouls</p>
                                        <p class="text-lg font-bold text-green-700">${latestVitals.heartRate}</p>
                                    </div>
                                    <div class="bg-orange-50 rounded-lg p-3 text-center">
                                        <p class="text-xs text-orange-600 uppercase font-medium">Temp.</p>
                                        <p class="text-lg font-bold text-orange-700">${latestVitals.temperature}°C</p>
                                    </div>
                                    <div class="bg-purple-50 rounded-lg p-3 text-center">
                                        <p class="text-xs text-purple-600 uppercase font-medium">SpO₂</p>
                                        <p class="text-lg font-bold text-purple-700">${latestVitals.oxygenSaturation}%</p>
                                    </div>
                                </div>
                            </div>
                        </c:if>

                        <!-- Cost Details -->
                        <div>
                            <h4 class="text-sm font-semibold text-gray-700 mb-3 flex items-center space-x-2">
                                <span>💰</span>
                                <span>Coût total</span>
                            </h4>
                            <div class="bg-emerald-50 border border-emerald-200 rounded-lg p-4">
                                <div class="space-y-2">
                                    <!-- Base consultation cost -->
                                    <div class="flex justify-between items-center py-1 text-sm">
                                        <span class="text-gray-600">Consultation de base</span>
                                        <span class="font-medium text-gray-900">150.0 DH</span>
                                    </div>

                                    <!-- Medical acts costs - will be populated dynamically -->
                                    <div id="medicalActsCostList">
                                        <c:if test="${not empty consultationMedicalActs}">
                                            <c:forEach var="cma" items="${consultationMedicalActs}">
                                                <div class="flex justify-between items-center py-1 text-sm" data-act-id="${cma.medicalAct.id}">
                                                    <span class="text-gray-600">+ ${cma.medicalAct.name}</span>
                                                    <span class="font-medium text-gray-900">${cma.totalPrice} DH</span>
                                                </div>
                                            </c:forEach>
                                        </c:if>
                                    </div>

                                    <!-- Total cost -->
                                    <div class="pt-2 border-t border-emerald-300">
                                        <div class="flex justify-between items-center">
                                            <span class="font-semibold text-gray-900">Total</span>
                                            <div class="text-right">
                                                <div id="totalCost" class="text-xl font-bold text-emerald-600">
                                                    ${consultation != null ? consultation.cost : '150.0'} DH
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- RIGHT COLUMN: Consultation Form -->
            <div class="bg-white rounded-2xl shadow-lg border border-gray-100 p-8">
                <div class="flex items-center space-x-3 mb-6">
                    <div class="w-8 h-8 bg-gradient-to-br from-green-500 to-emerald-600 rounded-lg flex items-center justify-center text-white">
                        ✏️
                    </div>
                    <h3 class="text-xl font-semibold text-gray-900">
                        <c:choose>
                            <c:when test="${mode == 'edit'}">Modifier la Consultation</c:when>
                            <c:otherwise>Nouvelle Consultation</c:otherwise>
                        </c:choose>
                    </h3>
                </div>

                <form method="post" action="${pageContext.request.contextPath}/doctor/create-consultation" class="space-y-6">
                    <input type="hidden" name="patientId" value="${patient.id}">
                    <c:if test="${mode == 'edit' && not empty consultation}">
                        <input type="hidden" name="consultationId" value="${consultation.id}">
                    </c:if>

                    <!-- Motif de Consultation -->
                    <div>
                        <label for="chiefComplaint" class="block text-sm font-semibold text-gray-700 mb-2">
                            Motif de consultation <span class="text-red-500">*</span>
                        </label>
                        <textarea 
                            id="chiefComplaint" 
                            name="chiefComplaint" 
                            required
                            rows="3"
                            class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200"
                            placeholder="Ex: Douleurs abdominales depuis 2 jours..."
                        >${consultation != null ? consultation.chiefComplaint : ''}</textarea>
                    </div>

                    <!-- Analyse des symptômes -->
                    <div>
                        <label for="symptoms" class="block text-sm font-semibold text-gray-700 mb-2">
                            Analyse des symptômes <span class="text-red-500">*</span>
                        </label>
                        <textarea 
                            id="symptoms" 
                            name="symptoms"
                            required
                            rows="3"
                            class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200"
                            placeholder="Décrivez les plaintes et ressentis du patient..."
                        >${consultation != null ? consultation.symptoms : ''}</textarea>
                    </div>

                    <!-- Examen Clinique -->
                    <div>
                        <label for="clinicalExamination" class="block text-sm font-semibold text-gray-700 mb-2">
                            Observations cliniques <span class="text-red-500">*</span>
                        </label>
                        <textarea 
                            id="clinicalExamination" 
                            name="clinicalExamination"
                            required
                            rows="4"
                            class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200"
                            placeholder="Résultats de l'examen physique (toucher, écouter, regarder, etc.)..."
                        >${consultation != null ? consultation.clinicalExamination : ''}</textarea>
                    </div>

                    <!-- Actes Techniques Médicaux -->
                    <div>
                        <h4 class="text-sm font-semibold text-gray-700 mb-3 flex items-center space-x-2">
                            <span>🔬</span>
                            <span>Actes Techniques Médicaux (Optionnel)</span>
                        </h4>
                        <p class="text-xs text-gray-600 mb-4">Actes techniques réalisés ou prescrits lors de cette consultation (ex: radiographie, analyse de sang, électrocardiogramme)</p>
                        
                        <!-- Note: Actes existants gérés par JavaScript pour éviter les doublons -->

                        <!-- Add Medical Act Form (only for create mode or IN_PROGRESS) -->
                        <c:if test="${mode == 'create' || (consultation != null && consultation.status == 'IN_PROGRESS')}">
                            <!-- Unified JavaScript mode for both creation and editing -->
                            <div class="flex flex-col sm:flex-row gap-3">
                                <div class="flex-1">
                                    <select id="medicalActId" name="medicalActToAdd"
                                            class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-indigo-500 focus:border-transparent">
                                        <option value="">-- Sélectionnez un acte médical --</option>
                                        <c:forEach var="act" items="${availableMedicalActs}">
                                            <option value="${act.id}" data-price="${act.price}">${act.name} - ${act.price} DH</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <button type="button" onclick="addMedicalAct()" 
                                        class="px-6 py-3 bg-gradient-to-r from-indigo-500 to-purple-600 text-white rounded-xl font-medium hover:from-indigo-600 hover:to-purple-700 transition-all duration-200 shadow-md hover:shadow-lg flex items-center justify-center space-x-2">
                                    <span>➕</span>
                                    <span>Ajouter</span>
                                </button>
                            </div>
                        </c:if>

                        <!-- Hidden input to store selected medical acts -->
                        <input type="hidden" id="selectedMedicalActs" name="selectedMedicalActs" value="">
                    </div>

                    <!-- Décisions -->
                    <div class="pt-4 border-t border-gray-200">
                        <c:choose>
                            <c:when test="${mode == 'create'}">
                                <!-- Mode création - Décisions simplifiées -->
                                <h4 class="text-sm font-semibold text-gray-700 mb-4 flex items-center space-x-2">
                                    <span>🎯</span>
                                    <span>Décision médicale</span>
                                </h4>
                                
                                <div class="space-y-3">
                                    <!-- Consultation complète avec diagnostic -->
                                    <div class="bg-green-50 border border-green-200 rounded-xl p-4">
                                        <div class="flex items-center justify-between mb-3">
                                            <div class="flex items-center space-x-2">
                                                <input type="radio" name="decision" value="complete" id="completeConsultation" class="text-green-600 focus:ring-green-500">
                                                <label for="completeConsultation" class="text-sm font-semibold text-green-800">Clôturer la consultation</label>
                                            </div>
                                            <span class="text-green-600">✅</span>
                                        </div>
                                        <div id="completeFields" class="space-y-3 hidden">
                                            <div>
                                                <label for="diagnosis" class="block text-xs font-medium text-green-700 mb-1">Diagnostic</label>
                                                <input type="text" id="diagnosis" name="diagnosis" 
                                                       class="w-full px-3 py-2 text-sm border border-green-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent"
                                                       placeholder="Saisissez le diagnostic...">
                                            </div>
                                            <div>
                                                <label for="prescription" class="block text-xs font-medium text-green-700 mb-1">Prescription</label>
                                                <textarea id="prescription" name="prescription" rows="2"
                                                          class="w-full px-3 py-2 text-sm border border-green-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent"
                                                          placeholder="Médicaments, posologie, recommandations..."></textarea>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Demande d'avis spécialiste -->
                                    <div class="bg-blue-50 border border-blue-200 rounded-xl p-4">
                                        <div class="flex items-center justify-between">
                                            <div class="flex items-center space-x-2">
                                                <input type="radio" name="decision" value="specialist" id="requestSpecialist" class="text-blue-600 focus:ring-blue-500">
                                                <label for="requestSpecialist" class="text-sm font-semibold text-blue-800">Demander avis spécialiste</label>
                                            </div>
                                            <span class="text-blue-600">👨‍⚕️</span>
                                        </div>
                                        <p class="text-xs text-blue-600 mt-2">Redirection vers la page de demande d'expertise</p>
                                    </div>

                                    <!-- Continue consultation -->
                                    <div class="bg-amber-50 border border-amber-200 rounded-xl p-4">
                                        <div class="flex items-center justify-between">
                                            <div class="flex items-center space-x-2">
                                                <input type="radio" name="decision" value="continue" id="continueConsultation" class="text-amber-600 focus:ring-amber-500" checked>
                                                <label for="continueConsultation" class="text-sm font-semibold text-amber-800">Enregistrer et continuer</label>
                                            </div>
                                            <span class="text-amber-600">💾</span>
                                        </div>
                                        <p class="text-xs text-amber-600 mt-2">Sauvegarder les informations en cours sans clôturer</p>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>

                                <!-- Affichage du diagnostic et traitement si déjà complété -->
                                <c:if test="${consultation.status == 'COMPLETED'}">
                                    <div class="bg-green-50 border border-green-200 rounded-xl p-6">
                                        <h4 class="text-lg font-semibold text-green-800 mb-4 flex items-center space-x-2">
                                            <span>✅</span>
                                            <span>Consultation Terminée</span>
                                        </h4>
                                        
                                        <div class="space-y-4">
                                            <div>
                                                <h5 class="font-medium text-green-700 mb-2">Diagnostic</h5>
                                                <p class="text-green-800 bg-white p-3 rounded-lg border border-green-200">${consultation.diagnosis}</p>
                                            </div>
                                            <div>
                                                <h5 class="font-medium text-green-700 mb-2">Traitement Prescrit</h5>
                                                <p class="text-green-800 bg-white p-3 rounded-lg border border-green-200">${consultation.treatment}</p>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Actions finales (uniquement en mode création) -->
                    <c:if test="${mode == 'create'}">
                        <div class="flex flex-col space-y-3 pt-4 border-t border-gray-200">
                            <button type="submit" class="w-full bg-gradient-to-r from-blue-500 to-indigo-600 hover:from-blue-600 hover:to-indigo-700 text-white px-6 py-3 rounded-xl font-medium transition-all duration-200 shadow-md hover:shadow-lg flex items-center justify-center space-x-2">
                                <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                                    <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"></path>
                                </svg>
                                <span>Valider la décision</span>
                            </button>
                            <a href="${pageContext.request.contextPath}/doctor/waiting-patients"
                               class="w-full bg-gray-100 hover:bg-gray-200 text-gray-700 px-6 py-3 rounded-xl font-medium transition-all duration-200 flex items-center justify-center space-x-2">
                                <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                                    <path fill-rule="evenodd" d="M9.707 16.707a1 1 0 01-1.414 0l-6-6a1 1 0 010-1.414l6-6a1 1 0 011.414 1.414L5.414 9H17a1 1 0 110 2H5.414l4.293 4.293a1 1 0 010 1.414z" clip-rule="evenodd"></path>
                                </svg>
                                <span>Retour à la liste</span>
                            </a>
                        </div>
                    </c:if>
                </form>
                
                <!-- Formulaire séparé pour la clôture de consultation (mode édition) -->
                <c:if test="${mode == 'edit' && consultation.status == 'IN_PROGRESS'}">
                    <div class="bg-white rounded-2xl shadow-lg border border-gray-100 p-8 mt-6">
                        <form method="post" action="${pageContext.request.contextPath}/doctor/complete-consultation" onsubmit="prepareCompleteForm(event)">
                            <input type="hidden" name="consultationId" value="${consultation.id}">
                            <input type="hidden" name="selectedMedicalActs" id="selectedMedicalActsForComplete" value="">
                            
                            <h4 class="text-sm font-semibold text-gray-700 mb-4 flex items-center space-x-2">
                                <span>💊</span>
                                <span>Diagnostic et Traitement</span>
                            </h4>
                            
                            <div class="space-y-4 mb-6">
                                <div>
                                    <label for="editDiagnosis" class="block text-sm font-medium text-gray-700 mb-2">Diagnostic</label>
                                    <textarea id="editDiagnosis" name="diagnosis" required
                                              placeholder="Entrez le diagnostic..."
                                              class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-purple-500 focus:border-transparent resize-none"
                                              rows="3">${consultation.diagnosis}</textarea>
                                </div>
                                <div>
                                    <label for="editTreatment" class="block text-sm font-medium text-gray-700 mb-2">Traitement Prescrit</label>
                                    <textarea id="editTreatment" name="treatment" required
                                              placeholder="Détaillez le traitement prescrit..."
                                              class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-purple-500 focus:border-transparent resize-none"
                                              rows="3">${consultation.treatment}</textarea>
                                </div>
                            </div>

                            <div class="flex flex-col sm:flex-row gap-3">
                                <button type="button" onclick="requestSpecialistEdit()" 
                                        class="flex-1 px-4 py-3 bg-gradient-to-r from-amber-500 to-orange-600 text-white rounded-xl font-medium hover:from-amber-600 hover:to-orange-700 transition-all duration-200 shadow-md hover:shadow-lg flex items-center justify-center space-x-2">
                                    <span>⏳</span>
                                    <span>Demander Avis Spécialiste</span>
                                </button>
                                <button type="submit" 
                                        class="flex-1 px-4 py-3 bg-gradient-to-r from-green-500 to-emerald-600 text-white rounded-xl font-medium hover:from-green-600 hover:to-emerald-700 transition-all duration-200 shadow-md hover:shadow-lg flex items-center justify-center space-x-2">
                                    <span>✅</span>
                                    <span>Clôturer la Consultation</span>
                                </button>
                            </div>
                        </form>
                    </div>
                </c:if>

                <!-- Expertise Section (only in edit mode with expertise requests) -->
                <c:if test="${mode == 'edit' && not empty expertiseRequests}">
                    <div class="bg-white rounded-2xl shadow-lg border border-gray-100 p-8 mt-6">
                        <h3 class="text-xl font-semibold text-gray-900 mb-6 flex items-center space-x-3">
                            <div class="w-8 h-8 bg-gradient-to-br from-emerald-500 to-teal-600 rounded-lg flex items-center justify-center text-white">
                                👨‍⚕️
                            </div>
                            <span>Avis d'Expert</span>
                        </h3>

                        <c:forEach var="expertiseRequest" items="${expertiseRequests}">
                            <!-- Expertise Info -->
                            <div class="bg-emerald-50 rounded-xl p-4 mb-4 border-l-4 border-emerald-500">
                                <div class="flex items-center justify-between mb-3">
                                    <h4 class="font-semibold text-gray-900">Demande d'expertise</h4>
                                    <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium ${expertiseRequest.status == 'EN_ATTENTE' ? 'bg-amber-100 text-amber-800' : 'bg-green-100 text-green-800'}">
                                        ${expertiseRequest.statusDisplay}
                                    </span>
                                </div>
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm">
                                    <div>
                                        <span class="text-emerald-700 font-medium">Spécialiste:</span>
                                        <span class="ml-2 text-gray-900 font-semibold">Dr. ${expertiseRequest.specialist.user.fullName}</span>
                                    </div>
                                    <div>
                                        <span class="text-emerald-700 font-medium">Spécialité:</span>
                                        <span class="ml-2 text-gray-900">${expertiseRequest.specialist.specialty.displayName}</span>
                                    </div>
                                    <div>
                                        <span class="text-emerald-700 font-medium">Priorité:</span>
                                        <span class="ml-2 text-gray-900">${expertiseRequest.priorityDisplay}</span>
                                    </div>
                                    <div>
                                        <span class="text-emerald-700 font-medium">Demandé le:</span>
                                        <span class="ml-2 text-gray-900">${expertiseRequest.createdAt.toLocalDate()}</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Your Question -->
                            <div class="bg-blue-50 rounded-xl p-4 mb-4 border-l-4 border-blue-500">
                                <h4 class="font-semibold text-gray-900 mb-2">❓ Votre question:</h4>
                                <p class="text-gray-800 leading-relaxed">${expertiseRequest.question}</p>
                            </div>

                            <!-- Clinical Data if available -->
                            <c:if test="${not empty expertiseRequest.clinicalData}">
                                <div class="bg-yellow-50 rounded-xl p-4 mb-4 border-l-4 border-yellow-500">
                                    <h4 class="font-semibold text-gray-900 mb-2">📋 Données cliniques supplémentaires:</h4>
                                    <p class="text-gray-800 leading-relaxed">${expertiseRequest.clinicalData}</p>
                                </div>
                            </c:if>

                            <!-- Specialist Response (if completed) -->
                            <c:if test="${expertiseRequest.status == 'TERMINEE'}">
                                <div class="bg-gradient-to-r from-green-50 to-emerald-50 rounded-xl p-6 border-2 border-green-200">
                                    <div class="flex items-center mb-4">
                                        <div class="w-10 h-10 bg-gradient-to-br from-green-500 to-emerald-600 rounded-full flex items-center justify-center text-white text-lg mr-3">
                                            ✅
                                        </div>
                                        <h4 class="text-lg font-bold text-green-800">Réponse du Spécialiste</h4>
                                        <c:if test="${not empty expertiseRequest.completedAt}">
                                            <span class="ml-auto text-sm text-green-600 font-medium">
                                                Reçu le ${expertiseRequest.completedAt.toLocalDate()}
                                            </span>
                                        </c:if>
                                    </div>
                                    
                                    <div class="space-y-4">
                                        <div class="bg-white rounded-lg p-4">
                                            <h5 class="font-semibold text-gray-900 mb-2 flex items-center">
                                                <span class="text-lg mr-2">💡</span>
                                                Avis médical:
                                            </h5>
                                            <p class="text-gray-800 leading-relaxed">${expertiseRequest.specialistResponse}</p>
                                        </div>
                                        
                                        <c:if test="${not empty expertiseRequest.recommendations}">
                                            <div class="bg-white rounded-lg p-4">
                                                <h5 class="font-semibold text-gray-900 mb-2 flex items-center">
                                                    <span class="text-lg mr-2">📝</span>
                                                    Recommandations:
                                                </h5>
                                                <p class="text-gray-800 leading-relaxed">${expertiseRequest.recommendations}</p>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </c:if>

                            <!-- Waiting Status -->
                            <c:if test="${expertiseRequest.status == 'EN_ATTENTE'}">
                                <div class="bg-amber-50 rounded-xl p-4 border-l-4 border-amber-500 text-center">
                                    <div class="flex items-center justify-center mb-2">
                                        <div class="animate-spin w-6 h-6 border-2 border-amber-500 border-t-transparent rounded-full mr-3"></div>
                                        <span class="text-amber-800 font-semibold">En attente de la réponse du spécialiste</span>
                                    </div>
                                    <p class="text-amber-700 text-sm">
                                        Dr. ${expertiseRequest.specialist.user.fullName} a été notifié de votre demande.
                                    </p>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</body>
</html>