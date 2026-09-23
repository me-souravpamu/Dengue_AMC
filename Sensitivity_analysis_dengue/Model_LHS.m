
clear all;
close all;

%% Sample size N
runs=1000;

%% LHS MATRIX  %%
b01 = 0.1;
beta_HM1 = 0.75;
beta_MH1 = 0.75;
p1  = 0.05;
m1  = 3;
theta1= 0.5;
% omega_R1=0.00137;
mu_M1 = 0.022; 


b0_LHS=LHS_Call(1e-7, b01, 1, 0 ,runs,'unif'); 
beta_HM_LHS=LHS_Call(1e-7, beta_HM1, 1, 0 ,runs,'unif'); 
beta_MH_LHS=LHS_Call(1e-7, beta_MH1, 1, 0 ,runs,'unif'); 
p_LHS=LHS_Call(1e-7, p1, 1, 0 ,runs,'unif'); 
m_LHS=LHS_Call(1, m1, 5, 0, runs,'unif'); 
theta_LHS=LHS_Call(1e-7,theta1,0.8, 0 ,runs,'unif'); 
% omega_R_LHS=LHS_Call(1e-7, omega_R1, 0.1, 0, runs,'unif'); 
mu_M_LHS=LHS_Call(1e-7, mu_M1, 1, 0 ,runs,'unif');
% alpha_2_LHS=LHS_Call(1e-7, alpha21, 1, 0 ,runs,'unif');
%i1_LHS=LHS_Call(1e-7, i11, 1, 0 ,runs,'unif');
% lambda_v_LHS=LHS_Call(1e-7, lambda_v1, 1, 0, runs,'unif'); 
% p1_LHS=LHS_Call(0.05, p11, 0.25, 0, runs,'unif'); 
% p2_LHS=LHS_Call(0.6, p21, 1, 0, runs,'unif'); 

% LHS MATRIX and PARAMETER LABELS................
LHSmatrix=[b0_LHS beta_HM_LHS beta_MH_LHS p_LHS m_LHS theta_LHS mu_M_LHS]';


%% Save the workspace
save Model_LHS_DenV.mat;
