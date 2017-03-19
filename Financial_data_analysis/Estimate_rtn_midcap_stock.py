# -*- coding: utf-8 -*-
"""
Created on Sun Mar 19 14:23:19 2017
examplee 5.2 esimate returns of midcap stocks
@author: User
"""

''' R codes:
midcapD.ts = read.csv("midcapD.ts.csv")
x = 100*as.matrix(midcapD.ts[,-c(1,22)])
train = x[1:250,]
valid = x[-(1:250),]
meansTrain = apply(train,2,mean)
commonmeanTrain = mean(meansTrain)
meansValid = apply(valid,2,mean)
SSseparate = sum((meansTrain-meansValid)^2)
SScommon = sum((commonmeanTrain - meansValid)^2)
SScommonTrain = sum((commonmeanTrain - meansTrain)^2)
SSseparate
SScommon
SScommonTrain
'''

import pandas as pd
import numpy as np
from scipy import stats
import matplotlib.pyplot as plt

path = 'D:\github\QCF_program\QCF_program\Financial_data_analysis\datasets\\'
dat = pd.read_table(path+"midcapD.ts.csv", delimiter=',')
dat_100 = dat.ix[:,1:-1].astype(float)*100
train = dat_100.ix[0:249,:]
valid = dat_100.ix[250:,:]
meansTrain = train.mean()
commonmeanTrain = meansTrain.mean()
meansValid = valid.mean()
SSseparate = sum((meansTrain-meansValid)**2)
SScommon = sum((commonmeanTrain - meansValid)**2)
SScommonTrain = sum((commonmeanTrain - meansTrain)**2)
print SSseparate, SScommon, SScommonTrain