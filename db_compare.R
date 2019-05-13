db1<-"C:/Data/GitHub/efs/ekostat/ekostat_C.db"
db2<-"output/ekostat_C.db"

readdb <- function(dbname,strSQL){
  db <- dbConnect(SQLite(), dbname=dbname)
  df <- dbGetQuery(db, strSQL)
  dbDisconnect(db)
  return(df)
}  

sql<-paste0("SELECT * FROM resAvg")
df1 <- readdb(db1, sql)
df2 <- readdb(db2, sql)

#df1 <- df1 %>%
#  mutate(IndSubtype=ifelse(is.na(IndSubtype),"",IndSubtype))
  #mutate(IndSubtype=ifelse(IndSubtype=="",NA,IndSubtype))


df1 <- df1 %>% 
  select(WB_ID,Period,Type,Typename,Indicator,IndSubtype,Mean_old=Mean,Code_old=Code) %>%
  arrange(WB_ID,Period,Type,Typename,Indicator,IndSubtype)

df2 <- df2 %>% 
  select(WB_ID,Period,Type,Typename,Indicator,IndSubtype,Mean,Code)  %>%
  arrange(WB_ID,Period,Type,Typename,Indicator,IndSubtype) 


df1X <- df1 %>%
  left_join(df2,by=c("WB_ID","Period","Type","Typename","Indicator","IndSubtype")) %>%
  filter(is.na(Code))


df2 <- df2 %>%
  left_join(df1,by=c("WB_ID","Period","Type","Typename","Indicator","IndSubtype"))

df1X <- select(df_WB,WB_ID,WB_Name) %>%
  left_join(df1X,by="WB_ID") %>%
  filter(!is.na(Code_old))

df2 <- select(df_WB,WB_ID,WB_Name) %>%
  left_join(df2,by="WB_ID") %>%
  filter(!is.na(Code))

df2X <- df2 %>% 
  filter(is.na(Code_old))
