#Requires Initial Data Upload to function
#Plot 2

#Sum Emissions by Year
BaltimoretotalNEI <- NEI[fips=='24510', lapply(.SD, sum, na.rm = TRUE), .SDcols = c("Emissions"), by = year]

#Create and save plot to PNG file
png(filename='plot2.png')
plot(BaltimoretotalNEI$year,BaltimoretotalNEI$Emissions,ylab="Emissions",xlab="Year",col="black",main="Baltimore Emissions by Year")
dev.off()
