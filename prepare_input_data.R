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
  select(WB_ID=MS_CD,station,date,Year,Month,
         Period,time,station_depth,sali,biovol,
         obspoint,institution,BQI,depth,MSMDI,
         DIN,DIP,TN,TP,chla,secchi,HypoxicAreaPct,O2_bot) %>%
  filter(WB_ID!="")

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

rm(list=c("dflbio","dflwq","dfrbio","dfrwq","dfcbio","dfcbqi","dfcmsmdi","dfcwater"))



