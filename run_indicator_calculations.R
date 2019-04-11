
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
nSimMC <- 10
#number of Monte Carlo simulations


outputdbC<-"output/ekostat_C_hypox.db"
outputdbL<-"output/ekostat_L.db"
outputdbR<-"output/ekostat_R.db"


wblistC<-df_WB %>% 
  distinct(CLR,WB_ID,Type) %>%
  filter(CLR=="Coast") %>%
  filter(WB_ID %in% c("WA46670058"))

    # filter(WB_ID %in% c("WA46670058","WA43270311","WA23971566",
    #                   "WA29111809",
    #                   "WA46408217","WA68382937","WA36243146",
    #                   "WA17695227","WA55983181","WA12817029",
    #                   "WA99366628","WA52813004","WA61585185"
    #                   ))

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
ind <- c("CoastHypoxicArea")

AssessmentMultiple(wblistC,df_periods,dfc,outputdbC,ind,df_bound,df_bound_WB,df_indicators,df_varcomp,df_var,nSimMC,bReplaceResults=T,logfile="log_C_hypox.txt",iStart=1)
#AssessmentMultiple(wblistL,df_periods,dfl,outputdbL,ind,df_bound,df_bound_WB,df_indicators,df_varcomp,df_var,nSimMC,bReplaceResults=T,logfile="log_L.txt")
#AssessmentMultiple(wblistR,df_periods,dfr,outputdbR,ind,df_bound,df_bound_WB,df_indicators,df_varcomp,df_var,nSimMC,bReplaceResults=T,logfile="log_R.txt")





