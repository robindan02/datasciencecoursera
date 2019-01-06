#Requires Initial Data Upload to function
#Plot 1
#Create and save plot to PNG file
png(filename='plot1.png')
plot(totalNEI$year,totalNEI$Emissions,ylab="Emissions",xlab="Year",col="black",main="Emissions by Year")
dev.off()