library(mongolite)

#drees-bads@sante.gouv.fr
download.file(url = "http://ipinfo.io/ip",mode = "wb",
              destfile = "current_ip.txt")
ip=readLines("current_ip.txt")
print("ip")
print(ip)

to_mongo_db=F
if (ip %in% c("54.204.34.9","54.204.36.75","54.204.37.78","164.131.131.193",
              "34.203.76.245","3.217.214.132","34.197.152.155")){
  to_mongo_db=T
}
if(to_mongo_db){
  options(mongodb = list(
    "host" = vars_env$MONGO_HOST,
    "username" = vars_env$MONGO_USERNAME,
    "password"= vars_env$MONGO_PWD
  ))
  databaseName <- "UX"
  collectionName <- "DicoSNDS"
  
  db <- mongo(collection = collectionName,
              url = sprintf(
                "mongodb+srv://%s:%s@%s/%s",
                options()$mongodb$username,
                options()$mongodb$password,
                options()$mongodb$host,
                databaseName))
  
  id=as.character(floor(runif(1)*1e16))#session$token
  db$insert(data.frame(id=id,time=Sys.time(),input="start",valeur="it's on"))
  
  
  
}
