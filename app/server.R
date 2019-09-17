# Backend logics
## Load data
PATH2DATA = "app_data/"
PATH2NOMENCLATURES =  paste0(PATH2DATA, "nomenclatures/")
MISSING_TEXT = 'Manquant' 
data <- load_data(PATH2DATA)
snds_nodes <- data$snds_nodes
snds_links <- data$snds_links
snds_vars <- data$snds_vars %>% 
  replace_na(list(creation = MISSING_TEXT, suppression = MISSING_TEXT))
snds_tables <- data$snds_tables %>% 
  replace_na(list(creation = MISSING_TEXT, suppression = MISSING_TEXT))

# Server logics
shinyServer(function(input, output, session) {
  # Explorateur des variables (tab 1)
  source("server/onglet_vars_explo.R", local=TRUE)
  
  # Explorateur des tabless (tab 2)
  source("server/onglet_tables_explo.R", local=TRUE)
  
  # Elasticsearch (tab 3)
  source("server/onglet_elasticsearch.R", local=TRUE)
  
  # SNDS Network (Schema) (tab 4)
  source("server/onglet_network.R", local=TRUE)
  
})
  
