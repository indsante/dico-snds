#!/bin/bash
apt-get update && apt-get install -y libv8-3.14-dev libcurl4-openssl-dev libssl-dev
r -e "install.packages(c('backports', 'crosstalk', 'dplyr', 'DT', 'evaluate', 'ggplot2', 'gridExtra', 'highr', 'knitr', 'markdown', 'networkD3', 'rmarkdown', 'rprojroot', 'rsconnect', 'shiny', 'testthat'), repos='http://cran.rstudio.com/')"