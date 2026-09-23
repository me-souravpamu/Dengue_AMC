load SEAIR_bootstrap_results.mat

% ===== FORECAST YEARS =====
years_forecast = (2026:2028)';
nY = numel(years_forecast);

% ===== BOOTSTRAP FORECASTS =====
cases_forecasts = zeros(nY, size(Phat,1));

for k = 1:size(Phat,1)
    cases_forecasts(:,k) = plotSEAIR_annual(Phat(k,:), years_forecast);
end

% samples × years
cases_forecasts = cases_forecasts';

% ===== VIOLIN PLOT SETTINGS =====
figure; hold on
violin_width = 0.35;
point_jitter = 0.06;

colors = [
    0.85 0.33 0.10   % orange-red
    0.93 0.69 0.13   % yellow
    0.47 0.67 0.19   % green
];

for i = 1:nY
    data = cases_forecasts(:,i);
    data = data(~isnan(data) & data > 0);

    % ===== KERNEL DENSITY =====
    [f, xi] = ksdensity(data, 'NumPoints', 200);
    f = f ./ max(f) * violin_width;

    % ===== VIOLIN BODY =====
    fill([i+f i-fliplr(f)], ...
         [xi fliplr(xi)], ...
         colors(i,:), ...
         'FaceAlpha', 0.35, ...
         'EdgeColor', [0.4 0.4 0.4], ...
         'LineWidth', 1.2);

    % ===== BOOTSTRAP POINTS =====
    xj = i + (rand(size(data))-0.5)*point_jitter;
    scatter(xj, data, 28, ...
        'MarkerFaceColor', colors(i,:), ...
        'MarkerEdgeColor', 'none', ...
        'MarkerFaceAlpha', 0.75);

    % ===== QUARTILES & MEDIAN =====
    q25 = quantile(data, 0.25);
    q75 = quantile(data, 0.75);
    med = median(data);

    % IQR bar (25–75%)
    plot([i i], [q25 q75], 'k', 'LineWidth', 5);

    % Median point
    % ===== MEDIAN VALUE AS TEXT INSIDE VIOLIN =====
    % Median point
    scatter(i, med, 80, 'w', 'filled', 'MarkerEdgeColor', 'k');
    hold on;
    text(i, med, sprintf('%.0f', med), ...
    'HorizontalAlignment','center', ...
    'VerticalAlignment','middle', ...
    'FontSize',12, ...
    'FontWeight','bold', ...
    'Color','k');

    % Full range (optional thin line)
    plot([i i], [min(data) max(data)], ...
        'Color',[0.3 0.3 0.3],'LineWidth',1);
end

% ===== AXES FORMATTING =====
set(gca,'XTick',1:nY,'XTickLabel',years_forecast)
xlabel('Year')
ylabel('Reported dengue cases')
title('Bootstrap forecast of dengue cases (2026–2028)', ...
      'FontWeight','bold')

set(gca,'FontSize',12)
box on
xlim([0.5 nY+0.5])

hold off




% load SEAIR_bootstrap_results.mat
% 
% % ===== FORECAST YEARS =====
% years_forecast = (2026:2028)';
% nY = numel(years_forecast);
% 
% % ===== GENERATE BOOTSTRAP FORECASTS =====
% cases_forecasts = zeros(nY, size(Phat,1));
% 
% for k = 1:size(Phat,1)
%     cases_forecasts(:,k) = plotSEAIR_annual(Phat(k,:), years_forecast);
% end
% 
% % Transpose for convenience: rows = samples, cols = years
% cases_forecasts = cases_forecasts';
% 
% % ===== VIOLIN PLOT =====
% figure; hold on
% 
% violin_width = 0.35;
% colors = [0.8 0.1 0.1];   % deep red (forecast theme)
% 
% for i = 1:nY
%     data = cases_forecasts(:,i);
%     data = data(~isnan(data) & data>0);
% 
%     % Kernel density
%     [f,xi] = ksdensity(data,'NumPoints',200);
%     f = f ./ max(f) * violin_width;
% 
%     % Violin shape
%     fill([i+f i-fliplr(f)], ...
%          [xi fliplr(xi)], ...
%          colors, ...
%          'FaceAlpha',0.35, ...
%          'EdgeColor','none');
% 
%     % Median
%     med = median(data);
%     plot([i-0.12 i+0.12], [med med], ...
%          'k','LineWidth',2);
% 
%     % Median value annotation
%     text(i, med, sprintf('%.0f',med), ...
%         'HorizontalAlignment','center', ...
%         'VerticalAlignment','bottom', ...
%         'FontSize',11, ...
%         'FontWeight','bold');
% end
% 
% % ===== AXIS SETTINGS =====
% set(gca,'XTick',1:nY,'XTickLabel',years_forecast)
% xlabel('Year')
% ylabel('Reported dengue cases')
% title('Forecast distribution of dengue cases (bootstrap)', ...
%       'FontWeight','bold')
% 
% set(gca,'FontSize',12)
% box on
% xlim([0.5 nY+0.5])
% 
% hold off
