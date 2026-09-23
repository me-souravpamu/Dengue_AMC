function y = plotSEAIR_annual(param,timevect)

b0 = param(1);
beta_HM = param(2);
beta_MH = param(3);
p  = param(4);
m  = param(5);
theta= param(6);
% omega_R=param(7);
mu_M = param(7); 

params_SEAIR;

% % Initial condition: end of 2018
% y0 = [
%   1777363.794
%   29202.45392
%   85.81223368 
%   994.1629412
%   283588.1647
%   3654630.495
%   4107.504534
% ];						
% Initial condition: end of 2017
y0 = [
  1759045.82
  29879.29
  87.8 
  1017.19
  289905.71
  3654512.87
  4225.13
];						

t0 = 0;
tF = (max(timevect)-2017)*365;
tspan = 0:1:tF;

opts = odeset('RelTol',1e-12,'AbsTol',1e-15);
[t,Y] = ode15s(@(t,y) SEAIR_ode(t,y,param),tspan,y0,opts);

E = Y(:,2);
daily_reported = rho * p * sigma_E .* E;

year_vec = 2020 + floor(t/365);

cases_yearly = zeros(length(timevect),1);

for i = 1:length(timevect)
    cases_yearly(i) = sum(daily_reported(year_vec == timevect(i)));
end

y = cases_yearly;
