# Repeated measures mixed model ( within-ss and between-ss factors)
#==================================================================
  rm (list = ls())
# INPUT array required: containing subjects as rows and all factors as columns("wide"data arrangement)
#Install package ( some might be unused)
  install.packages("R.utils")
  install.packages("reshape")
  install.packages("xlsx")
   install.packages("car")
  install.packages('gdata')
  install.packages("utils")
  install.packages("R.matlab")
#load libraries
  library(MASS)
  library(nnet)
  library(car)
  library(psych)
  library(reshape)
  library(xlsx)
  library(gdata)
  library(utils)
  library(R.matlab)
#Pop up windows for inputs to select data to plot
  answer <- menu(choices <- c("N1", "P1", "P2"), graphics = TRUE, title = "Select peak of interest")
  answer2 <- menu(choices2 <- c("amp", "lat"), graphics =TRUE, title = "Select values of interest")
  answer3 <- menu(choices3 <- c("allgroups", "PretestVsControl","LongitudinalTrainingGroups","manual selection of groups"),
               graphics =TRUE, title = "Select grouping factor")

     if (answer3 == 4) # if manual selection of groups choose now which groups
             { ansGroup1 <- menu(groupChoices <- c("preLSS", "preVWR","controlAge","controlDysl","postLSS","postVWR","slowDyslectics","fastDyslectics"), graphics =TRUE, title = "Select group1")
                ansGroup2 <- menu(groupChoices <- c("preLSS", "preVWR","controlAge","controlDysl","postLSS","postVWR","slowDyslectics","fastDyslectics"), graphics =TRUE, title = "Select group2")
                  group1 <- groupChoices[ansGroup1]
                  group2 <- groupChoices[ansGroup2]
                }

  peak <- choices[answer]
  value <- choices2[answer2]
  suffix =  paste(peak,value,sep='') # depends on labels given to olumns [in this case all end with PeakValue info (i.e.N1amp)]

#Define directory and file where to load data (in this case and .xls file)

    dirinput <-  "Y:/GORKA/Statistical Analysis/FRAND_R"
    diroutput <-  "Y:/GORKA/Statistical Analysis/FRAND_R"
                                                         
    filename <-  paste(paste("group",peak,sep = ''),"xls",sep=".")#  filename <-  "N1Pre&Post.xls"
    # table with design for the model
    tablefile2read = "Y:/GORKA/Statistical Analysis/FRAND_R/tableFactors14e.txt"
    if (answer3==3) { tablefile2read = "Y:/GORKA/Statistical Analysis/FRAND_R/tableFactors14e_post.txt"}
    # Directories
    setwd(dirinput)
    
# READ FILE     
    data <- read.xls(filename)# data <-read.xls(filename,sheet=answer) # sheets containing different peaks. Input tells which one to open
    attach(data)

# Define within-SS Experimental variables
    Type = c("W","S")    # type of string
    Length = c("S", "L") # length of string

  # Create extra column with grouping factor according to input

    group = c(1:dim(data)[1])
    iscntrl <- data[,1]>200 & data[,1]<300
    isdyscntrl <- data[,1]>300 & data[,1]<400
    isLSSpre <- data[,1]>=1 & data[,1]<100
    isVWRpre   <- data[,1]>=100 & data[,1]<200
    isLSSpost   <- data[,1]>=400 & data[,1]<500
    isVWRpost   <- data[,1]>=500
        for (ss in 1:length(group))
            { if  (iscntrl[ss] == T) { group[ss] = "controlAge" }
              else if  (isLSSpre[ss] == T) { group[ss]="preLSS"}
              else if  (isdyscntrl[ss] == T) { group[ss]= "controlDysl"}
              else if (isVWRpre[ss] == T){ group[ss]="preVWR"}
              else if   (isLSSpost[ss] == T){ group[ss]="postLSS"}
              else if  (isVWRpost[ss] == T){ group[ss]="postVWR"}
             }


    # Include group info in data
    data <- cbind(data[,1],group,data[,2:length(data)])
     colnames(data)[1] <- "subject"

# Load table and data of interest
#====================================================================================

 #Read table created in separate file (.txt) containing WITHIN SS factors as columns and each level as rows:
        # Electrode	Type	Length
        #1	TP7	       w	    S
        #2	P5	       w      L
        # ...

  table.idata <- read.table(tablefile2read)
  electrodes <- table.idata$Electrode[1:length(levels(table.idata$Electrode))]   # read electrodes to analyse from table (levels of the Electrode factor)
                      # electrodes are in the same order as in the table (levels(...) will take them in alphabetic order)

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


# Select data according to Between subjects factor selected
#===============================================================================

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
  {  if ((ansGroup1 >6) & (ansGroup2 > 7))   # if fast versus slow readers are selected
     { attach(data)
       slow <- c(1,3,7,8,9,14:18,21,301,302,304,307,308,309,318,320)
        fast <- c(4,5,6,10,11,19,303,305,306,310,311,312,313,314,315,317,319)}
      readingSpeed = c(1:dim(data)[1])
       for (ss in 1:length(subject))
        {
            {  if (!is.na(match(subject[ss],slow))) {readingSpeed[ss] = "slow"}
               else if  (!is.na(match(subject[ss],fast))) {readingSpeed[ss] = "fast"}
               else { readingSpeed[ss] = "-"}
              }
           }
         data <- cbind(data,readingSpeed)
         trainingType <- subset(readingSpeed,!readingSpeed=='-')
         data <-subset(data,!data$readingSpeed=='-')
         rownames(data) <- 1:dim(data)[1]
         readingSpeed <- factor(data$readingSpeed)
         betweenSS <- "readingSpeed"
     } else if      ((ansGroup1 < 6) & (ansGroup2 < 7))  
     {data <- subset(data,(data$group==group1 | data$group==group2))
      group <- factor(data$group)
      betweenSS <- "group"}


# Data to use in the model
#===============================================================================

  if (!answer3 == 3)
   {data2model <-as.matrix(data[ ,match(cols2use,colnames(data))])
   }else if (answer3 == 3)
    { cols2usePost <- as.vector(cbind(cols2use[1:length(cols2use)],sub(paste(peak,value,sep=""),paste("POST_",paste(peak,value,sep=""),sep=""),cols2use[1:length(cols2use)])))
    data2model <-as.matrix(data[ ,match(cols2usePost,colnames(data))])
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

