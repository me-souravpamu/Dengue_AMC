%% 9. MODEL EQUATIONS

function dydt = dengue_rhs(t,y,p)

S=y(1); E=y(2); I=y(3); A=y(4); R=y(5); Ms=y(6); Mi=y(7);
NUM_H = S + E + I + A + R;
NUM_M = Ms + Mi;
if p.use_seasonality
    b = p.b0*(1+p.a_b*sin(2*pi*t/365));
    b = max(b,0);
else
    b = p.b0;
end

f = 0;

p.mu_eff = p.mu_M*(1+0.6*f);
lambda_H = b*p.beta_HM*Mi/NUM_H;
lambda_M = (b*p.beta_MH*(I+p.theta*A))/NUM_H;

dS = p.b_H*p.N_H - (lambda_H+p.nu+p.mu_H)*S + p.omega_R*R;
dE = lambda_H*S - (p.sigma+p.mu_H)*E;
dI = p.p*p.sigma*E - (p.gamma_I+p.mu_H+p.xi)*I;
dA = (1-p.p)*p.sigma*E - (p.gamma_A+p.mu_H)*A;
dR = p.gamma_I*I + p.gamma_A*A - (p.omega_R+p.mu_H)*R;

dMs = p.mu_M*p.N_M - lambda_M*Ms - p.mu_eff*Ms;
dMi = lambda_M*Ms - p.mu_eff*Mi;

dydt = [dS; dE; dI; dA; dR; dMs; dMi];
end

function f = fogging_factor(t)

% t in days since 1-Jan-2026

day = mod(t,365);

% fogging months example: July–October
start_day = 1;  % July 1
end_day   = 365;  % October 31

if day >= start_day && day <= end_day
    
    % fogging every 7 days
    if mod(day-start_day,7) == 0
        f = 1;
    else
        f = 0;
    end
    
else
    f = 0;
end

end