function dydt = SEAIR_ode(t,y,param)

b0 = param(1);
p  = param(2);
m  = param(3);

params_SEAIR;

N_M = m*N_H;

S=y(1); E=y(2); I=y(3); A=y(4); R=y(5); Ms=y(6); Mi=y(7);

b = b0*(1 + a_b*sin(2*pi*t/365));
b = max(b,0);

lambda_H = b*beta_HM*(Mi/(S+E+I+A+R));
lambda_M = b*beta_MH*(I + theta*A)/(S+E+I+A+R);

dS = b_H*N_H - (lambda_H + nu + mu_H)*S + omega_R*R;
dE = lambda_H*S - (sigma_E + mu_H)*E;
dI = p*sigma_E*E - (gamma_I + mu_H + xi)*I;
dA = (1-p)*sigma_E*E - (gamma_A + mu_H)*A;
dR = gamma_I*I + gamma_A*A - (omega_R + mu_H)*R;

dMs = mu_M*N_M - lambda_M*Ms - mu_M*Ms;
dMi = lambda_M*Ms - mu_M*Mi;

dydt = [dS; dE; dI; dA; dR; dMs; dMi];
