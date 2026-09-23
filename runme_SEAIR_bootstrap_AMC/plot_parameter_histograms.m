% clear; clc; close all;

load SEAIR_bootstrap_results.mat   % contains Phat

b0 = Phat(:,1);
p  = Phat(:,2);
%m  = Phat(:,3);

% ===============================
% Compute statistics
% ===============================
b0_mean = mean(b0);
b0_ci   = prctile(b0,[2.5 97.5]);

p_mean  = mean(p);
p_ci    = prctile(p,[2.5 97.5]);

% m_mean  = mean(m);
% m_ci    = prctile(m,[2.5 97.5]);

% ===============================
% Plot
% ===============================
figure('Units','normalized','Position',[0.2 0.2 0.6 0.4]);

% ---- b0 panel ----
subplot(1,2,1)
histogram(b0,20,'FaceColor',[0.1 0.1 0.7],'EdgeColor','none');
xlabel('b_0')
ylabel('Frequency')
title(sprintf('b_0 = %.3f (95%% CI: %.3f, %.3f)', ...
      b0_mean, b0_ci(1), b0_ci(2)))
set(gca,'FontSize',14)

% ---- p panel ----
subplot(1,2,2)
histogram(p,20,'FaceColor',[0.1 0.1 0.7],'EdgeColor','none');
xlabel('p')
ylabel('Frequency')
title(sprintf('p = %.3f (95%% CI: %.3f, %.3f)', ...
      p_mean, p_ci(1), p_ci(2)))
set(gca,'FontSize',14)

% ---- m panel ----
% subplot(1,3,3)
% histogram(m,20,'FaceColor',[0.1 0.1 0.7],'EdgeColor','none');
% xlabel('m')
% ylabel('Frequency')
% title(sprintf('m = %.3f (95%% CI: %.3f, %.3f)', ...
%       m_mean, m_ci(1), m_ci(2)))
% set(gca,'FontSize',14)

set(gcf,'Color','white');
