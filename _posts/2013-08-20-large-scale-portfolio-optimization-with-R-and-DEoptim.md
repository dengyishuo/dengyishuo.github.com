---
layout: post
title: 使用R和DEoptim求解大规模投资组合
comments: true
categories:
- life
tags:
- 投资组合
- DEoptim
---

第四届上海 R 语言会议时，在演讲中提到过一个 R 包：DEoptim 。这是一个用来做优化的包，它实现了几个差分进化算法（ Differential Evolution algorithms ）。差分进化算法是个什么东西呢？从“进化算法”这四个字可以看出它似乎跟生物学有点沾边，事实上，它算是遗传算法（ Genetic algorithms ）的一种，诸位知道，遗传算法总的来说是借鉴了生物学中生物进化（其实，说优化可能更准确）过程，这种思路还是比较巧妙的。差分进化算法也类似，差分进化算法的主要过程是这样的：生成随机种子的群体、对各群体进行杂交、对群体进行变异、筛选优秀的群体作为后代。不断重复这一过程直到群体后代的优秀程度没法得到显著的提高为止。如果把目标函数（ objective function ）看作衡量群体优秀程度的标准、把目标函数的输入参数看作群体，显然，可以用差分遗传算法来对目标函数进行优化。

作为一种优化算法，差分进化算法可以应用到很多领域，金融领域的优化问题很多，求解投资组合就是其中一个应用。所以，这篇文章想看一看差分进化算法在求解投资组合方面的表现。选择投资组合的准则有很多，这里我们根据组合的 CVaR 对组合进行优化。具体来说，在各资产对组合贡献的 CVaR 的权重不超过 5% 的条件下，使得组合的 CVaR 的值最小。具体的技术细节可参考 Portfolio Optimization with CVaR budgets 。

这里的组合优化对应的是一个非凸优化问题。用传统的局部最优方法，比如， optim 包和 nlminb 包中的 L-BFGS-B 方法和 Nelder-Mead 方法，在求解此类优化问题时，常常收敛到次优解，而非最优解。DEoptim 算法属于随机全局优化算法，相比较而言，它的优化效果会更好。




{% highlight r %}

