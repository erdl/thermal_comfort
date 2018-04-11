# See frog_uhm_thermal_comfort.Rmd for how this code works.

#sink("/dev/null")    # now suppresses print messages from package functions


args = commandArgs(trailingOnly=TRUE)

s <- suppressPackageStartupMessages
list.of.packages <- c("data.table", "lubridate","knitr","dygraphs")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages, repos = "http://cran.us.r-project.org")
s(library(data.table))
s(library(lubridate))
s(library(knitr))
s(library(dygraphs))


# test if there is exact two argument: if not, return an error
if (length(args)!=2) {
  stop("Format: <path_to_input_file> <path_to_output_file> (e.g. some/place/input.csv some/place/output.csv). Please use the template input file header.", call.=FALSE)
}



readings <- fread(args[1])

colnames(readings) <- c("ta","tr","vel","rh","met","clo") 
readings$wme <- 0

readings_si <- readings
#Convert F to C
readings_si$ta <- (readings$ta - 32)*(5/9)
readings_si$tr <- (readings$tr - 32)*(5/9)

# Convert fpm to m/s
readings_si$vel <- 0.00508 * readings$vel

#Load Google's Javscript Engine V8 (See https://cran.r-project.org/web/packages/V8/vignettes/v8_intro.html)
library(V8)
#Create a new context
ct <- v8()

#Load Javascript Library for forEach function
ct$source(system.file("js/underscore.js", package="V8"))
#Load local comfortModel javscript library (only modified the path of the libraries)
ct$source("comfortmodels.js")
ct$source("util.js")
ct$source("psychrometrics.js")

#Apply the function over all the table for pmvElevatedAirspeed
# returns [pmv, ppd]
# ta, air temperature (C)
# tr, mean radiant temperature (C)
# vel, relative air velocity (m/s)
# rh, relative humidity (%) Used only this way to input humidity level
# met, metabolic rate (met)
# clo, clothing (clo)
# wme, external work, normally around 0 (met)
pmv_elevated_air <- data.table(invisible(ct$call("_.map", readings_si, JS("function(x){return(comf.pmvElevatedAirspeed(x.ta,x.tr,x.vel,x.rh,x.clo,x.met,x.wme))}"))))

pmv_elevated_air <- cbind(readings,pmv_elevated_air)


fwrite(pmv_elevated_air,args[2])

#sink() #end supression of print message
