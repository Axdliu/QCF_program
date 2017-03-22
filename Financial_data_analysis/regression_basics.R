#####  Code for R lab  #####
library(AER)
data("USMacroG")

MacroDiff=as.data.frame(apply(USMacroG,2,diff))

# write the data for python program to load
write.csv(MacroDiff, file = "D:\\github\\QCF_program\\QCF_program\\Financial_data_analysis\\datasets\\MacroDiff.csv",
          row.names = FALSE)

attach(MacroDiff)

pairs(cbind(consumption,dpi,cpi,government,unemp))
fitLm1 = lm(consumption~dpi+cpi+government+unemp)

summary(fitLm1)
confint(fitLm1)
anova(fitLm1)

library(MASS)
fitLm2 = stepAIC(fitLm1)
summary(fitLm2)

AIC(fitLm1)
AIC(fitLm2)
AIC(fitLm1)-AIC(fitLm2)
library(car)
vif(fitLm1)
vif(fitLm2)
par(mfrow=c(2,2))
sp = 0.8
crPlot(fitLm1,dpi,span=sp,col="black")
crPlot(fitLm1,cpi,span=sp,col="black")
crPlot(fitLm1,government,span=sp,col="black")
crPlot(fitLm1,unemp,span=sp,col="black")
