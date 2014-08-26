##' update derivative indicators
##'
##' update derivative indicators
##' @title update derivative indicators
##' @return NULL
##' @export
##' @importFrom RMySQL dbGetQuery
##' @importFrom RMySQL dbWriteTable
##' @importFrom quantutils df.tsTodf p
##' @author Weilin Lin
bloomberg.update.derivative = function(){
    
##################################################
###    
###   update indicators that are derived feom basic data
###
##################################################

    ### update credit spread data
        data <- bloomberg.market.getData(names = c("Yr10","Yr5","Yr3","Yr1","Yr5_gk","Yr5_2a_drzp","Yr5_2ap_drzp","Yr5_2a_qyz"), 20080101);
        data$xylc_2a         <- data$Yr5_2a_drzp  - data$Yr5;
        data$xylc_2ap        <- data$Yr5_2ap_drzp - data$Yr5;
        data$xylc_2a_gk      <- data$Yr5_2a_drzp  - data$Yr5_gk
        data$xylc_2ap_gk     <- data$Yr5_2ap_drzp - data$Yr5_gk
        data$slope           <- data$Yr10 - data$Yr1;
        data    <- data[,c("xylc_2a","xylc_2ap","xylc_2a_gk","xylc_2ap_gk","slope")];
        data    <- df.tsTodf(data);
        dbSendQuery(DBChannel.sigmaMacro, p("DELETE FROM bloomberg_daily WHERE name in ('xylc_2a','xylc_2ap','slope')"));        
        dbWriteTable(DBChannel.sigmaMacro, "bloomberg_daily", data, row.name=FALSE, append=TRUE);
   ###  update Macro derivtive data
        # estamate the return rate
        data <- bloomberg.macro.getData("")
        
        
        
  }
