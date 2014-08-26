##' KeyMap function for CB project 
##'
##' KeyMap function for CB project 
##' @title KeyMap function for CB project 
##' @param keys keys to be mapped
##' @param inputKeyType 
##' @param outputKeyType 
##' @param region 
##' @param keyMapFile 
##' @return vector
##' @export
##' @author Weilin Lin
keyMap.CB <- function(keys, inputKeyType="InnerCode", outputKeyType="JTID", region="CN", keyMapFile=NULL)
{  
   if(is.null(keyMapFile)) keyMapFile <- p(CB.DATA.DIR, "/", tolower(region), "/keyMap/keyMapUnix.csv");       
  keyVars    <- c(inputKeyType, outputKeyType);
  df         <- read.csv(keyMapFile, fileEncoding="UTF-8");
  outKeys    <- df[match(keys, df[[inputKeyType]]), outputKeyType];
  return(outKeys);
}
