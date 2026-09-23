clear all
clc
load Model_LHS_den.mat
parameters;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% beta11=1; 
phi1=0.315; 
theta1=0.5;
gamma11=0.1143; 
mu_11=0.02; 
mu_21=0.0714;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
beta1_LHS=sort(beta1_LHS);
for x=1:500  %Run solution x times choosing different values
beta11=beta1_LHS(x);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
param=[beta11;phi1;theta1;gamma11;mu_11;mu_21];
y0=[1000;100;200;300;100;100;1000;600]; 
% y0=[Sm0,Sf0,Im0,Inp0,Ip0,Iv0];

[time,y1] = ode45(@dengue_ode,tspan,y0,[],param);

A_1= y1(:,1); A_2= y1(:,2);
F_1=y1(:,3); F_2=y1(:,4);
F_3=y1(:,5); F_4=y1(:,6); 
M_1=y1(:,7); M_2=y1(:,8); 

Q=(1-theta1).*beta11*F_1*alpha_2 + beta11*F_2*alpha_3;

L=length(time);

New_cases=zeros(L,1);
New_cases(1)=y1(1,6);




for j=1:(L-1)
   New_cases(j+1)=trapz(Q(j:j+1));    
end

I_area(x)= trapz(New_cases);

end

figure
plot(beta1_LHS,I_area,'r-')