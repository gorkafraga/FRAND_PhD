# Repeated measures mixed model ( within-ss and between-ss factors)
#==================================================================
# clear all variables of current workspace
  rm (list = ls())

# INPUT array required: containing subjects as rows and all factors as columns("wide"data arrangement)
# load packages & libraries

	libraries2load <- c("heplots","psych","Hmisc", "MASS","foreign", "nnet", "R.utils","reshape","xlsx", "car", "gdata", "utils", "R.matlab")
	require(libraries2load)
	lapply(libraries2load, require,character.only = T)
	do.call("require", list(libraries2load))

#Define directories
    dirinput <-  "Y:/GORKA/Statistical Analysis/FRAND_R"
    diroutput <-  "Y:/GORKA/Statistical Analysis/FRAND_R"

#Pop up windows for inputs to select data to analyse
  answer <- menu(choices <- c("N1", "P1", "P2"), graphics = TRUE, title = "Select peak of interest")
  islong <- menu(choices1 <- c("Yes", "No"), graphics = TRUE, title = "Longitudinal Analysis?")
  answer2 <- menu(choices2 <- c("amp", "lat"), graphics =TRUE, title = "Select values of interest")
  ansGroup1 <- menu(groupChoices <- c("LSS", "VWR","controlAge","controlDysl","postLSS","postVWR"), graphics =TRUE, title = "Select group1")
  ansGroup2 <- menu(groupChoices <- c("LSS", "VWR","controlAge","controlDysl","postLSS","postVWR"), graphics =TRUE, title = "Select group2")

  peak <- choices[answer]
  value <- choices2[answer2]
  group1 <- groupChoices[ansGroup1]
  group2 <- groupChoices[ansGroup2]
  groups2use = cbind(group1,group2)

# ======= LOAD DATA ==========================================

# go to directory
    setwd(dirinput)
# Define filename (spss data file)
        filename <-  "FRAND_BERP_NOR.sav"
# Define  table with the design for the model (it will be read later)
    tablefile2read = "Y:/GORKA/Statistical Analysis/FRAND_R/tableFactors14e.txt"
    if (islong==1) { tablefile2read = "Y:/GORKA/Statistical Analysis/FRAND_R/tableFactors14e_post.txt"}
# READ DATA FILE
 data <- read.spss(filename, use.value.labels = TRUE, to.data.frame = TRUE,
			max.value.labels = Inf, trim.factor.names = FALSE,
			trim_values = TRUE, reencode = NA, use.missings = to.data.frame)

 # Check in which group the data is posttest
ispost <- pmatch("post",groups2use)

# ADD a variable "group" with strings defining groups (if no present in dataset)
attach(data)        
          group <- conditie
        # select only subjects that have posttest  from the training groups
          group [which(conditie==1 & Longitudinal == 1)] <- "LSS"
          group [which(group==2 & Longitudinal == 1)] <- "VWR"
          group [which(conditie==3)] <- "controlDysl"
          group [which(conditie==4)] <- "controlAge"

data<-cbind(group,data)
rownames(data) <- data$ppnr

#if (!is.na(ispost) == T)      
 #{data[which((group==gsub("post","",groups2use[ispost]))
  #& is.na(Longitudinal)==T),]$group <- 0  }


    
# ======= SELECT DATA FOR EACH GROUP =======================
# Selects rows and columns from full DATA with cols and row names specified above
    
 
#** LONGITUDINAL 
 if (islong == 1){
      data2use <- subset(data,(data$group==groups2use[-ispost]|data$group==gsub("post","",groups2use[ispost])))
    } else {   
#** NO LONGITUDINAL   
    if (!is.na(ispost) == T){ #if one group has Posttest
     data2use <- subset(data,(data$group==groups2use[-ispost]|data$group==gsub("post","",groups2use[ispost])))             
      
      #if there is NO POSTTEST data     
     } else if (is.na(ispost) == T){ 
           data2use <- subset(data,(data$group==groups2use[1]|data$group==groups2use[2]))                 
        }}   
    group <- factor(data2use$group)
    betweenSS <- "group"  
               
# ======= DEFINE COLUMNS FOR EACH GROUP =======================
                  
