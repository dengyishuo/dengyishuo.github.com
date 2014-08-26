\name{keyMap}
\alias{keyMap}
\title{Stock keyMap function}
\usage{
keyMap(keys, inputKeyType = "JTID", outputKeyType = "InnerCode", region,
  keyMapFile = NULL)
}
\arguments{
  \item{keys}{the input key values for mapping}

  \item{inputKeyType}{specified which kind of keys of
  input}

  \item{outputKeyType}{specify the type of output keys}

  \item{region}{shoud be equal to "CN" or "HK"}

  \item{keyMapFile}{unused argument}
}
\value{
return keys vector specified by the outputKeyType
}
\description{
KeyMap function to Map between different stock tickers
}
\details{
Support JTID,windID etc
}
\author{
Weilin Lin
}