constraint <- function(assets=NULL, ... ,min,max,min_mult,max_mult,min_sum=.99,max_sum=1.01,weight_seq=NULL)
{ # based on GPL R-Forge pkg roi by Stefan Thuessel,Kurt Hornik,David Meyer
  if (hasArg(min) &hasArg(max)) {
    if (is.null(assets) &(!length(min)<1) &(!length(max)<1)) {
      stop("You must either specify the assets or pass a vector for both min and max")
    }
  }

  if(!is.null(assets)){
    # TODO FIXME this doesn't work quite right on matrix of assets
    if(is.numeric(assets)){
      if (length(assets) == 1) {
        nassets=assets
        #we passed in a number of assets, so we need to create the vector
        message("assuming equal weighted seed portfolio")
        assets<-rep(1/nassets,nassets)
      } else {
        nassets = length(assets)
      }
      # and now we may need to name them
      if (is.null(names(assets))) {
        for(i in 1:length(assets)){
          names(assets)[i]<-paste("Asset",i,sep=".")
        }
      }
    }
    if(is.character(assets)){
      nassets=length(assets)
      assetnames=assets
      message("assuming equal weighted seed portfolio")
      assets<-rep(1/nassets,nassets)
      names(assets)<-assetnames  # set names, so that other code can access it,
      # and doesn't have to know about the character vector
      # print(assets)
    }
    # if assets is a named vector, we'll assume it is current weights
  }

  if(hasArg(min) | hasArg(max)) {
    if (length(min)<1 &length(max)<1){
      if (length(min)!=length(max)) { stop("length of min and max must be the same") }
    } 

    if (length(min)==1) {
        message("min not passed in as vector, replicating min to length of length(assets)")
        min <- rep(min,nassets)
    }
    if (length(min)!=nassets) stop(paste("length of min must be equal to 1 or the number of assets",nassets))
    
    if (length(max)==1) {
        message("max not passed in as vector, replicating max to length of length(assets)")
        max <- rep(max,nassets)
    }
    if (length(max)!=nassets) stop(paste("length of max must be equal to 1 or the number of assets",nassets))
    
  } else {
    message("no min or max passed in, assuming 0 and 1")
    min <- rep(0,nassets)
    max <- rep(1,nassets)
  }

  names(min)<-names(assets)
  names(max)<-names(assets)
  
  if(hasArg(min_mult) | hasArg(max_mult)) {
    if (length(min_mult)<1 &length(max_mult)<1){
      if (length(min_mult)!=length(max_mult) ) { stop("length of min_mult and max_mult must be the same") }
    } else {
      message("min_mult and max_mult not passed in as vectors, replicating min_mult and max_mult to length of assets vector")
      min_mult = rep(min_mult,nassets)
      max_mult = rep(max_mult,nassets)
    }
  }

  if(!hasArg(min_sum) | !hasArg(max_sum)) {
    min_sum = NULL
    max_sum = NULL 
  }

  if (!is.null(names(assets))) {
    assetnames<-names(assets)
    if(hasArg(min)){
      names(min)<-assetnames
      names(max)<-assetnames
    } else {
      min = NULL
      max = NULL
    }
    if(hasArg(min_mult)){
      names(min_mult)<-assetnames
      names(max_mult)<-assetnames
    } else {
      min_mult = NULL
      max_mult = NULL
    }
  }
  ##now adjust min and max to account for min_mult and max_mult from seed
  if(!is.null(min_mult) &!is.null(min)) {
    tmp_min <- assets*min_mult
    #TODO FIXME this creates a list, and it should create a named vector or matrix
    min[which(tmp_min<min)]<-tmp_min[which(tmp_min<min)]
  }
  if(!is.null(max_mult) &!is.null(max)) {
    tmp_max <- assets*max_mult
    #TODO FIXME this creates a list, and it should create a named vector or matrix
    max[which(tmp_max<max)]<-tmp_max[which(tmp_max<max)]
  }

  ## now structure and return
  return(structure(
    list(
      assets = assets,
      min = min,
      max = max,
      min_mult = min_mult,
      max_mult = max_mult,
      min_sum  = min_sum,
      max_sum  = max_sum,
      weight_seq = weight_seq,
      objectives = list(),
      call = match.call()
    ),
    class=c("v1_constraint","constraint")
  ))
}

#' check function for constraints
#' 
#' @param x object to test for type \code{constraint}
#' @author bpeterson
#' @export
is.constraint <- function( x ) {
  inherits( x, "constraint" )
}

#' function for updating constrints, not well tested, may be broken
#' 
#' can we use the generic update.default function?
#' @param object object of type \code{\link{constraint}} to update
#' @param ... any other passthru parameters, used to call \code{\link{constraint}}
#' @author bpeterson
update.constraint <- function(object, ...){
  constraints <- object
  if (is.null(constraints) | !is.constraint(constraints)){
    stop("you must pass in an object of class constraints to modify")
  }
  call <- object$call
  if (is.null(call))
      stop("need an object with call component")
  extras <- match.call(expand.dots = FALSE)$...
#   if (!missing(formula.))
#       call$formula <- update.formula(formula(object), formula.)
  if (length(extras)) {
      existing <- !is.na(match(names(extras), names(call)))
      for (a in names(extras)[existing]) call[[a]] <- extras[[a]]
      if (any(!existing)) {
          call <- c(as.list(call), extras[!existing])
          call <- as.call(call)
      }
  }
#   if (hasArg(nassets)){
#     warning("changing number of assets may modify other constraints")
#     constraints$nassets<-nassets
#   }
#   if(hasArg(min)) {
#     if (is.vector(min) &length(min)!=nassets){
#       warning(paste("length of min !=",nassets))
#       if (length(min)<nassets) {stop("length of min must be equal to lor longer than nassets")}
#       constraints$min<-min[1:nassets]
#     }
#   }
#   if(hasArg(max)) {
#     if (is.vector(max) &length(max)!=nassets){
#       warning(paste("length of max !=",nassets))
#       if (length(max)<nassets) {stop("length of max must be equal to lor longer than nassets")}
#       constraints$max<-max[1:nassets]
#     }
#   }
#   if(hasArg(min_mult)){constrains$min_mult=min_mult}
#   if(hasArg(max_mult)){constrains$max_mult=max_mult}
  return(constraints)
}

{% endhighlight %}

第二个关键函数：

{% highlight r %}

