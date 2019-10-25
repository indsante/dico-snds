# Backend logics
## Load data

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
  
  
  # Log to MongoDB Atlas
  source("server/log_mongo_atlas.R", local=TRUE)
  
  
  
  
})
  
