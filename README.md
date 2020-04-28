# ARIMA + GARCH hybrid time series analysis

### Run the project_code_complete.R with the datasets and get the results.

# Introduction

Financial years 2007-09 marked a watershed moment in the history of the world economy. Stock markets across the world with no exception tumbled down to historic lows. Investor sentiment was bleak, more than 50% of S&P 500 market capitalisation was wiped out during the 17 months long bear market (Yahoo Finance). Globally, companies lost more than $63 trillion in the same time (Roosevelt Institute, 2010). An unprecedented economic recession is being witnessed due to the rapidly changing COVID-19 situation. International Monetary Fund describes the COVID-19 induced recession to be more severe than the 2008 economic crisis. 
It is becoming increasing difficult for traders and retail investors to make non-negative returns from their investment bets. Tried and tested strategies like buy and hold give highly negative returns during these turbulent times making it imperative to devise an approach to circumvent this problem. Time-series analysis methods make use of historic information to quantify the trend, seasonality and noise in the information. Rapidly changing volatility of stock market returns requires the usage of Generalized Autoregressive Conditional Heteroskedasticity (GARCH) model and Autoregressive Integrated Moving Average model for improved prediction.
This project uses a combination of ARIMA and GARCH model to develop a short or long call for each day depending on the past scrip performance. Therefore, the empirical findings can serve as a guiding principle for retail investors to beat the market returns. This project details step by step procedure to build and use such a time-series model for S\&P  500 index share.


# Data and methodology

S&P 500 index prices were downloaded from Yahoo Finance. The dataset comprises of daily closing price, date and adjusted closing price. Differenced logarithmic returns of the "Closing Price" was calculated and NA values were removed. The data for this analysis is from 1st January 1995 till 24th April 2020. North American Free Trade Agreement (NAFTA), a major cornerstone of US economic history was signed on 1st January 1994. The starting date was set as 1st January 1995 to factor in the effects of this agreement on the US economy. The last date was kept as the latest date for which information was available. The aim was to capture the economic downturn associated with COVID-19 situation.

For each day, the previous k days of the differenced logarithmic returns of a stock market index will be used as a window for fitting an optimal ARIMA and GARCH model. The combined model was used to make a prediction for the next day returns. If the prediction is negative the stock is shorted at the previous close, while if it is positive it is longed. If the prediction is the same direction as the previous day then status quo is maintained.

Each trading day in the data is looped through to fit an appropriate ARIMA and GARCH model for the rolling window of length k. Value of k has been set as 500 for this project. Optimal value of p and q was selected for the ARMA model with lowest AIC score. The variance is modelled using the GARCH(1,1) model while the mean is modelled using ARMA(p,q) model. Fitting of ARMA+GARCH mode is done using ugarchfit command, which takes the specification, returns of S&P 500 share index and a numerical optimisation solver. The output for each date in the dataset is the prediction for the next day, expressed as +1 or -1. Predicted value was used to calculate the returns obtained from following the ARIMA + GARCH hybrid model by multiplying the forecast sign (+ or -) with the return itself.

# Discussion and conclusion

The period starting from the summer of 2007 when the economic crisis began, has consistently high levels of volatility as seen from figure 1. The period starting from the summer of 2007 when the economic crisis began, has consistently high levels of volatility. 

This tapers down gradually by 2019. Onset of the COVID-2019 crisis again increases the variance of returns as observed in this figure. Three local maxima can be observed in 2000, 2007 and 2019. The three stock-market high-points have been followed by massive economic shocks that lead to a bear run in the market. It can also be observed that the volume of shares traded is also at the highest level whenever there is a market crash. This phenomenon might be attributed to panic selling by retail investors who follow the sentiment conveyed by the news reports. Clearly, this situation presents a lucrative opportunity for traders who would guide their intuition using a more structured and quantitative approach as presented in this project.

Figure 2 depicts the comparative  returns realised from the Buy \& Hold strategy and the hybrid ARIMA + GARCH trading strategy. Clearly, it can be observed that the hybrid time-series model has outperformed the Buy \& Hold Strategy for majority of the time-period under consideration. The difference is more pronounced in a bear market, which has been demarcated using the green curve. Purchase of higher volume of shares coupled with lower prices will yield returns higher than the index itself.




