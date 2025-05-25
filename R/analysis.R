# Script d'analyse des données

# Charger les packages nécessaires
library(tidyverse)
library(ggplot2)
library(scales)

# Fonction pour créer le dossier de sortie
create_output_dir <- function() {
  output_dir <- "../output"
  dir.create(output_dir, showWarnings = FALSE)
  return(output_dir)
}

# Fonction pour les statistiques descriptives
generate_descriptive_stats <- function(data) {
  # Statistiques générales
  stats <- list()
  
  # Nombre total de répondants
  stats$total_respondents <- nrow(data)
  
  # Pourcentage d'étudiants ayant suivi des formations
  stats$percent_with_training <- mean(data$formation_suivie, na.rm = TRUE) * 100
  
  # Moyenne du nombre de formations
  stats$avg_formations <- mean(data$nombre_formations, na.rm = TRUE)
  
  # Moyenne de l'utilité perçue
  stats$avg_utility <- mean(as.numeric(data$utilite_avenir_pro), na.rm = TRUE)
  
  return(stats)
}

# Fonction pour créer les visualisations
create_visualizations <- function(data, output_dir) {
  # 1. Distribution des formations suivies
  p1 <- ggplot(data, aes(x = formation_suivie)) +
    geom_bar(fill = "steelblue") +
    labs(
      title = "Répartition des étudiants selon les formations suivies",
      x = "A suivi une formation",
      y = "Nombre d'étudiants"
    ) +
    theme_minimal()
  ggsave(file.path(output_dir, "distribution_formations.png"), p1)
  
  # 2. Impact sur la compréhension des cours
  p2 <- ggplot(data, aes(x = aide_comprehension_cours)) +
    geom_bar(fill = "orange") +
    labs(
      title = "Impact des formations sur la compréhension des cours",
      x = "Niveau d'aide (1-5)",
      y = "Nombre d'étudiants"
    ) +
    theme_minimal()
  ggsave(file.path(output_dir, "impact_comprehension.png"), p2)
  
  # 3. Utilité pour l'avenir professionnel
  p3 <- ggplot(data, aes(x = utilite_avenir_pro)) +
    geom_bar(fill = "forestgreen") +
    labs(
      title = "Perception de l'utilité pour l'avenir professionnel",
      x = "Niveau d'utilité (1-5)",
      y = "Nombre d'étudiants"
    ) +
    theme_minimal()
  ggsave(file.path(output_dir, "utilite_professionnelle.png"), p3)
  
  # 4. Relation entre nombre de formations et facilité de recherche d'emploi
  p4 <- ggplot(data, aes(x = as.numeric(facilite_recherche_emploi), 
                         y = nombre_formations)) +
    geom_point(alpha = 0.5) +
    geom_smooth(method = "lm", se = TRUE) +
    labs(
      title = "Relation entre nombre de formations et recherche d'emploi",
      x = "Facilité de recherche d'emploi (1-5)",
      y = "Nombre de formations suivies"
    ) +
    theme_minimal()
  ggsave(file.path(output_dir, "relation_formations_emploi.png"), p4)
}

# Fonction pour l'analyse des corrélations
# Fonction pour l'analyse des corrélations
analyze_correlations <- function(data) {
  # Créer une matrice de corrélation pour les variables numériques
  numeric_data <- data %>%
    mutate(
      aide_comprehension_cours = as.numeric(aide_comprehension_cours),
      facilite_recherche_emploi = as.numeric(facilite_recherche_emploi),
      utilite_avenir_pro = as.numeric(utilite_avenir_pro)
    ) %>%
    select(
      nombre_formations,
      aide_comprehension_cours,
      facilite_recherche_emploi,
      utilite_avenir_pro
    )
  
  correlations <- cor(numeric_data, use = "complete.obs")
  return(correlations)
}


# Fonction principale d'analyse
main_analysis <- function() {
  # Charger les données nettoyées
  data_file <- "../data/processed/clean_reponses_questionnaire.csv"
  if (!file.exists(data_file)) {
    stop("Fichier de données nettoyées non trouvé. Exécutez d'abord import.R")
  }
  
  data <- read_csv(data_file)
  
  # Créer le dossier de sortie
  output_dir <- create_output_dir()
  
  # Générer les statistiques descriptives
  stats <- generate_descriptive_stats(data)
  
  # Créer les visualisations
  create_visualizations(data, output_dir)
  
  # Analyser les corrélations
  correlations <- analyze_correlations(data)
  
  # Sauvegarder les résultats
  results <- list(
    statistics = stats,
    correlations = correlations
  )
  
  saveRDS(results, file.path(output_dir, "analysis_results.rds"))
  
  # Afficher un résumé
  cat("\nAnalyse terminée !\n")
  cat("\nStatistiques principales :\n")
  cat("- Nombre total de répondants :", stats$total_respondents, "\n")
  cat("- Pourcentage ayant suivi des formations :", round(stats$percent_with_training, 1), "%\n")
  cat("- Moyenne du nombre de formations :", round(stats$avg_formations, 2), "\n")
  cat("- Moyenne de l'utilité perçue (1-5) :", round(stats$avg_utility, 2), "\n")
}

# Exécuter l'analyse
tryCatch({
  main_analysis()
}, error = function(e) {
  cat("Erreur lors de l'analyse :", conditionMessage(e), "\n")
})