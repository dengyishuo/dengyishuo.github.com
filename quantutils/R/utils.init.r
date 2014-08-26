##' init the project
##'
##' init the project
##' @title project initiation
##' @return nothing
##' @export 
##' @author Weilin Lin
##' 
utils.init <- function() {
## global setting
options(stringsAsFactors = FALSE);
ip <<- getIP();
DATA.DIR     <- p("http://",ip,":20000/");
YTM.DATA.DIR <- p("http://",ip,":20000/yieldCurve");
CB.DATA.DIR <- p("http://",ip,":20000/CB");

DATE.BUS.DATES <- lapply(c("CN"="CN"),
                         function(region)
                         {
                           inFile   <- p(DATA.DIR, "alpha/", tolower(region),"/busDate/busDates.csv");
                           busDates <- date.convert(read.table(inFile, header=TRUE)[,"busDate"]);
                         } )
## update busdate
save(DATE.BUS.DATES,file=paste(path.package("quantutils"),"data/DATE.BUS.DATES.rda",sep="/"));
load(paste(path.package("quantutils"),"data/DATE.BUS.DATES.rda",sep="/"), .GlobalEnv);
## update data path
save(DATA.DIR,YTM.DATA.DIR,CB.DATA.DIR,file=paste(path.package("datatools"),"data/DATA.DIR.rda",sep="/"));
load(paste(path.package("datatools"),"data/DATA.DIR.rda",sep="/"), .GlobalEnv);

## define database connection
DBChannel <<- dbConnect(MySQL(),username="root", password="cos123!@#", host=getIP() ,port=20001)

DBChannel.sigmaMacro <<- dbConnect(MySQL(), user="root",password="cos123!@#",dbname="Macro",host=ip, port=20001);
DBChannel.sigmaTF    <<- dbConnect(MySQL(), user="root",password="cos123!@#",dbname="bondFuture",host=ip, port=20001);
DBChannel.APE.TF     <<- dbConnect(MySQL(),dbname="bondFuture",username="bond", password="bond", host="42.121.108.236",port=3306);
DBChannel_APE<<- dbConnect(MySQL() ,host="42.121.108.236",user="bond",password="bond",port=3306);
}
