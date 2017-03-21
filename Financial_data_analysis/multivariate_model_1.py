# -*- coding: utf-8 -*-
"""
Created on Sun Mar 19 23:53:03 2017
Multivariate model 1: corr and cov
@author: User
"""

import pandas as pd
from pandas.tools.plotting import scatter_matrix
import numpy as np
from scipy import stats, optimize
import matplotlib.pyplot as plt
from matplotlib.mlab import bivariate_normal

path = 'D:\github\QCF_program\QCF_program\Financial_data_analysis\datasets\\'
dat = pd.read_table(path+"eg_7_1.csv", delimiter=',')
dat_table = dat.ix[:,3:].astype(float)
print dat_table.corr()
print dat_table.cov()

# figures 7.1 scatterplot matrix
scatter_matrix(dat_table, alpha=0.2, figsize=(6, 6))

# figure 7.2 contour plots of a bivariate normal densities with N(0,1) 
# marginal distribution and correlations of 0.5 or -0.95
mu = np.zeros(2)
cov1 = np.mat([[1,.5],[.5,1]])
cov2 = np.mat([[1,-.95],[-.95,1]])
t = np.arange(-2.5,2.5+.025,.025)
t2 = pd.DataFrame([t,t]).transpose()
ff1 = stats.multivariate_normal.pdf(t2, mean = mu, cov = cov1)
ff2 = stats.multivariate_normal.pdf(t2, mean = mu, cov = cov2)
# http://stackoverflow.com/questions/36013063/what-is-purpose-of-meshgrid-in-python
X, Y = np.meshgrid(t, t)
tt = np.outer(t,t)

# bivariate_normal(X, Y, sigmax=1.0, sigmay=1.0, mux=0.0, muy=0.0, sigmaxy=0.0)
Z1 = bivariate_normal(X, Y, cov1[0,0], cov1[1,1], 0.0, 0.0, cov1[0,1])
Z2 = bivariate_normal(X, Y, cov1[0,0], cov1[1,1], 0.0, 0.0, cov2[0,1])
fig, axs = plt.subplots(1,2)
axs[0].contour(X,Y,Z1)
axs[1].contour(X,Y,Z2)
