
library(RSQLite)
library(tidyverse)
library(haven)
library(lubridate)
library(prodlim)

source("prepare_input_data.R")
source("read_parameter_files.R")
source("Assessment.R")
source("IndicatorSelectionSweden.R")


# Options for indicator calculations
nSimMC <- 1000
#number of Monte Carlo simulations


outputdbC<-"output/ekostat_C_BQI.db"


BQIlist<-c("WA80139110","WA23043276","WA63295529","WA69972288","WA79325467","WA82857164","WA98700208","WA51137015","WA55040263",
"WA51265873","WA38927215","WA96277013","WA24348954","WA18974073","WA12895460","WA70644789","WA35362374","WA23967996",
"WA11249942","WA88316659","WA13547710","WA19927154")


wblistC<-df_WB %>% 
  distinct(CLR,WB_ID,Type) %>%
  filter(CLR=="Coast") %>%
  filter(WB_ID %in% BQIlist)


#List of periods to be assessed from prepare_input_data.R

# dfc - coastal water measurements
# dfl - lake measurements
# dfr - river measurements

#--------------------------------------------------------------------------------------
ind<-df_indicators %>% 
  select(Indicator) %>%
  filter(!Indicator %in% c("RiverpHchange"))

ind<-paste0(ind$Indicator)
ind<-c("CoastBQI")

AssessmentMultiple(wblistC,df_periods,dfc,outputdbC,ind,df_bound,df_bound_WB,df_indicators,df_varcomp,df_var,nSimMC,bReplaceResults=T,logfile="log_C_BQI.txt",iStart=1)





