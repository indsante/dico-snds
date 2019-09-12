# global with dependencies and common paths

library(dplyr)
library(ggplot2) 
library(grid)
library(gridExtra) 
library(markdown)
library(networkD3)
library(shiny)
library(tidyr)
library(elasticsearchr)

# Data

PATH2MARKDOWNS = paste0("www/markdowns/")

PATH2GITLAB_SCHEMAS = 'https://gitlab.com/healthdatahub/schema-snds/blob/master/schemas/'
source("functions.R")

result_agg_by_index <- get_query_result_agg_by_index('')