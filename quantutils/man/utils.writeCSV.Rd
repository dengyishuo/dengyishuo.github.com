\name{utils.writeCSV}
\alias{utils.writeCSV}
\title{write an SDIV array or data.frame to daily CSV files to outDir/filePrefixYYYYMMDD.csv}
\usage{
utils.writeCSV(data, outDir, filePrefix = "data", startDate = NULL,
  endDate = NULL, vars = NULL, shift = 0, region = NULL,
  verbose = FALSE, quote = FALSE, row.names = FALSE,
  fileNameDelimiter = "_", ...)
}
\arguments{
  \item{data}{Data}

  \item{outDir}{out Direction}

  \item{filePrefix}{Prefix of files when write out datas}

  \item{startDate}{The start Date of data}

  \item{endDate}{The end Date of data}

  \item{vars}{Variables in data}

  \item{shift}{shift the date forward or backward n
  business days (e.g, if the data$date is 20090601, shift =
  1, then shift data$date to 20090602 and then write to
  filePrefix20090602.csv}

  \item{region}{The region of data}

  \item{verbose}{Logical}

  \item{quote}{Logical}

  \item{row.names}{Logical}

  \item{fileNameDelimiter}{Delimiter of file names}

  \item{...}{are the extra arguments from write.table()
  function (e.g. quote=FALSE,row.names=FALSE)}
}
\value{
null
}
\description{
write an SDIV array or data.frame to daily CSV files to
outDir/filePrefixYYYYMMDD.csv
}
\details{
write an SDIV array or data.frame to daily CSV files to
outDir/filePrefixYYYYMMDD.csv
}
\author{
Weilin Lin
}

