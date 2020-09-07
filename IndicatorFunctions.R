# AGGREGATION ROUTINES BASED ON MEASUREMENTS
# Aggregation principle used for e.g. coastal chlorophyll (over time points) and BQI (over obspoint)
# Aggregate over stations to yearly means then over years
Aggregate_year_station <- function(df) {
  yearmeans <- df %>%    group_by(year,Station) %>%
                         summarise(xvar = mean(xvar,na.rm = TRUE),.groups='drop') %>%
                         group_by(year) %>%
                         summarise(xvar = mean(xvar,na.rm = TRUE),.groups='drop')
                         
  periodmean <- mean(yearmeans$xvar)
  res <- list(periodmean=periodmean,yearmeans=yearmeans,error_code=0)
  return(res)
}

# Aggregation principle used for e.g. nutrients
# Aggregate over years and then period
Aggregate_year <- function(df) {
  yearmeans <- df %>% group_by(year) %>%
    summarise(xvar = mean(xvar,na.rm = TRUE),.groups='drop')
  
  periodmean <- mean(yearmeans$xvar)
  res <- list(periodmean=periodmean,yearmeans=yearmeans,error_code=0)
  return(res)
}
Min_year <- function(df) {
  yearmeans <- df %>% group_by(year) %>%
    summarise(xvar = min(xvar,na.rm = TRUE),.groups='drop')
  
  periodmean <- mean(yearmeans$xvar)
  res <- list(periodmean=periodmean,yearmeans=yearmeans,error_code=0)
  return(res)
}
Max_year <- function(df) {
  yearmeans <- df %>% group_by(year) %>%
    summarise(xvar = max(xvar,na.rm = TRUE),.groups='drop')
  
  periodmean <- mean(yearmeans$xvar)
  res <- list(periodmean=periodmean,yearmeans=yearmeans,error_code=0)
  return(res)
}


# Aggregation principle used for e.g. Secchi depth
# Aggregate over entire period
Aggregate_period <- function(df) {
  yearmeans <- df %>% group_by(year) %>%
    summarise(xvar = mean(xvar,na.rm = TRUE),.groups='drop')
  
  periodmean <- mean(df$xvar)
  res <- list(periodmean=periodmean,yearmeans=yearmeans,error_code=0)
  return(res)
}


# Aggregation principle used for pH change
# Aggregate over entire period and subtract RefCond
Aggregate_period_RC <- function(df) {
  yearmeans <- df %>% group_by(year) %>%
    summarise(xvar = mean(RefCond-xvar,na.rm = TRUE),.groups='drop')
  
  periodmean <- mean(df$RefCond-df$xvar)
  res <- list(periodmean=periodmean,yearmeans=yearmeans,error_code=0)
  return(res)
}

# AGGREGATION PRINCIPLES BASED ON EQR VALUES
# Aggregation principle used for e.g. biovolume in lakes
# Aggregate over entire period and then calculate EQR value
Aggregate_period_P_EQR <- function(df) {
  yearmeans <- df %>% group_by(year) %>%
    summarise(xvar = mean(RefCond,na.rm = TRUE)/mean(xvar,na.rm = TRUE),.groups='drop')
  
  periodmean <- mean(df$RefCond)/mean(df$xvar)
  res <- list(periodmean=periodmean,yearmeans=yearmeans,error_code=0)
  return(res)
}

# Aggregation principle used for e.g. biovolume in lakes
# Aggregate over entire period and then calculate EQR value
Aggregate_period_N_EQR <- function(df) {
  yearmeans <- df %>% group_by(year) %>%
    summarise(xvar = mean(xvar,na.rm = TRUE)/mean(RefCond,na.rm = TRUE),.groups='drop')
  
  periodmean <- mean(df$xvar)/mean(df$RefCond)
  res <- list(periodmean=periodmean,yearmeans=yearmeans,error_code=0)
  return(res)
}

