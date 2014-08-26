##' update bloomberg database
##'
##' update bloomberg database
##' @title update bloomberg database
##' @return NULL
##' @export
##' @author Weilin Lin
bloomberg.update = function(){
      bloomberg.update.wind(); ## update wind data 
      bloomberg.update.CB();   ## update convertible bond market index
      bloomberg.update.derivative();      
  }
