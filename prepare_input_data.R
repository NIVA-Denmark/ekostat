# Read in observation data

dflbio <- read_sas("data/lake_biolindex.sas7bdat")      # Lake biology data
dflwq <- read_sas("data/lake_WQdata.sas7bdat")          # Lake WQ data
dfrbio <- read_sas("data/river_biolindex.sas7bdat")     # River biology data
dfrwq <- read_sas("data/river_WQdata.sas7bdat")         # River WQ data
dfcbio<-read_sas("data/coast_biovol.sas7bdat")          # Coast biovolume
dfcbqi<- read_sas("data/coast_bqi.sas7bdat")            # Coast BQI
dfcmsmdi<- read_sas("data/coast_msmdi.sas7bdat")        # Coast MSMDI
dfcwater<- read_sas("data/coast_watersamples.sas7bdat") # Coast water samples

dfc<-bind_rows(dfcbio,dfcbqi,dfcmsmdi,dfcwater) %>%
  mutate(Year=year(date),Month=month(date)) %>%
  select(WB_ID=MS_CD,station,date,year=Year,month=Month,
         time,station_depth,sali,biovol,
         obspoint,institution,BQI,depth,MSMDI,
         DIN,DIP,TN,TP,chla,secchi,HypoxicAreaPct,O2_bot) %>%
  filter(WB_ID!="")
# 
# dfcmsmdi<-dfcmsmdi %>%
#   mutate(Year=year(date),Month=month(date)) %>%
#   select(WB_ID=MS_CD,station,date,year=Year,month=Month,
#          obspoint,institution,MSMDI) %>%
#   filter(WB_ID!="")
# 
# df_SMHI<-read.table(file="data/from_SMHI/WATERS_export.txt",header=T,stringsAsFactors=F,sep="\t")
# 
# df_SMHI <- df_SMHI %>% 
#   select(WB_ID=MS_CD,EU_CD=WB_ID,station=Station,date=Date,year,month,time=Time,station_depth,sali,biovol,institution=Institution,depth=DEPH,
#          BQI,DIN,DIP,TN,TP,chla=Chla,secchi=Secchi,HypoxicAreaPct,O2_bot) %>%
#   mutate(date=as.Date(date)) 
# 
# dfc<-bind_rows(df_SMHI,dfcmsmdi)

dfl<-bind_rows(dflwq,dflbio) %>%
  select(WB_ID=MS_CD,station,date,year,month,sali,obspoint,
         min_depth,max_depth,depth_min,depth_max,Nspecies_phytoplankton,
         biovol,biovolGony,Proportion_cyanobacteria,TrophicPlanktonIndex,
         PhytoplanktonTrophicIndex,BenthicDiatomsIPS,BenthicDiatomsACID,
         TrophicMacrophyteIndex,BenthicInvertebratesASPT,BenthicInvertebratesMILA,
         BenthicInvertebratesBQI,institution,WB_nameFish,
         Altitude,LakeArea,LakeDepth,EQR8,AindexW5,EindexW3,
         Abs_F420,TN,TP,chla,O2_surf,O2_bot,SecchiDepth) %>%
  filter(WB_ID!="")

dfr<-bind_rows(dfrbio,dfrwq) %>%
  select(WB_ID=MS_CD,station,date,year,month,sali,depth_min,depth_max,
         min_depth,max_depth,BenthicDiatomsIPS,
         BenthicDiatomsACID,BenthicDiatomsPctPT,BenthicDiatomsTDI,
         BenthicInvertebratesASPT,BenthicInvertebratesDJ,BenthicInvertebratesMISA,
         institution,obspoint,WB_nameFish,VIXsm,VIXh,VIX,Abs_F420,TN,TP,chla,
         O2_surf,O2_bot,SecchiDepth) %>%
  filter(WB_ID!="")

# ----- Add period information --------------------------

Period<-c("2007-2012","2013-2018")
df_periods<-data.frame(Period,stringsAsFactors=F) %>%
  mutate(yearFrom=as.numeric(substr(Period,1,4)),yearTo=as.numeric(substr(Period,6,9)))

yrmin<-min(df_periods$yearFrom)
yrmax<-max(df_periods$yearTo)

year<-yrmin:yrmax
dfYearPeriod<-expand.grid(year=year,Period=Period) %>%
  mutate(yearFrom=as.numeric(substr(Period,1,4)),yearTo=as.numeric(substr(Period,6,9))) %>%
  mutate(OK=(year>=yearFrom&year<=yearTo))

dfYearPeriod<-dfYearPeriod %>%
  filter(OK==T) %>%
  select(year,Period)

df_periods <- df_periods %>%
  select(Period)

# Add period information to the data files:

dfc <- dfc %>% left_join(dfYearPeriod,by="year")
dfl <- dfl %>% left_join(dfYearPeriod,by="year")
dfr <- dfr %>% left_join(dfYearPeriod,by="year")


rm(list=c("dflbio","dflwq","dfrbio","dfrwq","dfcbio","dfcbqi","dfcmsmdi","dfcwater",
          "dfYearPeriod","Period","year","yrmin","yrmax"))

