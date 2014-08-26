##' Get ip address from wtmart.com
##'
##' Get ip address from  wtmart.com
##' @title Get ip address from  wtmart.com
##' @importFrom  RCurl getURL
##' @export
##' @return ip as string
##' @author Weilin Lin

getIP <- function(...){
    webpage <- getURL("http://ip.wtmart.com/");
    ## ip <- readLines(tc <- textConnection(webpage)); close(tc);
    return(webpage);
}
