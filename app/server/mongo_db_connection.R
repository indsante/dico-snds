library(mongolite)

#drees-bads@sante.gouv.fr
download.file(url = "http://ipinfo.io/ip",mode = "wb",
              destfile = "current_ip.txt")
ip=readLines("current_ip.txt")
print("ip")
print(ip)

to_mongo_db=F
if (ip %in% c("54.204.34.9","54.204.36.75","54.204.37.78")){
  to_mongo_db=T
}
if(to_mongo_db){
  options(mongodb = list(
    "host" = "cluster0-6rshm.mongodb.net",
    "username" = "DREES_admin",
    "password"=mongo_pwd
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
  db$insert(data.frame(id=id,time=Sys.time(),input="IP",valeur=ip))
  
  
  
}
