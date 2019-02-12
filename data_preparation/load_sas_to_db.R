library(RSQLite)

# Path to ekostat database
dbpath<-"../efs/ekostat_input/ekostat.db"


# Create db connection
db <- dbConnect(SQLite(), dbname=dbpath)


# Close db connection
dbDisconnect(db)



read_sas()
