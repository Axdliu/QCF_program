clc
clear all
close all
% BS world dB/B = r*dt
% dS/S = mu*dt + sigma*dw


sigma = 0.3; % volatility of the underlying asset
r = 0.03; % risk free return
S_0 = 100; % price of the underlying asset 
K = 110;

dt = 1/1000;
T = 2;
time = (0:dt:T);

Stock_Price = nan(length(time), length(time));
Stock_Price(1,1) = S_0; % initialize the price
U = (1+r*dt+sigma*sqrt(dt));
D = (1+r*dt-sigma*sqrt(dt));

for dt_index = 2:length(time)
    Stock_Price(1,dt_index) = Stock_Price(1,dt_index-1)*U;
    Stock_Price(2:dt_index,dt_index) = Stock_Price(1:dt_index-1,dt_index-1)*D;
end

American_Put_Option_Price = nan(length(time), length(time));
American_Put_Option_Price(:,end) = max(K - Stock_Price(:,end),0);

for dt_index = length(time)-1:-1:1
    
    Value_if_you_wait = exp(-dt*r)*(...
        0.5* American_Put_Option_Price(1:dt_index,dt_index+1) ...
     +  0.5* American_Put_Option_Price(2:dt_index+1,dt_index+1)); 
 
    Value_if_you_exercise = max(K-Stock_Price(1:dt_index,dt_index), 0);
    
    American_Put_Option_Price(1:dt_index,dt_index) = ...
        max(Value_if_you_wait, Value_if_you_exercise);
end

