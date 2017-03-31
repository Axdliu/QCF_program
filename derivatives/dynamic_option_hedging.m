
clc
clear all
close all

%% Question 1

S_0 = 1000;
units = 10000;
r = .03;
sigma = .25;
K_comp = 1100;
T_comp = 2;

[comp_price, ~] = blsprice(S_0, K_comp, r, T_comp, sigma, 0);
[comp_delta, ~] = blsdelta(S_0, K_comp, r, T_comp, sigma, 0);
comp_gamma = blsgamma(S_0, K_comp, r, T_comp, sigma, 0);

%% Question 2

K_call = 1200;
T_call = 1;
K_put = 1600;
T_put = 3;

% simulate one sample path of google stock price
mu = .05;
dt = 1/1000;
time = (0:dt:.5);
dW = sqrt(dt)*randn(length(time),1);

dlogS = (mu-0.5*sigma^2)*dt + sigma*dW; % under P

temp = [log(S_0)
        dlogS ];
    
logS = cumsum(temp);
S = exp(logS);
plot(time, S(1:end-1))

% step 1
[comp_price_over_S, ~] = blsprice(S(1:end-1), K_comp, r, T_comp-time', sigma, 0);
[comp_delta_over_S, ~] = blsdelta(S(1:end-1), K_comp, r, T_comp-time', sigma, 0);
comp_gamma_over_S = blsgamma(S(1:end-1), K_comp, r, T_comp-time', sigma, 0);
[Call_price_over_S, ~] = blsprice(S(1:end-1), K_call, r, T_call-time', sigma, 0);
[Call_delta_over_S, ~] = blsdelta(S(1:end-1), K_call, r, T_call-time', sigma, 0);
Call_gamma_over_S = blsgamma(S(1:end-1), K_call, r, T_call-time', sigma, 0);
[~ ,Put_price_over_S] = blsprice(S(1:end-1), K_put, r, T_put-time', sigma, 0);
[~ ,Put_delta_over_S] = blsdelta(S(1:end-1), K_put, r, T_put-time', sigma, 0);
Put_gamma_over_S = blsgamma(S(1:end-1), K_put, r, T_put-time', sigma, 0);

% step 2: solve the system of equations
Portfolio_Value = nan(size(comp_price_over_S));
Portfolio_Value(1) = comp_price*units;

for t = 1:(length(time)-1)
    
    A = [S(t) Call_price_over_S(t) Put_price_over_S(t)
         1 Call_delta_over_S(t) Put_delta_over_S(t)
         0 Call_gamma_over_S(t) Put_gamma_over_S(t)];

    B = [Portfolio_Value(t)
         0
         0];
    
    new_pfo = A\B;
    
    Portfolio_Value(t+1) = new_pfo(1)*S(t+1)+...
        new_pfo(2)*Call_price_over_S(t+1)+...
        new_pfo(3)*Put_price_over_S(t+1);
end

plot(time, Portfolio_Value)
target_asset = Portfolio_Value(1)*exp(r*time)'
hold on
plot(time, target_asset)
plot(time, Portfolio_Value - target_asset)
