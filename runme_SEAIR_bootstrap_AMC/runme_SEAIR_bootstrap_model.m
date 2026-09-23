clear; close all;

% ===============================
% Observed annual data
% ===============================
data = [
    2020 432
    2021 3104
    2022 2538
    2023 2524
    2024 2235
];

timevect  = data(:,1);      % year
cases_obs = data(:,2);      % incidence

weights = ones(length(timevect),1);

options = optimoptions( ...
    'lsqcurvefit', ...
    'Algorithm','trust-region-reflective', ...
    'Display','off');

% ===============================
% Initial guess
% ===============================
z0 = [0.08856 0.0645];   % [b0 p]

LB = [0.02  0.001];
UB = [1.0   0.5];

% ===============================
% Fit to original data
% ===============================
[z_hat,resnorm,residual] = lsqcurvefit( ...
    @plotSEAIR_annual, ...
    z0, timevect, ...
    weights .* cases_obs, ...
    LB, UB, options);

b0_hat = z_hat(1)
p_hat  = z_hat(2)

% ===============================
% Model-predicted mean
% ===============================
mu_model = plotSEAIR_annual(z_hat, timevect);

% ===============================
% Bootstrap settings
% ===============================
M = 250;
Phat   = zeros(M,2);
curves = zeros(length(timevect),M);

% ===============================
% Bootstrap loop (model-based NB)
% ===============================
k_nb = 24;   % dispersion parameter

parfor k = 1:M

    cases_boot = zeros(size(cases_obs));

    for t = 1:length(cases_obs)

        mu = mu_model(t);

        r_nb = k_nb;
        p_nb = k_nb / (k_nb + mu);

        cases_boot(t) = nbinrnd(r_nb, p_nb);
    end

    [z_k,~,~] = lsqcurvefit( ...
        @plotSEAIR_annual, ...
        z_hat, timevect, ...
        cases_boot, ...
        LB, UB, options);

    Phat(k,:)   = z_k;
    curves(:,k) = plotSEAIR_annual(z_k, timevect);

end

save('SEAIR_bootstrap_results.mat','Phat','curves','z_hat','mu_model')
