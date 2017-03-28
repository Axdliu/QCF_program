
############  Code for Figure 7.4  ###############
##################################################
pdf("midcapDPairs.pdf",width=6,height=6)  ##  Figure 7.4  ##
midcapD.ts = read.csv("D:\\github\\QCF_program\\QCF_program\\Financial_data_analysis\\datasets\\midcapD.ts.csv")
x = midcapD.ts 
market = 100*as.matrix(x[,22])
x = as.matrix(x[,-c(1,22)])
pairs(x[,1:6])
graphics.off()


############  Code for Example 7.4 and Figure 7.5     ###############
#####################################################################
pdf("CRSPday_MultiT_profile.pdf")        #####  Figure 7.5  #####
library(mnormt)
library(MASS)
data(CRSPday,package="Ecdat")
dat =CRSPday[,4:7]
#  Fitting symmetric t by profile likelihood
df = seq(5.25,6.75,.01)
n = length(df)
loglik = rep(0,n)
for(i in 1:n){
        fit = cov.trob(dat,nu=df)
        loglik[i] = sum(log(dmt(dat,mean=fit$center,S=fit$cov,df=df[i])))
}
options(digits=7)
aic_t = -max(2*loglik)+ 2*(4 + 10 + 1) + 64000
z1 = (2*loglik > 2*max(loglik) - qchisq(.95,1))
par(mfrow = c(1,1))
plot(df,2*loglik-64000,type="l",cex.axis=1.5,cex.lab=1.5,
     ylab="2*loglikelihood - 64,000",lwd=2)
abline(h = 2*max(loglik) - qchisq(.95,1)-64000)
abline(h = 2*max(loglik)-64000 )
abline(v=(df[16]+df[17])/2)
abline(v=(df[130]+df[131])/2)
graphics.off()
options(digits=4)
cov.trob(dat,nu=6,cor=TRUE)
options(digits=4)
cor(dat)