#=====Load Packages=====
suppressWarnings(suppressMessages(c(library(devtools), library(ggmap), library(sp), library(classInt), library(plyr))))
suppressWarnings(suppressMessages(c(library(ggplot2), library(ggrepel), library(gridExtra), library(scales), library(png), library(grid), library(knitr), library(knitrBootstrap), library(rmarkdown), library(pander), library(xtable), library(XLConnectJars), library(XLConnect), library(gdxrrw), library(reshape), library(reshape2),library(scales),library(dplyr), library(RColorBrewer), library(R.utils), library(extrafont), library(maps), library(readxl), library(fields), library(ggthemes), library(plyr), library(stringr), library(lubridate)))) ; 


#Generate rainfall time-series
rain <- runif(100,min=0,max=10)  

rain_zero_place <- sample(1:100,size=30,replace = FALSE)
rain_zero_place

rain[rain_zero_place] <- 0
rain

#Logic array: whether rainfall>0 on certain day
whether_rain <- ifelse((rain>0),1,0)
whether_rain
 
#Logic array: whether rainfall>0 & rainfall in the former day >0
rain_1before <- c(0,rain[1:(length(rain)-1)])
whether_false_day <- ifelse((rain>0 & rain_1before>0),1,0)
whether_false_day

#Length of rainfall event
event <- rep(0,length(rain))

for (i in 1:length(rain)){
  current_event <- 0
  if (whether_rain[i]==1){current_event <- 1
  if (i!=length(rain)){
  for (j in ((i+1):length(rain))){
    ifelse(whether_rain[j]==1,current_event <- current_event+1,break)
  }
  }
  event[i] <- current_event
  }
}
event[whether_false_day==1] <- 0
event

#Amount of rainfall in each event
event_amount <- rep(0,length(rain))
for (i in 1:length(rain)){
  current_amount <- 0
  if (event[i]!=0){
    current_amount <- sum(rain[i:(i+event[i]-1)])
    event_amount[i] <- current_amount
  }
}
event_amount[whether_false_day==1] <- 0
event_amount

#Strength of rainfall, each event
event_strength <- event*event_amount
event_strength

#Final Matrix
Rain_Matrix <- cbind(seq(1,length(rain)),rain,event,event_amount,event_strength)
Rain_Matrix

Rain_Matrix_Ordered <- as.data.frame(Rain_Matrix) %>% arrange(desc(event_strength))
