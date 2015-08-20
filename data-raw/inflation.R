##############################################################################
##
## Clean CPI data from the St. Louis Fed
##
##############################################################################

library(dplyr)
library(lubridate)

cpi <- read.csv(file.path('data-raw', 'cpi.csv')) %>%
    tbl_df() %>%
    transmute(period = ymd(DATE),
              index = as.numeric(VALUE))

save(cpi, file = file.path('data', 'cpi.rda'))