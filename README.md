<div align="center">

# 🏥 CONSULEA - Système de Télé-Expertise Médicale

[![Java](https://img.shields.io/badge/Java-17-007396?style=for-the-badge&logo=java&logoColor=white)](https://www.oracle.com/java/)
[![Jakarta EE](https://img.shields.io/badge/Jakarta%20EE-10-orange?style=for-the-badge&logo=eclipse&logoColor=white)](https://jakarta.ee/)
[![Hibernate](https://img.shields.io/badge/Hibernate-6.2-59666C?style=for-the-badge&logo=hibernate&logoColor=white)](https://hibernate.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-316192?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)

### 🚀 **Optimisez le parcours patient avec la télé-expertise médicale**

*Une plateforme révolutionnaire pour connecter médecins généralistes et spécialistes en temps réel*

</div>

---

## 📋 Table des Matières

- [✨ À Propos](#-à-propos)
- [🎯 Fonctionnalités Principales](#-fonctionnalités-principales)
- [🏗️ Architecture](#️-architecture)
- [🛠️ Technologies Utilisées](#️-technologies-utilisées)
- [📦 Installation](#-installation)
- [🚀 Déploiement](#-déploiement)
- [📸 Démonstration](#-démonstration)
- [📊 Modélisation UML](#-modélisation-uml)
- [📝 Licence](#-licence)

---

## ✨ À Propos

**Consulea** est une plateforme de télé-expertise médicale innovante qui révolutionne la coordination des soins entre professionnels de santé. Notre système permet une collaboration fluide entre médecins généralistes et spécialistes, garantissant une prise en charge rapide et efficace des patients.

### 🎯 Objectifs du Projet

<div align="center">
<table>
<tr>
<td align="center" width="33%">
<img src="https://img.icons8.com/fluency/96/000000/time.png" width="60" height="60"/>
<br><b>⏱️ Gain de Temps</b>
<br><sub>Réduction du délai de prise en charge</sub>
</td>
<td align="center" width="33%">
<img src="https://img.icons8.com/fluency/96/000000/doctor-male.png" width="60" height="60"/>
<br><b>👨‍⚕️ Collaboration</b>
<br><sub>Échange facilité entre médecins</sub>
</td>
<td align="center" width="33%">
<img src="https://img.icons8.com/fluency/96/000000/heart-with-pulse.png" width="60" height="60"/>
<br><b>❤️ Qualité des Soins</b>
<br><sub>Meilleure prise en charge patient</sub>
</td>
</tr>
</table>
</div>

---

## 🎯 Fonctionnalités Principales

### 👩‍⚕️ **Module Infirmier**
- ✅ Enregistrement rapide des patients
- 📊 Saisie des signes vitaux (tension, température, pouls, saturation O2, poids, taille...)
- 📋 Gestion de la file d'attente
- 🔍 Recherche et consultation de l'historique des patients
- 👤 Mise à jour des informations patients

### 👨‍⚕️ **Module Médecin Généraliste**
- 🩺 Création et gestion des consultations complètes
- 📝 Demande d'expertise spécialisée avec priorisation
- 💊 Saisie des diagnostics et traitements
- 💰 Calcul automatique des coûts avec actes médicaux
- 📅 Visualisation des créneaux disponibles des spécialistes
- 📋 Suivi des consultations (en cours, en attente d'avis, terminées)

### 🔬 **Module Médecin Spécialiste**
- ⚙️ Configuration du profil (spécialité, tarif de consultation)
- 📨 Réception et traitement des demandes d'expertise
- 💬 Réponse détaillée avec recommandations médicales
- 📈 Tableau de bord avec statistiques et revenus
- 🗓️ Gestion des créneaux horaires de disponibilité

---

## 🏗️ Architecture

```mermaid
graph TB
    A[Client - Navigateur Web] -->|HTTP/HTTPS| B[Serveur Tomcat 10]
    B --> C[Contrôleurs Servlet]
    C --> D[Services Métier]
    D --> E[Couche DAO/Repository]
    E --> F[Hibernate ORM 6.2]
    F --> G[(PostgreSQL 15)]
    
    style A fill:#e1f5fe
    style B fill:#fff3e0
    style C fill:#f3e5f5
    style D fill:#e8f5e9
    style E fill:#fce4ec
    style F fill:#fff9c4
    style G fill:#e0f2f1
```

### 📁 Structure du Projet

```
📦 consulea-PatientCareCoordinator/
├── 📂 src/
│   ├── 📂 main/
│   │   ├── 📂 java/
│   │   │   └── 📂 com/consulea/
│   │   │       ├── 📂 servlet/        # Servlets & Contrôleurs
│   │   │       ├── 📂 entity/         # Entités JPA
│   │   │       ├── 📂 service/        # Logique métier
│   │   │       ├── 📂 dao/            # Couche d'accès aux données
│   │   │       ├── 📂 enums/          # Énumérations
│   │   │       ├── 📂 util/           # Classes utilitaires
│   │   │       └── 📂 filter/         # Filtres de sécurité
│   │   ├── 📂 resources/
│   │   │   ├── 📂 META-INF/
│   │   │   │   └── persistence.xml    # Configuration JPA
│   │   │   └── 📂 sql/                # Scripts SQL
│   │   └── 📂 webapp/
│   │       ├── 📂 WEB-INF/
│   │       │   └── 📂 views/          # Pages JSP
│   │       │       ├── 📂 nurse/      # Vues infirmier
│   │       │       ├── 📂 doctor/     # Vues médecin
│   │       │       └── 📂 specialist/ # Vues spécialiste
│   │       ├── 📂 assets/             # Ressources statiques
│   │       └── index.jsp              # Page d'accueil
│   └── 📂 test/                       # Tests unitaires
├── 📂 UML/                            # Diagrammes UML
├── 📂 demo/                           # Vidéo de démonstration
├── 📂 Doc/                            # Documentation flows
├── 📄 pom.xml                         # Configuration Maven
└── 📄 README.md                       # Ce fichier
```

---

## 🛠️ Technologies Utilisées

<div align="center">

### Backend
<p>
<img src="https://img.shields.io/badge/Java-17-007396?style=flat-square&logo=java&logoColor=white" alt="Java"/>
<img src="https://img.shields.io/badge/Jakarta_EE-10-orange?style=flat-square&logo=eclipse&logoColor=white" alt="Jakarta EE"/>
<img src="https://img.shields.io/badge/Servlet-6.0-4B8BBE?style=flat-square&logo=java&logoColor=white" alt="Servlet"/>
<img src="https://img.shields.io/badge/JSP-3.1-007396?style=flat-square&logo=java&logoColor=white" alt="JSP"/>
<img src="https://img.shields.io/badge/JSTL-3.0-FF6F00?style=flat-square&logo=java&logoColor=white" alt="JSTL"/>
</p>

### Base de Données & ORM
<p>
<img src="https://img.shields.io/badge/PostgreSQL-15-316192?style=flat-square&logo=postgresql&logoColor=white" alt="PostgreSQL"/>
<img src="https://img.shields.io/badge/Hibernate-6.2-59666C?style=flat-square&logo=hibernate&logoColor=white" alt="Hibernate"/>
<img src="https://img.shields.io/badge/JPA-3.0-007396?style=flat-square&logo=java&logoColor=white" alt="JPA"/>
</p>

### Frontend
<p>
<img src="https://img.shields.io/badge/Tailwind_CSS-3.3-38B2AC?style=flat-square&logo=tailwind-css&logoColor=white" alt="Tailwind CSS"/>
<img src="https://img.shields.io/badge/JavaScript-ES6-F7DF1E?style=flat-square&logo=javascript&logoColor=black" alt="JavaScript"/>
<img src="https://img.shields.io/badge/HTML5-E34F26?style=flat-square&logo=html5&logoColor=white" alt="HTML5"/>
<img src="https://img.shields.io/badge/CSS3-1572B6?style=flat-square&logo=css3&logoColor=white" alt="CSS3"/>
</p>

### Serveur & Build
<p>
<img src="https://img.shields.io/badge/Apache_Tomcat-10-F8DC75?style=flat-square&logo=apachetomcat&logoColor=black" alt="Tomcat"/>
<img src="https://img.shields.io/badge/Maven-3.8-C71A36?style=flat-square&logo=apachemaven&logoColor=white" alt="Maven"/>
</p>

### Tests & Sécurité
<p>
<img src="https://img.shields.io/badge/JUnit-5-25A162?style=flat-square&logo=junit5&logoColor=white" alt="JUnit"/>
<img src="https://img.shields.io/badge/Mockito-5.5-78C257?style=flat-square&logo=java&logoColor=white" alt="Mockito"/>
<img src="https://img.shields.io/badge/BCrypt-0.4-red?style=flat-square&logo=spring&logoColor=white" alt="BCrypt"/>
</p>

### Outils de Développement
<p>
<img src="https://img.shields.io/badge/Git-F05032?style=flat-square&logo=git&logoColor=white" alt="Git"/>
<img src="https://img.shields.io/badge/IntelliJ_IDEA-000000?style=flat-square&logo=intellijidea&logoColor=white" alt="IntelliJ"/>
</p>

</div>

---

## 📦 Installation

### Prérequis

- ☕ **Java 17** ou supérieur
- 🐘 **PostgreSQL 15** ou supérieur
- 🔧 **Maven 3.8+**
- 🐱 **Tomcat 10** ou supérieur
- 💻 **IDE** (IntelliJ IDEA recommandé)

### 🔧 Configuration de la Base de Données

1. **Créer la base de données**
```sql
CREATE DATABASE Consulea;
CREATE USER consulea_user WITH PASSWORD 'your_password';
GRANT ALL PRIVILEGES ON DATABASE Consulea TO consulea_user;
```

2. **Configurer persistence.xml**
```xml
<property name="jakarta.persistence.jdbc.url" 
          value="jdbc:postgresql://localhost:5432/Consulea"/>
<property name="jakarta.persistence.jdbc.user" value="consulea_user"/>
<property name="jakarta.persistence.jdbc.password" value="your_password"/>
```

### ⚙️ Configuration de l'Application

1. **Cloner le repository**
```bash
git clone https://github.com/votre-username/consulea-PatientCareCoordinator.git
cd consulea-PatientCareCoordinator
```

2. **Modifier la configuration de base de données**
   - Éditer `src/main/resources/META-INF/persistence.xml`
   - Mettre à jour les informations de connexion PostgreSQL

3. **Compiler le projet**
```bash
mvn clean compile
```

4. **Exécuter les tests**
```bash
mvn test
```

---

## 🚀 Déploiement

### Génération du fichier WAR

```bash
# Nettoyer et construire le projet
mvn clean package

# Le fichier WAR sera généré dans target/consulea.war
```

### Déploiement sur Tomcat

1. **Copier le fichier WAR**
```bash
cp target/consulea.war $TOMCAT_HOME/webapps/
```

2. **Démarrer Tomcat**
```bash
$TOMCAT_HOME/bin/startup.sh
```

3. **Accéder à l'application**
```
http://localhost:8080/consulea
```

### Comptes par défaut

- **Infirmier**: `infirmier@consulea.com` / `password123`
- **Médecin Généraliste**: `docteur@consulea.com` / `password123`
- **Médecin Spécialiste**: `specialiste@consulea.com` / `password123`

---

## 📸 Démonstration

### Vidéo de démonstration complète (clickez sur l'image dessous)

[![Demo Video](demo/img.png)](demo/consulea.mp4)

*Démonstration complète des fonctionnalités de la plateforme Consulea*

---

## 📊 Modélisation UML

### Diagramme de Classes

![Diagramme de Classes](UML/Consulea-ClassDiagram.png)

*Architecture complète du système avec toutes les entités, relations et annotations JPA*

### Entités Principales

- **User** : Gestion des utilisateurs (infirmiers, médecins, spécialistes)
- **Patient** : Informations des patients et historique médical
- **Consultation** : Consultations médicales avec diagnostic et traitement
- **ExpertiseRequest** : Demandes d'expertise entre médecins
- **Specialist** : Profils spécialisés des médecins spécialistes
- **TimeSlot** : Gestion des créneaux horaires
- **VitalSigns** : Signes vitaux des patients
- **MedicalAct** : Actes médicaux et tarification

---

## 📂 Documentation

### Flows Métier

- [**Nurse Flow**](Doc/Nurse-Flow.pdf) - Processus de travail des infirmiers
- [**Generalist Flow**](Doc/Generalist-Flow.pdf) - Processus de travail des médecins généralistes

### Fonctionnalités Détaillées

#### Gestion des Patients
- Enregistrement avec informations complètes
- Suivi des signes vitaux
- Historique médical complet

#### Système de Consultation
- Workflow complet de consultation
- Intégration des actes médicaux
- Calcul automatique des coûts

#### Télé-expertise
- Demandes priorisées
- Réservation de créneaux
- Réponses détaillées avec recommandations

---

## 🔧 Configuration Avancée

### Variables d'Environnement

```bash
# Base de données
DB_URL=jdbc:postgresql://localhost:5432/Consulea
DB_USER=consulea_user
DB_PASSWORD=your_password

# Serveur
SERVER_PORT=8080
CONTEXT_PATH=/consulea
```

### Profils Maven

```bash
# Développement
mvn clean package -Pdev

# Production
mvn clean package -Pprod
```

---

## 🐛 Dépannage

### Problèmes Courants

1. **Erreur de connexion à la base de données**
   - Vérifier que PostgreSQL est démarré
   - Contrôler les paramètres de connexion dans `persistence.xml`

2. **ClassNotFoundException**
   - Vérifier que toutes les dépendances sont dans le classpath
   - Rebuilder le projet : `mvn clean compile`

3. **Erreur de déploiement**
   - Vérifier que Tomcat 10+ est utilisé
   - Contrôler les logs dans `$TOMCAT_HOME/logs/catalina.out`

---

## 📝 Licence

Ce projet est sous licence MIT - voir le fichier [LICENSE](LICENSE) pour plus de détails.

---

<div align="center">

**Développé avec ❤️ pour améliorer les soins de santé**

*Consulea - Révolutionnons ensemble la télé-expertise médicale*

</div>