# Aggregation principle used for lakes in remiss
# Aggregate over entire period and then calculate EQR value based on transformation (x-max)/(ref-max)
Aggregate_period_RefMax_EQR <- function(df) {
  yearmeans <- df %>% group_by(year) %>%
    summarise(xvar = (mean(xvar,na.rm = TRUE)-mean(MaxCond,na.rm = TRUE))/(mean(RefCond,na.rm = TRUE)-mean(MaxCond,na.rm = TRUE)),.groups='drop')
  
  periodmean <- (mean(df$xvar)-mean(df$MaxCond))/(mean(df$RefCond)-mean(df$MaxCond))
  res <- list(periodmean=periodmean,yearmeans=yearmeans,error_code=0)
  return(res)
}

# Aggregation principle used for lakes in remiss
# Aggregate over entire period and then calculate EQR value based on transformation (x-max)/(ref-max), truncation of values <0 and >1
Aggregate_period_RefMax_EQRtrunc <- function(df) {
  df <- mutate(df,xvarEQR = ifelse(RefCond<MaxCond,ifelse(xvar<RefCond,1,ifelse(xvar>MaxCond,0,(xvar-MaxCond)/(RefCond-MaxCond))),ifelse(xvar>RefCond,1,ifelse(xvar<MaxCond,0,(xvar-MaxCond)/(RefCond-MaxCond)))))
  yearmeans <- df %>% group_by(year) %>%
    summarise(xvar = (mean(xvarEQR,na.rm = TRUE)),.groups='drop')
  
  periodmean <- mean(df$xvarEQR)
  res <- list(periodmean=periodmean,yearmeans=yearmeans,error_code=0)
  return(res)
}

# Aggregation principle used for proportions with EQR calculation
# Aggregate over entire period and then calculate EQR value
Aggregate_period_Prop_EQR <- function(df) {
  yearmeans <- df %>% group_by(year) %>%
    summarise(xvar = (1-mean(xvar,na.rm = TRUE))/(1-mean(RefCond,na.rm = TRUE)),.groups='drop')

  periodmean <- (1-mean(df$xvar))/(1-mean(df$RefCond))
  res <- list(periodmean=periodmean,yearmeans=yearmeans,error_code=0)
  return(res)
}

# Aggregation principle used for proportions with EQR calculation
# Aggregate over entire period and then calculate EQR value
Aggregate_period_TPI_EQR <- function(df) {
  yearmeans <- df %>% group_by(year) %>%
    summarise(x = mean(xvar,na.rm = TRUE),r50 = mean(RefCond),r75 = mean(HG_boundary),xvar = (r75-r50)/(x+r75-2*r50),.groups='drop')
  yearmeans <- yearmeans %>% mutate(x = NULL,r50 = NULL, r75 = NULL)
  
  r50 = mean(df$RefCond)
  r75 = mean(df$HG_boundary)
  periodmean <- (r75-r50)/(mean(df$xvar)+r75-2*r50)
  
  res <- list(periodmean=periodmean,yearmeans=yearmeans,error_code=0)
  return(res)
}


# AGGREGATION PRINCIPLES BASED ON EQR OBSERVATIONS
# Aggregation principle used for e.g. coastal chlorophyll as EQR
# Compute EQR values and then aggregate over stations, years and period
AggregateEQRtrunc_year_station <- function(df) {
  
  df <- mutate(df,xvarEQR = ifelse(xvar<RefCond,1,RefCond/xvar))

  yearmeans <- df %>%    group_by(year,Station) %>%
    summarise(xvarEQR = mean(xvarEQR,na.rm = TRUE),.groups='drop') %>%
    group_by(year) %>%
    summarise(xvar = mean(xvarEQR,na.rm = TRUE),.groups='drop')   # should be returned in xvar
  
  periodmean <- mean(yearmeans$xvar)
  res <- list(periodmean=periodmean,yearmeans=yearmeans,error_code=0)
  return(res)  
}

# Aggregation principle used for e.g. nutrients as EQR
# Aggregate over years and then period
AggregateEQR_year <- function(df) {
  
  df <- mutate(df,xvarEQR = RefCond/xvar)
  
  yearmeans <- df %>% group_by(year) %>%
    summarise(xvar = mean(xvarEQR,na.rm = TRUE),.groups='drop')   # should be returned in xvar
  
  periodmean <- mean(yearmeans$xvar)
  res <- list(periodmean=periodmean,yearmeans=yearmeans,error_code=0)
  return(res)  
}
MaxEQR_year <- function(df) {
  
  df <- mutate(df,xvarEQR = RefCond/xvar)
  
  yearmeans <- df %>% group_by(year) %>%
    summarise(xvar = max(xvarEQR,na.rm = TRUE),.groups='drop')   # should be returned in xvar
  
  periodmean <- mean(yearmeans$xvar)
  res <- list(periodmean=periodmean,yearmeans=yearmeans,error_code=0)
  return(res)  
}

