%clear; clc; close all;

% Time vector (one year)
t = 0:1:(365*3);

% Preallocate
f = zeros(size(t));

% Compute fogging factor
i = 1;
for i = 1:length(t)
    f(i) = fogging_factor(t(i));
end

% Plot fogging factor
figure;
plot(t, f, 'b-', 'LineWidth', 2);
hold on;

% Plot vertical lines manually
ymax = max(f);
% start_day = 0;  % July 1
% end_day   = 119;  % October 31
% plot([start_day start_day], [0 ymax], 'r--', 'LineWidth', 2);
% plot([end_day   end_day],   [0 ymax], 'k--', 'LineWidth', 2);

xlabel('Time (days)');
ylabel('Fogging factor f(t)');
title('Fogging Factor Over One Year');
%grid on;

legend('Fogging factor','Start day','End day');