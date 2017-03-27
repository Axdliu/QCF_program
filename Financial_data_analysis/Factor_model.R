###########  R script for Chapter 18  ####################################################
###########  of Statistics and Data Analysis for Financial Engineering, 2nd Edition ######
###########  by Ruppert and Matteson  ####################################################

####################################################################
############  Code for Example 18.2 and Figure 18.1  ###############
####################################################################

setwd('D:\\github\\QCF_program\\QCF_program\\Financial_data_analysis\\datasets\\')
datNoOmit = read.table("treasury_yields.txt",header=T)
diffdatNoOmit = diff(as.matrix(datNoOmit[,2:12]))
dat=na.omit(datNoOmit)
diffdat = na.omit(diffdatNoOmit)
n = dim(diffdat)[1]
options(digits=5)
pca = prcomp(diffdat)

summary(pca)
# The first row gives the values of ?????i, 
# the second row the values of ??i/(??1+· · · + ??d), and 
# the third row the values of (??1 + · · · + ??i)/(??1 + · · · + ??d) for i = 1, . . . , 11.

###  Figure 18.1
par(mfrow=c(2,2))
time = c(1/12,.25,.5,1, 2, 3, 5, 7, 10, 20, 30)

#  (a) Treasury yields on three dates.
plot(time,as.vector(dat[1,2:12]),ylim=c(0,6),type="b",lty=1,lwd=2,
     ylab="Yield",xlab="T",main="(a)") #,log="x",xaxs="r")
lines(time,as.vector(dat[486,2:12]),type="b",lty=2,lwd=2,col="red")
lines(time,as.vector(dat[n+2,2:12]),type="b",lty=3,lwd=2,col="blue")
legend("bottomright",c("07/31/01","07/02/07","10/31/08"),lty=c(1,2,3),lwd=2,
       cex=1, col=c("black","red","blue"))

# (b) Scree plot for the changes in Treasury yields. 
# Note that the first three principal components have most of the
# variation, and the first five have virtually all of it. 
plot(pca,main="(b)")

#  (c) The first three eigenvectors
# for changes in the Treasury yields
plot(time,pca$rotation[,1],,ylim=c(-.8,.8),type="b",lwd=2,ylab="PC",xlab="T",
     main="(c)")
lines(time,pca$rotation[,2],lty=2,type="b",lwd=2,col="red")
lines(time,pca$rotation[,3],lty=3,type="b",lwd=2,col="blue")
lines(0:30,0*(0:30),lwd=1)
legend("bottomright",c("PC 1","PC 2","PC 3"),lty=c(1,2,3),lwd=2,col=c("black","red","blue"))

# (d) The first three eigenvectors for changes in
# the Treasury yields in the range 0 ??? T ??? 3
plot(time,pca$rotation[,1],ylim=c(-.8,.8),type="b",lwd=2,ylab="PC",xlab="T",
     xlim=c(0,3),main="(d)")
lines(time,pca$rotation[,2],lty=2,type="b",lwd=2,col="red")
lines(time,pca$rotation[,3],lty=3,type="b",lwd=2,col="blue")
lines(0:30,0*(0:30),lwd=1)
legend("bottomright",c("PC 1","PC 2","PC 3"),lty=c(1,2,3),lwd=2,col=c("black","red","blue"))

##################################################
############  Code for Figure 18.2  ###############
##################################################

# (a) The mean yield curve plus and minus the first eigenvector.
mu = apply(dat[,2:12],2,mean)
par(mfrow=c(2,2))
plot(time,mu,ylim=c(2.75,4.65),type="b",lwd=4,xlab="T",ylab="Yield",
     main="(a)",xlim=c(0,7),col="black")
lines(time,mu+pca$rotation[,1],lty=5,type="b",lwd=2,col="red")
lines(time,mu-pca$rotation[,1],lty=5,type="b",lwd=2,col="blue")
legend("bottomright",c("mean","mean + PC1",
                       "mean -  PC1"),lty=c(1,5,5),lwd=c(4,2,2),col=c("black","red","blue"))


