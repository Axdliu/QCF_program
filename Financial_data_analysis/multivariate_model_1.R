data(CRSPday,package="Ecdat")
write.csv(CRSPday, file = "D:\\github\\QCF_program\\QCF_program\\Financial_data_analysis\\datasets\\eg_7_1.csv",
          row.names = FALSE)
ge = CRSPday[,4]
ibm = CRSPday[,5]
options(digits = 3)
cov(CRSPday[,4:7])
cor(CRSPday[,4:7])

plot(as.data.frame(CRSPday[,4:7]))

# figure 7.2
library("mnormt")
mu = rep(0,2)
cov1 = matrix(c(1,.5,.5,1),nrow=2)
cov2 = matrix(c(1,-.95,-.95,1),nrow=2)
t = seq(-2.5,2.5,.025)
ff1 <- function(x,x2){dmnorm(cbind(x,x2),mu,cov1)}
ff2 <- function(x,x2){dmnorm(cbind(x,x2),mu,cov2)}
par(mfrow=c(1,2))
contour(t,t,outer(t,t,ff1),xlab=expression(Y[1]),ylab=expression(Y[2]),
        cex.lab=1,cex.axis=1,labcex=.8,main="(a) corr = 0.5" )
contour(t,t,outer(t,t,ff2),xlab=expression(Y[1]),ylab=expression(Y[2]),
        cex.lab=1,cex.axis=1,labcex=1,main="(b) corr = -0.95" ,
        drawlabels=F)