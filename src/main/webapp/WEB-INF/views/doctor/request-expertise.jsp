<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Demander un Avis d'Expert - Médecin Généraliste</title>
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
    <style>
        .step-progress {
            transition: all 0.3s ease;
        }
        .step-progress.active {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
        }
        .step-progress.completed {
            background: linear-gradient(135deg, #059669, #047857);
            color: white;
        }
        .calendar-day {
            transition: all 0.2s ease;
        }
        .calendar-day:hover {
            transform: scale(1.05);
        }
        .time-slot {
            transition: all 0.2s ease;
        }
        .time-slot:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
        }
        .slide-section {
            transition: all 0.5s ease;
        }
    </style>
    <script>
        // Variables globales
        let currentStep = 1;
        let selectedSpecialty = null;
        let selectedSpecialist = null;
        let selectedDate = null;
        let selectedTimeSlot = null;
        let availableSpecialists = [];
        let availableTimeSlots = [];
        
        // Initialisation
        document.addEventListener('DOMContentLoaded', function() {
            initializeSteps();
            generateCalendar();
            setupEventListeners();
        });
        
        function initializeSteps() {
            updateStepIndicators();
            showStep(currentStep);
        }
        
        function updateStepIndicators() {
            for (let i = 1; i <= 4; i++) {
                const indicator = document.getElementById('step-' + i);
                if (i < currentStep) {
                    indicator.className = 'step-progress completed w-10 h-10 rounded-full flex items-center justify-center text-sm font-bold';
                } else if (i === currentStep) {
                    indicator.className = 'step-progress active w-10 h-10 rounded-full flex items-center justify-center text-sm font-bold';
                } else {
                    indicator.className = 'step-progress w-10 h-10 rounded-full flex items-center justify-center text-sm font-bold bg-gray-200 text-gray-600';
                }
            }
        }
        
        function showStep(step) {
            // Masquer toutes les sections
            document.querySelectorAll('.step-section').forEach(section => {
                section.classList.add('hidden');
            });
            
            // Afficher la section correspondante
            const sectionToShow = document.getElementById('step-section-' + step);
            if (sectionToShow) {
                sectionToShow.classList.remove('hidden');
            }
            
            updateStepIndicators();
        }
        
        function nextStep() {
            if (validateCurrentStep()) {
                currentStep++;
                showStep(currentStep);
                
                // Charger les données pour la nouvelle étape
                if (currentStep === 2) {
                    loadSpecialists();
                } else if (currentStep === 3) {
                    generateCalendar();
                } else if (currentStep === 4) {
                    updateSummary();
                    // Reconfigurer les event listeners car les éléments ont été créés
                    setupEventListeners();
                }
            }
        }
        
        function prevStep() {
            if (currentStep > 1) {
                currentStep--;
                showStep(currentStep);
            }
        }
        
        function validateCurrentStep() {
            switch (currentStep) {
                case 1:
                    const specialty = document.getElementById('specialty').value;
                    if (!specialty) {
                        alert('Veuillez sélectionner une spécialité');
                        return false;
                    }
                    selectedSpecialty = specialty;
                    return true;
                case 2:
                    if (!selectedSpecialist) {
                        alert('Veuillez sélectionner un spécialiste');
                        return false;
                    }
                    return true;
                case 3:
                    if (!selectedDate || !selectedTimeSlot) {
                        alert('Veuillez sélectionner une date et un créneau horaire');
                        return false;
                    }
                    return true;
                default:
                    return true;
            }
        }
        
        function loadSpecialists() {
            console.log('Chargement des spécialistes pour:', selectedSpecialty);
            
            // Charger les spécialistes via l'API
            fetch('${pageContext.request.contextPath}/doctor/api/specialists?specialty=' + selectedSpecialty)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Erreur HTTP: ' + response.status);
                    }
                    return response.json();
                })
                .then(specialists => {
                    console.log('Spécialistes reçus:', specialists);
                    displaySpecialistsFromServer(specialists);
                })
                .catch(error => {
                    console.error('Erreur lors du chargement des spécialistes:', error);
                    
                    // Afficher un message d'erreur à l'utilisateur
                    const container = document.getElementById('specialists-container');
                    container.innerHTML = 
                        '<div class="bg-red-50 border border-red-200 rounded-xl p-6 text-center">' +
                            '<div class="w-12 h-12 bg-red-100 rounded-xl flex items-center justify-center text-2xl mx-auto mb-3">' +
                                '❌' +
                            '</div>' +
                            '<h4 class="text-lg font-semibold text-red-800 mb-2">Erreur de chargement</h4>' +
                            '<p class="text-red-700 mb-4">' +
                                'Impossible de charger les spécialistes. Veuillez réessayer.' +
                            '</p>' +
                            '<button onclick="loadSpecialists()" class="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700">' +
                                'Réessayer' +
                            '</button>' +
                        '</div>';
                });
        }
        
        function displaySpecialistsFromServer(specialists) {
            const container = document.getElementById('specialists-container');
            container.innerHTML = '';
            
            if (!specialists || specialists.length === 0) {
                container.innerHTML = 
                    '<div class="bg-yellow-50 border border-yellow-200 rounded-xl p-6 text-center">' +
                        '<div class="w-12 h-12 bg-yellow-100 rounded-xl flex items-center justify-center text-2xl mx-auto mb-3">' +
                            '😔' +
                        '</div>' +
                        '<h4 class="text-lg font-semibold text-yellow-800 mb-2">Aucun spécialiste disponible</h4>' +
                        '<p class="text-yellow-700">' +
                            'Aucun spécialiste n\'est actuellement disponible pour cette spécialité.' +
                        '</p>' +
                    '</div>';
                return;
            }
            
            specialists.forEach(specialist => {
                const card = createSpecialistCard(specialist);
                container.appendChild(card);
            });
        }
        
        function createSpecialistCard(specialist) {
            const card = document.createElement('div');
            card.className = 'bg-white rounded-2xl shadow-lg border border-gray-100 p-6 hover:shadow-xl transition-all duration-300 cursor-pointer specialist-card';
            card.onclick = () => selectSpecialist(specialist);
            
            card.innerHTML = 
                '<div class="flex items-center justify-between">' +
                    '<div class="flex-1">' +
                        '<div class="flex items-center space-x-4 mb-4">' +
                            '<div class="w-16 h-16 bg-gradient-to-br from-blue-500 to-indigo-600 rounded-2xl flex items-center justify-center text-white text-2xl">' +
                                '👨‍⚕️' +
                            '</div>' +
                            '<div>' +
                                '<h3 class="text-xl font-bold text-gray-900">' + specialist.name + '</h3>' +
                                '<p class="text-gray-600 font-medium">' + specialist.specialty + '</p>' +
                            '</div>' +
                        '</div>' +
                        
                        '<div class="grid grid-cols-1 md:grid-cols-3 gap-4">' +
                            '<div class="bg-blue-50 rounded-xl p-3 border-l-4 border-blue-500">' +
                                '<h4 class="font-semibold text-gray-900 text-sm mb-1">💼 Spécialité</h4>' +
                                '<p class="text-blue-700 font-medium text-sm">' + specialist.specialty + '</p>' +
                            '</div>' +
                            
                            '<div class="bg-green-50 rounded-xl p-3 border-l-4 border-green-500">' +
                                '<h4 class="font-semibold text-gray-900 text-sm mb-1">💰 Tarif</h4>' +
                                '<p class="text-green-700 font-bold">' + specialist.fee + ' DH</p>' +
                            '</div>' +
                            
                            '<div class="bg-purple-50 rounded-xl p-3 border-l-4 border-purple-500">' +
                                '<h4 class="font-semibold text-gray-900 text-sm mb-1">📧 Contact</h4>' +
                                '<p class="text-purple-700 font-medium text-xs">' + specialist.email + '</p>' +
                            '</div>' +
                        '</div>' +
                    '</div>' +
                    
                    '<div class="ml-6">' +
                        '<div class="w-12 h-12 bg-gradient-to-r from-emerald-500 to-teal-600 rounded-full flex items-center justify-center text-white">' +
                            '<svg class="w-6 h-6" fill="currentColor" viewBox="0 0 20 20">' +
                                '<path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path>' +
                            '</svg>' +
                        '</div>' +
                    '</div>' +
                '</div>';
            
            return card;
        }
        
        function selectSpecialist(specialist) {
            selectedSpecialist = specialist;
            
            // Mettre à jour visuellement la sélection
            document.querySelectorAll('.specialist-card').forEach(card => {
                card.classList.remove('ring-2', 'ring-emerald-500', 'bg-emerald-50');
            });
            
            event.currentTarget.classList.add('ring-2', 'ring-emerald-500', 'bg-emerald-50');
            
            // Afficher le spécialiste sélectionné
            document.getElementById('selected-specialist-info').innerHTML = 
                '<div class="bg-emerald-50 rounded-xl p-4 border border-emerald-200">' +
                    '<h4 class="font-semibold text-emerald-900 mb-2">✅ Spécialiste sélectionné</h4>' +
                    '<p class="text-emerald-700"><strong>' + specialist.name + '</strong> - ' + specialist.specialty + ' (' + specialist.fee + ' DH)</p>' +
                '</div>';
            
            // Déclencher la validation après sélection
            setTimeout(validateForm, 50);
        }
        
        function generateCalendar() {
            const calendar = document.getElementById('calendar');
            const currentDate = new Date();
            const currentMonth = currentDate.getMonth();
            const currentYear = currentDate.getFullYear();
            
            // Générer les 30 prochains jours
            calendar.innerHTML = '';
            
            for (let i = 0; i < 30; i++) {
                const date = new Date(currentDate);
                date.setDate(currentDate.getDate() + i);
                
                // Exclure les dimanches
                if (date.getDay() === 0) continue;
                
                const dayElement = createDayElement(date);
                calendar.appendChild(dayElement);
            }
        }
        
        function createDayElement(date) {
            const div = document.createElement('div');
            div.className = 'calendar-day bg-white rounded-xl border border-gray-200 p-4 text-center cursor-pointer hover:border-emerald-500 hover:bg-emerald-50';
            div.onclick = () => selectDate(date, div);
            
            const dayNames = ['Dim', 'Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam'];
            const monthNames = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin', 'Juil', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'];
            
            div.innerHTML = 
                '<div class="text-xs text-gray-500 font-medium">' + dayNames[date.getDay()] + '</div>' +
                '<div class="text-xl font-bold text-gray-900">' + date.getDate() + '</div>' +
                '<div class="text-xs text-gray-500">' + monthNames[date.getMonth()] + '</div>';
            
            return div;
        }
        
        function selectDate(date, element) {
            selectedDate = date;
            
            // Mettre à jour visuellement la sélection
            document.querySelectorAll('.calendar-day').forEach(day => {
                day.classList.remove('ring-2', 'ring-emerald-500', 'bg-emerald-100');
            });
            
            element.classList.add('ring-2', 'ring-emerald-500', 'bg-emerald-100');
            
            // Charger les créneaux pour cette date
            loadTimeSlotsForDate(date);
            
            // Déclencher la validation après sélection de date
            setTimeout(validateForm, 50);
        }
        
        function loadTimeSlotsForDate(date) {
            const container = document.getElementById('time-slots-container');
            container.innerHTML = '<div class="col-span-full text-center text-gray-500">Chargement des créneaux...</div>';
            
            if (!selectedSpecialist) {
                container.innerHTML = '<div class="col-span-full text-center text-red-500">Erreur: Aucun spécialiste sélectionné</div>';
                return;
            }
            
            // Charger les créneaux depuis l'API
            fetch('${pageContext.request.contextPath}/doctor/api/time-slots?specialistId=' + selectedSpecialist.id)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Erreur HTTP: ' + response.status);
                    }
                    return response.json();
                })
                .then(slots => {
                    console.log('Créneaux reçus:', slots);
                    displayTimeSlots(slots);
                })
                .catch(error => {
                    console.error('Erreur lors du chargement des créneaux:', error);
                    container.innerHTML = 
                        '<div class="col-span-full bg-red-50 border border-red-200 rounded-xl p-4 text-center">' +
                            '<h4 class="text-red-800 font-semibold mb-2">❌ Erreur de chargement</h4>' +
                            '<p class="text-red-600 text-sm mb-3">Impossible de charger les créneaux disponibles.</p>' +
                            '<button onclick="loadTimeSlotsForDate(selectedDate)" class="px-3 py-1 bg-red-600 text-white rounded text-sm hover:bg-red-700">' +
                                'Réessayer' +
                            '</button>' +
                        '</div>';
                });
        }
        
        function displayTimeSlots(slots) {
            const container = document.getElementById('time-slots-container');
            container.innerHTML = '';
            
            if (!slots || slots.length === 0) {
                container.innerHTML = 
                    '<div class="col-span-full bg-yellow-50 border border-yellow-200 rounded-xl p-4 text-center">' +
                        '<h4 class="text-yellow-800 font-semibold mb-2">😔 Aucun créneau disponible</h4>' +
                        '<p class="text-yellow-600 text-sm">Ce spécialiste n\'a pas de créneaux disponibles pour cette date.</p>' +
                    '</div>';
                return;
            }
            
            slots.forEach(slot => {
                const slotElement = createTimeSlotElement(slot.timeRange, slot.id, slot.isAvailable && !slot.isBooked);
                container.appendChild(slotElement);
            });
        }
        
        function createTimeSlotElement(timeRange, id, isAvailable) {
            const div = document.createElement('div');
            div.className = 'time-slot ' + (isAvailable ? 'bg-gradient-to-br from-emerald-50 to-teal-50 border-emerald-200 cursor-pointer hover:border-emerald-500' : 'bg-gray-100 border-gray-200 cursor-not-allowed') + ' border-2 rounded-xl p-4 text-center transition-all duration-200';
            
            if (isAvailable) {
                div.onclick = () => selectTimeSlot(timeRange, id, div);
            }
            
            div.innerHTML = 
                '<div class="font-bold text-lg ' + (isAvailable ? 'text-gray-900' : 'text-gray-400') + '">' + timeRange + '</div>' +
                '<div class="text-xs ' + (isAvailable ? 'text-emerald-600' : 'text-gray-400') + ' mt-1">' +
                    (isAvailable ? '✅ Disponible' : '❌ Occupé') +
                '</div>' +
                '<div class="text-xs text-gray-500 mt-1">30 minutes</div>';
            
            return div;
        }
        
        function selectTimeSlot(timeRange, id, element) {
            selectedTimeSlot = { id, timeRange };
            
            // Mettre à jour visuellement la sélection
            document.querySelectorAll('.time-slot').forEach(slot => {
                slot.classList.remove('ring-2', 'ring-emerald-500', 'from-emerald-500', 'to-teal-600', 'text-white');
            });
            
            element.classList.add('ring-2', 'ring-emerald-500');
            element.classList.remove('from-emerald-50', 'to-teal-50');
            element.classList.add('from-emerald-500', 'to-teal-600', 'text-white');
            
            // Déclencher la validation après sélection de créneau
            setTimeout(validateForm, 50);
        }
        
        function updateSummary() {
            const summary = document.getElementById('expertise-summary');
            
            // Construire le HTML en utilisant la concaténation pour éviter les conflits avec JSP EL
            const specialistName = selectedSpecialist ? selectedSpecialist.name : 'Non sélectionné';
            const specialistSpecialty = selectedSpecialist ? selectedSpecialist.specialty : 'Non sélectionnée';
            const selectedDateStr = selectedDate ? selectedDate.toLocaleDateString('fr-FR') : 'Non sélectionnée';
            const timeSlotStr = selectedTimeSlot ? selectedTimeSlot.timeRange : 'Non sélectionné';
            const specialistFee = selectedSpecialist ? selectedSpecialist.fee : 0;
            
            summary.innerHTML = 
                '<div class="space-y-4">' +
                    '<div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm">' +
                        '<div class="space-y-2">' +
                            '<div class="flex justify-between">' +
                                '<span class="text-gray-600">Spécialiste:</span>' +
                                '<span class="font-semibold text-gray-900">' + specialistName + '</span>' +
                            '</div>' +
                            '<div class="flex justify-between">' +
                                '<span class="text-gray-600">Spécialité:</span>' +
                                '<span class="font-semibold text-gray-900">' + specialistSpecialty + '</span>' +
                            '</div>' +
                            '<div class="flex justify-between">' +
                                '<span class="text-gray-600">Date:</span>' +
                                '<span class="font-semibold text-gray-900">' + selectedDateStr + '</span>' +
                            '</div>' +
                        '</div>' +
                        '<div class="space-y-2">' +
                            '<div class="flex justify-between">' +
                                '<span class="text-gray-600">Créneau:</span>' +
                                '<span class="font-semibold text-gray-900">' + timeSlotStr + '</span>' +
                            '</div>' +
                            '<div class="flex justify-between">' +
                                '<span class="text-gray-600">Durée:</span>' +
                                '<span class="font-semibold text-gray-900">30 minutes</span>' +
                            '</div>' +
                            '<div class="flex justify-between">' +
                                '<span class="text-gray-600">Tarif expertise:</span>' +
                                '<span class="font-bold text-emerald-600 text-lg">' + specialistFee + ' DH</span>' +
                            '</div>' +
                        '</div>' +
                    '</div>' +
                '</div>';
        }
        
        function setupEventListeners() {
            // Event listeners pour la validation en temps réel
            console.log('Configuration des event listeners...');
            
            // Attendre un délai pour s'assurer que les éléments sont créés
            setTimeout(() => {
                const question = document.getElementById('question');
                const priority = document.getElementById('priority');
                
                console.log('Elements trouvés:', { question, priority });
                
                if (question) {
                    question.addEventListener('input', validateForm);
                    console.log('Event listener ajouté pour question');
                }
                if (priority) {
                    priority.addEventListener('change', validateForm);
                    console.log('Event listener ajouté pour priority');
                }
                
                // Validation initiale
                validateForm();
            }, 100);
        }
        
        function validateForm() {
            const questionEl = document.getElementById('question');
            const priorityEl = document.getElementById('priority');
            const submitBtn = document.getElementById('submitBtn');
            
            if (!questionEl || !priorityEl || !submitBtn) {
                console.log('Elements manquants:', { questionEl, priorityEl, submitBtn });
                return false;
            }
            
            const question = questionEl.value.trim();
            const priority = priorityEl.value;
            
            console.log('Validation du formulaire:');
            console.log('- Question:', question);
            console.log('- Priority:', priority);
            console.log('- selectedSpecialist:', selectedSpecialist);
            console.log('- selectedDate:', selectedDate);
            console.log('- selectedTimeSlot:', selectedTimeSlot);
            
            const isValid = question && priority && selectedSpecialist && selectedDate && selectedTimeSlot;
            
            if (isValid) {
                submitBtn.disabled = false;
                submitBtn.classList.remove('opacity-50', 'cursor-not-allowed');
            } else {
                submitBtn.disabled = true;
                submitBtn.classList.add('opacity-50', 'cursor-not-allowed');
            }
            
            return isValid;
        }
        
        function submitExpertiseRequest() {
            console.log('submitExpertiseRequest appelée');
            
            // Diagnostic complet
            const question = document.getElementById('question').value.trim();
            const priority = document.getElementById('priority').value;
            
            console.log('État actuel des variables:');
            console.log('- selectedSpecialist:', selectedSpecialist);
            console.log('- selectedDate:', selectedDate);
            console.log('- selectedTimeSlot:', selectedTimeSlot);
            console.log('- question:', question);
            console.log('- priority:', priority);
            
            // Vérifier chaque condition individuellement
            const missing = [];
            if (!selectedSpecialist) missing.push('un spécialiste');
            if (!selectedDate) missing.push('une date');
            if (!selectedTimeSlot) missing.push('un créneau');
            if (!question) missing.push('une question');
            if (!priority) missing.push('une priorité');
            
            if (missing.length > 0) {
                const message = 'Il manque: ' + missing.join(', ') + '. Veuillez suivre toutes les étapes du formulaire.';
                console.log('Validation échouée:', message);
                alert(message);
                return;
            }
            
            console.log('Validation réussie, préparation du formulaire...');
            
            const form = document.getElementById('expertise-form');
            
            if (!form) {
                console.error('Formulaire non trouvé');
                alert('Erreur: formulaire non trouvé');
                return;
            }
            
            // Ajouter les données sélectionnées au formulaire
            try {
                addHiddenInput(form, 'specialistId', selectedSpecialist.id);
                addHiddenInput(form, 'timeSlotId', selectedTimeSlot.id);
                addHiddenInput(form, 'selectedDate', selectedDate.toISOString());
                
                console.log('Données ajoutées au formulaire, soumission...');
                form.submit();
            } catch (error) {
                console.error('Erreur lors de la préparation du formulaire:', error);
                alert('Erreur lors de la soumission: ' + error.message);
            }
        }
        
        function addHiddenInput(form, name, value) {
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = name;
            input.value = value;
            form.appendChild(input);
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
                    <a href="${pageContext.request.contextPath}/doctor/create-consultation?consultationId=${consultation.id}" 
                       class="bg-white/10 hover:bg-white/20 text-white px-4 py-2 rounded-lg transition-all duration-200 flex items-center space-x-2">
                        <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M9.707 16.707a1 1 0 01-1.414 0l-6-6a1 1 0 010-1.414l6-6a1 1 0 011.414 1.414L5.414 9H17a1 1 0 110 2H5.414l4.293 4.293a1 1 0 010 1.414z" clip-rule="evenodd"></path>
                        </svg>
                        <span>Retour consultation</span>
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
                    🔍
                </div>
                <h2 class="text-3xl font-semibold text-gray-900">Demander un Avis d'Expert</h2>
            </div>
            <p class="text-gray-600 ml-13">Consultation pour ${consultation.patient.fullName}</p>
        </div>

        <!-- Progress Steps -->
        <div class="bg-white rounded-2xl shadow-lg border border-gray-100 p-6 mb-8">
            <div class="flex items-center justify-between">
                <div class="flex items-center space-x-4">
                    <div id="step-1" class="step-progress active w-10 h-10 rounded-full flex items-center justify-center text-sm font-bold">
                        1
                    </div>
                    <div class="text-sm font-medium text-gray-700">Spécialité</div>
                </div>
                
                <div class="flex-1 h-1 bg-gray-200 mx-4"></div>
                
                <div class="flex items-center space-x-4">
                    <div id="step-2" class="step-progress w-10 h-10 rounded-full flex items-center justify-center text-sm font-bold bg-gray-200 text-gray-600">
                        2
                    </div>
                    <div class="text-sm font-medium text-gray-700">Spécialiste</div>
                </div>
                
                <div class="flex-1 h-1 bg-gray-200 mx-4"></div>
                
                <div class="flex items-center space-x-4">
                    <div id="step-3" class="step-progress w-10 h-10 rounded-full flex items-center justify-center text-sm font-bold bg-gray-200 text-gray-600">
                        3
                    </div>
                    <div class="text-sm font-medium text-gray-700">Créneaux</div>
                </div>
                
                <div class="flex-1 h-1 bg-gray-200 mx-4"></div>
                
                <div class="flex items-center space-x-4">
                    <div id="step-4" class="step-progress w-10 h-10 rounded-full flex items-center justify-center text-sm font-bold bg-gray-200 text-gray-600">
                        4
                    </div>
                    <div class="text-sm font-medium text-gray-700">Demande</div>
                </div>
            </div>
        </div>

        <!-- Patient and Consultation Info -->
        <div class="grid grid-cols-1 xl:grid-cols-2 gap-8 mb-8">
            <!-- Patient Info -->
            <div class="bg-white rounded-2xl shadow-lg border border-gray-100 p-8">
                <h3 class="text-xl font-bold text-gray-900 mb-4 flex items-center">
                    <div class="w-8 h-8 bg-gradient-to-br from-blue-500 to-indigo-600 rounded-lg flex items-center justify-center text-white text-sm mr-3">
                        👤
                    </div>
                    Patient
                </h3>
                
                <div class="space-y-3">
                    <div class="flex items-center space-x-3 p-3 bg-gray-50 rounded-xl">
                        <div class="w-12 h-12 bg-gradient-to-br from-indigo-500 to-purple-600 rounded-xl flex items-center justify-center text-white font-bold text-lg">
                            ${consultation.patient.fullName.substring(0, 1)}
                        </div>
                        <div>
                            <div class="font-semibold text-gray-900">${consultation.patient.fullName}</div>
                            <div class="text-sm text-gray-600">${consultation.patient.age} ans</div>
                        </div>
                    </div>
                    
                    <div class="p-3 bg-gray-50 rounded-xl">
                        <div class="text-xs font-medium text-gray-500 mb-1">N° Sécurité Sociale</div>
                        <div class="font-mono text-sm font-semibold text-gray-900">${consultation.patient.socialSecurityNumber}</div>
                    </div>
                    
                    <div class="p-3 ${consultation.patient.allergies != null ? 'bg-red-50 border border-red-200' : 'bg-gray-50'} rounded-xl">
                        <div class="text-xs font-medium text-gray-500 mb-1">Allergies</div>
                        <div class="font-semibold ${consultation.patient.allergies != null ? 'text-red-600' : 'text-gray-900'}">
                            ${consultation.patient.allergies != null ? consultation.patient.allergies : 'Aucune allergie connue'}
                        </div>
                    </div>
                </div>
            </div>

            <!-- Consultation Details -->
            <div class="bg-white rounded-2xl shadow-lg border border-gray-100 p-8">
                <h3 class="text-xl font-bold text-gray-900 mb-4 flex items-center">
                    <div class="w-8 h-8 bg-gradient-to-br from-orange-500 to-red-600 rounded-lg flex items-center justify-center text-white text-sm mr-3">
                        🩺
                    </div>
                    Détails de la Consultation
                </h3>
                
                <div class="space-y-4">
                    <div class="bg-blue-50 rounded-xl p-4 border-l-4 border-blue-500">
                        <h4 class="font-semibold text-gray-900 mb-2">Motif de Consultation</h4>
                        <p class="text-gray-800 text-sm leading-relaxed">${consultation.chiefComplaint}</p>
                    </div>
                    
                    <c:if test="${not empty consultation.symptoms}">
                        <div class="bg-yellow-50 rounded-xl p-4 border-l-4 border-yellow-500">
                            <h4 class="font-semibold text-gray-900 mb-2">Symptômes</h4>
                            <p class="text-gray-800 text-sm leading-relaxed">${consultation.symptoms}</p>
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty consultation.clinicalExamination}">
                        <div class="bg-green-50 rounded-xl p-4 border-l-4 border-green-500">
                            <h4 class="font-semibold text-gray-900 mb-2">Examen Clinique</h4>
                            <p class="text-gray-800 text-sm leading-relaxed">${consultation.clinicalExamination}</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- Step 1: Specialty Selection -->
        <div id="step-section-1" class="step-section bg-white rounded-2xl shadow-lg border border-gray-100 p-8">
            <h3 class="text-xl font-bold text-gray-900 mb-6 flex items-center">
                <div class="w-8 h-8 bg-gradient-to-br from-purple-500 to-indigo-600 rounded-lg flex items-center justify-center text-white text-sm mr-3">
                    🎯
                </div>
                Étape 1: Sélectionner une Spécialité
            </h3>
            
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                    <label for="specialty" class="block text-sm font-medium text-gray-700 mb-2">
                        Spécialité Médicale *
                    </label>
                    <select id="specialty" name="specialty" required
                            class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent">
                        <option value="">-- Sélectionnez une spécialité --</option>
                        <c:forEach var="spec" items="${specialties}">
                            <option value="${spec}">${spec.displayName}</option>
                        </c:forEach>
                    </select>
                    <p class="mt-2 text-sm text-gray-600">
                        Choisissez la spécialité médicale appropriée pour cette consultation
                    </p>
                </div>
            </div>
            
            <div class="flex justify-end mt-8">
                <button type="button" onclick="nextStep()" 
                        class="px-6 py-3 bg-gradient-to-r from-blue-500 to-indigo-600 text-white rounded-xl font-semibold hover:from-blue-600 hover:to-indigo-700 transition-all duration-200 shadow-lg hover:shadow-xl">
                    Continuer →
                </button>
            </div>
        </div>

        <!-- Step 2: Specialist Selection -->
        <div id="step-section-2" class="step-section hidden bg-white rounded-2xl shadow-lg border border-gray-100 p-8">
            <h3 class="text-xl font-bold text-gray-900 mb-6 flex items-center">
                <div class="w-8 h-8 bg-gradient-to-br from-blue-500 to-indigo-600 rounded-lg flex items-center justify-center text-white text-sm mr-3">
                    👨‍⚕️
                </div>
                Étape 2: Choisir un Spécialiste
            </h3>
            
            <div id="specialists-container" class="space-y-6 mb-6">
                <!-- Les spécialistes seront chargés dynamiquement -->
            </div>
            
            <div id="selected-specialist-info" class="mb-6">
                <!-- Info du spécialiste sélectionné -->
            </div>
            
            <div class="flex justify-between">
                <button type="button" onclick="prevStep()" 
                        class="px-6 py-3 border border-gray-300 text-gray-700 rounded-xl font-semibold hover:bg-gray-50 transition-all duration-200">
                    ← Précédent
                </button>
                <button type="button" onclick="nextStep()" 
                        class="px-6 py-3 bg-gradient-to-r from-blue-500 to-indigo-600 text-white rounded-xl font-semibold hover:from-blue-600 hover:to-indigo-700 transition-all duration-200 shadow-lg hover:shadow-xl">
                    Continuer →
                </button>
            </div>
        </div>

        <!-- Step 3: Date and Time Selection -->
        <div id="step-section-3" class="step-section hidden bg-white rounded-2xl shadow-lg border border-gray-100 p-8">
            <h3 class="text-xl font-bold text-gray-900 mb-6 flex items-center">
                <div class="w-8 h-8 bg-gradient-to-br from-green-500 to-emerald-600 rounded-lg flex items-center justify-center text-white text-sm mr-3">
                    📅
                </div>
                Étape 3: Sélectionner Date et Créneau
            </h3>
            
            <!-- Calendar -->
            <div class="mb-8">
                <h4 class="text-lg font-semibold text-gray-900 mb-4">Sélectionnez une date</h4>
                <div id="calendar" class="grid grid-cols-7 gap-3">
                    <!-- Les jours seront générés dynamiquement -->
                </div>
            </div>
            
            <!-- Time Slots -->
            <div class="mb-8">
                <h4 class="text-lg font-semibold text-gray-900 mb-4">Créneaux disponibles</h4>
                <div id="time-slots-container" class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-3">
                    <!-- Les créneaux seront chargés après sélection de la date -->
                </div>
                <p class="mt-3 text-sm text-gray-600">
                    💡 Sélectionnez d'abord une date pour voir les créneaux disponibles.
                </p>
            </div>
            
            <div class="flex justify-between">
                <button type="button" onclick="prevStep()" 
                        class="px-6 py-3 border border-gray-300 text-gray-700 rounded-xl font-semibold hover:bg-gray-50 transition-all duration-200">
                    ← Précédent
                </button>
                <button type="button" onclick="nextStep()" 
                        class="px-6 py-3 bg-gradient-to-r from-blue-500 to-indigo-600 text-white rounded-xl font-semibold hover:from-blue-600 hover:to-indigo-700 transition-all duration-200 shadow-lg hover:shadow-xl">
                    Continuer →
                </button>
            </div>
        </div>

        <!-- Step 4: Final Form -->
        <div id="step-section-4" class="step-section hidden bg-white rounded-2xl shadow-lg border border-gray-100 p-8">
            <h3 class="text-xl font-bold text-gray-900 mb-6 flex items-center">
                <div class="w-8 h-8 bg-gradient-to-br from-red-500 to-pink-600 rounded-lg flex items-center justify-center text-white text-sm mr-3">
                    📝
                </div>
                Étape 4: Finaliser la Demande
            </h3>
            
            <!-- Instructions -->
            <div class="bg-blue-50 border border-blue-200 rounded-xl p-4 mb-6">
                <div class="flex items-center">
                    <div class="w-6 h-6 bg-blue-500 rounded-full flex items-center justify-center text-white text-sm mr-3">
                        ℹ️
                    </div>
                    <div class="text-sm text-blue-800">
                        <strong>Important:</strong> Vous devez d'abord compléter les étapes 1, 2 et 3 pour sélectionner une spécialité, un spécialiste et un créneau avant de pouvoir envoyer votre demande.
                    </div>
                </div>
            </div>
            
            <form id="expertise-form" method="post" action="${pageContext.request.contextPath}/doctor/create-expertise-request">
                <input type="hidden" name="consultationId" value="${consultation.id}">
                
                <!-- Summary -->
                <div class="bg-emerald-50 rounded-xl p-6 border border-emerald-200 mb-8">
                    <h4 class="text-lg font-semibold text-emerald-900 mb-4">📋 Récapitulatif de la demande</h4>
                    <div id="expertise-summary">
                        <!-- Le récapitulatif sera généré dynamiquement -->
                    </div>
                </div>
                
                <!-- Priority -->
                <div class="mb-6">
                    <label for="priority" class="block text-sm font-medium text-gray-700 mb-2">
                        Priorité de la demande *
                    </label>
                    <select id="priority" name="priority" required
                            class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent">
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
                
                <div class="flex justify-between">
                    <button type="button" onclick="prevStep()" 
                            class="px-6 py-3 border border-gray-300 text-gray-700 rounded-xl font-semibold hover:bg-gray-50 transition-all duration-200">
                        ← Précédent
                    </button>
                    <button type="button" id="submitBtn" onclick="submitExpertiseRequest();" disabled
                            class="px-8 py-3 bg-gradient-to-r from-emerald-500 to-teal-600 text-white rounded-xl font-semibold hover:from-emerald-600 hover:to-teal-700 transition-all duration-200 shadow-lg hover:shadow-xl disabled:opacity-50 disabled:cursor-not-allowed">
                        Envoyer la demande d'expertise
                    </button>
                    
                </div>
            </form>
        </div>
    </div>
</body>
</html>