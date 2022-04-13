d <- dir()
readLines(d[5])

 #only rep measures results (with uncorrected Ps)
 out <- as.character(capture.output(RMANO))

 as.character(capture.output(out))