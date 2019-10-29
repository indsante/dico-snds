# Deploy
apt-get update && apt-get install -y libv8-3.14-dev libcurl4-openssl-dev libssl-dev xclip libsasl2-dev zlib1g-dev
r -e "install.packages(c('backports', 'crosstalk', 'clipr' , 'dplyr', 'DT', 'elastic', 'evaluate', 'ggplot2', 'gridExtra', 'highr', 'knitr', 'markdown', 'mongolite', 'networkD3', 'rmarkdown', 'rprojroot', 'rsconnect', 'shiny', 'testthat', 'tidyr'), repos='http://cran.rstudio.com/')"
r -e "rsconnect::setAccountInfo(name='drees', token='${TOKEN}', secret='${SECRET}')"
echo "MONGO_PWD=${MONGO_TOKEN}" > app/server/var_env.txt
echo "ES_PWD=${ES_PWD}" >> app/server/var_env.txt
r -e "rsconnect::deployApp(appDir = 'app', appName = 'dico-snds')"

