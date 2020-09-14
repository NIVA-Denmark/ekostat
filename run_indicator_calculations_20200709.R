
library(RSQLite)
library(tidyverse)
library(haven)
library(lubridate)
library(prodlim)

source("prepare_input_data.R")
source("read_parameter_files.R")
source("Assessment.R")
source("IndicatorSelectionSweden.R")
source("prepare_input_R_L.R")


# Options for indicator calculations
nSimMC <- 2 #1000
#number of Monte Carlo simulations


outputdbC<-"output/ekostat_C_khf.db"
outputdbL<-"output/ekostat_L.db"
outputdbR<-"output/ekostat_R.db"

logC<-"log_C.txt"
logL<-"log_L.txt"
logR<-"log_R.txt"

wblistC<-df_WB %>% 
  distinct(CLR,WB_ID,Type) %>%
  filter(CLR=="Coast") %>% 
  filter(WB_ID=="WA72333352") %>%
  rename(Vatten_ID=WB_ID)

wblistL<-df_WB %>% 
  distinct(WaterCategory,Vatten_ID,Type,LakeAltitude,AreaAgriculturePct,TPagricultureRefCond) %>%
  #filter(Vatten_ID=="WA20127072") %>%
  filter(WaterCategory=="LW") %>%
  mutate(CLR="Lake")

wblistR<-df_WB %>% 
  distinct(WaterCategory,Vatten_ID,Type,LakeAltitude,AreaAgriculturePct,TPagricultureRefCond) %>%
  #filter(Vatten_ID=="WA20127072") %>%
  filter(WaterCategory=="RW") %>%
  mutate(CLR="River")

# wblistR<-df_WB %>% 
#   distinct(CLR,WB_ID,Type) %>%
#   filter(CLR=="River") %>%
#   rename(Vatten_ID=WB_ID)


#List of periods to be assessed from prepare_input_data.R

# dfc - coastal water measurements
# dfl - lake measurements
# dfr - river measurements

#--------------------------------------------------------------------------------------
ind<-df_indicators %>% 
  filter(Water_type=="Rivers") %>%
  select(Indicator)# %>%
  #filter(Indicator %in% c("CoastChla","CoastChlaEQR"))
 #filter(!Indicator %in% c("RiverpHchange"))

ind<-paste0(ind$Indicator)
ind<-c("LakePTIEQR")

#AssessmentMultiple(wblistC,df_periods,dfc,outputdbC,ind,df_bound,df_bound_WB,df_indicators,df_varcomp,df_var,nSimMC,bReplaceResults=F,logfile=logC,iStart=1)
#AssessmentMultiple(wblistL,df_periods,dflake,outputdbL,ind,df_bound,df_bound_WB,df_indicators,df_varcomp,df_var,nSimMC,bReplaceResults=T,logfile=logL)
AssessmentMultiple(wblistR,df_periods,dfriver,outputdbR,ind,df_bound,df_bound_WB,df_indicators,df_varcomp,df_var,nSimMC,bReplaceResults=T,logfile=logR)





