%% The results should be compared to the PRCC results section in
%% Supplementary Material D and Table D.1 for different N (specified by
%% "runs" in the script below
clear all;
close all;
load Model_LHS_DenV.mat
params_SEAIR;
timevect = 2026:1:2030;
%% LHS MATRIX  %%

LHSmatrix=LHSmatrix';
%% LHS MATRIX and PARAMETER LABELS

parfor x=1:1000%Run solution x times choosing different values
    x
b01=b0_LHS(x);
beta_HM1=beta_HM_LHS(x);
beta_MH1=beta_MH_LHS(x);
p1=p_LHS(x);
m1=m_LHS(x);
theta1=theta_LHS(x);
% omega_R1=omega_R_LHS(x);
mu_M1=mu_M_LHS(x);



param=[b01;beta_HM1;beta_MH1;p1;m1;theta1;mu_M1];

%Imax(x)=max(New_cases);
output = plotSEAIR_annual(param,timevect);
I_total(x)= sum(output(end-4:end));
 
 %%%%%%%%%%%%% Basic Reproduction Number %%%%%%%%%%%%%
% param=[beta11;phi1;alpha_11;theta1;gamma11;mu_11;mu_21];

% R0(x)=((phi1.*alpha_3.*(1-q).*(alpha_2.*beta11+mu_21))./(theta1.*alpha_2.*(1-p).*(alpha_3.*beta11+mu_21)));
end

[prcc_area sign_area]=PRCC(LHSmatrix,I_total,1,PRCC_var,0.05);
% [prcc_r0 sign_r0]=PRCC(LHSmatrix,R0,1,PRCC_var,0.05);

% [prcc_max sign_max]=PRCC(LHSmatrix,Imax,1,PRCC_var,0.05);
% [prcc_area sign_area]=PRCC(LHSmatrix,I_area,1,PRCC_var,0.05);


% figure;
% bar(prcc_r0,0.5,'b');
% set(gca,'xtick',1:7)
% set(gca,'xticklabel',PRCC_var)
% ylabel('PRCC');
% 

x = categorical(PRCC_var);
y = prcc_area;
% Sort by decreasing y value.
[sortedY, sortOrder] = sort(y, 'descend');
% You must sort x the same way so you don't lose correspondences.
sortedX = x(sortOrder);
figure;
bar(sortedY,0.5,'b');
set(gca,'xtick',1:7)
set(gca,'xticklabel',char(sortedX))
ylabel('PRCC');


% Lmat =LHSmatrix;
%% Save the workspace
% save Model_LHS.mat;
% CALCULATE PRCC
%[prcc sign sign_label]=PRCC(LHSmatrix,V_lhs,1:length(time_points),PRCC_var,alpha);
% end
save('sen_results.mat', 'prcc_area', 'sign_area','LHSmatrix','PRCC_var','I_total')