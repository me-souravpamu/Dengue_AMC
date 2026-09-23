clear all
clc
load Model_LHS_den.mat
parameters;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
beta11=1; 
phi1=0.315; 
theta1=0.5;
gamma11=0.1143; 
mu_11=0.02; 
% mu_21=0.0714;


% LHSmatrix=LHSmatrix';
%% LHS MATRIX and PARAMETER LABELS
mu_2_LHS=sort(mu_2_LHS);
for x=1:500  %Run solution x times choosing different values
mu_21=mu_2_LHS(x);
 
R0(x)=((phi1.*alpha_3.*(1-q).*(alpha_2.*beta11+mu_21))./(theta1.*alpha_2.*(1-p).*(alpha_3.*beta11+mu_21)));

 %R0(i,1)=Rd(i,1)+Rv(i,1);

end
plot(mu_2_LHS,R0,'r-')