clear; close all;

% ===============================
% Observed annual data
% ===============================
data = [
    2021 3104
    2022 2538
    2023 2524
    2024 2235
];

timevect = data(:,1);      % "time" = year
cases_obs = data(:,2);     % annual incidence

weights = ones(length(timevect),1);
options = optimoptions('lsqcurvefit', 'Algorithm', 'trust-region-reflective');

% ===============================
% Initial guess (YOU provided)
% ===============================
z0 = [0.08856 0.0645];   % [b0 p]

LB = [0.02  0.001];
UB = [1.0  0.5];

% ===============================
% Fit to original data
% ===============================
[z_hat,resnorm,residual] = lsqcurvefit( ...
    @plotSEAIR_annual, z0, timevect, ...
    weights.*cases_obs, LB, UB, options, weights);

b0_hat = z_hat(1)
p_hat  = z_hat(2)
%m_hat  = z_hat(3)

% ===============================
% Bootstrap settings
% ===============================
M = 500;
Phat = zeros(M,2);
curves = [];

% ===============================
% Bootstrap loop (Poisson)
% ===============================
% for k = 1:M
% 
%     cases_boot = poissrnd(cases_obs);
% 
%     [z_k,~,~] = lsqcurvefit( ...
%         @plotSEAIR_annual, z_hat, timevect, ...
%         cases_boot, LB, UB, options, weights);
% 
%     Phat(k,:) = z_k;
% 
%     curves = [curves plotSEAIR_annual(z_k,timevect,weights)];
% end
% ===============================
% Bootstrap loop (Negative Binomial)
% ===============================
k_nb = 20;   % dispersion parameter (try 20–100)

parfor k = 1:M

    cases_boot = zeros(size(cases_obs));

    for t = 1:length(cases_obs)
        mu = cases_obs(t);

        % Negative binomial parameters
        r_nb = k_nb;
        p_nb = k_nb / (k_nb + mu);

        cases_boot(t) = nbinrnd(r_nb, p_nb);
    end

    [z_k,~,~] = lsqcurvefit( ...
        @plotSEAIR_annual, z_hat, timevect, ...
        cases_boot, LB, UB, options, weights);

    Phat(k,:) = z_k;

    curves = [curves plotSEAIR_annual(z_k,timevect,weights)];
end

save('SEAIR_bootstrap_results.mat','Phat','curves','z_hat')