# (b) The mean yield curve plus and minus the second eigenvector.
plot(time,mu,ylim=c(2.75,4.65),type="b",lwd=4,xlab="T",ylab="Yield",
     main="(b)", xlim=c(0,7))
lines(time,mu+pca$rotation[,2],lty=5,type="b",lwd=2,col="red")
lines(time,mu-pca$rotation[,2],lty=5,type="b",lwd=2,col="blue")
legend("bottomright",c("mean","mean + PC2","mean -  PC2"),lty=c(1,5,5),
       lwd=c(4,2,2),col=c("black","red","blue"))

# (c) The mean yield curve plus and minus the third eigenvector. 
plot(time,mu,ylim=c(2.75,4.65),type="b",lwd=4,xlab="T",ylab="Yield",
     main="(c)",xlim=c(0,7))
lines(time,mu+pca$rotation[,3],lty=5,type="b",lwd=2,col="red")
lines(time,mu-pca$rotation[,3],lty=5,type="b",lwd=2,col="blue")
legend("bottomright",c("mean","mean + PC3",
                       "mean -  PC3"),lty=c(1,5,5),lwd=c(4,2,2),col=c("black","red","blue"))

#  (d) The fourth and fifth eigenvectors for changes in the Treasury yields.
par(lwd=1)
plot(time,pca$rotation[,4],ylim=c(-.7,.7),type="b",lwd=2,ylab="PC",xlab="T",
     xlim=c(0,30),main="(d)")
lines(time,pca$rotation[,5],lty=5,type="b",lwd=2,col="red")
lines(0:30,0*(0:30),lwd=1)
legend("topright",c("PC 4","PC 5"),lty=c(1,5,5),lwd=2,col=c("black","red"))



###########################################################
############  Code for Figure 18.3 and 18.4 ###############
###########################################################

# Time series plots of the first three principal components of the Treasury
# yields. There are 819 days of data, but they are not consecutive because of missing
# data; see text.
par(mfrow=c(1,3))
for (i in 1:3){
        plot(pca$x[,i],main=paste("PC",toString(i)),xlab="day",
             ylab="")}

# 
acf(pca$x[,1:3],ylab="",xlab="lag")


#####################################################################
############  Code for Example 18.3 and Figure 18.5   ###############
#####################################################################S

# Principal components analysis of equity funds
# The variables are daily
# returns from January 1, 2002 to May 31, 2007 on eight equity funds: EASTEU,
# LATAM, CHINA, INDIA, ENERGY, MINING, GOLD, and WATER.
equityFunds = read.csv("equityFunds.csv")
equityFunds[1:10,]
pairs(equityFunds[,2:9])
pcaEq = prcomp(equityFunds[,2:9])
summary(pcaEq)

par(mfrow=c(1,2))
plot(pcaEq,main="(a)")
Names = names(equityFunds)[2:9]

plot(pcaEq$rotation[,1],type="b",ylab="PC",lwd=2,ylim=c(-1.4,2),main="(b)")
lines(pcaEq$rotation[,2],type="b",lty=2,lwd=2,col="red")
lines(pcaEq$rotation[,3],type="b",lty=3,lwd=2,col="blue")
lines(0:9,0*(0:9))
legend("top",c("PC1","PC2","PC3"),lty=c(1,2,3),lwd=2,cex=.65,col=c("black", "red", "blue"))
text(4.35,-1.25, "   EASTEU   LATAM   CHINA   INDIA   ENERGY   MINING   GOLD   WATER",cex=.38)


#####################################################
############  Code for Example 18.4   ###############
#####################################################
DowJones30 = read.csv("DowJones30.csv")
pcaDJ = prcomp(DowJones30[,2:31])
summary(pcaDJ)

#####################################################################
############  Code for Example 18.5 and Figure 18.6   ###############
#####################################################################

# the factors in a macroeconomic model are not the macroeconomic variables 
# themselves, but rather the residuals when changes in the macroeconomic 
# variables are predicted from past data by a time series model, 
# such as, a multivariate AR model.

