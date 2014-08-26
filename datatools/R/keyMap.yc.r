##' KeyMap function for yieldCurve project 
##'
##' KeyMap function for yieldCurve project 
##' @title KeyMap function for yieldCurve project 
##' @param keys keys to be mapped
##' @param inputKeyType 
##' @param outputKeyType 
##' @param region 
##' @param keyMapFile 
##' @return vector
##' @export
##' @author Weilin Lin
keyMap.yc <- function(keys, inputKeyType="InnerCode", outputKeyType="JTID", region="CN", keyMapFile=NULL)
{
  if(is.null(keyMapFile))
    keyMapFile <- p(YTM.DATA.DIR, "/", tolower(region), "/keyMap/keyMap.csv");
  keyVars    <- c(inputKeyType, outputKeyType);
  df         <- read.csv(keyMapFile)
  outKeys    <- df[match(keys, df[[inputKeyType]]), outputKeyType];
  return(outKeys);
}
