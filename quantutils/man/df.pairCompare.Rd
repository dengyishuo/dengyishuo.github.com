\name{df.pairCompare}
\alias{df.pairCompare}
\title{compare every pair of the column of data frame}
\usage{
df.pairCompare(df, vars, tol = 1e-04, suffixes = c(".x", ".y"),
  absoluteTol = TRUE)
}
\arguments{
  \item{df}{data frame}

  \item{vars}{variables in data frame}

  \item{tol}{tolerence}

  \item{suffixes}{suffixes}

  \item{absoluteTol}{absolute tolerence}
}
\value{
x
}
\description{
compare every pair of the column of data frame
}
\details{
compare every pair of the column of data frame,can not be
explicit called
}
\examples{
pairCompareResults <- df.pairCompare(df,  c("V2","V3","V4","in"),  tol = 1e-04, suffixes = c(".x", ".y"), absoluteTol = TRUE)
}
\author{
Weilin Lin
}