CPI.dat = read.csv("CPI.dat.csv")
IP.dat = read.csv("IP.dat.csv")
berndtInvest = read.csv("berndtInvest.csv")
berndt = as.matrix(berndtInvest[,-1])   #  1978-01-01 to 1987-12-01
CPI.dat = read.csv("CPI.dat.csv")
IP.dat = read.csv("IP.dat.csv")
berndt = as.matrix(berndtInvest[,-1])   #  1978-01-01 to 1987-12-01
CPI2 = as.matrix(CPI.dat$CPI[775:900]) #  1977-07-30  to 1987-12-31
CPI = as.data.frame(diff(log(CPI2)))  
names(CPI)[1]="CPI"
IP2 = as.matrix(IP.dat$IP)[703:828,]   #  1977-07-28 to 1987-12-28 
IP = as.data.frame(diff(log(IP2)))
names(IP)[1] = "IP"
CPI_IP = cbind(CPI,IP)
arFit = ar(cbind(CPI,IP))
res = arFit$resid[6:125,]
lmfit = lm(berndt[,2:10]~res[,1]+res[,2])
slmfit = summary(lmfit)
rsq=rep(0,9)
for (i in 1:9){rsq[i]= slmfit[[i]][[8]]}
beta_CPI = lmfit$coef[2,]
beta_IP = lmfit$coef[3,]
par(mfrow=c(1,3))
barplot(rsq,horiz=T,names=names(beta_CPI),main="R squared")
barplot(beta_CPI,hori=T,main="beta CPI")
barplot(beta_IP,hori=T,main="beta IP")


#########################################################################################
############  Code for Examples 18.6 and 18.7 and Figures 18.7 and 18.8   ###############
#########################################################################################S
#  Uses monthly data from Jan-69 to Dec-98

FF_data = read.table("FamaFrench_mon_69_98.txt",header=T)
attach(FF_data)
library("Ecdat")
library("robust")
data(CRSPmon)
ge = 100*CRSPmon[,1] - RF
ibm = 100*CRSPmon[,2] - RF
mobil = 100*CRSPmon[,3] - RF
stocks=cbind(ge,ibm,mobil)
fit = lm(cbind(ge,ibm,mobil)~Mkt.RF+SMB+HML)
options(digits=3)
fit
# The coefficients of HML indicate that GE and Mobil are value stocks and IBM is a growth stock.

pairs(cbind(ge,ibm,mobil,Mkt.RF,SMB,HML))
# use ctrl+shift+C to comment out block
# Focusing on GE, we see that, as would be expected,
# GE excess returns are highly correlated with the excess market returns. The
# GE returns are negatively related with the factor HML which would indicate that GE behaves as a growth stock, since it moves in the same direction
# as low BE/ME stocks and in the opposite direction of high BE/ME stocks.
# However, this is a false impression caused by the lack of adjustment for associations between GE excess returns and the other factors. Regression analysis
# will be used soon to address this problem. The two Fama-French factors are
# not quite hedge portfolios since SMB is positively and HML negatively related to the excess market return. However, these associations are far weaker
# than that between the excess returns on the stocks and the market excess
# returns. Moreover, SMB and HML have little association between each other,
# so multicollinearity is not a problem.


# check for cross-correlations
cor(fit$residuals)
covRob(fit$residuals,cor=T)
cor.test(fit$residuals[,1], fit$residuals[,2])
cor.test(fit$residuals[,1], fit$residuals[,3])
cor.test(fit$residuals[,2], fit$residuals[,3])

pairs(fit$residuals)


################################################################
########## Code for Example 18.7   #############################
################################################################

# upside is that there is less bias
# The downside of the factor
# model is that there will be bias in the estimate of ??R if the factor model is
# misspecified, especially if ?? is not diagonal as the factor model assumes.
# Another advantage of the factor model is expediency. Having fewer parameters to estimate is one convenience and another is ease of updating. Suppose
# a portfolio manager has implemented a factor model for n equities and now
# needs to add another equity. If the manager uses the sample covariance matrix, then the n sample covariances between the new return time series and
# the old ones must be computed. This requires that all n of the old time series
# be available. In comparison, with a factor model, the portfolio manager needs
# only to regress the new return time series on the factors. Only the p factor
# time series need to be available.