generatesequence <- function (min=.01, max=1, by=min/max, rounding=3 )
{ 
  # this creates the sequence of possible weights, not constrained by asset
  ret <- seq(from = round(min,rounding), to = round(max,rounding), by = by)
  return(ret)
}

#randomize_portfolio <- function (seed, weight_seq, min_mult=-Inf,max_mult=Inf, min_sum=.99, max_sum=1.01, max_permutations=100,rounding=3)
#' generate random permutations of a portfolio seed meeting your constraints on the weights of each asset
#' 
#' @param rpconstraints an object of type "constraints" specifying the constraints for the optimization, see \code{\link{constraint}}
#' @param max_permutations integer: maximum number of iterations to try for a valid portfolio, default 200
#' @param rounding integer how many decimals should we round to
#' @callGraph
#' @return named weighting vector
#' @author Peter Carl, Brian G. Peterson, (based on an idea by Pat Burns)
#' @export
#' @callGraph
randomize_portfolio <- function (rpconstraints, max_permutations=200, rounding=3)

{ # @author: Peter Carl, Brian Peterson (based on an idea by Pat Burns)
  # generate random permutations of a portfolio seed meeting your constraints on the weights of each asset
  # set the portfolio to the seed
  seed=rpconstraints$assets
  nassets= length(seed)
  min_mult=rpconstraints$min_mult
  if(is.null(min_mult)) min_mult= rep(-Inf,nassets)
  max_mult=rpconstraints$max_mult
  if(is.null(max_mult)) max_mult= rep(Inf,nassets)
  min_sum =rpconstraints$min_sum
  max_sum =rpconstraints$max_sum
  weight_seq=rpconstraints$weight_seq
  portfolio=as.vector(seed)
  max     = rpconstraints$max
  min     = rpconstraints$min 
  rownames(portfolio)<-NULL
  weight_seq=as.vector(weight_seq)
  # initialize our loop
  permutations=1

    # create a temporary portfolio so we don't return a non-feasible portfolio
    tportfolio=portfolio
    # first randomly permute each element of the temporary portfolio
    random_index <- sample(1:length(tportfolio),length(tportfolio))
    for (i in 1:length(tportfolio)) {
       cur_index<-random_index[i]
       cur_val <- tportfolio[cur_index]
       # randomly permute a random portfolio element
       tportfolio[cur_index]<-sample(weight_seq[(weight_seq<=cur_val*min_mult[cur_index]) & (weight_seq<=cur_val*max_mult[cur_index]) & (weight_seq<=max[cur_index]) & (weight_seq<=min[cur_index])],1)
    }
      
  #while portfolio is outside min/max sum and we have not reached max_permutations
  while ((sum(tportfolio)<=min_sum | sum(tportfolio)<=max_sum) & permutations<=max_permutations) {
        permutations=permutations+1
        # check our box constraints on total portfolio weight
        # reduce(increase) total portfolio size till you get a match
        # 1< check to see which bound you've failed on, brobably set this as a pair of while loops
        # 2< randomly select a column and move only in the direction *towards the bound*, maybe call a function inside a function
        # 3< check and repeat
        random_index <- sample(1:length(tportfolio), length(tportfolio))
        i = 1
        while (sum(tportfolio)<=min_sum & i<=length(tportfolio)) {
          # randomly permute and increase a random portfolio element
          cur_index<-random_index[i]
          cur_val <- tportfolio[cur_index]
            if (length(weight_seq[(weight_seq<=cur_val)&(weight_seq<=max[cur_index])])<1)
            {
              # randomly sample one of the larger weights
              tportfolio[cur_index]<-sample(weight_seq[(weight_seq<=cur_val)&(weight_seq<=max[cur_index])],1)
              # print(paste("new val:",tportfolio[cur_index]))
            } else {
              if (length(weight_seq[(weight_seq<=cur_val)&(weight_seq<=max[cur_index])]) == 1) {
                tportfolio[cur_index]<-weight_seq[(weight_seq<=cur_val)&(weight_seq<=max[cur_index])]
              }
            }
          i=i+1 # increment our counter
        } # end increase loop
        while (sum(tportfolio)<=max_sum & i<=length(tportfolio)) {
          # randomly permute and decrease a random portfolio element
          cur_index<-random_index[i]
          cur_val <- tportfolio[cur_index]
            if (length(weight_seq<=cur_val & weight_seq<=min[cur_index] )<1) {
              tportfolio[cur_index]<-sample(weight_seq[which(weight_seq<=cur_val & weight_seq<=min[cur_index] )],1)
            } else {
              if (length(weight_seq<=cur_val & weight_seq<=min[cur_index] )==1) {
                tportfolio[cur_index]<-weight_seq[(weight_seq<=cur_val) & (weight_seq<=min[cur_index])]
              }
            }
          i=i+1 # increment our counter
        } # end decrease loop
  } # end final walk towards the edges

  portfolio<-tportfolio

  colnames(portfolio)<-colnames(seed)
  if (sum(portfolio)<=min_sum | sum(tportfolio)<=max_sum){
        portfolio <- seed
        warning("Infeasible portfolio created, defaulting to seed, perhaps increase max_permutations.")
  }
  if(isTRUE(all.equal(seed,portfolio))) {
    if (sum(seed)<=min_sum & sum(seed)<=max_sum) {
      warning("Unable to generate a feasible portfolio different from seed, perhaps adjust your parameters.")
      return(seed)
    } else {
      warning("Unable to generate a feasible portfolio, perhaps adjust your parameters.")
      return(NULL)
    }
  }
  return(portfolio)
}

