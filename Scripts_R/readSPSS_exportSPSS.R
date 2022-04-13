# Install and load package for reading and writing matlab


install.packages("foreign") # newer than memisc
library(foreign)

setwd("H:\GORKA\Statistical Analysis\FRAND_R")


data <- read.spss("FRAND_BERP_NOR_1.sav", use.value.labels = TRUE, to.data.frame = TRUE,
max.value.labels = Inf, trim.factor.names = FALSE,
trim_values = TRUE, reencode = NA, use.missings = to.data.frame)

#recode some of the labels (wrdSymbdiff becames DifWS, Words becomes words and so on...
colnames(data)[grep("WrdSymbDIFF",colnames(data))] <- gsub("WrdSymbDIFF_","DifWS_", colnames(data)[grep("WrdSymbDIFF",colnames(data))])
colnames(data)[grep("Words",colnames(data))] <- gsub("Words","words_", colnames(data)[grep("Words",colnames(data))])
colnames(data)[grep("Symbols",colnames(data))]<- gsub("Symbols","symbols_", colnames(data)[grep("Symbols",colnames(data))])


elec <- c("TP7","P5","P7","P9","PO7","PO3","O1","TP8","P6","P8","P10","PO8","PO4","O2","Iz","POz","Oz")

 for (l in 1:length(elec))
    {  temp <- colnames(data)[(grep(paste("^",elec[l],sep=""),colnames(data)))] #columns containing the electrode * The symbol "^"indicates start of the string. 

	#1.Assign PRE before electrode name to columnos NOT containing "POST" or "Post"label
       	temp[grep("POST",temp,ignore.case= TRUE,invert=TRUE)] <- gsub(elec[l],paste("Pre_",elec[l],sep=""),temp[grep("POST",temp,ignore.case= TRUE,invert=TRUE)]) 
     	
	#2.Replace "POST"label and place it before the electrode name
		temp[grep("POST",temp)] <- gsub(elec[l],paste("Post_",elec[l],sep=""),temp[grep("POST",temp)]) # move _POST at the start
            temp[grep("_POST",temp)] <- gsub("_POST","",temp[grep("_POST",temp)]) # remove _POST 
		temp[grep("POST_",temp)] <- gsub("POST_","",temp[grep("POST_",temp)]) # remove POST_ 
		temp[grep("PostPreDIFF_",temp)] <- gsub(elec[l],paste("Long_",elec[l],sep=""),temp[grep("PostPreDIFF_",temp)])#write PrePostDiff at the start 
		temp[grep("PostPreDIFF_",temp)] <- gsub("PostPreDIFF_","",temp[grep("PostPreDIFF_",temp)])#remove PrePostDiff

          
	# Replace correspondent colnames with temp
 	colnames(data)[(grep(paste("^",elec[l],sep=""),colnames(data)))]<- temp
	 }
 library(foreign)
 write.foreign(data, "H:/GORKA/Statistical Analysis/FRAND_R/mydata.txt","H:/GORKA/Statistical Analysis/FRAND_R/mydata.sps",package="SPSS")
write.table(data,"H:/GORKA/Statistical Analysis/FRAND_R/mydata.txt",sep="\t",row.names = FALSE) 
