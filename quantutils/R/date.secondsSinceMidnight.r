##' seconds from midnight
##'
##' seconds from midnight
##' @title seconds from midnight
##' @param timeOrTimeString 
##' @return date string
##' @export
##' @author Weilin Lin
date.secondsSinceMidnight <- function(timeOrTimeString)
{
  if(class(timeOrTimeString) == "character" || class(timeOrTimeString) == "factor")
    {
      timeOrTimeString <- as.character(timeOrTimeString);
      if(all(regexpr("^[0-9][0-9]:[0-9][0-9]:[0-9][0-9]$", timeOrTimeString) != -1))
        {
          hh <- as.integer(substring(timeOrTimeString,1,2));
          mm <- as.integer(substring(timeOrTimeString,4,5));
          ss <- as.integer(substring(timeOrTimeString,7,8));
          return(hh* 3600 + mm*60 + ss);
        }
    }

  timeOrTimeString <- as.POSIXlt(date.convert(timeOrTimeString));
  return(timeOrTimeString$hour * 3600 + timeOrTimeString$min * 60 + timeOrTimeString$sec);
}
