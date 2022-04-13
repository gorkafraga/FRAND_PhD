
install.packages('foreign')
library(foreign)
install.packages('pwr')
library(pwr)
setwd ('H:/GORKA/Statistical Analysis/FRAND_SPSS/Analysis Responses Excluded')
frand <- read.spss('FRAND_BERP_NOR.sav', to.data.frame=T)

ctrlpwr <- pwr.r.test(n = 20, r = 0., sig.level = 0.05, power = NULL, 
			alternative = c("two.sided", "less","greater"))
dyslpwr <- pwr.r.test(n = 40, r = 0.40, sig.level = 0.05, power = NULL, 
			alternative = c("two.sided", "less","greater"))