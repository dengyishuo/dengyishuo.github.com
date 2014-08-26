##' data frame to SQL conversion
##'
##' Convert data frame to SQL for insert
##' @title data frame to SQL insert query
##' @param data data frame
##' @param dbname database to insert
##' @return SQL string
##' @export
##' @author Weilin Lin
##' 
df.dfToSQL <- function(data, dbname){
  strLst <- list();  
  for(i in 1:nrow(data)){
    data[i,sapply(data[i,], class)=="character"] <- p("'",data[i,sapply(data[i,], class)=="character"],"'");
    strLst[[i]] <- p("(",p(data[i,], collapse=","),")");
    strLst[[i]] <- gsub('NA','NULL',strLst[[i]]);
    strLst[[i]] <- gsub('NaN','NULL',strLst[[i]]);
    strLst[[i]] <- gsub('Inf','NULL',strLst[[i]]);
  }
  dataStr <- p(strLst, collapse=",");      
  sqlStr <- p("INSERT INTO ", dbname, "(",p(colnames(data), collapse=","),")",
            " VALUES ", dataStr);
  return(sqlStr);
}
