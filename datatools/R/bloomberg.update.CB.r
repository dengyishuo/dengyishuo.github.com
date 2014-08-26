##' update convertible bond market index data 
##'
##' update convertible bond market index data 
##' @title update convertible bond market index data 
##' @return NULL
##' @importFrom quantutils date.convert
##' @importFrom quantutils dot.date.convert
##' @importFrom quantutils dot.date.convert
##' @importFrom quantutils df.rbindList
##' @importFrom RMySQL dbGetQuery
##' @importFrom RMySQL dbWriteTable
##' @export
##' @author Weilin Lin
##' 
bloomberg.update.CB = function(){
      ## update treasury market data.
        data <- dbGetQuery(DBChannel, "SELECT * FROM daily.conbd_index");
        # Map Chiname to EngName
		chinesename <- dbGetQuery(DBChannel,"SELECT * FROM daily.CB_index_china_name")
        tmpDf <- data.frame(indexType = chinesename,
                            indexName = c("cbMktWgtIndex","cbStockMktWgtIndex","cbStockEqWgtIndex","ytmMktIndex","ytmEqWgtIndex","parityPremiumEqWgtIndex","parityPremiumMktWgtIndex","treasuryYield")
                            );
        data            <- merge(data, tmpDf, by = "indexType");
        data            <- data[,c("indexName","date","indexValue")];
        data$date       <- as.character(date.convert(data$date, format = "%Y-%m-%d"));
        data$updateTime <- as.character(Sys.time());
        colnames(data) = c("name","date","value","updateTime");
        ## adjust the scale
        data$value[data$name=="ytmMktIndex"] <- 100*data$value[data$name=="ytmMktIndex"];
        data$value[data$name=="ytmEqWgtIndex"] <- 100*data$value[data$name=="ytmEqWgtIndex"];
        
        ## truncate old data
        vars   <- p("'",unique(data$name),"'");
        sqlStr <- p("DELETE FROM bloomberg_daily WHERE name in (",p(vars,collapse = ","),")");                
        dbSendQuery(DBChannel.sigmaMacro, sqlStr);     
        dbWriteTable(DBChannel.sigmaMacro, "bloomberg_daily", data, row.name=FALSE, append=TRUE);        
  }
