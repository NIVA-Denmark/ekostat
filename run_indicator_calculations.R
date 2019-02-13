
library(RSQLite)
library(tidyverse)
library(haven)
library(lubridate)

source("prepare_input_data.R")
source("read_parameter_files.R")
source("Assessment.R")


# Options for indicator calculations
nSimMC <- 3  #1000 #number of Monte Carlo simulations

# 
start_time <- Sys.time()

outputdb<-"output/test.db"

# dfc - coastal water measurements
# dfl - lake measurements
# dfr - river measurements

#--------------------------------------------------------------------------------------
ind<-df_indicators %>% filter(Water_type=="Coastal") %>% select(Indicator)
ind<-paste0(ind$Indicator)

#AssessmentMultiple(dfc,outputdb,IndList=ind,df_bounds,df_bounds_hypox,df_bathy,df_indicators,df_variances,bReplaceResults=T)
AssessmentMultiple(dfc,outputdb,ind,df.bounds,df.bounds.hypox,df.bathy,df.indicators,df.variances,bReplaceResults=T)
AssessmentMultiple(dfl,outputdb,ind,df.bounds,df.bounds.hypox,df.bathy,df.indicators,df.variances,bReplaceResults=T)
AssessmentMultiple(dfr,outputdb,ind,df.bounds,df.bounds.hypox,df.bathy,df.indicators,df.variances,bReplaceResults=T)

  

