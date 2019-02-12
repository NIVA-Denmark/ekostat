library(readxl)
library(dplyr)

  # get data for boundaries and variance components from dropbox 

source("data_preparation/excel_to_text.R")

file<-"C:/Users/CJM/Dropbox/WATERS_tools/tables_for_waters_tool/Structured tables for shinyapp and R.xlsx"

  # Variance Components
df_varcomp <- excel_to_text(xlfile=file,sheet="Varcomp",textfile="parameters/varcomp.txt")

  # indicator boundaries
df_bound <- excel_to_text(xlfile=file,sheet="Boundaries",textfile="parameters/boundaries.txt")

  # WB-specific boundaries for bottom oxygen for selected coastal waterbodies
df_bound_WB <- excel_to_text(xlfile=file,sheet="Boundaries WB",textfile="parameters/boundaries_WB.txt")

  # Indicator List - with pressures
df_indicators <- excel_to_text(xlfile=file,sheet="Indicator data",textfile="parameters/indicators.txt")

