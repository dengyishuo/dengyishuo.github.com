function (x) 
{
  half <- function(N) sort(c(N, N[-length(N)] + ((diff(N) + 1)%/%2)))
  rscalc <- function(x) {
    n <- length(x)
    y <- cumsum(x - mean(x))
    R <- diff(range(y))
    S <- sd(x)
    return(R/S)
  }
  X <- c(length(x))
  Y <- c(rscalc(x))
  N <- c(0, length(x)%/%2, length(x))
  while (min(diff(N)) >= 8) {
    xl <- c()
    yl <- c()
    for (i in 2:length(N)) {
      rs <- rscalc(x[(N[i - 1] + 1):N[i]])
      xl <- c(xl, N[i] - N[i - 1])
      yl <- c(yl, rs)
    }
    X <- c(X, mean(xl))
    Y <- c(Y, mean(yl))
    N <- half(N)
  }
  rs_lm <- lm(log(Y) ~ log(X))
  return(unname(coefficients(rs_lm)[2]))
}
