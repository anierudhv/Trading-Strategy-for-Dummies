install.packages("quantmod")
install.packages("lattice")
install.packages("timeSeries")
install.packages("rugarch")
library(quantmod)
library(lattice)
library(timeSeries)
library(rugarch)
library(timeSeries)
library(xts)
library(openair)

getSymbols("^GSPC", from="1995-01-01")
spReturns = diff(log(Cl(GSPC)))
spReturns[as.character(head(index(Cl(GSPC)),1))] = 0
candleChart(GSPC,multi.col=TRUE,theme="white")

windowLength = 500
foreLength = length(spReturns) - windowLength
forecasts <- vector(mode="character", length=foreLength)

for (d in 0:foreLength) {
  spReturnsOffset = spReturns[(1+d):(windowLength+d)]
  final.aic <- Inf
  final.order <- c(0,0,0)
  for (p in 0:5) for (q in 0:5) {
    if ( p == 0 && q == 0) {
      next
    }
    
    arimaFit = tryCatch( arima(spReturnsOffset, order=c(p, 0, q)),
                         error=function( err ) FALSE,
                         warning=function( err ) FALSE )
    
    if( !is.logical( arimaFit ) ) {
      current.aic <- AIC(arimaFit)
      if (current.aic < final.aic) {
        final.aic <- current.aic
        final.order <- c(p, 0, q)
        final.arima <- arima(spReturnsOffset, order=final.order)
      }
    } else {
      next
    }
  }
  spec = ugarchspec(
    variance.model=list(garchOrder=c(1,1)),
    mean.model=list(armaOrder=c(final.order[1], final.order[3]), include.mean=T),
    distribution.model="sged")
  
  fit = tryCatch(
    ugarchfit(
      spec, spReturnsOffset, solver = 'hybrid'
    ), error=function(e) e, warning=function(w) w
  )
  if(is(fit, "warning")) {
    forecasts[d+1] = paste(index(spReturnsOffset[windowLength]), 1, sep=",")
    print(paste(index(spReturnsOffset[windowLength]), 1, sep=","))
  } else {
    fore = ugarchforecast(fit, n.ahead=1)
    ind = fore@forecast$seriesFor
    forecasts[d+1] = paste(colnames(ind), ifelse(ind[1] < 0, -1, 1), sep=",")
    print(paste(colnames(ind), ifelse(ind[1] < 0, -1, 1), sep=",")) 
  }
}


write.csv(forecasts, file="forecasts_test.csv", row.names=FALSE)
write.csv(spReturns, file="spReturns.csv", row.names=FALSE)



data_test <- read.csv("forecasts_manual.csv")
date <- as.Date(as.character(data_test$Date), "%Y-%m-%d")
mcData <- xts(data_test$Prediction, date)
spIntersect <- merge(mcData,spReturns, join='inner')
spArimaGarchReturns = spIntersect[,1] * spIntersect[,2]


spArimaGarchCurve = log( cumprod( 1 + spArimaGarchReturns ) )
spBuyHoldCurve = log( cumprod( 1 + spIntersect[,2] ) )
spCombinedCurve = merge( spArimaGarchCurve, spBuyHoldCurve, all=F )

# Plot the equity curves for theentire range
xyplot( 
  spCombinedCurve,
  superpose=T,
  col=c("darkred", "darkblue"),
  lwd=2,
  key=list( 
    text=list(
      c("ARIMA+GARCH", "Buy & Hold")
    ),
    lines=list(
      lwd=2, col=c("darkred", "darkblue")
    )
  )
)


combined_returns <- data.frame(date=index(spCombinedCurve), coredata(spCombinedCurve))
write.csv(combined_returns, file="combined_returns.csv", row.names=FALSE)

returns_relevant <- selectByDate(combined_returns, start = "01/6/2007", end = "24/04/2020")
date <- as.Date(as.character(returns_relevant$date), "%Y-%m-%d")
mcData2 <- xts(returns_relevant$mcData, date)
spret2 <- xts(returns_relevant$GSPC.Close, date)
spIntersect2 <- merge(mcData2,spret2, join='inner')

# plot only since 2007
xyplot( 
  spIntersect2,
  superpose=T,
  col=c("darkred", "darkblue"),
  lwd=2,
  key=list( 
    text=list(
      c("ARIMA+GARCH", "Buy & Hold")
    ),
    lines=list(
      lwd=2, col=c("darkred", "darkblue")
    )
  )
)

