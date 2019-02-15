
library(RSQLite)
library(tidyverse)
library(haven)
library(lubridate)

source("prepare_input_data.R")
source("read_parameter_files.R")
source("Assessment.R")
source("IndicatorSelectionSweden.R")

#db <- dbConnect(SQLite(), dbname=dbpath)
#dbWriteTable(conn=db,name="WB_info",df_wb_unique,overwrite=T,append=F,row.names=FALSE)

# Options for indicator calculations
nSimMC <- 3  #1000 #number of Monte Carlo simulations

# 
start_time <- Sys.time()


outputdb<-"output/test.db"

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
ind<-df_indicators %>% select(Indicator)
ind<-paste0(ind$Indicator)

#AssessmentMultiple(dfc,outputdb,IndList=ind,df_bounds,df_bounds_hypox,df_bathy,df_indicators,df_variances,bReplaceResults=T)
AssessmentMultiple(wblistC,df_periods,dfc,outputdb,ind,df_bound,df_bound_WB,df_indicators,df_varcomp,bReplaceResults=T)
#AssessmentMultiple(wblistL,dfl,outputdb,ind,df_bound,df_bound_WB,df_indicators,df_varcomp,bReplaceResults=F)
#AssessmentMultiple(wblistR,dfr,outputdb,ind,df_bound,df_bound_WB,df_indicators,df_varcomp,bReplaceResults=F)

  

