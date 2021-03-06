library(dplyr)

## download file and unzip, if it is not downloaded before.
if(!file.exists("data.zip")){
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
                "data.zip",method="curl")
  unzip("data.zip")
}

## set Locale to C : date functions use Locale and it may cause an error.
locale_old <- Sys.getlocale("LC_TIME")
Sys.setlocale("LC_TIME","C")

## Only 2007-2-1 and 2007-2-2 data are loaded. 
lines <- grep("^[12]/2/2007",readLines("household_power_consumption.txt"),value=TRUE)
data <- tbl_df(read.table(textConnection(lines),sep = ";",na.strings = "?",
                          colClasses = c("character","character","numeric","numeric","numeric",
                                         "numeric","numeric","numeric","numeric")))
names(data) <- c("date","time","global_active_power","global_reactive_power",
                 "voltage","global_intensity", "sub_metering_1", "sub_metering_2", "sub_metering_3")

## Convert character to date type.
data <- mutate(data,datetime = as.POSIXct(paste(date,time), format = "%d/%m/%Y %H:%M:%S")) %>% 
  select(-c(date,time))

## make a plot
png(filename = "plot1.png",width = 480, height = 480)
hist(data$global_active_power,main="Global Active Power", 
     xlab = "Global Active Power (kilowatts)", col="red")
dev.off()

# set original Locale
Sys.setlocale("LC_TIME",locale_old)
