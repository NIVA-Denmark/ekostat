
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
nSimMC <- 3
#number of Monte Carlo simulations


outputdbC<-"output/ekostat_C_count.db"
outputdbL<-"output/ekostat_L.db"
outputdbR<-"output/ekostat_R.db"


wblistC<-df_WB %>% 
  distinct(CLR,WB_ID,Type) %>%
  filter(CLR=="Coast")
  
  wblistL<-df_WB %>% 
  distinct(CLR,WB_ID,Type) %>%
  filter(CLR=="Lake") 

wblistR<-df_WB %>% 
  distinct(CLR,WB_ID,Type) %>%
  filter(CLR=="River") 

#List of periods to be assessed from prepare_input_data.R

# dfc - coastal water measurements
# dfl - lake measurements
# dfr - river measurements

#--------------------------------------------------------------------------------------
ind<-df_indicators %>% 
  select(Indicator) %>%
  filter(!Indicator %in% c("RiverpHchange"))

ind<-paste0(ind$Indicator)

AssessmentMultiple(wblistC,df_periods,dfc,outputdbC,ind,df_bound,df_bound_WB,df_indicators,df_varcomp,df_var,nSimMC,bReplaceResults=T,logfile="log_C_obs_count.txt")





