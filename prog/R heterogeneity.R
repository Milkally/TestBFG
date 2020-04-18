D<-read.table('meap00_01.raw')
names(D)<-c('dcode','bcode','math4','read4','lunch','enroll','exppp','lenroll','lexppp')
attach(D)

lm1<-lm(math4~lunch+lenroll+lexppp,data=D)
summary(lm1)

lm11<-lm(lunch~lenroll+lexppp)
se1<-sqrt(t(lm11residual2)residual^2)%*%lm1residual^2/(sum(lm11$residual^2))^2)
se1
lm12<-lm(lenroll~lunch+lexppp)
se2<-sqrt(t(lm12residual2)residual^2)%*%lm1residual^2/(sum(lm12$residual^2))^2)
se2
lm13<-lm(lexppp~lenroll+lunch)
se3<-sqrt(t(lm13residual2)residual^2)%*%lm1residual^2/(sum(lm13$residual^2))^2)
se3

coeftest(lm1, vcov=sandwich)