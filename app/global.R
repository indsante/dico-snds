# global with dependencies and common paths

library(dplyr)
library(ggplot2) 
library(grid)
library(gridExtra) 
library(markdown)
library(networkD3)
library(shiny)
library(tidyr)
library(elastic)

# Data

PATH2MARKDOWNS = paste0("www/markdowns/")

PATH2GITLAB_SCHEMAS = 'https://gitlab.com/healthdatahub/schema-snds/blob/master/schemas/'

# set connexion to the db
ELASTIC_CONNEXION <- elastic::connect(
  host = "elasticsearch.health-data-hub.fr",
  port = 9200,
  transport_schema = "http",
  user = "elastic",
  pwd = "*****"
)

# Source auxiliary functions
source("functions.R")

# Load the data
PATH2DATA = "app_data/"
PATH2NOMENCLATURES =  paste0(PATH2DATA, "nomenclatures/")
MISSING_TEXT = 'Manquant' 
data <- load_data(PATH2DATA)
snds_nodes <- data$snds_nodes
snds_nomenclatures <- data$snds_nomenclatures
snds_links <- data$snds_links
snds_vars <- data$snds_vars %>% 
  replace_na(list(creation = MISSING_TEXT, suppression = MISSING_TEXT))
snds_tables <- data$snds_tables %>% 
  replace_na(list(creation = MISSING_TEXT, suppression = MISSING_TEXT))

# default aggregated request for new page
result_agg_by_index <- get_query_result_agg_by_index(
  term='', 
  snds_nomenclatures=snds_nomenclatures, 
  elastic_connexion=ELASTIC_CONNEXION)
