# Analyse de l'Impact des Formations et Certifications - iTeam University

Ce projet R analyse l'impact des formations et certifications sur le parcours des étudiants de iTeam University.

To clone the repository:

```bash
git clone https://github.com/Tarek-Issaoui/analysis-R-project.git
cd analysis-R-project
```
Je suis utilisé VSCode pour écrire le code R. car je suis plus à l'aise avec VSCode que avec RStudio.
Mais il est possible de lancer le code R avec RStudio.

## Structure du Projet

```
.
├── README.md
├── data/               # Dossier pour stocker les données
│   └── raw/           # Données brutes (CSV des réponses)
├── R/                 # Scripts R
│   ├── setup.R       # Installation des packages
│   ├── import.R      # Import et nettoyage des données
│   ├── analysis.R    # Analyses et visualisations
│   ├── dashboard.Rmd # Dashboard interactif
│   └── render_dashboard.R # Script pour générer le dashboard
├── docs/             # Documentation
│   └── questionnaire.md  # Structure du questionnaire
├── dashboard/        # Dashboard HTML généré
└── output/           # Résultats et visualisations
```

## Prérequis

- R (>= 4.0.0)
- RStudio (recommandé)
- Packages R : tidyverse, readxl, janitor, ggplot2, dplyr

## Installation

1. Cloner ce dépôt
2. Ouvrir RStudio
3. Exécuter `R/setup.R` pour installer les dépendances

## Utilisation

1. Collecter les données via le questionnaire (voir docs/questionnaire.md)
2. Placer le fichier CSV des réponses dans `data/raw/`
3. Exécuter les scripts dans l'ordre :
   - `R/import.R` pour importer et nettoyer les données
   - `R/analysis.R` pour générer les analyses
   - `R/render_dashboard.R` pour créer le dashboard interactif

## Visualisation des Résultats

Pour visualiser les résultats de l'analyse :

1. Exécutez le script `R/render_dashboard.R`
2. Ouvrez le fichier généré `dashboard/dashboard.html` dans votre navigateur web
3. Explorez le dashboard interactif qui contient :
   - Un résumé des statistiques principales
   - Des visualisations des distributions
   - Des graphiques d'analyse de corrélation
   - Une matrice de corrélation interactive

## Licence

MIT License
