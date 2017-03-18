
""" 
Assignment 6.2 

"""

import datetime as dt
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import os
import csv
from sklearn import linear_model
import gc

path = "D:\QCF\data_temp"

tickers = pd.Series(os.listdir(path))
num = tickers.size

""" select data from the following list:

'id' 'member_id' 'loan_amnt' 'funded_amnt' 'funded_amnt_inv' 'term'
 'int_rate' 'installment' 'grade' 'sub_grade' 'emp_title' 'emp_length'
 'home_ownership' 'annual_inc' 'verification_status' 'issue_d'
 'loan_status' 'pymnt_plan' 'desc' 'purpose' 'title' 'zip_code'
 'addr_state' 'dti' 'delinq_2yrs' 'earliest_cr_line' 'inq_last_6mths'
 'mths_since_last_delinq' 'mths_since_last_record' 'open_acc' 'pub_rec'
 'revol_bal' 'revol_util' 'total_acc' 'initial_list_status' 'out_prncp'
 'out_prncp_inv' 'total_pymnt' 'total_pymnt_inv' 'total_rec_prncp'
 'total_rec_int' 'total_rec_late_fee' 'recoveries'
 'collection_recovery_fee' 'last_pymnt_d' 'last_pymnt_amnt' 'next_pymnt_d'
 'last_credit_pull_d' 'collections_12_mths_ex_med'
 'mths_since_last_major_derog' 'policy_code'
 
 """
 
# this step is not necessary, but can reduce of chance of 'Memory Error'
parameters = ['term', 'int_rate', 'grade', 'home_ownership', 'issue_d', 'loan_status', 'dti', 'delinq_2yrs', 
              'mths_since_last_delinq', 'revol_util', 'total_rec_prncp', 'verification_status', 'open_acc', 
               'last_pymnt_amnt', 'installment', 'total_acc', 'total_rec_late_fee', 'funded_amnt', 'inq_last_6mths', 'pub_rec']
               
data_set = []
for i in tickers:
    data_file = path + "//" + str(i)
    print 'Read data of ticker: '+ str(i)   
    data = pd.read_csv(data_file, index_col=False, header=0)
    data_select = data[parameters]
    data_set.append(data_select)

data_frame = data_set[0].append([data_set[1], data_set[2], data_set[3], data_set[4], data_set[5]])
rows = len(data_frame.index)

del data_set, data, data_select
gc.collect()

# computing parameters
# Guidance: http://pandas.pydata.org/pandas-docs/stable/text.html

# create year information based on issue_d
issue_date = data_frame['issue_d']
issue_date_df = pd.DataFrame(issue_date)
issue_date_df[['digit','temp']] = issue_date_df['issue_d'].str.rsplit('-', expand=True)
issue_date_df['year'] = issue_date_df['digit'].astype(np.int64) + 2000
data_frame['year'] = issue_date_df['year'].copy()

# create verification status
data_frame['verification'] = 1
data_frame['verification'][data_frame['verification_status'].str.contains('not')] = 0

# create grade_score
data_frame = data_frame.replace({'grade': {'A':5,'B':0,'C':-5,'D':-10,'E':-15,'F':-20,'G':-50}})

# create home score
data_frame['home_score'] = 0
data_frame['home_score'][data_frame['home_ownership'].str.contains('OWN')] = 1

# creat term score
data_frame['term_score'] = 0
data_frame['term_score'][data_frame['term'].str.contains('3')] = 1

# create default flags
data_frame['default'] = 0.5
data_frame['default'][data_frame['loan_status'].str.contains('Fully Paid')] = 0 
data_frame['default'][data_frame['loan_status'].str.contains('Charged Off')] = 1     
data_frame['default'][data_frame['loan_status'].str.contains('Default')] = 1  

# compute interest rate
data_frame['int_rate2'] = data_frame['int_rate'].str.replace('%','')
data_frame['int_rate'] = data_frame['int_rate2'].astype(float) / 100.0

# compute revol utility
data_frame['revol_util2'] = data_frame['revol_util'].str.replace('%','')
data_frame['revol_util'] = data_frame['revol_util2'].astype(float) / 100.0

# dti to divide 100
data_frame['dti'] = data_frame['dti']/100.0

# months to last delinquency
data_frame['mths_since_last_delinq'] = data_frame['mths_since_last_delinq'].fillna(60)

# compute repayment percentage
data_frame['payment_pert'] = data_frame['open_acc'] / data_frame['total_acc']

# compute verificed dti
data_frame['verified_dti'] = data_frame['dti'] 
data_frame['verified_dti'][data_frame['verification'] == 1] = data_frame['dti'] * 3

# compute payment speed
data_frame['payment_speed'] = data_frame['last_pymnt_amnt']/data_frame['installment']

# compute late fee as a percentage of total fund
data_frame['latefee_pert'] = data_frame['total_rec_late_fee']/data_frame['funded_amnt']

# convert type of 
data_frame['inq_last_6mths'] = data_frame['inq_last_6mths'].fillna(0) 


