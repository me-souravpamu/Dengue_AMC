% dengue_AMC_patients_2020_correct.m
% -------------------------------------------------------------
% SEAIR–mosquito dengue model for Ahmedabad
% Seasonal biting, fixed-step RK45 (Dormand–Prince)
% Time span: 1961–2020 (daily, no leap years)
%
% Computes:
% 1) Daily state variables
% 2) Daily reported incidence = rho * p * sigma * E(t)
% 3) Yearly reported patients
% 4) Correct hospital-reported patients in 2020
% -------------------------------------------------------------

clear; clc; close all;

%% 1. TIME SETTINGS

year_start = 1961;
year_end   = 2020;
n_years    = year_end - year_start + 1;

dt = 1;                              % day
t0 = 0;
tF = n_years*365 - 1;

tvec = t0:dt:tF;
nt   = numel(tvec);

year_vec = year_start + floor(tvec/365);
day_vec  = mod(tvec,365) + 1;

%% 2. PARAMETERS

params.N_H = 1181000;
params.m   = 3.098;
params.N_M = params.m * params.N_H;

params.b_H  = 7.92e-5;
params.mu_H = 3.0e-5;
params.nu   = 0.0;

params.sigma   = 3.3/365;
params.p       = 0.0645;
params.gamma_I = 0.20;
params.gamma_A = 0.25;
params.xi      = 1.0e-4;
params.omega_R = 0.00137;

params.mu_M = 0.022;

params.b0      = 0.08856;
params.beta_HM = 0.75;
params.beta_MH = 0.75;
params.theta   = 0.8;

params.rho = 0.05;

params.a_b = 0.5;
params.use_seasonality = true;

%% 3. INITIAL CONDITIONS (1 Jan 1961)

I0 = 1;  E0 = 0;  A0 = 0;  R0 = 0;
Mi0 = 1;

Ms0 = params.N_M - Mi0;
S0  = params.N_H - (E0 + I0 + A0 + R0);

y0 = [S0; E0; I0; A0; R0; Ms0; Mi0];

Y = zeros(nt,7);
Y(1,:) = y0.';

%% 4. RK45 COEFFICIENTS

c2 = 1/5; c3 = 3/10; c4 = 4/5; c5 = 8/9; c6 = 1;

a21 = 1/5;
a31 = 3/40; a32 = 9/40;
a41 = 44/45; a42 = -56/15; a43 = 32/9;
a51 = 19372/6561; a52 = -25360/2187; a53 = 64448/6561; a54 = -212/729;
a61 = 9017/3168; a62 = -355/33; a63 = 46732/5247; a64 = 49/176; a65 = -5103/18656;

b1 = 35/384; b3 = 500/1113; b4 = 125/192; b5 = -2187/6784; b6 = 11/84;

%% 5. TIME INTEGRATION

t = t0;
y = y0;

for i = 1:nt-1
    k1 = dengue_rhs(t,y,params);
    k2 = dengue_rhs(t+c2,y+a21*k1,params);
    k3 = dengue_rhs(t+c3,y+a31*k1+a32*k2,params);
    k4 = dengue_rhs(t+c4,y+a41*k1+a42*k2+a43*k3,params);
    k5 = dengue_rhs(t+c5,y+a51*k1+a52*k2+a53*k3+a54*k4,params);
    k6 = dengue_rhs(t+c6,y+a61*k1+a62*k2+a63*k3+a64*k4+a65*k5,params);

    y = y + (b1*k1 + b3*k3 + b4*k4 + b5*k5 + b6*k6);
    t = t + dt;

    Y(i+1,:) = y.';
end

%% 6. DAILY INCIDENCE AND REPORTED CASES (CORRECT)

E_series = Y(:,2);

daily_incidence = params.p * params.sigma .* E_series;   % p?E(t)
daily_reported  = params.rho * daily_incidence;          % ? p?E(t)

out_daily = table(year_vec(:),day_vec(:), ...
    Y(:,1),Y(:,2),Y(:,3),Y(:,4),Y(:,5), ...
    Y(:,6), Y(:,7), daily_reported(:), ...
    'VariableNames',{'year','day','S','E','I','A','R','M_s', 'M_i','reported_daily'});

writetable(out_daily,'dengue_AMC_daily_1961_2020.csv');

%% 7. YEARLY REPORTED PATIENTS

years = (year_start:year_end).';
nY = numel(years);

yearly_patients = zeros(nY,1);

for i = 1:nY
    yearly_patients(i) = sum(daily_reported(year_vec == years(i)));
end

out_yearly = table(years,yearly_patients, ...
    'VariableNames',{'year','reported_patients'});

writetable(out_yearly,'dengue_AMC_yearly_1961_2020.csv');

%% 8. CORRECT NUMBER OF PATIENTS IN 2020 (HOSPITAL COUNT)

patients_2020 = yearly_patients(years == 2020);

fprintf('\n========================================\n');
fprintf('Total reported dengue patients in 2020 = %.1f\n', patients_2020);
fprintf('========================================\n');

%% 10. PLOT ALL COMPARTMENTS

figure('Color','w');

subplot(4,2,1)
plot(tvec/365 + year_start, Y(:,1),'LineWidth',2)
xlabel('Year')
ylabel('S')
title('Susceptible Humans')
grid on

subplot(4,2,2)
plot(tvec/365 + year_start, Y(:,2),'LineWidth',2)
xlabel('Year')
ylabel('E')
title('Exposed Humans')
grid on

subplot(4,2,3)
plot(tvec/365 + year_start, Y(:,3),'LineWidth',2)
xlabel('Year')
ylabel('I')
title('Symptomatic Infected Humans')
grid on

subplot(4,2,4)
plot(tvec/365 + year_start, Y(:,4),'LineWidth',2)
xlabel('Year')
ylabel('A')
title('Asymptomatic Infected Humans')
grid on

subplot(4,2,5)
plot(tvec/365 + year_start, Y(:,5),'LineWidth',2)
xlabel('Year')
ylabel('R')
title('Recovered Humans')
grid on

subplot(4,2,6)
plot(tvec/365 + year_start, Y(:,6),'LineWidth',2)
xlabel('Year')
ylabel('M_s')
title('Susceptible Mosquitoes')
grid on

subplot(4,2,7)
plot(tvec/365 + year_start, Y(:,7),'LineWidth',2)
xlabel('Year')
ylabel('M_i')
title('Infected Mosquitoes')
grid on

subplot(4,2,8)
plot(tvec/365 + year_start, daily_reported,'LineWidth',2)
xlabel('Year')
ylabel('Cases/day')
title('Daily Reported Dengue Cases')
grid on

title('SEAIR-Mosquito Dengue Model Dynamics (1961--2020)')