sigF = as.matrix(var(cbind(Mkt.RF,SMB,HML)))
bbeta = as.matrix(fit$coef)
bbeta = t( bbeta[-1,])
n=dim(CRSPmon)[1]
sigeps = (n-1)/(n-4) * as.matrix((var(as.matrix(fit$resid))))
sigeps = diag(as.matrix(sigeps))
sigeps = diag(sigeps,nrow=3)
cov_equities = bbeta %*% sigF %*% t(bbeta) + sigeps

options(digits=5)
sigF
bbeta
sigeps
bbeta %*% sigF %*% t(bbeta)
cov_equities   # covariance estimated based on factor models
cov(stocks)    # sample covariance
# The largest difference between the estimate of ??T??F ?? + ?? and the sample
# covariance matrix is in the covariance between the excess returns on GE and
# Mobil. The reason for this large discrepancy is that the factor model assumes
# a zero residual correlation between these two variables, but, as we learned
# earlier, the data show a negative correlation of ???0.25

###############################################################################
############  Code for Example 18.8 and Figures 18.9 and 18.10  ###############
###############################################################################

#  Cross-Sectional Factor Models
# time series factor models do not make use of variables
# such as dividend yields, book-to-market value, or other variables 
# specific to the jth firm.
# An alternative is a cross-sectional factor model, which is a regression
# model using data from many assets but from only a single holding period.

# There are two fundamental differences between time series factor models
# and cross-sectional factor models. The first is that with a time series factor
# model one estimates parameters, one asset at a time, using multiple holding
# periods, while in a cross-sectional model one estimates parameters, one single
# holding period at a time, using multiple assets. The other major difference
# is that in a time series factor model, the factors are directly measured and
# the loadings are the unknown parameters to be estimated by regression. In
# a cross-sectional factor model the opposite is true; the loadings are directly
# measured and the factor values are estimated by regression.

berndtInvest = read.csv("berndtInvest.csv")
returns = berndtInvest[,-c(1,11,18)]
ind_codes = as.factor(c(3,3,2,1,1,2,3,3,1,2,2,3,1,2,3))
codes = as.matrix(model.matrix(~ind_codes))
codes[,1] =  1 - codes[,2] - codes[,3]
betas = as.data.frame(codes)
rownames(betas) = colnames(berndtInvest[,-c(1,11,18)])
betas

factors = matrix(0,nrow=120,ncol=3)
for (i in 1:120)
{
        return_data = cbind(t(returns[i,]),betas)
        colnames(return_data)[1] = "return"
        lmfit = lm(return~betas[,1] + betas[,2], data=return_data)
        factors[i,]= lmfit$coef
}

###  Figure 18.9
par(mfrow=c(1,3),cex.axis=1.08,cex.lab=1.08,cex.main=1.05)
plot(factors[,1],type="b",lty="dotted",
     lwd=2,xlab="month",ylab="factor",main="market")
plot(factors[,2],lty="dotted",lwd=2,type="b",
     xlab="month",ylab="factor",main="technology")
plot(factors[,3],lty="dotted",lwd=2,type="b",
     xlab="month",ylab="factor",main="oil")


colnames(factors) = c("market","tech","oil")
cor(factors)
options(digits=2)
sqrt(diag(cov(factors)))

###  Figure 18.10
acf(factors,ylab="",xlab="lag")


################################################################
############  Code for Examples 18.9 and 18.10   ###############
################################################################

equityFunds = read.csv("equityFunds.csv")
fa_none = factanal(equityFunds[,2:9],4,rotation="none")
fa_vari = factanal(equityFunds[,2:9],4,rotation="varimax")
print(fa_none,cutoff=0.1)
print(fa_vari,cutoff=0.1,sort=T)
print(fa_vari,cutoff=0.1)
sum(fa_vari$loadings[,1]^2)
B=fa_vari$loadings[,]

