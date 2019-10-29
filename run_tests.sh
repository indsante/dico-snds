#!/usr/bin/env bash
set -euo pipefail
apt-get update && apt-get install -y libv8-3.14-dev libcurl4-openssl-dev libssl-dev xclip libsasl2-dev zlib1g-dev curl
echo "install packages"
r -e "install.packages(c('backports', 'crosstalk', 'clipr' , 'dplyr', 'DT', 'elastic', 'evaluate', 'ggplot2', 'gridExtra', 'highr', 'knitr', 'markdown', 'mongolite', 'networkD3', 'rmarkdown', 'rprojroot', 'rsconnect', 'shiny', 'testthat', 'tidyr'), repos='http://cran.rstudio.com/')"
echo 'setaccountinfo'
r -e "rsconnect::setAccountInfo(name='drees', token='${TOKEN}', secret='${SECRET}')"
echo "MONGO_PWD=${MONGO_TOKEN}" > app/server/var_env.txt
echo "ES_PWD=${ES_PWD}" >> app/server/var_env.txt
echo "deploy app"
r -e "rsconnect::deployApp(appDir = 'app', appName = 'dico-snds-test')"
echo 'deployment to shinyapps.io done !'
sleep 30s
echo 'curl to shinyapps.io/dico-snds-test'
curl "https://drees.shinyapps.io/dico-snds-test/" > app/dico.html
cd app/tests/
echo 'run tests'
Rscript backend_tests.R > output.txt
echo 'return errors'
cat output.txt
echo 'end of errors'
r -e "stopifnot(sum(grepl('(error-code)|(error has occurred)',readLines('../dico.html')))==0)"
cd ../../
