# -----安装和载入包-----
install.packages("wpp2019")
library("wpp2019")


# -----加载数据-----
# 加载历史数据进global environment：男性/女性，各国分年龄段人口
data(popM)
data(popF)
data(pop)
data(mxM)
# 加载未来预测数据进global environment：男性/女性，各国分年龄段人口
data("popMprojMed")
data("popFprojMed")


#-----处理数据-----
#Copy to process(for not touching raw data)
popF_1 <- popF;popF_1$sex="F"
popM_1 <- popM;popM_1$sex="M"
popFprojMed_1 <- popFprojMed;popFprojMed_1$sex="F"
popMprojMed_1 <- popMprojMed;popMprojMed_1$sex="M"


#For getting full contry list
write.table(popF_1,append = FALSE,file="C:\\Users\\user\\Desktop\\popF.csv",sep=",",row.names = F,col.names = T)
Country_list <- unique(popFinal$name)


# Historical population
popTotal <- popF_1
COLS <- colnames(popF_1[,4:18])

popTotal[,1:3] <- popF_1[,1:3]
popTotal[,4:18]<-popF_1[,4:18]+popM_1[,4:18]
popTotal$sex <- "Both"


# Projected future population(Med projection)
popFuture <- popFprojMed_1
COLS_Future <- colnames(popFuture[,4:19])

popFuture[,1:3] <- popFprojMed_1[,1:3]
popFuture[,4:19]<-popFprojMed_1[,4:19]+popMprojMed_1[,4:19]
popFuture$sex <- "Both"


#  Get final Population Matrix
popFinal <- popTotal[,1:18]
popFinal[,19:34] <- popFuture[,4:19]
# merge(popTotal,popFuture,by=c("name"), all.x = TRUE) 


# Calculate total population of Sum all ages
# for (i in Country_list){
#   popFinal[popFinal$i]
# }

# 要不还是在GAMS里面做吧
write.table(as.character(popFinal$age),append = FALSE,file="C:\\Users\\user\\Desktop\\age.csv",sep=",",row.names = F,col.names = T,fileEncoding = "UTF-8")


#----View and Check----
head(popFuture)
library("reshape")
melt_popFuture <- melt(popFuture, id.vars=c("country_code","name","age"), measure.vars=c("2025","2030","2035","2040","2045","2050","2055","2060","2065","2070","2075","2080","2085","2090","2095","2100"), variable.name="year", value.name="Population")
colnames(melt_popFuture) <- c("country_code","country","age","year","Population")
popFuture_Check1 <- subset(melt_popFuture,(country %in% "World") & (year %in% c("2050")) )
# popFuture <- subset(popFuture,  (name %in% "World") & (year %in% c("2005","2010","2020","2030","2050","2100")) )
popFuture_Check1['sum'] <- sum(popFuture_Check1[1:21,5])


# ----
rm(Temp_popF)
rm(popMT,popFT)
rm(popM_1,popF_1,popFprojMed_1,popMprojMed_1)
rm(popFuture_Check1)