# Deploy
apt-get update && apt-get install -y libv8-3.14-dev libcurl4-openssl-dev libssl-dev
r -e "install.packages(c('rsconnect'), repos='http://cran.rstudio.com/')"
r -e "rsconnect::setAccountInfo(name='drees', token='${TOKEN}', secret='${SECRET}')"
r -e "rsconnect::deployApp(appDir = 'app', appName = 'dico-snds')"