B_none = fa_none$loadings[,]
BB_none = B_none %*% t(B_none)
D_none = diag(fa_none$unique)
Sigma_R_hat = BB_none + D_none
t(B_none) %*% solve(D_none) %*% B_none

options(digits=3)

diff = Sigma_R_hat - fa_vari$corr
product = solve(Sigma_R_hat) %*% fa_vari$corr
max(diff)
min(diff)
eig_diff = eigen(diff)
sort(eig_diff$values)

w = matrix(1/8,nrow =1,ncol=8)
w %*% BB_none %*% t(w)
w %*% fa_vari$corr %*% t(w)
w %*% eig_diff$vectors %*% t(w)

t(B) %*% diag(1/fa_vari$unique) %*% B
t(BB_none) %*% diag(1/fa_none$unique) %*% BB_none

##################################################
############  Code for the R lab   ###############
##################################################

################################################################
########## Code for Section 18.8.1   ###########################
################################################################

yieldDat = read.table("yields.txt",header=T)
maturity = c((0:5),5.5,6.5,7.5,8.5,9.5)
pairs(yieldDat)
par(mfrow=c(4,3))
for (i in 0:11)
{
        plot(maturity,yieldDat[100*i+1,],type="b")
}

eig = eigen(cov(yieldDat))
eig$values
eig$vectors
par(mfrow=c(1,1))
barplot(eig$values)

par(mfrow=c(2,2))
plot(eig$vector[,1],ylim=c(-.7,.7),type="b")
abline(h=0)
plot(eig$vector[,2],ylim=c(-.7,.7),type="b")
abline(h=0)
plot(eig$vector[,3],ylim=c(-.7,.7),type="b")
abline(h=0)
plot(eig$vector[,4],ylim=c(-.7,.7),type="b")
abline(h=0)


library("tseries")
adf.test(yieldDat[,1])

n=dim(yieldDat)[1]
delta_yield = yieldDat[-1,] - yieldDat[-n,]

par(mfrow=c(1,1))
pca_del = princomp(delta_yield)
names(pca_del)
summary(pca_del)
plot(pca_del)

fa_none_5 = factanal(equityFunds[,2:9],5,rotation="none")  ## Does not run


################################################################
########## Code for Section 18.8.2    ##########################
################################################################

#  Extracts daily data 2004-2005 from FamaFrenchDaily.txt

stocks = read.csv("Stock_FX_Bond_2004_to_2005.csv",header=T)
attach(stocks)
stocks_subset=as.data.frame(cbind(GM_AC,F_AC,UTX_AC,MRK_AC))
FF_data0 = read.table("FamaFrenchDaily.txt",header=T)
dat = FF_data0[FF_data0$date > 20040000,]
FF_data = dat[dat$date<20060000,]
FF_data = FF_data[-1,] # delete first row since stocks_diff
# lost a row due to differencing

stocks_diff = as.data.frame(100*apply(log(stocks_subset),2,diff) - FF_data$RF)
names(stocks_diff) = c("GM","Ford","UTX","Merck")
detach(stocks)

fit1 = lm(as.matrix(stocks_diff)~FF_data$Mkt.RF)
summary(fit1)

fit2 = lm(as.matrix(stocks_diff)~FF_data$Mkt.RF +
                  FF_data$SMB + FF_data$HML)
summary(fit2)


################################################################
########## Code for Section 18.8.3   ###########################
################################################################

dat = read.csv("Stock_FX_Bond.csv")
stocks_ac = dat[,c(3,5,7,9,11,13,15,17)]
n = length(stocks_ac[,1])
stocks_returns = log(stocks_ac[-1,] / stocks_ac[-n,])
fact = factanal(stocks_returns,factors=2,,rotation="none")
print(fact)
print(fact,cutoff = 0.01)
print(fact,cutoff = 0)

loadings = matrix(as.numeric(loadings(fact)),ncol=2)
unique = as.numeric(fact$unique)
loadings
unique

