#Requires Initial Data Upload to function

# Initial Download of data and reading into data table
library("data.table")
library("ggplot2")
path <- getwd()
download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
              , destfile = paste(path, "dataFiles.zip", sep = "/"))
unzip(zipfile = "dataFiles.zip")

#Assign data into data tables
SCC <- data.table::as.data.table(x = readRDS(file = "Source_Classification_Code.rds"))
NEI <- data.table::as.data.table(x = readRDS(file = "summarySCC_PM25.rds"))
#End Initial Data Load

NEI[, Emissions := lapply(.SD, as.numeric), .SDcols = c("Emissions")]

#Sum Emissions by Year
totalNEI <- NEI[, lapply(.SD, sum, na.rm = TRUE), .SDcols = c("Emissions"), by = year]
