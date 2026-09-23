% Load saved figures
a=hgload('beta_vs_R0.fig');
b=hgload('phi_vs_R0.fig');
c=hgload('theta_vs_R0.fig');
d=hgload('mu2_vs_R0.fig');


% Prepare subplots
figure
h(1)=subplot(2,2,1);
h(2)=subplot(2,2,2);
h(3)=subplot(2,2,3);
h(4)=subplot(2,2,4);
% h(5)=subplot(2,3,5);
% h(6)=subplot(2,3,6);

% Paste figures on the subplots
copyobj(allchild(get(a,'CurrentAxes')),h(1));
copyobj(allchild(get(b,'CurrentAxes')),h(2));
copyobj(allchild(get(c,'CurrentAxes')),h(3));
copyobj(allchild(get(d,'CurrentAxes')),h(4));
% copyobj(allchild(get(e,'CurrentAxes')),h(5));
% copyobj(allchild(get(f,'CurrentAxes')),h(6));
