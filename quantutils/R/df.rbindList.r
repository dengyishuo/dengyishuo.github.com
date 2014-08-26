##' bind list
##' 
##' bind list 
##' @title bind list
##' @param lst An list
##' @return df 
##' @export
##' @author Weilin Lin
##' 

df.rbindList <- function(lst)
{
   df <- do.call(rbind, lst);
   rownames(df) <- NULL;
   return(data.frame(df));
}


