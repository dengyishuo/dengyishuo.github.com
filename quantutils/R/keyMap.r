##' KeyMap function to Map between different stock tickers
##'
##' Support JTID,windID etc
##' @title Stock keyMap function
##' @param keys the input key values for mapping
##' @param inputKeyType specified which kind of keys of input
##' @param outputKeyType specify the type of output keys
##' @param region shoud be equal to "CN" or "HK"
##' @param keyMapFile unused argument
##' @return return keys vector specified by the outputKeyType
##' @author Weilin Lin
##' 
keyMap <- function(keys, inputKeyType="JTID", outputKeyType="InnerCode", region, keyMapFile=NULL)
{
  if(is.null(keyMapFile))
    keyMapFile <- p(DATA.DIR, "/", tolower(region), "/keyMap/keyMap.csv");
  keyVars    <- c(inputKeyType, outputKeyType);
  df         <- read.csv(keyMapFile, fileEncoding = "UTF-8")
  outKeys    <- df[match(keys, df[[inputKeyType]]), outputKeyType];
  return(outKeys);
}
