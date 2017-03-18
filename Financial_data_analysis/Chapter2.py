# -*- coding: utf-8 -*-
"""
Created on Fri Mar 17 19:33:07 2017
replicate codes in chapter 2 FDA
@author: Arnold
"""

# figure 2.1 | R codes: #
'''
pdf("logxplusone.pdf",width=6,height=5) 
x= seq(-.25,.25,length=200) 
plot(x,log(x+1),type="l",lwd=2)
lines(x,x,lty=2,lwd=2,col="red")
legend("bottomright",c("log(x+1)","x"),lty=c(1,2),lwd=2,col=c("black","red"))
graphics.off() 
'''
import numpy as np
import matplotlib.pyplot as plt
x = np.arange(-.25,.25,(.25+.25)/200)
line1, = plt.plot(x, np.log(x+1), 'k', linewidth=2)
line2, = plt.plot(x, x, 'r--', linewidth=2)
plt.legend([line1, line2], ['log(x+1)', 'x'], loc=4)


# figure 2.2 | R codes: #
'''
x=seq(0,10,length=300)
plot(x,x/2,type="l",ylim=c(-1,9),lwd=2,ylab="",xlab="time")
lines(x,x/2+sqrt(x),lty=2,lwd=2)
lines(x,x/2-sqrt(x),lty=2,lwd=2)
legend("topleft",c("mean","mean + SD",
                   expression( paste("mean ",-phantom()," SD") )),
       lwd=2,lty=c(1,2,2))
'''
import numpy as np
import matplotlib.pyplot as plt
x = np.arange(0,10,(10-0)/300.)
line1, = plt.plot(x, x/2, 'k', lw=2)
plt.ylabel('')
plt.xlabel('time')
plt.ylim((-1,9))
line_sd1, = plt.plot(x, x/2+np.sqrt(x), 'k--', lw=2)
line_sd2, = plt.plot(x, x/2-np.sqrt(x), 'k--', lw=2)
plt.legend([line1, line_sd1, line_sd2], ["mean", "mean + SD", "mean - SD"],\
           loc=2)

# Code for the R lab#
'''
dat = read.csv("Stock_bond.csv",header=TRUE)
names(dat)
attach(dat)
par(mfrow=c(1,2))
plot(GM_AC,type="l")
plot(F_AC)
n = dim(dat)[1]
GMReturn = GM_AC[2:n]/GM_AC[1:(n-1)] - 1
FReturn = F_AC[2:n]/F_AC[1:(n-1)] - 1
pdf("ReturnsLab01.pdf",width=6,height=5)
par(mfrow=c(1,1))
plot(GMReturn,FReturn)
graphics.off()
'''
import pandas as pd
import matplotlib.pyplot as plt
path = 'D:\github\QCF_program\QCF_program\Financial_data_analysis\datasets\\'
dat = pd.read_csv(path+'Stock_bond.csv', header=None)
dat = pd.DataFrame(dat.values, columns=dat.loc[0].copy(deep=True)) 
dat = dat.loc[1:]

f, (ax1, ax2) = plt.subplots(1, 2)
ax1.plot(dat['GM_AC'], 'k')
ax2.plot(dat['F_AC'], 'ko')
n = dat.shape[0]
dat['GM_AC'] = dat['GM_AC'].astype(float)
dat['F_AC'] = dat['F_AC'].astype(float)
GMReturn = (dat['GM_AC']/dat['GM_AC'].shift(1) - 1).values[1:]
FReturn = (dat['F_AC']/dat['F_AC'].shift(1) - 1).values[1:]
plt.plot(GMReturn, FReturn, 'ko')