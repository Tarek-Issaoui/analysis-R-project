# Installation des packages nécessaires
packages <- c(
  "tidyverse",  # Pour la manipulation et visualisation des données
  "readxl",     # Pour lire les fichiers Excel
  "janitor",    # Pour le nettoyage des données
  "ggplot2",    # Pour les visualisations
  "dplyr",      # Pour la manipulation des données
  "scales",     # Pour le formatage des échelles dans les graphiques
  "knitr",      # Pour la génération de rapports
  "rmarkdown"   # Pour la génération de rapports
)

# Fonction pour installer les packages manquants
install_if_missing <- function(packages) {
  new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]
  if(length(new_packages)) install.packages(new_packages)
}

# Installation des packages
install_if_missing(packages)

# Charger les packages
lapply(packages, library, character.only = TRUE)

# Vérification de l'installation
cat("Installation terminée. Packages installés :\n")
for(pkg in packages) {
  version <- packageVersion(pkg)
  cat(sprintf("- %s (version %s)\n", pkg, version))
}