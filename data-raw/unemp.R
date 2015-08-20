##############################################################################
##
## Clean unemployment data from the St. Louis Fed
##
##############################################################################


library(gdata)
library(dplyr)
library(lubridate)

cpi <- read.csv(file.path('data-raw', 'fredgraph.xls')) %>%
    tbl_df() %>%
    transmute(period = ymd(FRED.Graph.Observations),
              index = as.numeric(as.character(X)))

save(cpi, file = file.path('data', 'unemp.rda'))