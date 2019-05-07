# Deploy
r -e "rsconnect::setAccountInfo(name='drees', token='${TOKEN}', secret='${SECRET}')"
r -e "rsconnect::deployApp(appDir = 'app', appName = 'dico-snds')"