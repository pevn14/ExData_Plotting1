library(dplyr)
# upload data setand unzip it only if doesn't
# filter for relevant date, and save to a file to gain time 
if (file.exists("data-set.csv") == FALSE){
  if(file.exists("household_power_consumption.txt")==FALSE) {
    link <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    zip_file <- "household_power_consumption.zip"
    download.file(link, zip_file)
    unzip(zip_file)
  }
  read.csv2("household_power_consumption.txt") %>%
  mutate(Date = as.Date(Date, format= "%d/%m/%Y")) %>%
  filter(Date=="2007-2-1"|Date=="2007-2-2") %>%
  mutate(Date_time = paste(as.character(Date), as.character(Time))) -> data # some values must be numeric
  write.csv(data,"data-set.csv", row.names = FALSE) # save filtered file to gain time for 3 others plots 
}
data<- read.csv("data-set.csv")

# coerce relevant data to num class
data <- mutate(data, Global_active_power= as.numeric(Global_active_power),
                     Global_reactive_power = as.numeric(as.character(Global_reactive_power)),
                     Voltage= as.numeric(as.character(Voltage)),
                     Sub_metering_1 = as.numeric(as.character(Sub_metering_1)),
                     Sub_metering_2 = as.numeric(as.character(Sub_metering_2)),
                     Sub_metering_3 = as.numeric(as.character(Sub_metering_3))) 

# seem have a problem with mutate and class POSIXlt
Date <- strptime(data$Date_time, format = "%Y-%m-%d %H:%M:%S") 

#Sys.setlocale("LC_TIME", "English") # print correct days'names with windows os
Sys.setlocale("LC_TIME", "en_US.UTF-8") # for linux
png("plot4.png")
par(mfcol=c(2, 2))
plot(Date, data$Global_active_power,  type="l", ylab = "Global Active Power", xlab="")
plot(Date, data$Sub_metering_1,  type='l', ylab = "Energy sub metering", xlab="")
lines(Date, data$Sub_metering_2,  type='l', col="red")
lines(Date, data$Sub_metering_3,  type='l', col="blue")
legend("topright", bty = 'n',cex=0.9, legend=c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"), lty=c(1,1,1), col=c("black","red", "blue")) #dev.off()
plot(Date, data$Voltage,  type="l", ylab = "Voltage", xlab="datetime")
plot(Date, data$Global_reactive_power,  type="l", ylab = "Global_reactive_power", xlab="datetime")
par(mfcol=c(1, 1))
dev.off()
