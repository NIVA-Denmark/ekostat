
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


outputdbC<-"output/ekostat_C_WA86698934.db"
outputdbL<-"output/ekostat_L.db"
outputdbR<-"output/ekostat_R.db"


wblistC<-df_WB %>% 
  distinct(CLR,WB_ID,Type) %>%
  filter(CLR=="Coast") %>%
  filter(WB_ID=="WA86698934")


#List of periods to be assessed from prepare_input_data.R

# dfc - coastal water measurements
dfc <- dfc %>%
  filter(WB_ID=="WA86698934") %>%
  filter(station!="HÖ3 / ÖGERBOFJÄRDEN")

#--------------------------------------------------------------------------------------
ind<-df_indicators %>% 
  select(Indicator) %>%
  filter(!Indicator %in% c("RiverpHchange"))

ind<-paste0(ind$Indicator)


AssessmentMultiple(wblistC,df_periods,dfc,outputdbC,ind,df_bound,df_bound_WB,df_indicators,df_varcomp,df_var,nSimMC,bReplaceResults=T,logfile="log_C_WA86698934.txt",iStart=1)
#AssessmentMultiple(wblistL,df_periods,dfl,outputdbL,ind,df_bound,df_bound_WB,df_indicators,df_varcomp,df_var,nSimMC,bReplaceResults=T,logfile="log_L.txt")
#AssessmentMultiple(wblistR,df_periods,dfr,outputdbR,ind,df_bound,df_bound_WB,df_indicators,df_varcomp,df_var,nSimMC,bReplaceResults=T,logfile="log_R.txt")





