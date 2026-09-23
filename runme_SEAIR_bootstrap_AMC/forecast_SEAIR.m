% load SEAIR_bootstrap_results.mat
% 
% years_forecast = (2025:2027)';
% 
% cases_forecasts = zeros(numel(years_forecast),size(Phat,1));
% 
% for k = 1:size(Phat,1)
%     cases_forecasts(:,k) = plotSEAIR_annual(Phat(k,:),years_forecast);
% end
% 
% figure
% plot(years_forecast,plims(cases_forecasts',0.5),'r','LineWidth',2)
% hold on
% plot(years_forecast,plims(cases_forecasts',0.025),'r--')
% plot(years_forecast,plims(cases_forecasts',0.975),'r--')
% xlabel('Year')
% ylabel('Reported dengue cases')
load SEAIR_bootstrap_results.mat

years_forecast = (2025:2027)';

cases_forecasts = zeros(numel(years_forecast),size(Phat,1));

for k = 1:size(Phat,1)
    cases_forecasts(:,k) = plotSEAIR_annual(Phat(k,:),years_forecast);
end

%% ===== BAR-WISE (YEAR-WISE) DISTRIBUTION PLOT =====

figure
hold on

% Boxplot expects data as columns ? transpose
boxplot(cases_forecasts', years_forecast, ...
    'Widths',0.6, ...
    'Symbol','')     % remove outliers for clean bars

% Median values
med_vals = median(cases_forecasts,2);

% Annotate median values (numbers on top of bars)
for i = 1:numel(years_forecast)
    text(i, med_vals(i), ...
        sprintf('%.1f', med_vals(i)), ...
        'HorizontalAlignment','center', ...
        'VerticalAlignment','bottom', ...
        'FontSize',10, ...
        'FontWeight','bold');
end

set(gca,'XTickLabel', years_forecast)
xlabel('Year')
ylabel('Reported dengue cases')
set(gca,'FontSize',12)
box on
