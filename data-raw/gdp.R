##############################################################################
##
## Download and clean GDP data from the BEA
##
##############################################################################


library(gdata)
library(dplyr)
library(tidyr)
library(lubridate)


if (!file.exists(file.path('data-raw', 'gdpClean.csv'))) {

    srcFile <- file.path('data-raw', 'gdplev.xls')
    srcUrl <- 'http://www.bea.gov/national/xls/gdplev.xls'

    if (!file.exists(srcFile)) {
        download.file(srcUrl, destfile = srcFile)
    }

    read.xls(srcFile) %>%
        select(5:7) %>%
        slice(-(1:3)) %>%
        rename(period = X.3, gdp.cur = X.4, gdp.chained.2009 = X.5) %>%
        lapply(function(x) { sub(',', '', x) }) %>%
        data.frame() %>%
        tbl_df() %>%
        write.csv(file = file.path('data-raw', 'gdpClean.csv'), row.names = FALSE)

}

gdp <- read.csv(file.path('data-raw', 'gdpClean.csv'))

gdp$period <- gsub('q1', '-Jan-1', gdp$period)
gdp$period <- gsub('q2', '-Apr-1', gdp$period)
gdp$period <- gsub('q3', '-Jul-1', gdp$period)
gdp$period <- gsub('q4', '-Oct-1', gdp$period)

gdp <- gdp %>%
    tbl_df() %>%
    mutate(period = ymd(period),
           gdp.cur = as.numeric(gdp.cur),
           gdp.chained.2009 = as.numeric(gdp.chained.2009))

save(gdp, file = file.path('data', 'gdp.rda'))


