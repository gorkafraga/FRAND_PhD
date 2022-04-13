# Install and load package for reading and writing matlab
# http://cran.r-project.org/web/packages/R.matlab/R.matlab.pdf



descriptives <- describeBy(data, data$trainingType)

install.packages("R.utils")
library(psych)
install.packages("reshape")
install.packages("xlsReadWrite")
install.packages("xlsx")
install.packages('gdata')
install.packages("R.matlab")

library(gdata)
library(reshape)
library(R.matlab)
library(xlsReadWrite)
library(xlsx)
xls.getshlib()

path <- ("C:/Users/Gorka/Personal/R_workspace")
pathname <-file.path(path,"groupN1.mat")


data <- read.xlsx("N1Pre&Post.xls")
attach(data)

 
#Labels of 64 channels
 channels=c('Fp1','AF7','AF3','F1','F3','F5','F7','FT7','FC5','FC3',
'FC1','C1','C3','C5','T7','TP7','CP5','CP3','CP1','P1','P3','P5','P7',
'P9','PO7','PO3','O1','Iz','Oz','POz','Pz','CPz','Fpz','Fp2','AF8','AF4',
'Afz','Fz','F2','F4','F6','F8','FT8','FC6','FC4','FC2','FCz','Cz','C2','C4',
'C6','T8','TP8','CP6','CP4','CP2','P2','P4','P6','P8','P10','PO8','PO4','O2');



totalsize = length(chans)*length(data$subject)*length(typestr)*length(lengthstr)*length(value)

data1 = stack(data)
electrode = rbind(0,(as.matrix(rep(as.matrix(chans),dim(data1)[1]/length(chans)))))
headers <- colnames(data)
rows <-  rownames(data)
                                # missing values check 
                               ismissing <- data[!complete.cases(data),]
# Separate amplitudes and latencies
     ampdata = data[,(headers[grep("amp",headers)])]
     rownames(ampdata)= data$subject
     latdata = data[,(headers[grep("lat",headers)])]
     rownames(latdata)= data$subject
# Define search parameters 
      peak = c('N1','P1','P2') 
      value = c('amp','lat')   
    
      
# Define experimental variables to arrange data for AOV                                                                             
#------------------------------------------------------------------------------
# make X inside a loop!
# WITHIN SS 
      typestr = c('W','S')    #Words/Symbols 
      lengthstr = c('S', 'L') #Short/Long
      
      nchan = 1:length(channels);  names(nchan) = channels 
      chans = channels[c(16,22:30,53,59:64)] # electrodes in analysis
      names(chans) <- NULL
      
      
for (TS in 1:length(typestr))
   { 
    for (L in 1:length(lengthstr))  
    { 
col2get <-  paste((paste(lengthstr[L],typestr[TS],sep='')), paste(peak[1],value[1],sep=''),sep='_');
        x <- stack(data[,(headers[grep(col2get,headers)])])

  rbind(x1,x2,x3,x4)

data1 = stack(data)
data1[3] =  rep(data$subject, dim(data1)[1]/length(data$subject)) # subjects                  

colnames(data1)= c("value", "label","subject")

aov.out = aov( ~ store + Error(subject/t), data=data1)
> summary(aov.out)