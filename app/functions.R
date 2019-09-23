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
  
  data$snds_nomenclatures <- read.csv(paste0(path2data, "snds_nomenclatures.csv"),
                                      encoding = "UTF-8")
  
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
get_query_result_agg_by_index <- function(term, snds_nomenclatures, elastic_connexion){
  
  aggs <- list(
    aggs = list(
      index_freq = list(
        terms = list(
          field = "_index",
          size = 200
        )
      )
    )
  )
  
  df = tryCatch({
    request <- elastic::Search(elastic_connexion, index = 'nomenclature', q = paste0('*', term, '*'), body=aggs, asdf = T)
    dd <- request$aggregations$index_freq$buckets
    dd[,1] <- toupper(dd[,1]) 
    colnames(dd)[1] <- "nomenclature"
    colnames(dd)[2] <- "occurrences"
    dd <- merge(x=dd, y=snds_nomenclatures, by = "nomenclature", all.x = T)
    dd <- dd %>% select(nomenclature, titre, occurrences)
    # the merge has shuffled the rows so we need to reorder
    dd <- dd[with(dd, order(-occurrences)), ]
    return(dd)
    },
    error=function(cond){
      print(paste0("Error when performing query to ES with term '", term, "'"))
      dd <- data.frame("-"="Pas de résultats")
      return(dd)
  })
}

get_query_result <- function(term, index, elastic_connexion){
  df <- tryCatch({
    # size set to 1000 but might be extended ? 
    request <- elastic::Search(elastic_connexion, index = index, q = paste0('*', term, '*'), size=1000)$hits$hits
    # get back only _source field (does not use _index, _type, _id, _score and )
    request_source <- lapply(request, function(x) x[["_source"]])
    dd <- bind_rows(request_source)
    return(dd)
    },
    error=function(cond){
      print(paste0("Error when performing query to ES with term '", term, "' in the ", index, " nomenclature"))
      dd <- data.frame("-"="Pas de résultats")
      return(dd)
  })
}
