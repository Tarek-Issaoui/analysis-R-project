# Trouver Pandoc dans l'installation RStudio
find_rstudio_pandoc <- function() {
  # Chemins possibles pour RStudio sur Windows
  possible_paths <- c(
    "C:/Program Files/RStudio/resources/app/bin/quarto/bin/tools/pandoc",
    "C:/Program Files/RStudio/bin/quarto/bin/tools/pandoc",
    "C:/Program Files/RStudio/bin/pandoc",
    "C:/Program Files/RStudio/resources/app/bin/pandoc"
  )
  
  # Vérifier chaque chemin
  for (path in possible_paths) {
    if (dir.exists(path)) {
      return(path)
    }
  }
  
  # Rechercher dans le répertoire d'installation de RStudio
  rstudio_dir <- "C:/Program Files/RStudio"
  if (dir.exists(rstudio_dir)) {
    # Recherche récursive de pandoc.exe
    pandoc_paths <- list.files(rstudio_dir, pattern = "pandoc\\.exe$", 
                              recursive = TRUE, full.names = TRUE)
    if (length(pandoc_paths) > 0) {
      # Retourner le répertoire contenant pandoc.exe
      return(dirname(pandoc_paths[1]))
    }
  }
  
  return(NULL)
}

# Configurer Pandoc
pandoc_path <- find_rstudio_pandoc()
if (!is.null(pandoc_path)) {
  Sys.setenv(RSTUDIO_PANDOC = pandoc_path)
  cat("Pandoc trouvé à:", pandoc_path, "\n")
} else {
  # Si Pandoc n'est pas trouvé, essayer de l'installer directement
  cat("Installation de Pandoc via rmarkdown...\n")
  if (!requireNamespace("rmarkdown", quietly = TRUE)) {
    install.packages("rmarkdown")
  }
  rmarkdown::find_pandoc(cache = FALSE)
  
  if (!rmarkdown::pandoc_available()) {
    stop("Impossible de trouver ou d'installer Pandoc. Veuillez l'installer manuellement ou exécuter ce script depuis RStudio.")
  }
}

# Script pour générer le dashboard

# Vérifier et installer les packages nécessaires
source("setup.R")

# Vérifier si les données existent et les importer si nécessaire
if (!file.exists("../data/processed/clean_reponses_questionnaire.csv")) {
  source("import.R")
}

# Exécuter l'analyse si les résultats n'existent pas
if (!file.exists("../output/analysis_results.rds")) {
  source("analysis.R")
}

# Créer le dossier pour le dashboard s'il n'existe pas
dashboard_dir <- "../dashboard"
dir.create(dashboard_dir, showWarnings = FALSE)

# Rendre le dashboard
cat("Génération du dashboard...\n")
rmarkdown::render(
  "dashboard.Rmd",
  output_file = file.path(dashboard_dir, "dashboard.html"),
  quiet = TRUE
)

cat("\nDashboard généré avec succès !\n")
cat("Vous pouvez ouvrir le fichier suivant dans votre navigateur :\n")
cat(normalizePath(file.path(dashboard_dir, "dashboard.html")), "\n")