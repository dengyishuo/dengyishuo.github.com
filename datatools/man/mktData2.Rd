\name{mktData2}
\alias{mktData2}
\title{Read data from our server}
\usage{
  mktData2(startDate, endDate = startDate, jtids = NULL,
    vars = NULL, region = "CN", ...)
}
\arguments{
  \item{startDate}{The startDate of Data}

  \item{endDate}{The endDate of Data}

  \item{jtids}{symbols}

  \item{vars}{variables in data}

  \item{region}{region for data}

  \item{...}{other parametres}
}
\value{
  An OHLC files
}
\description{
  Read data from our server
}
\details{
  Read market data of A share and HK market stock data from
  server
}
\author{
  Yishuo Deng
}

