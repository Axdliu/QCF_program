# -*- coding: utf-8 -*-
"""
Created on Sun Mar 19 13:44:05 2017
simple linear regression Ex.9.1
@author: User
"""

''' R codes:
dat = read.table(file="WeekInt.txt",header=T)
attach(dat)
cm10_dif = diff( cm10 )
aaa_dif = diff( aaa )
cm30_dif = diff( cm30 )
ff_dif = diff( ff )
par(mfrow=c(1,1))
pdf("cm10aaa.pdf",width=6,height=5)
plot(cm10_dif,aaa_dif,xlab="change in 10YR T rate",
     ylab="change in AAA rate")
graphics.off()
options(digits = 3)
summary(lm(aaa_dif ~ cm10_dif))
'''

import pandas as pd
import numpy as np
from scipy import stats
import matplotlib.pyplot as plt

path = 'D:\github\QCF_program\QCF_program\Financial_data_analysis\datasets\\'
# dat = pd.read_table(path+"WeekInt.txt")
with open(path+"WeekInt.txt", 'r') as f:
    data = f.readlines()
dat = []
for line in data:
    dat.append(line.strip().split())
df = pd.DataFrame(dat[1:], columns=dat[0])
cm10_dif = df['cm10'].astype(float).diff()[1:]
aaa_dif = df['aaa'].astype(float).diff()[1:]
cm30_dif = df['cm30'].astype(float).diff()[1:]
ff_dif = df['ff'].astype(float).diff()[1:]
f1 = plt.plot(cm10_dif, aaa_dif, 'ko')
plt.xlabel("change in 10YR T rate")
plt.ylabel("change in AAA rate")
lr = stats.linregress(cm10_dif, aaa_dif)
print lr.slope, lr.pvalue