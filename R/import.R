# Script d'importation et de nettoyage des données

# Charger les packages nécessaires
library(tidyverse)
library(janitor)

# Fonction pour importer et nettoyer les données
import_and_clean_data <- function(file_path) {
  # Vérifier si le fichier existe
  if (!file.exists(file_path)) {
    stop("Le fichier de données n'existe pas : ", file_path)
  }
  
  # Importer les données
  data <- read_csv(file_path)
  
  # Nettoyer les noms de colonnes
  data <- clean_names(data)
  
  # Convertir les réponses Oui/Non en booléens
  yes_no_cols <- c(
    "formation_suivie",
    "mention_cv",
    "evoque_entretien",
    "souhaite_autres_formations"
  )
  
  data <- data %>%
    mutate(across(
      all_of(yes_no_cols),
      ~case_when(
        tolower(.) %in% c("oui", "yes") ~ TRUE,
        tolower(.) %in% c("non", "no") ~ FALSE,
        TRUE ~ NA
      )
    ))
  
  # Convertir les échelles en facteurs ordonnés
  echelle_cols <- c(
    "aide_comprehension_cours",
    "facilite_recherche_emploi",
    "utilite_avenir_pro"
  )
  
  data <- data %>%
    mutate(across(
      all_of(echelle_cols),
      ~factor(., levels = 1:5, ordered = TRUE)
    ))
  
  # Convertir le nombre de formations en numérique
  data <- data %>%
    mutate(nombre_formations = as.numeric(nombre_formations))
  
  # Supprimer les lignes complètement vides
  data <- drop_na(data, everything())
  
  # Sauvegarder les données nettoyées
  clean_file_path <- file.path(
    dirname(dirname(file_path)),
    "processed",
    paste0("clean_", basename(file_path))
  )
  
  # Créer le répertoire processed s'il n'existe pas
  dir.create(dirname(clean_file_path), showWarnings = FALSE, recursive = TRUE)
  
  # Sauvegarder les données nettoyées
  write_csv(data, clean_file_path)
  
  # Retourner les données nettoyées
  return(data)
}

# Chemin vers le fichier de données (à modifier selon vos besoins)
data_file <- "../data/raw/reponses_questionnaire.csv"

# Importer et nettoyer les données
tryCatch({
  data <- import_and_clean_data(data_file)
  cat("Importation et nettoyage terminés avec succès.\n")
  cat("Dimensions du jeu de données :", dim(data)[1], "lignes,", dim(data)[2], "colonnes\n")
}, error = function(e) {
  cat("Erreur lors de l'importation :", conditionMessage(e), "\n")
})