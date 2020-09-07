# read from dropbox

  checkyr <- 30
  # years given as two digits: YY
  # if year is > checkyr, then we assume it's 19YY
  # otherwise year is 20YY
  # e.g. 08 ---> 2008
  #      97 ---> 1997


  #dropbox<-"C:/Users/CJM/Dropbox/WATERS_tools/tables_for_waters_tool/Data tables for shiny/"
  dropbox<-"./data/dropbox/"

  read_dropbox<-function(filename,folder=dropbox){
    df <- read.table(paste0(dropbox,filename),
                     sep=",",header=T,stringsAsFactors=F,comment.char="",quote='"')
    # check column names
    names(df)[names(df)=="Station"] <- "station"
    names(df)[names(df)=="Vatten_ID"] <- "WB_ID"
    names(df)[names(df)=="Date"] <- "date"
    return(df)
  }
# ------------ Lake data -------------------------------------------------
  l1 <- read_dropbox("LakeBenthicInvertebrates.csv")
  l2 <- read_dropbox("LakeFish.csv")
  l3 <- read_dropbox("LakeMacrophytes.csv")
  l4 <- read_dropbox("LakePhytobenthos.csv")
  l5 <- read_dropbox("LakePhytoplankton.csv")
  l6 <- read_dropbox("LakeWQ.csv")
  
  dflake<-bind_rows(l1,l2,l3,l4,l5,l6) %>%
    filter(WB_ID!="") %>%
    mutate(year=as.numeric(substr(date,1,2)),
           month=as.numeric(substr(date,4,5))) %>%
    mutate(year=year+ifelse(year>checkyr,1900,2000),
           date=paste0(ifelse(year>checkyr,"19","20"),date))
  
  rm(list=c("l1","l2","l3","l4","l5","l6"))
  
  # ------------ River data -------------------------------------------------
  r1 <- read_dropbox("RiverBenthicInvertebrates.csv")
  r2 <- read_dropbox("RiverFish.csv")
  r3 <- read_dropbox("RiverPhytobenthos.csv")
  r4 <- read_dropbox("RiverWQ.csv")
  
  dfriver<-bind_rows(r1,r2,r3,r4) %>%
    filter(WB_ID!="")  %>%
    mutate(year=as.numeric(substr(date,1,2)),
           month=as.numeric(substr(date,4,5))) %>%
    mutate(year=year+ifelse(year>checkyr,1900,2000),
           date=paste0(ifelse(year>checkyr,"19","20"),date))
  
  rm(list=c("r1","r2","r3","r4"))
  
# ------------- Add period information -----------------------

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
  
  dflake <- dflake %>% left_join(dfYearPeriod,by="year")
  dfriver <- dfriver %>% left_join(dfYearPeriod,by="year")
  
    # namesl<-c(names(l1),names(l2),names(l3),names(l4),names(l5),names(l6)) 
  # namesl<-sort(unique(namesl))
  # namesl
  # 
  # namesr<-c(names(r1),names(r2),names(r3),names(r4)) 
  # namesr<-sort(unique(namesr))
  # namesr
  
    # "CoastMSMDI.csv"               
  # "LakeBenthicInvertebrates.csv" 
  # "LakeFish.csv"                 
  # "LakeMacrophytes.csv"          
  # "LakePhytobenthos.csv"         
  # "LakePhytoplankton.csv"        
  # "LakeWQ.csv"                   
  # "RiverBenthicInvertebrates.csv"
  # "RiverFish.csv"                
  # "RiverPhytobenthos.csv"        
  # "RiverWQ.csv"                  
  # "SE_County.csv"                
  # "SE_Municipality.csv"          
  # "SE_WB.csv"                    
  # "SMHI"