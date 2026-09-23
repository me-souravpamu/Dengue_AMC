clear; clc;

runs = 600;

% Initial guesses
b0_0 = 0.1;
p_0  = 0.06;
m_0  = 2.5;

% Bounds
lb = [0.02, 0.01, 1.0];
ub = [0.15, 0.3, 5.0];

% LHS
b0_LHS = LHS_Call(lb(1),b0_0,ub(1),0,runs,'unif');
p_LHS  = LHS_Call(lb(2),p_0 ,ub(2),0,runs,'unif');
m_LHS  = LHS_Call(lb(3),m_0 ,ub(3),0,runs,'unif');

LHSmatrix = [b0_LHS p_LHS m_LHS]';

J = zeros(runs,3);
K = zeros(runs,1);

parfor i = 1:runs
    param = LHSmatrix(:,i);
    J(i,:) = param';
    K(i)   = SEAIR_ss(param);
end

save('sampling_result_SEAIR_fit.mat','J','K')

[~,idx] = min(K);
fprintf('\nBest parameters:\n');
fprintf('b0 = %.5f, p = %.4f, m = %.3f\n',J(idx,1),J(idx,2),J(idx,3));
