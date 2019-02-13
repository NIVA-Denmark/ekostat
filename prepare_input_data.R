# Read in observation data

dflbio <- read_sas("data/lake_biolindex.sas7bdat")  # Lake biology data
dflwq <- read_sas("data/lake_WQdata.sas7bdat")      # Lake WQ data
dfrbio <- read_sas("data/river_biolindex.sas7bdat") # River biology data
dfrwq <- read_sas("data/river_WQdata.sas7bdat")     # River WQ data

dfcbio<-read_sas("data/coast_biovol.sas7bdat")
dfcbqi<- read_sas("data/coast_bqi.sas7bdat")
dfcmsmdi<- read_sas("data/coast_msmdi.sas7bdat")
dfcwater<- read_sas("data/coast_watersamples.sas7bdat")


dfcw<-bind_rows(dfcbio,dfcbqi,dfcmsmdi,dfcwater) %>%
  mutate(Year=year(date),Month=month(date)) %>%
  select(WB_ID=MS_CD,station,date,Year,Month,
         Period,time,station_depth,sali,biovol,
         obspoint,institution,BQI,depth,MSMDI,
         DIN,DIP,TN,TP,chla,secchi,HypoxicAreaPct,O2_bot)