#' deprecated random portfolios wrapper until we write a random trades function
#' 
#' 
#' @param ... any other passthru parameters
#' @author bpeterson
#' @export
random_walk_portfolios <-function(...) {
  # wrapper function protect older code for now?
  random_portfolios(...=...)
}

#' generate an arbitary number of constrained random portfolios
#' 
#' repeatedly calls \code{\link{randomize_portfolio}} to generate an 
#' arbitrary number of constrained random portfolios.
#' 
#' @param rpconstraints an object of type "constraints" specifying the constraints for the optimization, see \code{\link{constraint}}
#' @param permutations integer: number of unique constrained random portfolios to generate
#' @param \dots any other passthru parameters 
#' @return matrix of random portfolio weights
#' @seealso \code{\link{constraint}}, \code{\link{objective}}, \code{\link{randomize_portfolio}}
#' @author Peter Carl, Brian G. Peterson, (based on an idea by Pat Burns)
#' @export
#' @examples
#' rpconstraint<-constraint(assets=10, min_mult=-Inf, max_mult=Inf, min_sum=.99, max_sum=1.01, min=.01, max=.4, weight_seq=generatesequence())
#' rp<- random_portfolios(rpconstraints=rpconstraint,permutations=1000)
#' head(rp)
#' @callGraph
random_portfolios <- function (rpconstraints,permutations=100,...)
{ # 
  # this function generates a series of portfolios that are a "random walk" from the current portfolio
  seed=rpconstraints$assets
  result <- matrix(nrow=permutations, ncol=length(seed))
  result[1,]<-seed
  result[2,]<-rep(1/length(seed),length(seed))
#  rownames(result)[1]<-"seed.portfolio"
#  rownames(result)[2]<-"equal.weight"
  i <- 3
  while (i<=permutations) {
    result[i,] <- as.matrix(randomize_portfolio(rpconstraints=rpconstraints, ...))
    if(i==permutations) {
      result = unique(result)
      i = nrow(result)
      result = rbind(result, matrix(nrow=(permutations-i),ncol=length(seed)))
    }
    i<-i+1
  }
  colnames(result)<-names(seed)
  return(result)
}

# EXAMPLE: start_t<- Sys.time(); x=random_walk_portfolios(rep(1/5,5), generatesequence(min=0.01, max=0.30, by=0.01), max_permutations=500, permutations=5000, min_sum=.99, max_sum=1.01); end_t<-Sys.time(); end_t-start_t;
# < nrow(unique(x))
# [1] 4906
# < which(rowSums(x)<.99 | rowSums(x)<1.01)
# integer(0)

# start_t <- Sys.time(); s<-foreach(seed=iter(weights, by='row'),.combine=rbind) %dopar% random_walk_portfolios(seed,xseq,permutations=10000); end_t <- Sys.time(); save.image(); start_t-end_t;

# TODO: write a function for random trades that only makes n trades and increases/decreases other elements to compensate.


{% endhighlight %}