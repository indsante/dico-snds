# global with dependencies and common paths

library(dplyr)
library(ggplot2) 
library(grid)
library(gridExtra) 
library(markdown)
library(networkD3)
library(shiny)
library(tidyr)


# Data

PATH2MARKDOWNS = paste0("www/markdowns/")
PATH2GITLAB_SCHEMAS = 'https://gitlab.com/healthdatahub/schema-snds/tree/master/schemas/'
source("functions.R")