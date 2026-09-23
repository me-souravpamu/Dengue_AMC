%clear; clc; close all;

% Load data
A = load('forecast_cases_2026_2028_without_intervention.mat');
fn = fieldnames(A);
cases_no = A.(fn{1});

B = load('forecast_cases_2026_2028_with_intervention.mat');
fn = fieldnames(B);
cases_with = B.(fn{1});

years = [2026 2027 2028];

% Ensure rows = years
[nr, nc] = size(cases_no);
if nr ~= 3
    cases_no = cases_no';
    cases_with = cases_with';
end

% Compute reduction
reduction = 100 * (cases_no - cases_with) ./ cases_no;
mean_reduction = mean(reduction, 2);

data = reduction';

figure('Position',[300 200 750 550])

% Create boxplot WITHOUT LineWidth parameter
boxplot(data, ...
    'Widths',0.7, ...
    'Symbol','.', ...
    'Colors','k')

hold on

% Set linewidth AFTER creation (this works in all MATLAB versions)
set(findobj(gca,'Type','line'),'LineWidth',1.5)

% Color boxes
boxes = findobj(gca,'Tag','Box');

colors = [0.0078 0.4510 0.7412;
          0.1333 0.5451 0.1333;
          0.8500 0.3250 0.0980];

for j = 1:length(boxes)
    
    patch(get(boxes(j),'XData'), ...
          get(boxes(j),'YData'), ...
          colors(j,:), ...
          'FaceAlpha',0.6, ...
          'EdgeColor',colors(j,:));
end

% Mean labels (LaTeX)
for i = 1:3
    
    text(i+0.18, mean_reduction(i), ...
        sprintf('$%.1f$', mean_reduction(i)), ...
        'Interpreter','latex', ...
        'FontSize',14, ...
        'FontWeight','bold');
end

% Axis formatting with LaTeX ticks
set(gca, ...
    'XTick',1:3, ...
    'XTickLabel',{'$2026$','$2027$','$2028$'}, ...
    'TickLabelInterpreter','latex', ...
    'FontSize',14, ...
    'LineWidth',1.5)

ylabel('$\mathrm{Relative\ total\ cases\ reduction\ (\%)}$', ...
    'Interpreter','latex', ...
    'FontSize',16)

xlabel('$\mathrm{Year}$', ...
    'Interpreter','latex', ...
    'FontSize',16)

ylim([0 100])

%grid on
box on

set(gca,'TickDir','in')
set(gca,'TickLength',[0.02 0.02])