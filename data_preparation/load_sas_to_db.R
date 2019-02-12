library(RSQLite)
library(haven)

# Path to ekostat database
dbpath<-"../efs/ekostat_input/ekostat.db"


# Create db connection
db <- dbConnect(SQLite(), dbname=dbpath)


# Close db connection
dbDisconnect(db)

df_coast_biovol <- read_sas("data/coast_biovol.sas7bdat")

df_coast_bqi <- read_sas("data/coast_bqi.sas7bdat")
df_coast_msmdi <- read_sas("data/coast_msmdi.sas7bdat")
df_coast_watersamples <- read_sas("data/coast_watersamples.sas7bdat")
df_lake_biolindex <- read_sas("data/lake_biolindex.sas7bdat")
df_lake_wqdata <- read_sas("data/lake_wqdata.sas7bdat")
df_river_biolindex <- read_sas("data/river_biolindex.sas7bdat")
df_river_wqdata <- read_sas("data/river_wqdata.sas7bdat")

# coast_biovol
# coast_bqi
# coast_msmdi
# coast_watersamples
# lake_biolindex
# lake_wqdata
# river_biolindex
# river_wqdata

