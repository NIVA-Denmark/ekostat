
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


outputdbC<-"output/ekostat_C.db"
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

#List of periods to be assessed

# dfc - coastal water measurements
# dfl - lake measurements
# dfr - river measurements

#--------------------------------------------------------------------------------------
ind<-df_indicators %>% 
  select(Indicator) %>%
  filter(!Indicator %in% c("RiverpHchange"))

ind<-paste0(ind$Indicator)


AssessmentMultiple(wblistC,df_periods,dfc,outputdbC,ind,df_bound,df_bound_WB,df_indicators,df_varcomp,df_var,nSimMC,bReplaceResults=F,logfile="log_C.txt",iStart=1)
AssessmentMultiple(wblistL,df_periods,dfl,outputdbL,ind,df_bound,df_bound_WB,df_indicators,df_varcomp,df_var,nSimMC,bReplaceResults=T,logfile="log_L.txt")
AssessmentMultiple(wblistR,df_periods,dfr,outputdbR,ind,df_bound,df_bound_WB,df_indicators,df_varcomp,df_var,nSimMC,bReplaceResults=T,logfile="log_R.txt")





