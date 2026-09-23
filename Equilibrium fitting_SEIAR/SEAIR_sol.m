function yearly_cases = SEAIR_sol(param)

params_SEAIR;

T = (2020-1961+1)*365;
tspan = 0:1:T;

I0=1; E0=0; A0=0; R0=0; Mi0=1;
Ms0 = 2.5*N_H - Mi0;
S0  = N_H - (E0+I0+A0+R0);

y0 = [S0 E0 I0 A0 R0 Ms0 Mi0];

opts = odeset('RelTol',1e-8,'AbsTol',1e-10);
[~,Y] = ode15s(@(t,y)SEAIR_ode(t,y,param),tspan,y0,opts);

E_series = Y(:,2);
daily_reported = rho * param(2) * sigma_E .* E_series;

year_vec = 1961 + floor(tspan'/365);
idx2020 = (year_vec==2020);

yearly_cases = sum(daily_reported(idx2020));
