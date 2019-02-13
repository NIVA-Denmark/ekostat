# Read Excel xlsx file and optionally export to text file

# xlfile   :: xlsx file to be read
# sheet    :: worksheet containing required data
# textfile :: [OPTIONAL] text file to write data to 

excel_to_text<-function(xlfile,sheet,textfile=""){
  require(dplyr)
  require(readxl)
  df <- read_xlsx(xlfile,sheet)
  colnames<-names(df)
  colnames<-colnames[!colnames %in% grep("..",colnames,value=T,fixed=T)]
  df <- df[,colnames]
  if(textfile!=""){
    write.table(df,file=textfile,row.names=F,col.names=T,sep="\t",quote=F)
    message("Writing ",textfile)
  }
  return(df)
}
