function y = With_intervention_SEAIR(params,timevect)

b0 = params(1);
p  = params(2);
%m  = z(3);   % <-- MUST be active

params_SEAIR;

% Initial condition: end of 2017
y0 = [1759045.82
  29879.29
  87.8 
  1017.19
  289905.71
  3654512.87
  4225.13];						

tspan1 = 0:1:(365*8-1);

opts = odeset('RelTol',1e-12,'AbsTol',1e-15);
[~,Y] = ode15s(@(t,y) SEAIR_ode(t,y,params),tspan1,y0,opts);

pop_end2025 = Y(end,:);

y00 = pop_end2025;

tspan2 = 0:1:(365*3-1);

[t,Y1] = ode15s(@(t,y) SEAIR_ode_prevention(t,y,params),tspan2,y00,opts);

E = Y1(:,2);
daily_reported = rho * p * sigma_E .* E;

year_vec = 2026 + floor(t/365);

cases_yearly = zeros(length(timevect),1);

for i = 1:length(timevect)
    cases_yearly(i) = sum(daily_reported(year_vec == timevect(i)));
end

y = cases_yearly;
