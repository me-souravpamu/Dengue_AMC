clear; clc; close all;

% Load results
load SEAIR_bootstrap_results.mat

% Observed data (EXACTLY as used in fitting)
years = [2020; 2021; 2022; 2023; 2024];
cases_obs = [432; 3104; 2538; 2524; 2235];

% --- Sanity check
size(curves)   % should be [5 x M]

% -----------------------------
% Plot bootstrap realizations
% -----------------------------
figure;
plot(years, curves, 'Color', [0.8 0.8 0.8]);   % all bootstrap fits
hold on;

% Median model fit
median_fit = prctile(curves', 50)';
plot(years, median_fit, 'r-', 'LineWidth', 2);

% 95% confidence band
lower = prctile(curves', 2.5)';
upper = prctile(curves', 97.5)';
plot(years, lower, 'r--', 'LineWidth', 2);
plot(years, upper, 'r--', 'LineWidth', 2);

% Observed data
plot(years, cases_obs, 'ko', 'MarkerFaceColor','k', 'MarkerSize', 8);

% Labels
xlabel('Year');
ylabel('Reported dengue cases');
title('SEAIR–M model fit with bootstrap uncertainty');
legend('Bootstrap realizations','Median fit','95% CI','Location','NorthEast');

set(gca,'FontSize',14);
set(gcf,'Color','white');
