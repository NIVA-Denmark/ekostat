
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
nSimMC <- 2
#number of Monte Carlo simulations


outputdbC<-"output/ekostat_C.db"
outputdbL<-"output/ekostat_L.db"
outputdbR<-"output/ekostat_R.db"

#exclude <- read.table("exclude.txt", sep="\t", stringsAsFactors=F,header=T,comment.char="") %>%
#  mutate(Exclude=T)

# df_WB <- df_WB %>%
#   left_join(exclude,by="WB_ID") %>%
#   mutate(Exclude=ifelse(is.na(Exclude),F,Exclude))


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
#Testing
#ind<-c("CoastSecchiEQR")

#wbselect<-c("SE652920-222650","SE622011-146303","SE552170-130626","SE560900-145280","SE562000-123800") 
#wblistC <- wblistC %>% left_join(df_WB_EU,by="WB_ID") %>% filter(EU_CD %in% wbselect)

#wbselect<-c("WA81741467")
#wblistC <- wblistC %>% filter(WB_ID %in% wbselect)

#wbselect<-c("SE615375-137087","SE652852-155412","SE652177-159038","SE664197-149337","SE670275-146052","SE652364-156455") 
#wbselect<-c("SE653974-137560") 
#wblistL <- wblistL %>% left_join(df_WB_EU,by="WB_ID") %>% filter(EU_CD %in% wbselect)

#wbselect<-c("SE654141-124734","SE638475-137575","SE694939-144561","SE632601-145366")
#wblistR <- wblistR %>% left_join(df_WB_EU,by="WB_ID") %>% filter(EU_CD %in% wbselect)

AssessmentMultiple(wblistC,df_periods,dfc,outputdbC,ind,df_bound,df_bound_WB,df_indicators,df_varcomp,df_var,nSimMC,bReplaceResults=F,logfile="log_C.txt",iStart=1)
AssessmentMultiple(wblistL,df_periods,dfl,outputdbL,ind,df_bound,df_bound_WB,df_indicators,df_varcomp,df_var,nSimMC,bReplaceResults=F,logfile="log_L.txt")
AssessmentMultiple(wblistR,df_periods,dfr,outputdbR,ind,df_bound,df_bound_WB,df_indicators,df_varcomp,df_var,nSimMC,bReplaceResults=F,logfile="log_R.txt")





