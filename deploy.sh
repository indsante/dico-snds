#!/usr/bin/env bash
set -euo pipefail
apt-get update && apt-get install -y libv8-3.14-dev libcurl4-openssl-dev libssl-dev xclip libsasl2-dev zlib1g-dev
r -e "install.packages(c('backports', 'crosstalk', 'clipr' , 'dplyr', 'DT', 'elastic', 'evaluate', 'ggplot2', 'gridExtra', 'highr', 'knitr', 'markdown', 'mongolite', 'networkD3', 'rmarkdown', 'rprojroot', 'rsconnect', 'shiny', 'testthat', 'tidyr'), repos='http://cran.rstudio.com/')"
r -e "rsconnect::setAccountInfo(name='drees', token='${TOKEN}', secret='${SECRET}')"
echo "MONGO_PWD=${MONGO_TOKEN}" > app/server/var_env.txt
echo "MONGO_HOST=${MONGO_HOST}" >> app/server/var_env.txt
echo "MONGO_USERNAME=${MONGO_USERNAME}" >> app/server/var_env.txt
echo "ES_PWD=${ES_PWD}" >> app/server/var_env.txt
echo "ES_HOST=${ES_HOST}" >> app/server/var_env.txt
echo "ES_USERNAME=${ES_USERNAME}" >> app/server/var_env.txt
echo "ES_PORT=${ES_PORT}" >> app/server/var_env.txt
r -e "rsconnect::deployApp(appDir = 'app', appName = 'dico-snds')"

