function dydt = SEAIR_ode_prevention(t,y,params)

% VERY IMPORTANT: load parameter script first
params_SEAIR;

% Extract bootstrap parameters
b0 = params(1);
p  = params(2);
%m  = params(3);

S  = y(1);
E  = y(2);
I  = y(3);
A  = y(4);
R  = y(5);
Ms = y(6);
Mi = y(7);

%N_H = S+E+I+A+R;
% M = Ms+Mi;
N_M = m*N_H;

b = b0*(1 + a_b*sin(2*pi*t/365));
b = max(b,0);

lambda_H = b*beta_HM*(Mi/(S+E+I+A+R));
lambda_M = b*beta_MH*(I + theta*A)/(S+E+I+A+R);

% Fogging intervention
% f = @fogging_factor(t);

% muM_eff = @(t)(mu_M + 0.6*fogging_factor(t));

dS = b_H*N_H - (lambda_H + nu + mu_H)*S + omega_R*R;
dE = lambda_H*S - (sigma_E + mu_H)*E;
dI = p*sigma_E*E - (gamma_I + mu_H + xi)*I;
dA = (1-p)*sigma_E*E - (gamma_A + mu_H)*A;
dR = gamma_I*I + gamma_A*A - (omega_R + mu_H)*R;

dMs = mu_M*N_M - lambda_M*Ms - (mu_M + spraying(t))*Ms;
dMi = lambda_M*Ms - (mu_M + spraying(t))*Mi;

dydt = [dS; dE; dI; dA; dR; dMs; dMi];

end