#READ TABLE WITH DESIGN in a Txt file ================================================================================
               
         #Read table created in separate file (.txt) containing WITHIN SS factors as columns and each level as rows:
                # Electrode	Type	Length
                #1	TP7	       w	  S
                #2	P5	       w      L
                # ...

  table.idata <- read.table(tablefile2read)
  Electrode <- c("TP7-TP8","P5-P6","P7-P8","P9-P10","PO7-PO8","PO3-PO4","O1-O2")
  PostTest <- c("pre", "post")
  Hemisphere <- c("L", "R")
 # Define within-SS Experimental variables
    electrodes <- c("TP7","P5","P7","P9","PO7","PO3","O1","TP8","P6","P8","P10","PO8","PO4","O2")
    Type = c("W","S")    # type of string
    Length = c("S", "L") # length of string
    suffix <- paste(peak,value,sep='')# depends on labels given to columns [in this case all end with PeakValue info (i.e.N1amp)]
 # BAsic label of columns is: Pre(or Post)_electrode_LengthType_PeakValue (i.e; Pre_O1_SW_N1amp ). Pretest data (Pre_**) used as default 
  # select the columns with the variables of interest  
    cols2use <- {}
      for (e in 1:length(electrodes))
       {for (tp in 1:length(Type))
        {for (l in 1:length(Length))
         { if (tp == 1 & l == 1) {c <- e}
           else if (tp == 1 & l == 2) { c <- length(electrodes) + e}
           else if (tp == 2 & l == 1) { c <- 2*length(electrodes) + e}
           else if (tp == 2 & l == 2) { c <- 3*length(electrodes) + e}
      cols2use[c] <- paste("Pre",(paste(paste(paste(electrodes[e],Length[l],sep="_"),Type[tp],sep=''),suffix,sep="_")),sep="_")
        }}}
 # col names for post test data: 
    cols2usePost <- gsub("Pre","Post", cols2use)
    

# === SELECT VARIABLES TO USE IN THE MODEL ========================= ========== ====
if (islong == 1) {    #if longitudinal
   data2model <- cbind(as.matrix(data2use[ ,match(cols2use,colnames(data2use))]),
                    as.matrix(data2use[ ,match(cols2usePost,colnames(data2use))]))

  }else{ #if not longitudinal 
   if (!is.na(ispost) == T){ #if one group has Posttest
     data1 <- as.matrix(data2use[data2use$group==groups2use[-ispost],match(cols2use,colnames(data2use))])
     data2 <- as.matrix(data2use[data2use$group==gsub("post","",groups2use[ispost]),match(cols2usePost,colnames(data2use))])
     data2 <-data2[complete.cases(data2),]
    # rename cols after rbind (avoid conflict btw pre-post colnames)  
     colnames(data1) <-gsub("Pre_","",colnames(data1))
     colnames(data2) <-gsub("Post_","",colnames(data2)) 
     data2model <- as.matrix(rbind(data1,data2)) 
        #if there is NO POSTTEST data     
     } else if (is.na(ispost) == T){ 
        data2model <- as.matrix(data2use[ ,match(cols2use,colnames(data2use))])
     }}
         
 #-------------------------------------------------------------------
 # Linear model and ANOVA
 #====================================================================
 # Linear model: data predicted by Between-SS
# ==========================================
 
if (islong == 1){
    formula <- paste("data2model~1")
    Lmodel = lm(formula)
    options(contrasts=c("contr.sum","contr.poly"))  # Option to use Type III SS in model SS
 } else 
    { 
    formula <- paste("data2model~", betweenSS,sep='')
    Lmodel = lm(formula)
    options(contrasts=c("contr.sum","contr.poly"))  # Option to use Type III SS in model SS
    } 
 
# Use model in ANOVA
# ==========================================               
 
 if (islong == 1){
 RANO =Anova(Lmodel,idata=table.idata,
        idesign =~PostTest*Type*Length*Hemisphere*Electrode, type="III")

 } else {    # don't include PostTest factor if longitudinal = no
   RANO =Anova(Lmodel,idata=table.idata,
        idesign =~Type*Length*Hemisphere*Electrode, type="III")
 }  
  
  effectsizes <- etasq(RANO, anova = FALSE) # calculate eta square (default:not printed in file)


# Get DESCRITIVES statistics
# ========================================== 
  descriptives <- describeBy(data2model,get(betweenSS))  
  setwd(diroutput)

 #export it to wordfile
  if (islong==1) {
  file2export <-paste(paste("RANO_long",group1,sep=" "),peak,value)
  } else {
  file2export <-paste(paste("RANO",paste(group1,group2,sep=" "),sep="_"),peak,value)
  }
  capture.output(summary(RANO),file=paste("full",paste(file2export,".txt", sep=""),sep="_"))
  capture.output(effectsizes,file=paste("etsq",paste(file2export,".txt", sep=""),sep="_"))

  #capture.output(RMANO,file=paste(file2export,".txt", sep="")) #only saves manova! 

#only rep measures results (with uncorrected Ps?)
 #out <- as.data.frame(capture.output(RMANO))
 # capture.output(descriptives,file=paste(file2export,"_descript.doc", sep=""))

