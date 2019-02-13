

# -----------------------------  tables for selection   -----------------------------

#Type_region <- data.frame(Type_region=c(1,2,3,4),Type_region_desc=c("Södra Sverige (1)","Norra Sverige ≤ 200 m (2)","Norra Sverige 200-800 m (3)","Norra Sverige ≥ 800 m (4)"))
#Type_depth <- data.frame(Type_depth=c("G","M","D"),Type_depth_desc=c("≤3 m (G)","3-15 m (M)",">15 m (D)"))
#Type_alkalinity <- data.frame(Type_alkalinity=c("L","H"),Type_alkalinity_desc=c("≤1 mekv/l (L)",">1 mekv/l (H)"))
#Type_humus <- data.frame(Type_humus=c("K","B"),Type_humus_desc=c("≤30 mg Pt/l (K)",">30 mg Pt/l (B)"))
#Type_catchment_size <- data.frame(Type_catchment=c("?","???"),Type_catchment_desc=c("",""))
#Type_gradient<- data.frame(Type_gradient=c("?","???"),Type_gradient_desc=c("",""))




test <- df_lan %>% 
  group_by(WB_ID) %>% 
  summarise(n=n()) %>%
  filter(n>1) %>%
  select(WB_ID) %>%
  left_join(df_wb_unique,by="WB_ID") %>%
  arrange(CLR,WB_ID)

test <- df_wb %>% 
  distinct(WB_ID,EU_CD) %>%
  group_by(WB_ID) %>%
  summarise(n=n()) %>%
  filter(n>1) %>%
  select(WB_ID) %>%
  left_join(df_wb,by="WB_ID")%>%
  arrange(CLR,WB_ID)



if(F){
  
  dbpath<-"../efs/ekostat/ekostat2.db"
  db <- dbConnect(SQLite(), dbname=dbpath)
  df<-dbGetQuery(conn=db,"Select * from resAvg")
  dbDisconnect(db)
  
  dbpath<-"../efs/ekostat/ekostat3.db"
  db <- dbConnect(SQLite(), dbname=dbpath)
  dbWriteTable(conn=db,name="resAvg",df,overwrite=T,append=F,row.names=FALSE)
  sql<-"CREATE UNIQUE INDEX `idx_resAvg` ON `resAvg` ( `WB`, `Period`, `Indicator`, `IndSubtype` )"
  res<-dbExecute(conn=db,statement=sql)
  dbDisconnect(db)
  
  
  
  
  names(df_l[substr(names(df_l),1,5)=="Type_"])
  names(df_s[substr(names(df_s),1,5)=="Type_"])
  
  distinct(df_l,Type_region)     # 1,2,3,4
  distinct(df_l,Type_depth)      # "G" grunda  "≤ 3 m", "M" mellan , "D" djupa
  distinct(df_l,Type_alkalinity) # "L" low, "H" high
  distinct(df_l,Type_humus)      # "B" brown, "K" klar
  
  distinct(df_s,Type_region)          # 1,2,3,4
  distinct(df_s,Type_catchment_size)  # 
  distinct(df_s,Type_gradient)        #
  
  
  
  # ------------------- arrange tables ----------------------------------------------
  
  dfnames_c<-data.frame(name=names(df_c),stringsAsFactors=F) %>% mutate(type="C",value=T)
  dfnames_c$id<-seq(1:nrow(dfnames_c))
  dfnames_l<-data.frame(name=names(df_l),stringsAsFactors=F) %>% mutate(type="L",value=T)
  dfnames_l$id<-seq(1:nrow(dfnames_l))
  dfnames_s<-data.frame(name=names(df_s),stringsAsFactors=F) %>% mutate(type="S",value=T)
  dfnames_s$id<-seq(1:nrow(dfnames_s))
  
  dfnames<- bind_rows(dfnames_c,dfnames_l,dfnames_s) %>%
    spread(value="value",key="type") %>%
    arrange(C,L,id)
  
  newnames<-function(df,matchcol="name",newcol="name_new",oldname="",newname=""){
    if(length(names(df)[names(df)==newcol])==0){
      df[,newcol]<-""
    }
    df[df[,matchcol]==oldname,newcol]<-newname
    return(df)
  }
  
  
  dfnames2 <- newnames(dfnames,oldname="Vatten-ID",newname="EU_CD")
  dfnames2 <- newnames(dfnames,oldname="Vatten-ID_2",newname="WB_ID")
}