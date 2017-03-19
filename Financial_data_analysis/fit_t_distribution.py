# -*- coding: utf-8 -*-
"""
Created on Sun Mar 19 15:41:18 2017
E.g.5.3 fitting t_distribution
@author: User
"""

'''R codes:
data(Capm,package="Ecdat")
write.csv(Capm$rf, file = "D:\\github\\QCF_program\\QCF_program\\Financial_data_analysis\\datasets\\ex5_3.csv",
          row.names = FALSE)
x = diff(Capm$rf)
library(MASS)
fitdistr(x,"t")
library(fGarch)
n = length(x)
start = c(mean(x),sd(x),5)
loglik_t = function(beta) sum( - dt((x-beta[1])/beta[2],
                                    beta[3],log=TRUE) + log(beta[2]) )    
fit_t = optim(start,loglik_t,hessian=T,method="L-BFGS-B",
              lower = c(-1,.001,1))                                 
AIC_t = 2*fit_t$value+2*3
BIC_t = 2*fit_t$value+log(n)*3
sd_t = sqrt(diag(solve(fit_t$hessian)))
options(digits=3)
fit_t$par
sd_t
options(digits=5)
AIC_t
BIC_t
loglik_std = function(beta) sum( - dstd(x,mean=beta[1],
                                        sd=beta[2],nu=beta[3],log=TRUE) )
fit_std = optim(start,loglik_std,hessian=T,method="L-BFGS-B",
                lower = c(-.1,.01,2.1))                                   
AIC_std = 2*fit_std$value+2*3
BIC_std = 2*fit_std$value+log(n)*3
sd_std = sqrt(diag(solve(fit_std$hessian)))
fit_std$par
sd_std
AIC_std
BIC_std
0.04585 * sqrt(3.332/(3.332-2))
'''

import pandas as pd
import numpy as np
from scipy import stats, optimize
import matplotlib.pyplot as plt

path = 'D:\github\QCF_program\QCF_program\Financial_data_analysis\datasets\\'
dat = pd.read_table(path+"ex5_3.csv")
x = dat.diff()[1:]
stats.t.fit(x)  #(df, mean, sd)


def loglik_t(beta):
    return sum(-np.log(stats.t.pdf((x-beta[0])/beta[1], beta[2])) +np.log(beta[1]))
n = len(x)
start = [x.mean()[0], x.std()[0], 5]
fit_t = optimize.minimize(loglik_t, start, method='L-BFGS-B', bounds=((-1,None),(0.001,None),(1,None)))
print round(fit_t.fun[0])
AIC_t = 2*fit_t.fun[0]+2*3
BIC_t = 2*fit_t.fun[0]+np.log(n)*3
print fit_t.x        #(mean, sd, df)
print stats.t.fit(x) #(df, mean, sd)

def loglik_std(beta):
    return sum(-stats.t.logpdf(x, beta[2], loc=beta[0], scale=beta[1]))
fit_std = optimize.minimize(loglik_std, start, method='L-BFGS-B', bounds=((-0.1,None),(0.01,None),(2.1,None)))
AIC_std = 2*fit_std.fun[0]+2*3
BIC_std = 2*fit_std.fun[0]+np.log(n)*3
print fit_std.x        #(mean, sd, df)