data_frame = data_frame[data_frame['default'] != 0.5]

# task3: select parameters for computation for all data (2007-2016)
parameters_mod1 = ['int_rate', 'delinq_2yrs', 'verification', 'verified_dti', 'payment_pert', 'latefee_pert', 'payment_speed', 'inq_last_6mths', 'pub_rec']

X = data_frame[parameters_mod1]
Y = data_frame['default'] 

# run the classifier
clf = linear_model.LogisticRegression()
modele = clf.fit(X, Y)
beta = modele.coef_
intercept = modele.intercept_
probas = modele.predict_proba(X)
score = probas[:,1]
result_1 = pd.DataFrame(Y)
result_1['prob'] = score
result_1_sorted = result_1.sort(['prob'], ascending=0)
rows1 = len(result_1_sorted)

index_c = ['Top10%','Top20%', 'Top30%','Top40%','Top50%','Top60%','Top70%','Top80%','Top90%','Top100%']

Summary_allinsample = pd.DataFrame({'No.of default' : [0.00], 'Accu.Probability' : [0.00], 'Accu.Default' : [0.00], 'Probability' : [0.00], 'Default' : [0.00]}, index = index_c)
for i in range(0, 10):
    Summary_allinsample['No.of default'][index_c[i]] = sum(result_1_sorted['default'][0: long(rows1/10.0)*(i+1)])
    Summary_allinsample['Accu.Probability'][index_c[i]] = sum(result_1_sorted['prob'][0: long(rows1/10.0)*(i+1)])*1.0/sum(result_1_sorted['prob'])
    Summary_allinsample['Accu.Default'][index_c[i]] = sum(result_1_sorted['default'][0: long(rows1/10.0)*(i+1)])*1.0/sum(result_1_sorted['default'])
    Summary_allinsample['Probability'][index_c[i]] = (sum(result_1_sorted['prob'][0: long(rows1/10.0)*(i+1)])*1.0 - sum(result_1_sorted['prob'][0: long(rows1/10.0)*(i)])*1.0)/sum(result_1_sorted['prob'])
    Summary_allinsample['Default'][index_c[i]] = (sum(result_1_sorted['default'][0: long(rows1/10.0)*(i+1)])*1.0 - sum(result_1_sorted['default'][0: long(rows1/10.0)*(i)])*1.0)/sum(result_1_sorted['default'])

del X, Y
gc.collect()
    
# task4: in-sample trainning (2007-2014), out-sample testing (2015&2016)
parameters_year = ['year', 'int_rate', 'delinq_2yrs', 'verification', 'verified_dti', 'payment_pert', 'latefee_pert', 'payment_speed', 'inq_last_6mths', 'pub_rec']
Y_year = data_frame[['default','year']]
X_fullset =  data_frame[parameters_year]

result_test = pd.DataFrame({'prob' : [], 'default' : []})

for i in [2015,2016]:    
    X_train = X_fullset[parameters_mod1][X_fullset['year'] < i]
    X_test = X_fullset[parameters_mod1][X_fullset['year'] == i]
    Y_train = Y_year['default'][Y_year['year'] < i]
    Y_test = Y_year['default'][Y_year['year'] == i]
    modele2 = clf.fit(X_train, Y_train)
    probability = modele2.predict_proba(X_test)
    score2 = probability[:,1]
    result_2 = pd.DataFrame(Y_test)
    result_2['prob'] = score2
    result_test = result_test.append(result_2)

result_2_sorted = result_test.sort(['prob'], ascending=0)
rows2 = len(result_2_sorted)

Summary_outsample = pd.DataFrame({'No.of default' : [0.00], 'Accu.Probability' : [0.00], 'Accu.Default' : [0.00], 'Probability' : [0.00], 'Default' : [0.00]}, index = index_c)
for i in range(0, 10):
    Summary_outsample['No.of default'][index_c[i]] = sum(result_2_sorted['default'][0: long(rows2/10.0)*(i+1)])
    Summary_outsample['Accu.Probability'][index_c[i]] = sum(result_2_sorted['prob'][0: long(rows2/10.0)*(i+1)])*1.0/sum(result_2_sorted['prob'])
    Summary_outsample['Accu.Default'][index_c[i]] = sum(result_2_sorted['default'][0: long(rows2/10.0)*(i+1)])*1.0/sum(result_2_sorted['default'])
    Summary_outsample['Probability'][index_c[i]] = (sum(result_2_sorted['prob'][0: long(rows2/10.0)*(i+1)])*1.0 - sum(result_2_sorted['prob'][0: long(rows2/10.0)*(i)])*1.0)/sum(result_2_sorted['prob'])
    Summary_outsample['Default'][index_c[i]] = (sum(result_2_sorted['default'][0: long(rows2/10.0)*(i+1)])*1.0 - sum(result_2_sorted['default'][0: long(rows2/10.0)*(i)])*1.0)/sum(result_2_sorted['default'])


print  X_train.columns
print modele.coef_
print Summary_allinsample
print Summary_outsample

result_2_sorted.to_csv('result.csv')