# Aggregate over entire period
# Indicator response positive to degradation, i.e. chlorophyll
AggregateEQR_P_period <- function(df) {
  
  df <- mutate(df,xvarEQR = RefCond/xvar)
  
  yearmeans <- df %>% group_by(year) %>%
    summarise(xvar = mean(xvarEQR,na.rm = TRUE),.groups='drop')   # should be returned in xvar
  
  periodmean <- mean(df$xvarEQR)
  res <- list(periodmean=periodmean,yearmeans=yearmeans,error_code=0)
  return(res)  
}

# Aggregate over entire period
# Indicator response negative to degradation, i.e. Secchi depth
AggregateEQR_N_period <- function(df) {
  
  df <- mutate(df,xvarEQR = xvar/RefCond)
  
  yearmeans <- df %>% group_by(year) %>%
    summarise(xvar = mean(xvarEQR,na.rm = TRUE),.groups='drop')   # should be returned in xvar
  
  periodmean <- mean(df$xvarEQR)
  res <- list(periodmean=periodmean,yearmeans=yearmeans,error_code=0)
  return(res)  
}

# Aggregate over entire period with truncation of values above 1
# Indicator response negative to degradation, e.g. LakeFishAindexW5 and LakeFishEindexW3
AggregateEQRtrunc_N_period <- function(df) {
  
  df <- mutate(df,xvarEQR = ifelse(xvar>RefCond,1,xvar/RefCond))
  
  yearmeans <- df %>% group_by(year) %>%
    summarise(xvar = mean(xvarEQR,na.rm = TRUE),.groups='drop')   # should be returned in xvar
  
  periodmean <- mean(df$xvarEQR)
  res <- list(periodmean=periodmean,yearmeans=yearmeans,error_code=0)
  return(res)  
}

# SPECIAL CASES FOR COASTAL INDICATORS
# Calculation of BQI indicator according to Handbook
BQIbootstrap <- function(df) {
  error_code <- 0
  yearstatmeans <- df %>%    group_by(year,station) %>%
    summarise(xvar = mean(xvar,na.rm = TRUE),.groups='drop')
  Nyearstat <- yearstatmeans %>% group_by(year) %>% summarise(n_station = length(xvar),.groups='drop')
  # Check if fewer than 5 stations and years - error_code=-93
  if (sum(Nyearstat$n_station)<5) error_code <- -93
  BQIsimyear <- mat.or.vec(length(Nyearstat$n_station),9999)
  BQIsimperiod <- mat.or.vec(9999,1)
  for (isim in 1:9999) {
    for(i in 1:length(Nyearstat$n_station)) {
      BQIsim <- trunc(runif(Nyearstat$n_station[i],1,Nyearstat$n_station[i]+1))
      BQIsim <- yearstatmeans$xvar[yearstatmeans$year == Nyearstat$year[i]][BQIsim]
      BQIsimyear[i,isim] <- mean(BQIsim)
    }
    BQIsimperiod[isim] <- mean(BQIsimyear[,isim])
  }
  periodmean <- quantile(BQIsimperiod,probs=0.2)
  yearmeans <- data.frame(year=Nyearstat$year,xvar = apply(BQIsimyear,1,quantile,probs=0.2,na.rm=TRUE))
  res <- list(periodmean=periodmean,yearmeans=yearmeans,error_code=error_code)
  return(res)  
}

# Oxygen in bottom water - calculate lower quartile
OxygenLowerQuartile <- function(df) {
  yearmeans <- df %>% group_by(year) %>%
    summarise(xvar = quantile(xvar,probs=c(0.25),na.rm = TRUE),.groups='drop')
  
  periodmean <- mean(yearmeans$xvar)
  res <- list(periodmean=periodmean,yearmeans=yearmeans,error_code=0)
  return(res)
}








