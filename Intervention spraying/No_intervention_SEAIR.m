function y = No_intervention_SEAIR(z,timevect)

b0 = z(1);
p  = z(2);
%m  = z(3);   % <-- MUST be active

params_SEAIR;


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
[t,Y] = ode15s(@(t,y) SEAIR_ode(t,y,[b0 p]),tspan,y0,opts);

E = Y(:,2);
daily_reported = rho * p * sigma_E .* E;

year_vec = 2020 + floor(t/365);

cases_yearly = zeros(length(timevect),1);

for i = 1:length(timevect)
    cases_yearly(i) = sum(daily_reported(year_vec == timevect(i)));
end

y = cases_yearly;
