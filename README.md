<div align="center">

# 🏥 CONSULEA - Système de Télé-Expertise Médicale


[![Java](https://img.shields.io/badge/Java-17-007396?style=for-the-badge&logo=java&logoColor=white)](https://www.oracle.com/java/)
[![Jakarta EE](https://img.shields.io/badge/Jakarta%20EE-10-orange?style=for-the-badge&logo=eclipse&logoColor=white)](https://jakarta.ee/)
[![Hibernate](https://img.shields.io/badge/Hibernate-6.0-59666C?style=for-the-badge&logo=hibernate&logoColor=white)](https://hibernate.org/)
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
- [📸 Démonstration](#-captures-décran)
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
- 📊 Saisie des signes vitaux (tension, température, pouls...)
- 📋 Gestion de la file d'attente
- 🔍 Recherche et historique patients

### 👨‍⚕️ **Module Médecin Généraliste**
- 🩺 Création et gestion des consultations
- 📝 Demande d'expertise spécialisée
- 💊 Prescription et diagnostic
- 💰 Calcul automatique des coûts
- 📅 Visualisation des créneaux disponibles

### 🔬 **Module Médecin Spécialiste**
- ⚙️ Configuration du profil (tarif, spécialité)
- 📨 Réception des demandes d'expertise
- 💬 Réponse aux consultations avec recommandations
- 📈 Statistiques et revenus
- 🗓️ Gestion des créneaux horaires

---

## 🏗️ Architecture

```mermaid
graph TB
    A[Client - Navigateur Web] -->|HTTP/HTTPS| B[Serveur Tomcat]
    B --> C[Contrôleurs Servlet]
    C --> D[Services Métier]
    D --> E[Couche DAO/Repository]
    E --> F[Hibernate ORM]
    F --> G[(PostgreSQL)]
    
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
📦 consulea/
├── 📂 src/
│   ├── 📂 main/
│   │   ├── 📂 java/
│   │   │   └── 📂 com/consulea/
│   │   │       ├── 📂 controllers/    # Servlets & Contrôleurs
│   │   │       ├── 📂 models/         # Entités JPA
│   │   │       ├── 📂 services/       # Logique métier
│   │   │       ├── 📂 dao/            # Couche d'accès aux données
│   │   │       ├── 📂 utils/          # Classes utilitaires
│   │   │       └── 📂 filters/        # Filtres de sécurité
│   │   ├── 📂 resources/
│   │   │   ├── 📂 META-INF/
│   │   │   │   └── persistence.xml    # Configuration JPA
│   │   │   └── 📂 sql/
│   │   │       ├── schema.sql         # Structure BDD
│   │   │       └── data.sql           # Données initiales
│   │   └── 📂 webapp/
│   │       ├── 📂 WEB-INF/
│   │       │   ├── web.xml            # Configuration web
│   │       │   └── 📂 views/           # Pages JSP
│   │       ├── 📂 css/                # Styles
│   │       ├── 📂 js/                 # JavaScript
│   │       └── 📂 images/              # Images & icônes
│   └── 📂 test/
│       └── 📂 java/                    # Tests unitaires
├── 📂 docs/                            # Documentation
├── 📄 pom.xml                          # Configuration Maven
└── 📄 README.md                        # Ce fichier
```

---

## 🛠️ Technologies Utilisées

<div align="center">

### Backend
<p>
<img src="https://img.shields.io/badge/Java-17-007396?style=flat-square&logo=java&logoColor=white" alt="Java"/>
<img src="https://img.shields.io/badge/Jakarta_EE-10-orange?style=flat-square&logo=eclipse&logoColor=white" alt="Jakarta EE"/>
<img src="https://img.shields.io/badge/Servlet-5.0-4B8BBE?style=flat-square&logo=java&logoColor=white" alt="Servlet"/>
<img src="https://img.shields.io/badge/JSP-3.0-007396?style=flat-square&logo=java&logoColor=white" alt="JSP"/>
<img src="https://img.shields.io/badge/JSTL-1.2-FF6F00?style=flat-square&logo=java&logoColor=white" alt="JSTL"/>
</p>

### Base de Données & ORM
<p>
<img src="https://img.shields.io/badge/PostgreSQL-15-316192?style=flat-square&logo=postgresql&logoColor=white" alt="PostgreSQL"/>
<img src="https://img.shields.io/badge/Hibernate-6.0-59666C?style=flat-square&logo=hibernate&logoColor=white" alt="Hibernate"/>
<img src="https://img.shields.io/badge/JPA-3.0-007396?style=flat-square&logo=java&logoColor=white" alt="JPA"/>
</p>

### Frontend
<p>
<img src="https://img.shields.io/badge/Bootstrap-5.3-7952B3?style=flat-square&logo=bootstrap&logoColor=white" alt="Bootstrap"/>
<img src="https://img.shields.io/badge/JavaScript-ES6-F7DF1E?style=flat-square&logo=javascript&logoColor=black" alt="JavaScript"/>
<img src="https://img.shields.io/badge/HTML5-E34F26?style=flat-square&logo=html5&logoColor=white" alt="HTML5"/>
<img src="https://img.shields.io/badge/CSS3-1572B6?style=flat-square&logo=css3&logoColor=white" alt="CSS3"/>
<img src="https://img.shields.io/badge/Font_Awesome-6.0-339AF0?style=flat-square&logo=fontawesome&logoColor=white" alt="Font Awesome"/>
</p>

### Serveur & Build
<p>
<img src="https://img.shields.io/badge/Apache_Tomcat-10-F8DC75?style=flat-square&logo=apachetomcat&logoColor=black" alt="Tomcat"/>
<img src="https://img.shields.io/badge/Maven-3.8-C71A36?style=flat-square&logo=apachemaven&logoColor=white" alt="Maven"/>
</p>

### Tests & Sécurité
<p>
<img src="https://img.shields.io/badge/JUnit-5-25A162?style=flat-square&logo=junit5&logoColor=white" alt="JUnit"/>
<img src="https://img.shields.io/badge/Mockito-4.0-78C257?style=flat-square&logo=java&logoColor=white" alt="Mockito"/>
<img src="https://img.shields.io/badge/BCrypt-Security-red?style=flat-square&logo=spring&logoColor=white" alt="BCrypt"/>
<img src="https://img.shields.io/badge/CSRF-Protection-orange?style=flat-square&logo=security&logoColor=white" alt="CSRF"/>
</p>

### Outils de Développement
<p>
<img src="https://img.shields.io/badge/Git-F05032?style=flat-square&logo=git&logoColor=white" alt="Git"/>
<img src="https://img.shields.io/badge/IntelliJ_IDEA-000000?style=flat-square&logo=intellijidea&logoColor=white" alt="IntelliJ"/>
<img src="https://img.shields.io/badge/Postman-FF6C37?style=flat-square&logo=postman&logoColor=white" alt="Postman"/>
<img src="https://img.shields.io/badge/JIRA-0052CC?style=flat-square&logo=jira&logoColor=white" alt="JIRA"/>
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
GRANT ALL PRIVILEGES ON DATABASE consulea_db TO consulea_user;
```

2. **Exécuter les scripts SQL**
```bash
psql -U consulea_user -d consulea_db -f src/main/resources/sql/schema.sql
psql -U consulea_user -d consulea_db -f src/main/resources/sql/data.sql
```

### ⚙️ Configuration de l'Application

1. **Cloner le repository**
```bash
git clone https://github.com/votre-username/consulea.git
cd consulea
```

2. **Configurer persistence.xml**
```xml
<property name="javax.persistence.jdbc.url" 
          value="jdbc:postgresql://localhost:5432/consulea_db"/>
<property name="javax.persistence.jdbc.user" value="consulea_user"/>
<property name="javax.persistence.jdbc.password" value="your_password"/>
```

3. **Compiler le projet**
```bash
mvn clean compile
```

---


## 📸 Démonstration
![Démo](demo/consulea.mp4)
---

## 📊 Modélisation UML

### Diagramme de Classes
![Diagramme de Classes](UML/Consulea-ClassDiagram.png)
*Architecture complète du système avec toutes les entités et relations*

---

## 📝 Licence

Ce projet est sous licence MIT - voir le fichier [LICENSE](LICENSE) pour plus de détails.


</div>