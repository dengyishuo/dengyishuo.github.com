##' update macro and market data
##'
##' update macro and market data
##' @title update macro and market data
##' @return NULL
##' @importFrom quantutils date.convert
##' @importFrom quantutils dot.date.convert
##' @importFrom quantutils dot.date.convert
##' @importFrom quantutils df.rbindList
##' @importFrom RMySQL dbGetQuery
##' @importFrom RMySQL dbWriteTable
##' @export
##' @author Weilin Lin
bloomberg.update.wind = function(){
      ## update treasury market data.
        #data = dbGetQuery(DBChannel.sigmaMacro, "SELECT * FROM treasury");
        #vars = setdiff(colnames(data),"date");
        #lst  = list();
        #for(var in vars){
        #            df = data[,c("date",var)];
        #            df$date = date.convert(dot.date.convert(data$date, format="%Y-%m-%d"), format="%Y-%m-%d");
        #            df$name = var;
        #            df$updateTime = as.character(Sys.time());
        #            df = df[,c("name","date",var,"updateTime")];
        #            colnames(df) = c("name","date","value","updateTime");
        #            df$value = as.numeric(df$value);
        #            lst[[var]] = df;
                    ## truncate old data
        #            dbSendQuery(DBChannel.sigmaMacro, p("DELETE FROM bloomberg_daily WHERE name='",var,"'"));
        #    }
        #df = df.rbindList(lst);
        #dbWriteTable(DBChannel.sigmaMacro, "bloomberg_daily", df, row.name=FALSE, append=TRUE);

        ## update money market data.
        #data = dbGetQuery(DBChannel.sigmaMacro, "SELECT * FROM moneymarket");
        #vars = setdiff(colnames(data),"date");
        #lst  = list();
        #for(var in vars){
        #        df = data[,c("date",var)];
        #            df$date = date.convert(dot.date.convert(data$date, format="%Y-%m-%d"), format="%Y-%m-%d");
        #            df$name = var;
        #            df$updateTime = as.character(Sys.time());
        #            df = df[,c("name","date",var,"updateTime")];
        #            colnames(df) = c("name","date","value","updateTime");
        #            lst[[var]] = df;
                  ## truncate old data
        #            dbSendQuery(DBChannel.sigmaMacro, p("DELETE FROM bloomberg_daily WHERE name='",var,"'"));
        #    }
        #df = df.rbindList(lst);
        #dbWriteTable(DBChannel.sigmaMacro, "bloomberg_daily", df, row.name=FALSE, append=TRUE);
  }
