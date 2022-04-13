# Repeated measures mixed model ( within-ss and between-ss factors)
#==================================================================
# clear all variables of current workspace
  rm (list = ls())

# INPUT array required: containing subjects as rows and all factors as columns("wide"data arrangement)
# load packages & libraries

	libraries2load <- c("Hmisc", "MASS","foreign", "nnet", "R.utils","reshape","xlsx", "car", "gdata", "utils", "R.matlab")
	require(libraries2load)
	lapply(libraries2load, require,character.only = T)
	do.call("require", list(libraries2load))
           
#Define directories
    dirinput <-  "Y:/GORKA/Statistical Analysis/FRAND_R"
    diroutput <-  "Y:/GORKA/Statistical Analysis/FRAND_R"

#Pop up windows for inputs to select data to plot
  answer <- menu(choices <- c("N1", "P1", "P2"), graphics = TRUE, title = "Select peak of interest")
  answer1 <- menu(choices1 <- c("Yes", "No"), graphics = TRUE, title = "Longitudinal Analysis?")
  answer2 <- menu(choices2 <- c("amp", "lat"), graphics =TRUE, title = "Select values of interest")
  answer3 <- menu(choices3 <- c("allgroups", "PretestVsControl","LongitudinalTrainingGroups","manual selection of groups"),
               graphics =TRUE, title = "Select grouping factor")
     if (answer3 == 4) # if manual selection of groups choose now which groups
             { ansGroup1 <- menu(groupChoices <- c("LSS", "VWR","controlAge","controlDysl","postLSS","postVWR","slowDyslectics","fastDyslectics"), graphics =TRUE, title = "Select group1")
                ansGroup2 <- menu(groupChoices <- c("LSS", "VWR","controlAge","controlDysl","postLSS","postVWR","slowDyslectics","fastDyslectics"), graphics =TRUE, title = "Select group2")
                  group1 <- groupChoices[ansGroup1]
                  group2 <- groupChoices[ansGroup2]
                }
  peak <- choices[answer]
  value <- choices2[answer2]
  
# ======= LOAD DATA ==========================================

# go to directory
    setwd(dirinput)

# Define filename (spss data file) 
        filename <-  "FRAND_BERP_NOR.sav"

# Define  table with the design for the model (it will be read later)
    tablefile2read = "Y:/GORKA/Statistical Analysis/FRAND_R/tableFactors14e.txt"
    if (answer3==3) { tablefile2read = "Y:/GORKA/Statistical Analysis/FRAND_R/tableFactors14e_post.txt"}   
   
# READ DATA FILE    
 data <- read.spss(filename, use.value.labels = TRUE, to.data.frame = TRUE,
			max.value.labels = Inf, trim.factor.names = FALSE,
			trim_values = TRUE, reencode = NA, use.missings = to.data.frame)    

# ======= GRouPs  ================================================================================
           
             attach(data)
#add a variable "group" with strings defining groups (if no present in dataset)
            group <- conditie
            if (answer1 == 1) { #if longitudinal select only subjects with posttest
                group [which(group==1 & Longitudinal == 1)] <- "LSS"
                 group [which(group==2 & Longitudinal == 1)] <- "VWR"   
             }
            group [which(group==1)] <- "LSS"
            group [which(group==2)] <- "VWR"
            group [which(group==3)] <- "controlDysl"
            group [which(group==4)] <- "controlAge"
                   
            data<-cbind(group,data)
            rownames(data) <- data$ppnr
            
#READ TABLE WITH DESIGN in a Txt file ================================================================================
         
         #Read table created in separate file (.txt) containing WITHIN SS factors as columns and each level as rows:
                # Electrode	Type	Length
                #1	TP7	       w	  S
                #2	P5	       w      L
                # ...
        
          table.idata <- read.table(tablefile2read)
          electrodes <- table.idata$Electrode[1:length(levels(table.idata$Electrode))]   # read electrodes to analyse from table (levels of the Electrode factor)
                              # electrodes are in the same order as in the table (levels(...) will take them in alphabetic order)
        # Define within-SS Experimental variables
            Type = c("W","S")    # type of string
            Length = c("S", "L") # length of string
            suffix <- paste(peak,value,sep='')# depends on labels given to columns [in this case all end with PeakValue info (i.e.N1amp)]
        # In this case columns are labeled: electrode_LengthType_PeakValue (i.e; O1_SW_N1amp)
          cols2use <- {}
            for (e in 1:length(electrodes))
             {for (tp in 1:length(Type))
              {for (l in 1:length(Length))
               { if (tp == 1 & l == 1) {c <- e}
                 else if (tp == 1 & l == 2) { c <- length(electrodes) + e}
                 else if (tp == 2 & l == 1) { c <- 2*length(electrodes) + e}
                 else if (tp == 2 & l == 2) { c <- 3*length(electrodes) + e}
                      cols2use[c] <- (paste(paste(paste(electrodes[e],Length[l],sep="_"),Type[tp],sep=''),suffix,sep="_"))
              }}}
        
