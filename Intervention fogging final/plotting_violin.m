clear; clc; close all;

%% LOAD DATA
A = load('forecast_cases_2026_2028_without_intervention.mat');
fn = fieldnames(A);
cases_no = A.(fn{1});

B = load('forecast_cases_2026_2028_with_intervention.mat');
fn = fieldnames(B);
cases_with = B.(fn{1});

years = [2026 2027 2028];
nY = length(years);

% Ensure rows = bootstrap, columns = years
cases_no   = cases_no';
cases_with = cases_with';

%% VIOLIN SETTINGS (IDENTICAL TO YOUR FIRST CODE)
violin_width = 0.30;
point_jitter = 0.06;
offset = 0.18;

color_no   = [0.85 0.33 0.10];
color_with = [0.00 0.45 0.74];

figure('Position',[200 200 900 550])
hold on

for i = 1:nY
    
    %% ===============================
    %% WITHOUT INTERVENTION VIOLIN
    %% ===============================
    
    data = cases_no(:,i);
    data = data(~isnan(data) & data > 0);
    
    % Kernel density (same as your working code)
    [f, xi] = ksdensity(data,'NumPoints',200);
    f = f ./ max(f) * violin_width;
    
    % Violin body
    fill(i-offset+[f -fliplr(f)], ...
         [xi fliplr(xi)], ...
         color_no, ...
         'FaceAlpha',0.35, ...
         'EdgeColor',[0.4 0.4 0.4], ...
         'LineWidth',1.2);
    
    % Bootstrap scatter points
    xj = i-offset + (rand(size(data))-0.5)*point_jitter;
    scatter(xj, data, 22, ...
        'MarkerFaceColor',color_no, ...
        'MarkerEdgeColor','none', ...
        'MarkerFaceAlpha',0.7);
    
    % Quartiles and median
    q25 = quantile(data,0.25);
    q75 = quantile(data,0.75);
    med = median(data);
    
    plot([i-offset i-offset],[q25 q75],'k','LineWidth',5)
    
    % Median point
    scatter(i-offset, med, 80, 'w','filled','MarkerEdgeColor','k')
    
    % Median text
    text(i-offset, med, sprintf('%.0f',med), ...
        'HorizontalAlignment','center', ...
        'VerticalAlignment','middle', ...
        'FontSize',11, ...
        'FontWeight','bold')
    
    % Full range line
    plot([i-offset i-offset],[min(data) max(data)], ...
        'Color',[0.3 0.3 0.3],'LineWidth',1)
    
    
    %% ===============================
    %% WITH INTERVENTION VIOLIN
    %% ===============================
    
    data = cases_with(:,i);
    data = data(~isnan(data) & data > 0);
    
    [f, xi] = ksdensity(data,'NumPoints',200);
    f = f ./ max(f) * violin_width;
    
    fill(i+offset+[f -fliplr(f)], ...
         [xi fliplr(xi)], ...
         color_with, ...
         'FaceAlpha',0.35, ...
         'EdgeColor',[0.4 0.4 0.4], ...
         'LineWidth',1.2);
    
    % Bootstrap scatter
    xj = i+offset + (rand(size(data))-0.5)*point_jitter;
    scatter(xj, data, 22, ...
        'MarkerFaceColor',color_with, ...
        'MarkerEdgeColor','none', ...
        'MarkerFaceAlpha',0.7);
    
    % Quartiles and median
    q25 = quantile(data,0.25);
    q75 = quantile(data,0.75);
    med = median(data);
    
    plot([i+offset i+offset],[q25 q75],'k','LineWidth',5)
    
    scatter(i+offset, med, 80, 'w','filled','MarkerEdgeColor','k')
    
    text(i+offset, med, sprintf('%.0f',med), ...
        'HorizontalAlignment','center', ...
        'VerticalAlignment','middle', ...
        'FontSize',11, ...
        'FontWeight','bold')
    
    plot([i+offset i+offset],[min(data) max(data)], ...
        'Color',[0.3 0.3 0.3],'LineWidth',1)
    
end

%% AXES FORMAT (same style)
set(gca,'XTick',1:nY,'XTickLabel',years)
xlabel('Year')
ylabel('Reported dengue cases')
title('Bootstrap forecast comparison (2026–2028)')

set(gca,'FontSize',13,'LineWidth',1.5)
box on
xlim([0.5 nY+0.5])

%% LEGEND
h1 = patch(NaN,NaN,color_no,'FaceAlpha',0.35,'EdgeColor','k');
h2 = patch(NaN,NaN,color_with,'FaceAlpha',0.35,'EdgeColor','k');

legend([h1 h2], ...
    {'Without intervention','With intervention'}, ...
    'Location','northwest', ...
    'FontSize',13)

legend boxon