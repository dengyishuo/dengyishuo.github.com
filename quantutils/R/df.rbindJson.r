##' convert data frame with jtid and time to json
##'
##' convert data frame with jtid and time to json
##' @title data frame to json conversion
##' @param data data frame with jtid and time in first and second column
##' @return json string
##' @export 
##' @author Weilin Lin
##'
##' 
df.rbindJson <- function(data){
  json <- p("[",data[,1],",",data[,2],"]");
  return(p("[",p(json,collapse=","),"]"));
}
