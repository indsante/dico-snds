# Deploy
apt-get update && apt-get install -y libv8-3.14-dev libcurl4-openssl-dev libssl-dev xclip libsasl2-dev zlib1g-dev curl
r -e "install.packages(c('backports', 'crosstalk', 'clipr' , 'dplyr', 'DT', 'elastic', 'evaluate', 'ggplot2', 'gridExtra', 'highr', 'knitr', 'markdown', 'mongolite', 'networkD3', 'rmarkdown', 'rprojroot', 'rsconnect', 'shiny', 'testthat', 'tidyr'), repos='http://cran.rstudio.com/')"
r -e "rsconnect::setAccountInfo(name='drees', token='${TOKEN}', secret='${SECRET}')"
echo ${MONGO_TOKEN} > app/server/mongo_password.txt
r -e "rsconnect::deployApp(appDir = 'app', appName = 'dico-snds-test')"
sleep 30s
curl "https://drees.shinyapps.io/dico-snds-test/" > dico.html
r -e "testthat::test_that('erreur lors du deploiement ?',{testthat::expect_equal(sum(grepl('(error-code)|(error has occurred)',readLines('dico.html'))),0)})"
r -e "rsconnect::deployApp(appDir = 'app', appName = 'dico-snds')"

