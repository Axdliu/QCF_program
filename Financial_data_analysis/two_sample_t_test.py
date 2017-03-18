# -*- coding: utf-8 -*-
"""
Created on Sat Mar 18 17:56:40 2017
two sample paired t-test
@author: User
"""

''' R codes:
prices = read.csv("Stock_Bond.csv")
prices_Merck = prices[ , 11]
return_Merck = diff(log(prices_Merck))
prices_Pfizer = prices[ , 13]
return_Pfizer = diff(log(prices_Pfizer))
cor(return_Merck,return_Pfizer)
t.test(return_Merck, return_Pfizer, paired = TRUE)
differences = return_Merck - return_Pfizer
n = length(differences)
confi_intval = mean(differences) + c(-1,1) * qt(0.025, n - 1, lower.tail = FALSE) * sd(differences) / sqrt(n)
'''

import pandas as pd
import numpy as np
from scipy import stats
from scipy.stats import t

path = 'D:\github\QCF_program\QCF_program\Financial_data_analysis\datasets\\'
prices = pd.read_csv(path+'Stock_bond.csv', header=None)
prices = pd.DataFrame(prices.values, columns=prices.loc[0].copy(deep=True)) 
prices = prices.loc[1:]

prices_Merck = prices['MRK_AC'].astype(float)
return_Merck = np.log(prices_Merck).diff().loc[2:]
prices_Pfizer = prices['PFE_AC'].astype(float)
return_Pfizer = np.log(prices_Pfizer).diff().loc[2:]
# here we need to use paired correlation rather than np.correlate
cor = np.corrcoef(return_Merck, return_Pfizer)[0,1]
t_test = stats.ttest_rel(return_Merck, return_Pfizer)
differences = return_Merck - return_Pfizer
n = len(differences)
confi_intval = np.mean(differences) + np.array([1, -1]) *\
                 t.ppf(0.025, n-1) * np.std(differences) / np.sqrt(n)