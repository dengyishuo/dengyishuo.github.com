\name{utils.readCSV}
\alias{utils.readCSV}
\title{read csv data}
\usage{
utils.readCSV(jtids = NULL, startDate, endDate, dataDir,
  filePrefix = "data", intervals = NULL, vars = NULL, shift = 0,
  region = NULL, verbose = FALSE, outClass = "data.frame",
  fileNameDelimiter = "_", source = "CSV", ...)
}
\arguments{
  \item{jtids}{symbols for stock or bonds}

  \item{startDate}{start Date for data}

  \item{endDate}{end Date for data}

  \item{dataDir}{Direcion for data}

  \item{filePrefix}{Prefix of file's name}

  \item{intervals}{intervals for data}

  \item{vars}{variables in data}

  \item{shift}{shift}

  \item{region}{region for data}

  \item{verbose}{logic}

  \item{outClass}{Class for result}

  \item{fileNameDelimiter}{file names}

  \item{...}{other parametres}
}
\value{
a data file
}
\description{
read csv data
}
\details{
read csv data
}
\author{
Weilin Lin
}

