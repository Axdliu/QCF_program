# -*- coding: utf-8 -*-
"""
Created on Tue Mar 14 19:57:54 2017
replicate the model done by Matlab
@author: User
"""

import numpy as np
import pandas as pd

def american_put_option(sigma, r, S_0, K, T):
    '''
    valuation based on binary tree model
    '''
    dt = 1.0/1000    
    time = np.array(range(0, int(T/dt)+1))
    stock_price = np.empty((len(time), len(time)))
    stock_price[:] = np.NAN
    stock_price = pd.DataFrame(stock_price, index=time, columns=time)
    American_Put_Option_Price = stock_price.copy()
    stock_price.loc[0,0] = S_0
    U = (1.0+r*dt+sigma*np.sqrt(dt))
    D = (1.0+r*dt-sigma*np.sqrt(dt))
    
    for dt_index in range(1,len(time)):
        stock_price.loc[0,dt_index] = stock_price.loc[0,dt_index-1]*U
        stock_price.loc[1:dt_index,dt_index] = (stock_price.loc[0:dt_index-1,dt_index-1]*D).values
    
    American_Put_Option_Price.iloc[:,-1] = K - stock_price.iloc[:,-1]
    American_Put_Option_Price.iloc[:,-1][American_Put_Option_Price.iloc[:,-1]<0] = 0

    for dt_index in range(len(time)-2,-1,-1):        
        Value_if_you_wait = np.exp(-dt*r)*(0.5* American_Put_Option_Price.loc[0:dt_index,dt_index+1].values \
                                   + 0.5* American_Put_Option_Price.loc[1:dt_index+1,dt_index+1].values) 
     
        Value_if_you_exercise = (K-stock_price.loc[0:dt_index,dt_index]).values
        Value_if_you_exercise[Value_if_you_exercise<0] = 0
        
        American_Put_Option_Price.loc[0:dt_index,dt_index] = Value_if_you_wait
        American_Put_Option_Price.loc[0:dt_index,dt_index]\
            [American_Put_Option_Price.loc[0:dt_index,dt_index]<Value_if_you_exercise]\
            = Value_if_you_exercise
            
    return American_Put_Option_Price.loc[0,0]
      
if __name__ == "__main__":
    sigma = 0.3     # volatility of the underlying asset
    r = 0.03        # risk free return
    S_0 = 100       # price of the underlying asset 
    K = 110         # striking price
    T = 2           # expiration time
    print american_put_option(sigma, r, S_0, K, T)
    