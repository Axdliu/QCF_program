

clc
clear all
close all

% example 1

S_0 = 1100;
r = .03;
sigma = .3;
K_call = 1000;
T_call = 2;
K_put = 700;
T_put = 1.5;

% step 1
[Call_price, ~] = blsprice(S_0, K_call, r, T_call, sigma, 0);
[Call_delta, ~] = blsdelta(S_0, K_call, r, T_call, sigma, 0);

% step 2
Pfo_Value = S_0*1000;
A = [S_0 Call_price
    1 Call_delta];
B = [Pfo_Value
    0];
new_Pfo = A\B; % number of stock and number of options

% check out the effect of risk management
Range_of_Stock_Price_of_interest = [1000:1:1200];
Existing_Pfo_Value = 1000*Range_of_Stock_Price_of_interest;
[Call_option_price_over_the_range, ~] = ...
    blsprice(Range_of_Stock_Price_of_interest, K_call, r, T_call, sigma, 0);
New_Pro_Value = ...
    new_Pfo(1)*Range_of_Stock_Price_of_interest + ...
    new_Pfo(2)*Call_option_price_over_the_range;

plot(Range_of_Stock_Price_of_interest, Existing_Pfo_Value)
hold on
plot(Range_of_Stock_Price_of_interest, New_Pro_Value)
legend('old', 'new')

%% example 2

% step 1
[Call_price, ~] = blsprice(S_0, K_call, r, T_call, sigma, 0);
[Call_delta, ~] = blsdelta(S_0, K_call, r, T_call, sigma, 0);
Call_gamma = blsgamma(S_0, K_call, r, T_call, sigma, 0);
[~ ,Put_price] = blsprice(S_0, K_put, r, T_put, sigma, 0);
[~ ,Put_delta] = blsdelta(S_0, K_put, r, T_put, sigma, 0);
Put_gamma = blsgamma(S_0, K_put, r, T_put, sigma, 0);

% step 2
A = [S_0 Call_price Put_price
    1 Call_delta Put_delta
    0 Call_gamma Put_gamma];

B = [Pfo_Value
    0
    0];

new_Pfo_delta_gamma_neutral = A \ B

% checkout the effect

[~, Put_option_price_over_the_range] = ...
    blsprice(Range_of_Stock_Price_of_interest, K_put, r, T_put, sigma, 0);
New_Pfo_Value_delta_gamma_neutral = ...
    new_Pfo_delta_gamma_neutral(1)*Range_of_Stock_Price_of_interest + ... 
    new_Pfo_delta_gamma_neutral(2)*Call_option_price_over_the_range + ...
    new_Pfo_delta_gamma_neutral(3)*Put_option_price_over_the_range

plot(Range_of_Stock_Price_of_interest, Existing_Pfo_Value)
hold on
plot(Range_of_Stock_Price_of_interest, New_Pro_Value)
hold on
plot(Range_of_Stock_Price_of_interest, New_Pfo_Value_delta_gamma_neutral, 'k')
legend('old', 'delta', 'gamma')
