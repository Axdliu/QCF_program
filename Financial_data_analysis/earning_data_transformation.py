# -*- coding: utf-8 -*-
"""
Created on Sun Mar 19 19:11:03 2017
R_lab earning data transformation 
@author: User
"""

import pandas as pd
import numpy as np
from scipy import stats, optimize
import matplotlib.pyplot as plt

path = 'D:\github\QCF_program\QCF_program\Financial_data_analysis\datasets\\'
dat = pd.read_table(path+"5_19_1.csv", delimiter=',')
male_earnings = dat['ahe'][dat['sex']=='male']
sqr_male_earnings = male_earnings**0.5
log_male_earnings = np.log(male_earnings)

ax1 = plt.subplot(221)
stats.probplot(male_earnings, plot=plt)
ax1.set_title("untransformed")
ax2 = plt.subplot(222)
stats.probplot(sqr_male_earnings, plot=plt)
ax2.set_title("square-root transformed")
ax3 = plt.subplot(223)
stats.probplot(log_male_earnings, plot=plt)
ax3.set_title("log-transformed")

ax1 = plt.subplot(221)
plt.boxplot(male_earnings)
ax1.set_title("untransformed")
ax2 = plt.subplot(222)
plt.boxplot(sqr_male_earnings)
ax2.set_title("square-root transformed")
ax3 = plt.subplot(223)
plt.boxplot(log_male_earnings)
ax3.set_title("log-transformed")

ax1 = plt.subplot(221)
den1 = stats.gaussian_kde(male_earnings)
plt.plot(male_earnings,den1(male_earnings),'k.')
ax1.set_title("untransformed")
ax2 = plt.subplot(222)
den2 = stats.gaussian_kde(sqr_male_earnings)
plt.plot(sqr_male_earnings, den2(sqr_male_earnings),'k.')
ax2.set_title("square-root transformed")
ax3 = plt.subplot(223)
den3 = stats.gaussian_kde(log_male_earnings)
plt.plot(log_male_earnings,den3(log_male_earnings),'k.')
ax3.set_title("log-transformed")

boxc_male_earnings = stats.boxcox(male_earnings)

