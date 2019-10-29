# Load data
library(testthat)
library(dplyr)

PATH2DATA = "../app_data/"
source("../functions.R")

data <- load_data(PATH2DATA)
snds_nodes <- data$snds_nodes
snds_links <- data$snds_links
snds_vars <- data$snds_vars
snds_tables <- data$snds_tables

test_that("load_data returns all dataframes necessary to the app", {
  expect_equal(length(load_data(PATH2DATA)), 5)
})

test_that("get_snds_tables returns the good columns", {
  expect_equal(colnames(get_snds_tables(snds_tables)), c('Produit', 'Table', 'Libelle'))
})


test_that("nomenclature column is present in snds_vars", {
  expect_true("nomenclature" %in% colnames(snds_vars))
})

test_that("get_snds_vars returns the good columns", {
  expect_equal(colnames(get_snds_vars(snds_vars)), c("table", "var", "description", "nomenclature"))
})

test_that("network inputs have the relevant columns", {
  expect_equal(colnames(snds_nodes), c("name", "description", "group", "index", "nb_vars"))
  expect_equal(colnames(snds_links), c("source", "target", "joint_var"))
})

test_that('erreur lors du deploiement ?',{
  expect_equal(sum(grepl('(error-code)|(error has occurred)',readLines('../dico.html'))),0)
})
