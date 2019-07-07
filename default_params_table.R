# Reset the params to their defaults. 
# Will overwrite existing params table without asking. 

make_default_params_table <- function(){
  params = list(
    param_file=      "params.csv", 
    students_file=   "students.csv", 
    advisers_file=   "advisers.csv",
    exclude_file=    "exclude.csv",
 
    overflow_max_advisors = -100,
    forbidden_penalty= -1000, 
    pref_by_adviser= 10
  )
  par <-data.frame(name= names(params),value=unlist(params), 
                             stringsAsFactors = FALSE)
  write.csv(par, params[["param_file"]], row.names = FALSE, quote=FALSE)
}

# Get the params from the parameter table. Return them as list.

get_default_params_table <- function(location= "params.csv"){
  if(! file.exists(location)) {
    print("-100: no paramms.csv file in the working directory")
    return(NULL)
    }
  par <- read.csv(location, stringsAsFactors = FALSE, sep= ",")
  params <- as.list(par$value)
  names(params) <- par$name
  for(i in names(params)){
    v<- params[[i]]
    suppressWarnings(v<- as.integer(v))
    if (!is.na(v)) params[[i]] <- v
  }
  return(params)
}