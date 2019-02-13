library(tidyverse)
library(readxl)
library(RSQLite)


# example link to VISS
# http://viss.lansstyrelsen.se/Waters.aspx?waterMSCD=WA57943788

# ------------------ database path --------------------------------------------------
dbpath<-"../efs/ekostat/ekostat3.db"
writeToDB=F

# -------------------- Read tyoplogy information from DropBox -----------------------

datafolder<-"C:/Users/CJM/Dropbox/WATERS_tools/tables_for_waters_tool/new_typologies/"

xlfile_c<-"coast/new_coastal.xlsx"   #   654 coastal waterbodies
xlfile_l<-"lakes/lakes_new.xlsx"     #  7540 lake waterbodies
xlfile_s<-"streams/streams_new.xlsx" # 15783 stream waterbodies

df_c<-read_excel(paste0(datafolder,xlfile_c), sheet = "Vatten-Parameter",col_names = TRUE)
df_l<-read_excel(paste0(datafolder,xlfile_l), sheet = "Vatten-Parameter",col_names = TRUE)
df_s<-read_excel(paste0(datafolder,xlfile_s), sheet = "Vatten-Parameter",col_names = TRUE)


colnewname<-function(df,oldname,newname){
  if(newname!=""){
    names(df)[names(df)==oldname]<-newname
  }
  return(df)
}
# ----------------------------- rename columns -----------------------------
# Coastal
df_c <- df_c %>% colnewname("Vatten-ID_2", "WB_ID")
df_c <- df_c %>% colnewname("Vatten-ID", "EU_CD")
df_c <- df_c %>% colnewname("Namn Vatten", "WB_Name")
df_c <- df_c %>% colnewname("Huvudavrinningsområde", "Catchment")
df_c <- df_c %>% colnewname("Län", "Lan")
df_c <- df_c %>% colnewname("Kommun(er)", "Municipality")
df_c <- df_c %>% colnewname("Myndighet", "Authority")
df_c <- df_c %>% colnewname("Distrikt", "District")
df_c <- df_c %>% colnewname("Vattenkategori", "Category")
df_c <- df_c %>% colnewname("Limnisk ekoregion/Kustvattentyp", "Type")
df_c <- df_c %>% colnewname("Åtgärdsområde", "ActionArea")

# Lakes
df_l <- df_l %>% colnewname("Vatten-ID", "WB_ID")
df_l <- df_l %>% colnewname("Vatten-ID_2", "EU_CD")
df_l <- df_l %>% colnewname("Namn Vatten", "WB_Name")
df_l <- df_l %>% colnewname("Huvudavrinningsområde", "Catchment")
df_l <- df_l %>% colnewname("Län", "Lan")
df_l <- df_l %>% colnewname("Kommun(er)", "Municipality")
df_l <- df_l %>% colnewname("Myndighet", "Authority")
df_l <- df_l %>% colnewname("Distrikt", "District")
df_l <- df_l %>% colnewname("Vattenkategori", "Category")
df_l <- df_l %>% colnewname("Vattentyp - Sjö", "Type")
df_l <- df_l %>% colnewname("Limnisk vattentypsregion", "Type_region")
df_l <- df_l %>% colnewname("Medeldjup (m)", "Type_depth")
df_l <- df_l %>% colnewname("Alkalinitet (mekv/l)", "Type_alkalinity")
df_l <- df_l %>% colnewname("Humus (mg Pt/l)", "Type_humus")
df_l <- df_l %>% colnewname("Åtgärdsområde", "ActionArea")

# Rivers
df_s <- df_s %>% colnewname("Vatten-ID", "WB_ID")
df_s <- df_s %>% colnewname("Vatten-ID_2", "EU_CD")
df_s <- df_s %>% colnewname("Namn Vatten", "WB_Name")
df_s <- df_s %>% colnewname("Huvudavrinningsområde", "Catchment")
df_s <- df_s %>% colnewname("Län", "Lan")
df_s <- df_s %>% colnewname("Kommun(er)", "Municipality")
df_s <- df_s %>% colnewname("Myndighet", "Authority")
df_s <- df_s %>% colnewname("Distrikt", "District")
df_s <- df_s %>% colnewname("Vattenkategori", "Category")
df_s <- df_s %>% colnewname("Vattentyp - Vattendrag", "Type")
df_s <- df_s %>% colnewname("Limnisk vattentypsregion", "Type_region")
df_s <- df_s %>% colnewname("Tillrinningsområdets storlek (km2)", "Type_catchment_size")
df_s <- df_s %>% colnewname("Vattendragslutning (%)", "Type_gradient")
df_s <- df_s %>% colnewname("Åtgärdsområde", "ActionArea")

