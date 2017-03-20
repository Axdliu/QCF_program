library("Ecdat")
?CPSch3
data(CPSch3)
write.csv(CPSch3, file = "D:\\github\\QCF_program\\QCF_program\\Financial_data_analysis\\datasets\\5_19_1.csv",
          row.names = FALSE)
dimnames(CPSch3)[[2]]

male.earnings = CPSch3[CPSch3[,3]=="male",2]
sqrt.male.earnings = sqrt(male.earnings)
log.male.earnings = log(male.earnings)

par(mfrow=c(2,2))
qqnorm(male.earnings,datax=T,main="untransformed")
qqnorm(sqrt.male.earnings,datax=T,main="square-root transformed")
qqnorm(log.male.earnings,datax=T,main="log-transformed")

par(mfrow=c(2,2))
boxplot(male.earnings,main="untransformed")
boxplot(sqrt.male.earnings,main="square-root transformed")
boxplot(log.male.earnings,main="log-transformed")

par(mfrow=c(2,2))
plot(density(male.earnings),main="untransformed")
plot(density(sqrt.male.earnings),main="square-root transformed")
plot(density(log.male.earnings),main="log-transformed")


library("MASS")
par(mfrow=c(1,1))
bc2 = boxcox(male.earnings~1)
boxcox(male.earnings~1,lambda = seq(.3, .45, 1/100))
bc = boxcox(male.earnings~1,lambda = seq(.3, .45, by=1/100),interp=F)
ind = (bc$y==max(bc$y))
ind2 = (bc$y > max(bc$y) - qchisq(.95,df=1)/2)
bc$x[ind]
bc$x[ind2]

library("fGarch")
fit = sstdFit(male.earnings,hessian=T)
