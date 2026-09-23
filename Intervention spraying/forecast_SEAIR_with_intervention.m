clear all;
clc

load SEAIR_bootstrap_results.mat


years_forecast = (2026:2028)';

cases_with_intervention = zeros(numel(years_forecast),size(Phat,1));

parfor k = 1:size(Phat,1) 
    cases_with_intervention(:,k) = With_intervention_SEAIR(Phat(k,:),years_forecast);
end

%% ===== BAR-WISE (YEAR-WISE) DISTRIBUTION PLOT =====
save forecast_cases_2026_2028_with_intervention.mat cases_with_intervention

nY = numel(years_forecast);
cases_forecasts = cases_with_intervention';

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

% figure
% hold on
% 
% % Boxplot expects data as columns ? transpose
% boxplot(cases_no_intervention', years_forecast, ...
%     'Widths',0.6, ...
%     'Symbol','')     % remove outliers for clean bars
% 
% % Median values
% med_vals = median(cases_no_intervention,2);
% 
% % Annotate median values (numbers on top of bars)
% for i = 1:numel(years_forecast)
%     text(i, med_vals(i), ...
%         sprintf('%.1f', med_vals(i)), ...
%         'HorizontalAlignment','center', ...
%         'VerticalAlignment','bottom', ...
%         'FontSize',10, ...
%         'FontWeight','bold');
% end
% 
% set(gca,'XTickLabel', years_forecast)
% xlabel('Year')
% ylabel('Reported dengue cases')
% set(gca,'FontSize',12)
% box on
