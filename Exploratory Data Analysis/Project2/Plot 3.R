#Requires Initial Data Upload to function
#Plot 3

#Create and save plot to PNG file
png(filename='plot3.png')
#Subset Baltimore City Data within the ggplot function
ggplot(subset(NEI,fips=='24510'),aes(factor(year),Emissions,fill=type)) +
  geom_bar(stat="identity") +
  facet_grid(.~type,scales = "free",space="free") + 
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (Tons)")) + 
  theme(axis.text.x = element_text(colour="grey20",angle=90,hjust=.5,vjust=.5,face="plain")) +
  labs(title=expression("PM"[2.5]*" Emissions, Baltimore City 1999-2008 by Source Type"))
dev.off()
