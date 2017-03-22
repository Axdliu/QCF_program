# -*- coding: utf-8 -*-
"""
Created on Tue Mar 21 16:48:15 2017
Replication of Chapter9, regression.
@author: User
"""

import pandas as pd
import numpy as np
from scipy import stats
import matplotlib.pyplot as plt
from sklearn import datasets, linear_model
import statsmodels.api as sm
import statsmodels.formula.api as smf
from statsmodels.formula.api import ols
from pandas.tools.plotting import scatter_matrix
import itertools

# R-lab
path = 'D:\github\QCF_program\QCF_program\Financial_data_analysis\datasets\\'
MacroDiff = pd.read_table(path+"MacroDiff.csv", delimiter=',').astype(float)

# scatter plotting
scatter_matrix(MacroDiff[['consumption','dpi','cpi','government','unemp']], alpha=0.2, figsize=(8,8))
'''
Q1: findings from the scatterplots
Changes in consumption show a positive relationship with changes in dpi and
a negative relationship with changes in unemp, so these two variables should be
most useful for predicting changes in consumption. The correlations between
the predictors (changes in the variables other than consumption) are weak and
collinearity will not be a serious problem.
'''

# first try of the model and evaluate results
regr = linear_model.LinearRegression()
regr.fit(MacroDiff[['dpi','cpi','government','unemp']], MacroDiff['consumption'])
print('Coefficients: \n', regr.coef_)
X = MacroDiff[['consumption','dpi','cpi','government','unemp']]
X_inde = MacroDiff[['dpi','cpi','government','unemp']]
model = smf.ols('consumption ~ dpi + cpi + government + unemp', data=X)
fitLm1 = model.fit()
print fitLm1.summary()
'''
Q2: evaluating the result of regression
Changes in dpi and unemp are highly significant and so are useful for prediction.
Changes in cpi and government have large p-values and do not seem useful.
'''

# ANOVA test
print sm.stats.anova_lm(fitLm1)
'''
Q3: what does ANOVA show?
No, the AOV table contains sums of squares and mean squares that are not in
the summary, but these are not needed for variable selection
'''

# select model with AIC
AICs = {}
para = ['dpi','cpi','government','unemp']
for k in range(1, len(para)+1):
    for variables in itertools.combinations(para, k):
        predictors = list(variables)
        i = True
        independent =''
        for p in predictors:
            if i:
                independent = p
                i=False
            else:
                independent+='+ {}'.format(p)
        regresion = 'consumption ~ {}'.format(independent)
        res = smf.ols(regresion, data=X).fit()
        AICs[variables] = 2*(k+1) - 2*res.llf
AIC_table = pd.DataFrame(AICs.values(), index=AICs.keys())
fitLm2_para = AIC_table.idxmin()
print fitLm2_para[0]
'''
Q4: what is changed?
First changes in government is removed and then changes in cpi.
'''

# compute the change of AICs
AIC2 = AIC_table.loc[fitLm2_para][0][0]
AIC1 = AIC_table.iloc[-1][0]
print AIC1, AIC2, AIC1-AIC2
'''
Q5: what is the change of AIC, why?
 AIC decreased by 2.83 which is not a huge improvement. Dropping variables
increases the log-likelihood (which increases AIC) and decreases the number
of variables (which decreases AIC). The decrease due to dropping variables is
limited; it is twice the number of deleted variables. In this case, the maximum
possible decrease in AIC from dropping variables is 4 and is achieved only if
dropping the variables does not change the log-likelihood, so we should not have
expected a huge decrease. Of course, when there are many variables then a huge
decrease in AIC is possible if a very large number of variables can be dropped.
'''

# compute  variance inflation factors and evalaute collinearity 

