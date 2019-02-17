
library(RSQLite)
library(tidyverse)
library(haven)
library(lubridate)
library(prodlim)

source("prepare_input_data.R")
source("read_parameter_files.R")
source("Assessment.R")
source("IndicatorSelectionSweden.R")

#db <- dbConnect(SQLite(), dbname=dbpath)
#dbWriteTable(conn=db,name="WB_info",df_wb_unique,overwrite=T,append=F,row.names=FALSE)

# Options for indicator calculations
nSimMC <- 10  #1000 #number of Monte Carlo simulations

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

wbselect<-c("SE652920-222650",
            "SE622011-146303",
            "SE552170-130626",
            "SE560900-145280")

wbselect<-c("SE622011-146303")

wblistC <- wblistC %>% 
  left_join(df_WB_EU,by="WB_ID") %>%
  filter(EU_CD %in% wbselect)

           
# SE622011-146303
# MSMDI 2007-2012 mean=0.898849

AssessmentMultiple(wblistC,df_periods,dfc,outputdb,ind,df_bound,df_bound_WB,df_indicators,df_varcomp,bReplaceResults=T)
#AssessmentMultiple(wblistL,df_periods,dfl,outputdb,ind,df_bound,df_bound_WB,df_indicators,df_varcomp,bReplaceResults=F)
#AssessmentMultiple(wblistR,df_periods,dfr,outputdb,ind,df_bound,df_bound_WB,df_indicators,df_varcomp,bReplaceResults=F)

  

