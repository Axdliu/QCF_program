setwd('D:\\github\\QCF_program\\QCF_program\\Financial_data_analysis\\datasets\\')

rm(list=ls())# clearing

a=read.table("roe01.txt",header=T)#read table
round(a[1:10,],4)#first 10 rows, 4 digits after decimal point
a1=a
Mean=sapply(a1,mean)#mean per column
Min=sapply(a1,min)# min per column
Median=sapply(a1,median)#median
Max=sapply(a1,max)#max
SD=sapply(a1,sd)#standard deviation
cbind(Mean,Min,Median,Max,SD)#combine
round(cor(a),3)#correlation, up to 3 digits after decimal points
plot(a1$ROEt,a1$ROE)#plot ROE versus ROEt
lm1=lm(ROE~ROEt+ATO+PM+LEV+GROWTH+PB+ARR+INV+ASSET,data=a1)
#fit the linear model, via least squares
summary(lm1)#summary of results
round(a1[1:10,],3)#first 10 rows again
par(mfrow=c(2,2))#drawing in 2 by 2 format
plot(lm1,which=c(1:4)) #plot four figures corresponding to lm1,Residual,QQ, Cook-distance
a1=a1[-47,]#remove row 47
lm2=lm(ROE~ROEt+ATO+PM+LEV+GROWTH+PB+ARR+INV+ASSET,data=a1) #fit regression line again save in lm2
plot(lm2,which=c(1:4)) # plot four figures for lm2
library(car)#load package car
round(vif(lm2),2)#variance inflation factors
lm.aic=step(lm2,trace=F)#AIC model selection
summary(lm.aic)# present
lm.bic=step(lm2,k=log(length(a1[,1])),trace=F)#BIC model selection
summary(lm.bic)#present