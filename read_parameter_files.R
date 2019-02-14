

# ultimately, all parameters should be in a database

df_bound<-read.table("parameters/boundaries.txt", sep="\t", stringsAsFactors=F,header=T,comment.char="") 
df_bound_WB<-read.table("parameters/boundaries_WB.txt", sep="\t", stringsAsFactors=F,header=T,comment.char="") 
df_indicators<-read.table("parameters/indicators.txt", sep="\t", stringsAsFactors=F,header=T,comment.char="") 
df_varcomp<-read.table("parameters/varcomp.txt", sep="\t", stringsAsFactors=F,header=T,comment.char="") 
df_var<-read.table("parameters/variables.txt", sep="\t", stringsAsFactors=F,header=T,comment.char="") 


dbpath<-"../efs/ekostat/ekostat3.db"
db <- dbConnect(SQLite(), dbname=dbpath)
df_WB<-dbGetQuery(conn=db,"Select * from WB_info")
df_WB_mun<-dbGetQuery(conn=db,"Select * from WB_mun")
df_WB_lan<-dbGetQuery(conn=db,"Select * from WB_lan")
df_WB_EU<-dbGetQuery(conn=db,"Select * from WB_EU")
dbDisconnect(db)
