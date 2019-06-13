# Deploy
apt-get update && apt-get install -y libv8-3.14-dev libcurl4-openssl-dev libssl-dev xclip
r -e "install.packages(c('backports', 'crosstalk', 'clipr' , 'dplyr', 'DT', 'evaluate', 'ggplot2', 'gridExtra', 'highr', 'knitr', 'markdown', 'networkD3', 'rmarkdown', 'rprojroot', 'rsconnect', 'shiny', 'testthat'), repos='http://cran.rstudio.com/')"
r -e "rsconnect::setAccountInfo(name='drees', token='${TOKEN}', secret='${SECRET}')"
r -e "rsconnect::deployApp(appDir = 'app', appName = 'dico-snds')"