# ----------------------------- select columns -----------------------------
df_c<-df_c %>% select(Category,EU_CD,WB_ID,WB_Name,Catchment,Lan,Municipality,Authority,District,Type,ActionArea)
df_l<-df_l %>% select(Category,EU_CD,WB_ID,WB_Name,Catchment,Lan,Municipality,Authority,District,Type,ActionArea,Type_region,Type_depth,Type_alkalinity,Type_humus)
df_s<-df_s %>% select(Category,EU_CD,WB_ID,WB_Name,Catchment,Lan,Municipality,Authority,District,Type,ActionArea,Type_region,Type_catchment_size,Type_gradient)
# ----------------------------- coastal - fix Type  -----------------------------

# for coastal, split the Type into a TypeID (e.g. 12n) and a Type Name
# some use ":" as separator, others use "."
df_c <- df_c %>%
  separate(Type,into=c("Type","TypeName"),sep=":",remove=F,fill="right",extra="merge") %>%
 separate(Type,into=c("Type2","TypeName2"),sep="\\.",remove=F,fill="right",extra="merge") %>%
  mutate(Type=ifelse(is.na(TypeName),Type2,Type),
         TypeName=ifelse(is.na(TypeName),TypeName2,TypeName)) %>%
  select(-c(Type2,TypeName2))

# join coastal, lake and stream WBs
df_wb <- bind_rows(df_c,df_l,df_s)
df_wb <- df_wb %>% 
  mutate(CLR=ifelse(Category=="CW","Coast",ifelse(Category=="LW","Lake",ifelse(Category=="RW","River",""))))

df_wb_unique<- df_wb %>% distinct(Category,CLR,WB_ID,WB_Name,Catchment,Lan,Municipality,Authority,
                                  District,Type,ActionArea,Type_region,Type_depth,Type_alkalinity,Type_humus,
                                  Type_catchment_size,Type_gradient)


# ---- Län table -------------------------------------
df_lan <- df_wb %>% 
  distinct(WB_ID,Lan) 

colsLan<-c("Lan1", "Lan2", "Lan3", "Lan4")
df_lan <- df_lan %>%
  separate(col=Lan,into=colsLan,sep = ",",fill="right") %>%
  gather(key="n",value="Lan",colsLan) %>%
  select(-n) %>%
  filter(!is.na(Lan))

df_lan <- df_lan %>%
  separate(col=Lan,into = c("LanName","LanID"),sep = " - ",remove=F) %>%
  arrange(LanName)

# ---- Municipality table -------------------------------------

df_mun <- df_wb %>% 
  distinct(WB_ID,Municipality) 

colsMun<-c("Mun1", "Mun2", "Mun3","Mun4", "Mun5", "Mun6","Mun7", "Mun8", "Mun9")
df_mun <- df_mun %>%
  separate(col=Municipality, into=colsMun, sep=",",fill="right") %>%
  gather(key="n",value="Mun",colsMun) %>%
  select(-n) %>%
  filter(!is.na(Mun))

df_mun <- df_mun %>%
  separate(col=Mun,into = c("MunName","MunID"),sep = " - ",remove=F,fill="right") %>%
  arrange(MunName)

# ---- EU_CD table -------------------------------------

df_EU_CD <- df_wb %>% 
  distinct(WB_ID,EU_CD) 

colsEU_CD<-c("EU_CD1", "EU_CD2", "EU_CD3","EU_CD4")
df_EU_CD <- df_EU_CD %>%
  separate(col=EU_CD, into=colsEU_CD, sep=",",fill="right") %>%
  gather(key="n",value="EU_CD",colsEU_CD) %>%
  select(-n) %>%
  filter(!is.na(EU_CD))



# ------------------ write tables to database ---------------------------------------
if(writeToDB){
  db <- dbConnect(SQLite(), dbname=dbpath)
  dbWriteTable(conn=db,name="WB_info",df_wb_unique,overwrite=T,append=F,row.names=FALSE)
  dbWriteTable(conn=db,name="WB_mun",df_mun,overwrite=T,append=F,row.names=FALSE)
  dbWriteTable(conn=db,name="WB_lan",df_lan,overwrite=T,append=F,row.names=FALSE)
  dbWriteTable(conn=db,name="WB_EU",df_EU_CD,overwrite=T,append=F,row.names=FALSE)

  res<-dbExecute(conn=db,"CREATE INDEX `idx_WB_Lan` ON `WB_Lan` ( `WB_ID` ASC )")
  res<-dbExecute(conn=db,"CREATE INDEX `idx_WB_Mun` ON `WB_Mun` ( `WB_ID` )")
  res<-dbExecute(conn=db,"CREATE INDEX `idx_WB_EU` ON `WB_EU` ( `WB_ID` )")
  res<-dbExecute(conn=db,"CREATE UNIQUE INDEX `idx_WB_info` ON `WB_info` ( `WB_ID` ASC )")
  dbDisconnect(db)
}