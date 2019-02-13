AssessmentMultiple<-function(df,outputdb,IndList,df_bounds,df_bounds_hypox,df_bathy,df_indicators,df_variances,bReplaceResults=T){

  if(bReplaceResults){
    bOVR<-TRUE
    bAPP<-FALSE
  }else{
    bOVR<-FALSE
    bAPP<-TRUE
  }
for(iWB in wbcount:wb1){
  #for(iWB in 1:1){
  
  dfselect<-df %>% filter(WB == wblist$WB[iWB])
  cat(paste0(wblist$CLR[iWB]," WB: ",wblist$WB[iWB]," (",iWB," of ",wbcount ,")\n"))
  
  AssessmentResults <- Assessment(dfselect, nsim = nSimMC, IndList,df_bounds,df_bounds_hypox,df_bathy,df_indicators,df_variances)
  
  ETA <- Sys.time() + (Sys.time() - start_time)*wbcount/(wbcount-iWB)
  cat(paste0("Time: ",Sys.time(),"  (elapsed: ",round(Sys.time() - start_time,4),") ETA=",ETA,"\n"))
  
  resAvg <- AssessmentResults[[1]]
  resMC <- AssessmentResults[[2]]
  resErr <- AssessmentResults[[3]]
  resYear <- AssessmentResults[[4]]
  db <- dbConnect(SQLite(), dbname=outputdb)
  
  if(!is.na(resAvg)){
    WB <- resAvg %>% group_by(WB,Type,Period,Region,Typename) %>% summarise()
    dbWriteTable(conn = db, name = "resMC", resMC, overwrite=bOVR,append=bAPP, row.names=FALSE)
    dbWriteTable(conn = db, name = "resYear", resYear, overwrite=bOVR,append=bAPP, row.names=FALSE)
    dbWriteTable(conn = db, name = "WB", WB, overwrite=bOVR,append=bAPP, row.names=FALSE)
    dbWriteTable(conn = db, name = "data", dfselect, overwrite=bOVR,append=bAPP, row.names=FALSE)
    dbWriteTable(conn = db, name = "resAvg", resAvg, overwrite=bOVR,append=bAPP, row.names=FALSE)
  }
  dbWriteTable(conn = db, name = "resErr", resErr, overwrite=bOVR,append=bAPP, row.names=FALSE)
  dbDisconnect(db)
  
  bOVR<-FALSE
  bAPP<-TRUE
  
}}
