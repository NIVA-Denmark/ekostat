
library(RSQLite)
library(tidyverse)
library(haven)

source("prepare_input_data.R")
source("read_parameter_files.R")

# Options for indicator calculations
nSimMC <- 3  #1000 #number of Monte Carlo simulations


start_time <- Sys.time()