# SELECT DATA according to user defined  Between subjects #==============================================================================
        
#1 Use all groups
             if (answer3 == 1)
          {
          group <- factor(data$group)
          betweenSS <- "group"}
          
#2 Use only pretest data from [LSS training group+ Control dyslexia] vs Control [40ss vs 20ss]
        if (answer3 == 2)
                     { data <- subset(data,(data$group=="preLSS"| data$group=="controlDysl"| data$group=="controlAge"))
                        data <- cbind(data[,1],data[,2],data[,2],data[,3:length(data)]) #add extra column with "dyslexia"factor
                       colnames(data)[1:3] <- c("subject", "group", "dyslexia") # rename columns
                       for (row in 1:dim(data)[1])
                          {  dyslexia <- as.character(data$dyslexia)
                          if  (!is.na(match(dyslexia[row],"preLSS")) | !is.na(match(dyslexia[row],"controlDysl")))
                             {dyslexia[row] = "dyslectic"
                           }else {dyslexia[row] = "normalReader"}
                          data$dyslexia <- dyslexia
                          }
                       dyslexia <- factor(data$dyslexia)
                       betweenSS <- "dyslexia"
                       }        
#3 Use only dyslectics and pre-posttest data: LSS training group vs VWR training [18ss vs 19ss]
        #rearrange data if analysis is longitudinal
           if (answer3==3) # only if we want to look at prepost info
               {D <- data
                  D <- cbind(D$subject,D[cols2use])
                 colnames(D)[1]<- "subject"            # D contains all data from selected channels and value (all subjects pre and post)
        
                # P contains only  Post test of selected data
                tmp <- data.frame(matrix(nrow=dim(D[D$subject<400,])[1], ncol=length(D)))  # empty frame with dimensions = D (excluding Post test rows)
                tmp[,1] <-D$subject[D$subject<400]
                colnames(tmp)[2:length(colnames(tmp))] <- sub(paste(peak,value,sep=""),paste("POST_",paste(peak,value,sep=""),sep=""),cols2use[1:length(cols2use)])# label Post columns
                colnames(tmp)[1] <- "subject"
        
                  for (row in 1:dim(D[D$subject>400,])[1])
                   { matchrow <- which(tmp$subject ==  D[D$subject>400,]$subject[row]-400)
                         tmp[matchrow,-1] <- D[D$subject>400,][row,-1] }
                 #new group information (for new data set with post test as columns)
                      for (ss in 1:length(group))
                          { if  ((data[,1]>200 & data[,1]<300)[ss] == T) { group[ss] = "controlAge" }
                            else if  ((data$subject>=1 & data$subject<100)[ss] == T) { group[ss]="preLSS"}
                            else if  ((data$subject>300 & data$subject<400)[ss]==T) { group[ss]= "controlDysl"}
                            else if ((data$subject>=100 & data$subject<200)[ss] == T){ group[ss]="preVWR"}
                            else { group[ss]="-"}
                          }
                 group <-   subset(group,!group=="-")
                 data <- cbind(group,D[D$subject<400,],tmp[,-1])
                 attach(data)
                 group <- factor(data$group)
        
                }
                # check cases for drop outs, prune dataset
                    if (answer3 == 3)
                        { trainingType = c(1:dim(data)[1])
                                 colcheck <- (paste(paste(paste("P9",Length[2],sep="_"),Type[2],sep=''),suffix,sep="_"))
                                 colcheckpost <- paste(paste(paste(paste("P9",Length[2],sep="_"),"W",sep=''),"POST" ,sep="_"),
                                 suffix,sep="_" )
                            for (ss in 1:length(group))
                            # Check (with P9 electrode)that there is pre and post test data (no dropout)
                              { attach(data)
                              if (is.na(get(colcheck)[ss]==TRUE) | is.na(get(colcheckpost)[ss])==TRUE) {trainingType[ss] = "-"
                                 }else
                                   {  if (!is.na(match(group[ss],"preLSS"))) {trainingType[ss] = "LSS_training"}
                                   else if  (!is.na(match(group[ss],"preVWR"))){trainingType[ss] = "VWR_training"}
                                   else { trainingType[ss] = "-"}
                                   }
                               }
                                # remove rows without ss in groups of interest
                                data <- cbind(data,trainingType)
                                trainingType <- subset(trainingType,!trainingType=='-')
                                data <-subset(data,!data$trainingType=='-')
                                rownames(data) <- 1:dim(data)[1]
                         trainingType <- factor(data$trainingType)
                         betweenSS <- "trainingType"
                         }
