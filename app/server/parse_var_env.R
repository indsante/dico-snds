vars_env = strsplit(readLines("server/var_env.txt"),"=")
names(vars_env) <- lapply(vars_env,function(x)x[1])
vars_env <-lapply(vars_env,function(x)x[2])
