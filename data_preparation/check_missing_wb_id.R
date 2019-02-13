# This analysis is not part of routine data preparation

dflbio <- read_sas("data/lake_biolindex.sas7bdat")      # Lake biology data
dflwq <- read_sas("data/lake_WQdata.sas7bdat")          # Lake WQ data
dfrbio <- read_sas("data/river_biolindex.sas7bdat")     # River biology data
dfrwq <- read_sas("data/river_WQdata.sas7bdat")         # River WQ data
dfcbio<-read_sas("data/coast_biovol.sas7bdat")          # Coast biovolume
dfcbqi<- read_sas("data/coast_bqi.sas7bdat")            # Coast BQI
dfcmsmdi<- read_sas("data/coast_msmdi.sas7bdat")        # Coast MSMDI
dfcwater<- read_sas("data/coast_watersamples.sas7bdat") # Coast water samples

dfc_missing<-bind_rows(dfcbio,dfcbqi,dfcmsmdi,dfcwater) %>%
  filter(MS_CD=="")


dfl_missing<-bind_rows(dflwq,dflbio)   %>%
  filter(MS_CD=="") 

dfr_missing<-bind_rows(dfrbio,dfrwq)   %>%
  filter(MS_CD=="")