#4 Analysis for 2 groups (manually selected)
        
if (answer3 == 4) 
     {#define data to use in analysis (containing the 2 groups specified)
      if(answer1==1){  #if longitudinal analysis remove "post"from groupname to search in data(posttest data is in the same row as pretest in data)         
           if (pmatch("post", group1,nomatch = 0) == 1) 
            {datagroup1 = data[!is.na(match(group,gsub("post","",group1))),]
            datagroup2 = data[!is.na(match(group,group2)),]
            } else if (pmatch("post", group2,nomatch = 0) == 1) 
            { datagroup1 = data[!is.na(match(group,group1)),]
            datagroup2 = data[!is.na(match(group,gsub("post","",group2))),] 
            } }
     else if (!answer1== 1)
     {      datagroup1 = data[!is.na(match(group,group1)),]
            datagroup2 = data[!is.na(match(group,group2)),]
            group <- factor(data$group)
      }
     betweenSS <- "group"}
        

# ======= Data to use in the model ====================================
#===============================================================================

  if (!answer1 == 1)
   {data2model <-as.matrix(rbind(group1,group2)[ ,match(paste("Pre",cols2use,sep = "_"),colnames(data))])
   # if longitudinal analysis is yes
   }else if (answer1 == 1) #take "POST" variables from the group defined as "post"
    {  if (pmatch("post", group1,nomatch = 0) == 1) 
       {datagroup1 <- datagroup1[,match(paste("Post",cols2use,sep = "_"),colnames(data))]
        datagroup2 <- datagroup2[ ,match(paste("Pre",cols2use,sep = "_"),colnames(data))]
        colnames(datagroup1) <- colnames (datagroup2)
        data2model <-as.matrix(rbind(datagroup1,datagroup2))
     } else if (pmatch("post", group2,nomatch = 0) == 1) 
     {datagroup1 <- datagroup1[,match(paste("Pre",cols2use,sep = "_"),colnames(data))]
      datagroup2 <- datagroup2[ ,match(paste("Post",cols2use,sep = "_"),colnames(data))] 
      colnames(datagroup1) <- colnames (datagroup2)
      data2model <-as.matrix(rbind(datagroup1,datagroup2))
     }  
    }    
    

 #-------------------------------------------------------------------
 # Linear model and ANOVA
 #====================================================================

# Linear model: data predicted by Between-SS
# ==========================================
formula <- paste("data2model~", betweenSS,sep='')# Last column indicates the group factor (made above in script according to input)
Lmodel=lm(formula) # data2model ~ BETWEEN factor
options(contrasts=c("contr.sum","contr.poly"))  # Option to use Type III SS in model SS

 # fit model in ANOVA
# ====================
 Electrode <- electrodes
 Time <- c("pre", "post")

  if (answer3 == 3)
  {rmANOVAlongitudinal=Anova(Lmodel,idata=table.idata, idesign =~ Type*Length*Electrode*PostTest, type="III")
  }else
  {rmANOVA=Anova(Lmodel,idata=table.idata, idesign =~ Type*Length*Electrode, type="III")}

# Get descriptive statistics  
  descriptives <- describeBy(data2model,get(betweenSS))
  setwd(diroutput)

 #export it to wordfile
if (answer3==4)
{  file2export <-paste(paste("rmANOVA",paste(group1,group2,sep=" "),sep="_"),peak,value)
}else {file2export <-paste(paste("rmANOVA",betweenSS,sep=" "),peak,value)}

if (answer3==3)
 { file2export <-paste(paste("rmANOVA_long",betweenSS,sep=" "),peak,value)
 capture.output(summary(rmANOVAlongitudinal),file=paste(file2export,".doc", sep="")) 
 }else  {capture.output(summary(rmANOVA),file=paste(file2export,".doc", sep=""))}
         
  capture.output(descriptives,file=paste(file2export,"_descript.doc", sep=""))

