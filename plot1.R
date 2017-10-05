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
  rm (link, zip_file)
}
data<- read.csv("data-set.csv")

# coerce relevant data to num class
data <- mutate(data, Global_active_power= as.numeric(Global_active_power)) 

png("plot1.png")
hist(data$Global_active_power, col="red", main="Global Active Power", xlab = "Global Active Power (kilowatts)")
dev.off()
