\name{df.compareDfs}
\alias{df.compareDfs}
\title{compare two data frame and return their compareStats}
\usage{
df.compareDfs(df.x, df.y, mergeBy, suffixes = c(".x", ".y"), tol = 1e-04,
  data = FALSE, absoluteTol = TRUE)
}
\arguments{
  \item{df.x}{data frame}

  \item{df.y}{data frame}

  \item{mergeBy}{an variable in data frame used when merge
  df.x and df.y}

  \item{suffixes}{suffixes}

  \item{tol}{tolorence}

  \item{data}{logical}

  \item{absoluteTol}{logical}
}
\value{
a list
}
\description{
compare two data frame and return their compareStats
}
\details{
compare two data frame and return their compareStats
}
\examples{
df.x=as.data.frame(matrix(round(rnorm(12),2),3,4));df.y=as.data.frame(matrix(round(rnorm(12),2),3,4));df.y[,1]=df.x[,1];df.y[1,]=df.x[1,];df.compareDfs(df.x,df.y,mergeBy="V1")
}
\author{
Weilin Lin
}

