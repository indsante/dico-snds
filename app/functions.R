load_data <- function(path2data){
  data <- list()
  # SNDS nodes table
  data$snds_nodes <- read.csv(paste0(path2data, "snds_nodes.csv"),
                        encoding = "UTF-8")
  # SNDS links table
  data$snds_links <- read.csv(paste0(path2data, "snds_links.csv"),
                        encoding = "UTF-8")
  # SNDS variables table
  data$snds_vars <- read.csv(paste0(path2data,"snds_vars.csv"), 
                       encoding = "UTF-8", 
                       stringsAsFactors = FALSE)
  data$snds_vars$table <- as.factor(data$snds_vars$table)
  
  # SNDS tables
  data$snds_tables <- read.csv(paste0(path2data, "snds_tables.csv"),
                          encoding = "UTF-8")
  data$snds_tables$Libelle <- as.character(data$snds_tables$Libelle)
  return(data)
}

# Utils functions for feeding DT functions
## Preprocess snds tables
get_snds_tables <- function(snds_tables){
  df <- snds_tables %>% 
    select(one_of('Produit', 'Table', 'Libelle'))
  return(df)
}
## Preprocess snds vars
get_snds_vars <- function(snds_vars){
  df <- snds_vars %>% 
    select(one_of("table", "var", "description", "format"))
  return(df)
}

# Functions for ElasticSearch queries
get_query_result_agg_by_index <- function(term){
  body_query <- '{"multi_match" : {"query" : "*'
  term_query <- query(paste0(body_query, term, '*"}}'))
  index_freq <- aggs('{"index_freq" : {
                     "terms" : {
                     "field" : "_index",
                     "size" : 200
                          } 
                        }
                      }')
  df <- elastic("http://localhost:9200", "nomenclature") %search% (term_query + index_freq)
  return(df)
}

get_query_result <- function(term, index){
  body_query <- '{"multi_match" : {"query" : "'
  term_query <- query(paste0(body_query, term, '"}}'))
  df <- elastic("http://localhost:9200", index) %search% term_query
  }

